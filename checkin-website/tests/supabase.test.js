// Tests for supabase.js. Run: node --test
// The browser pieces it uses (fetch, localStorage, the page address) are
// replaced with small fakes, so nothing here touches the internet.
import assert from "node:assert/strict";
import { beforeEach, test } from "node:test";

// ---- Fake browser ----
const stored = new Map();
globalThis.localStorage = {
  getItem: (key) => stored.get(key) ?? null,
  setItem: (key, value) => stored.set(key, String(value)),
  removeItem: (key) => stored.delete(key),
};
globalThis.location = { origin: "https://example.org", pathname: "/checkin/", hash: "", search: "" };
globalThis.history = { replaceState: (_, __, address) => (history.address = address) };

// A fake Supabase. `routes` maps a path to a function returning [status, body].
let routes = {};
let requests = [];
globalThis.fetch = async (url, options) => {
  const path = new URL(url).pathname;
  requests.push({ path, token: options.headers.Authorization, body: JSON.parse(options.body), signal: options.signal });
  if (!routes[path]) throw new TypeError("Failed to fetch");  // like being offline
  const [status, body] = routes[path](options);
  return new Response(JSON.stringify(body), { status });
};

const supabase = await import("../supabase.js");

const SAVED = "furnace-sign-in";
const signedInAs = (access_token, refresh_token = "refresh-1") =>
  stored.set(SAVED, JSON.stringify({ access_token, refresh_token }));
const saved = () => JSON.parse(stored.get(SAVED) ?? "null");
const renewals = () => requests.filter((r) => r.path === "/auth/v1/token").length;

// Renewing hands out a new pair of tokens; a used refresh token is refused.
const renewOnce = (options) => {
  const { refresh_token } = JSON.parse(options.body);
  return refresh_token === "refresh-1"
    ? [200, { access_token: "new-access", refresh_token: "refresh-2" }]
    : [400, { error: "invalid_grant" }];
};
// The database accepts only "new-access".
const acceptsNewAccess = (options) =>
  options.headers.Authorization === "Bearer new-access" ? [200, { ok: true }] : [401, {}];

beforeEach(() => {
  stored.clear();
  routes = {};
  requests = [];
  location.hash = "";
  location.search = "";
  history.address = undefined;
});

test("coming back from Google saves the sign-in and tidies the address", () => {
  location.hash = "#access_token=a1&refresh_token=r1&expires_in=3600&token_type=bearer";
  supabase.finishSignIn();
  assert.deepEqual(saved(), { access_token: "a1", refresh_token: "r1" });
  assert.equal(history.address, "https://example.org/checkin/");
  assert.equal(supabase.isSignedIn(), true);
});

test("a cancelled Google sign-in is reported", () => {
  location.search = "?error=access_denied&error_description=User+cancelled";
  assert.throws(() => supabase.finishSignIn(), { message: "User cancelled" });
  assert.equal(supabase.isSignedIn(), false);
});

test("an ordinary visit leaves the address alone", () => {
  location.search = "?from=qr";
  supabase.finishSignIn();
  assert.equal(history.address, undefined);
  assert.equal(supabase.isSignedIn(), false);
});

test("calls send the sign-in and the arguments", async () => {
  signedInAs("a1");
  routes["/rest/v1/rpc/monthly_report"] = () => [200, [{ name: "Ana", days: 3 }]];

  const rows = await supabase.call("monthly_report", { month_start: "2026-10-01" });

  assert.deepEqual(rows, [{ name: "Ana", days: 3 }]);
  assert.equal(requests[0].token, "Bearer a1");
  assert.deepEqual(requests[0].body, { month_start: "2026-10-01" });
});

test("an expired sign-in is renewed and the call retried", async () => {
  signedInAs("old-access");
  routes["/auth/v1/token"] = renewOnce;
  routes["/rest/v1/rpc/check_in"] = acceptsNewAccess;

  assert.deepEqual(await supabase.call("check_in"), { ok: true });
  assert.deepEqual(saved(), { access_token: "new-access", refresh_token: "refresh-2" });
  assert.equal(renewals(), 1);
});

test("calls that expire together share one renewal", async () => {
  signedInAs("old-access");
  routes["/auth/v1/token"] = renewOnce;
  routes["/rest/v1/rpc/my_status"] = acceptsNewAccess;
  routes["/rest/v1/rpc/check_in"] = acceptsNewAccess;

  await Promise.all([supabase.call("my_status"), supabase.call("check_in")]);

  assert.equal(renewals(), 1);
});

test("a renewal done in another tab is used without renewing again", async () => {
  signedInAs("old-access");
  routes["/rest/v1/rpc/my_status"] = acceptsNewAccess;

  // Another tab renews and saves the new sign-in.
  signedInAs("new-access", "refresh-2");

  assert.deepEqual(await supabase.call("my_status"), { ok: true });
  assert.equal(renewals(), 0);
});

test("a refused renewal signs the person out", async () => {
  signedInAs("old-access", "already-used");
  routes["/auth/v1/token"] = renewOnce;
  routes["/rest/v1/rpc/check_in"] = acceptsNewAccess;

  await assert.rejects(supabase.call("check_in"), supabase.SignedOut);
  assert.equal(supabase.isSignedIn(), false);
});

test("still refused after renewing signs the person out", async () => {
  signedInAs("old-access");
  routes["/auth/v1/token"] = renewOnce;
  routes["/rest/v1/rpc/check_in"] = () => [401, {}];

  await assert.rejects(supabase.call("check_in"), supabase.SignedOut);
  assert.equal(supabase.isSignedIn(), false);
});

test("every request has a time limit", async () => {
  signedInAs("a1");
  routes["/rest/v1/rpc/my_status"] = () => [200, {}];
  await supabase.call("my_status");
  assert.ok(requests[0].signal instanceof AbortSignal);
});

test("a request that runs out of time keeps the person signed in", async () => {
  signedInAs("a1");
  routes["/rest/v1/rpc/check_in"] = () => {
    throw new DOMException("The operation timed out.", "TimeoutError");
  };
  await assert.rejects(supabase.call("check_in"), { name: "TimeoutError" });
  assert.equal(supabase.isSignedIn(), true);
});

test("being offline keeps the person signed in", async () => {
  signedInAs("a1");
  await assert.rejects(supabase.call("check_in"), TypeError);
  assert.equal(supabase.isSignedIn(), true);
});

test("a database error comes back as a readable message", async () => {
  signedInAs("a1");
  routes["/rest/v1/rpc/monthly_report"] = () => [400, { message: "Only coordinators can see the report" }];

  await assert.rejects(supabase.call("monthly_report"), { message: "Only coordinators can see the report" });
  assert.equal(supabase.isSignedIn(), true);
});

test("calling without signing in asks the person to sign in", async () => {
  await assert.rejects(supabase.call("my_status"), supabase.SignedOut);
  assert.equal(requests.length, 0);
});

test("signing out works even when offline", async () => {
  signedInAs("a1");
  await supabase.signOut();
  assert.equal(supabase.isSignedIn(), false);
});
