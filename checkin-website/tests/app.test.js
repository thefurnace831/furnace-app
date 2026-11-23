// Exercise the real page and Supabase client with a small fake browser.
// No dependencies, network access, or live attendance records are needed.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { after, beforeEach, test } from "node:test";

const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
const sections = [...html.matchAll(/<section id="([^"]+)"/g)].map((match) => match[1]);
const SAVED = "furnace-sign-in";
const me = { name: "Test Student", today: "2026-11-23", checked_in_at: null, days_this_month: 0, is_coordinator: false };
const rows = [{ name: 'Ana, "A"', email: "ana@example.test", days: 2, dates: "Oct 1, Oct 2" }];
const settle = () => new Promise(setImmediate);
const deferred = () => Promise.withResolvers();
let nodes, stored, events, requests, downloads, answer, visit = 0;

class Element {
  constructor(id = "", hidden = false) {
    Object.assign(this, { id, hidden, disabled: false, children: [], value: "", textContent: "" });
  }
  append(...children) { this.children.push(...children); }
  replaceChildren(...children) { this.children = children; }
  setCustomValidity(message) { this.validationMessage = message; }
  reportValidity() { return !this.validationMessage; }
  click() { downloads.push(this); }
}

const originalError = console.error;
after(() => { console.error = originalError; });
beforeEach(() => {
  console.error = () => {};
  nodes = new Map([...html.matchAll(/<[^>]*\bid="([^"]+)"[^>]*>/g)]
    .map(([tag, id]) => [id, new Element(id, /\bhidden\b/.test(tag))]));
  stored = new Map([[SAVED, JSON.stringify({ access_token: "test-access", refresh_token: "test-refresh" })]]);
  events = new EventTarget();
  requests = [];
  downloads = [];
  answer = async () => me;
  globalThis.document = Object.assign(new EventTarget(), {
    hidden: false,
    getElementById: (id) => nodes.get(id),
    querySelectorAll: () => sections.map((id) => nodes.get(id)),
    createElement: () => new Element(),
  });
  globalThis.addEventListener = events.addEventListener.bind(events);
  globalThis.localStorage = {
    getItem: (key) => stored.get(key) ?? null,
    setItem: (key, value) => stored.set(key, value),
    removeItem: (key) => stored.delete(key),
  };
  globalThis.location = {
    origin: "https://example.test", pathname: "/", hash: "", search: "",
    assign: (url) => { location.destination = url; },
    reload: () => assert.fail("Resuming should preserve the page, not reload it"),
  };
  globalThis.history = { replaceState: () => { location.hash = ""; location.search = ""; } };
  globalThis.fetch = async (url, options) => {
    const request = { name: new URL(url).pathname.split("/").at(-1), args: JSON.parse(options.body) };
    requests.push(request);
    return new Response(JSON.stringify(await answer(request)), { status: 200 });
  };
});

const $ = (id) => nodes.get(id);
async function open() {
  await import(`../app.js?visit=${++visit}`);
  await settle();
}
function visibility(hidden) {
  document.hidden = hidden;
  document.dispatchEvent(new Event("visibilitychange"));
}
function month(value) {
  $("month").value = value;
  $("month").oninput();
}

for (const error of [new TypeError("Failed to fetch"), new DOMException("Timed out", "TimeoutError")]) {
  test(`${error.name} on initial load offers a retry that recovers without signing out`, async () => {
    answer = async () => { throw error; };
    await open();
    assert.equal($("loading").hidden, true);
    assert.equal($("retry").hidden, false);
    assert.equal($("problem").hidden, false);
    assert.ok(stored.has(SAVED));

    await $("retry").onclick();
    assert.equal($("retry").hidden, false, "A failed retry must still be recoverable");
    answer = async () => me;
    await $("retry").onclick();
    assert.equal($("signed-in").hidden, false);
    assert.equal($("problem").hidden, true);
    assert.equal($("retry").hidden, true);
    assert.equal($("check-in").disabled, false);
  });
}

test("cancelled Google sign-in leaves a working sign-in button", async () => {
  stored.clear();
  location.search = "?error=access_denied&error_description=User+cancelled";
  await open();
  assert.equal($("signed-out").hidden, false);
  assert.equal($("retry").hidden, true);
  assert.match($("problem").textContent, /User cancelled/);
  $("sign-in").onclick();
  assert.match(location.destination, /provider=google/);
  assert.equal(requests.length, 0);
});

test("returning the next day refreshes status once and enables today's check-in", async () => {
  answer = async () => ({ ...me, today: "2026-11-22", checked_in_at: "2026-11-22T23:00:00Z", days_this_month: 1 });
  await open();
  assert.equal($("check-in").hidden, true);
  visibility(true);
  assert.equal(requests.length, 1);

  const fresh = deferred();
  answer = () => fresh.promise;
  visibility(false);
  events.dispatchEvent(new Event("focus"));
  assert.equal(requests.length, 2, "Visibility and focus must share the in-flight request");
  assert.equal($("check-in").disabled, true);
  fresh.resolve(me);
  await settle();
  assert.match($("today").textContent, /23/);
  assert.equal($("checked-in").hidden, true);
  assert.equal($("check-in").hidden, false);
  assert.equal($("check-in").disabled, false);
});

test("focus and a restored Back-button page also refresh status", async () => {
  await open();
  events.dispatchEvent(new Event("pageshow"));
  assert.equal(requests.length, 1, "The initial pageshow must not repeat startup");
  events.dispatchEvent(new Event("focus"));
  await settle();
  assert.equal(requests.length, 2);
  events.dispatchEvent(Object.assign(new Event("pageshow"), { persisted: true }));
  await settle();
  assert.equal(requests.length, 3);
});

test("a failed resume hides stale attendance and provides a retry", async () => {
  answer = async () => ({ ...me, checked_in_at: "2026-11-23T22:00:00Z" });
  await open();
  answer = async () => { throw new TypeError("Offline"); };
  events.dispatchEvent(new Event("focus"));
  await settle();
  assert.equal($("signed-in").hidden, true);
  assert.equal($("retry").hidden, false);
  assert.ok(stored.has(SAVED));
  answer = async () => ({ ...me, today: "2026-11-24" });
  await $("retry").onclick();
  assert.equal($("signed-in").hidden, false);
  assert.equal($("check-in").hidden, false);
  assert.match($("today").textContent, /24/);
});

test("returning after signing out in another tab shows the sign-in screen", async () => {
  await open();
  stored.clear();
  events.dispatchEvent(new Event("focus"));
  await settle();
  assert.equal($("signed-out").hidden, false);
  assert.equal($("sign-out").hidden, true);
  assert.equal($("signed-in").hidden, true);
  assert.equal(requests.length, 1);
});

test("check-in and status refresh cannot overwrite each other", async () => {
  await open();
  const pendingStatus = deferred();
  answer = () => pendingStatus.promise;
  events.dispatchEvent(new Event("focus"));
  await $("check-in").onclick();
  assert.equal(requests.length, 2, "Check-in must wait for the fresh status");
  pendingStatus.resolve(me);
  await settle();

  const pendingCheckIn = deferred();
  answer = () => pendingCheckIn.promise;
  const checkIn = $("check-in").onclick();
  events.dispatchEvent(new Event("focus"));
  visibility(false);
  await $("check-in").onclick();
  assert.equal(requests.length, 3, "No duplicate check-in or concurrent status read");
  assert.equal(requests.at(-1).name, "check_in");
  pendingCheckIn.resolve({ ...me, checked_in_at: "2026-11-23T22:00:00Z", days_this_month: 1 });
  await checkIn;
  assert.equal($("check-in").hidden, true);
  assert.equal($("checked-in").hidden, false);
});

test("failed check-in releases the button for another attempt", async () => {
  await open();
  answer = async () => { throw new TypeError("Offline"); };
  await $("check-in").onclick();
  assert.equal($("check-in").disabled, false);
  answer = async () => ({ ...me, checked_in_at: "2026-11-23T22:00:00Z" });
  await $("check-in").onclick();
  assert.equal($("checked-in").hidden, false);
});

test("admin can export a month older than a year and keep it selected across New Year", async () => {
  answer = async () => ({ ...me, is_coordinator: true });
  await open();
  assert.equal($("coordinator").hidden, false);
  month("2024-10");
  answer = async () => rows;
  await $("view-report").onclick();
  assert.deepEqual(requests.at(-1), { name: "monthly_report", args: { month_start: "2024-10-01" } });

  answer = async () => ({ ...me, today: "2027-01-01", is_coordinator: true });
  events.dispatchEvent(new Event("focus"));
  await settle();
  assert.equal($("month").max, "2027-01");
  assert.equal($("month").value, "2024-10");
  assert.equal($("report-area").hidden, false);
  assert.equal($("report-total").textContent, "1 person, 2 check-ins");
  $("download").onclick();
  const link = downloads.at(-1);
  assert.equal(link.download, "furnace-attendance-2024-10.csv");
  // Read the real download bytes without using the network.
  const { resolveObjectURL } = await import("node:buffer");
  assert.match(await resolveObjectURL(link.href).text(), /"Ana, ""A"""/);
  URL.revokeObjectURL(link.href);
});

test("changing months hides the old CSV and ignores late reports", async () => {
  answer = async () => ({ ...me, is_coordinator: true });
  await open();
  answer = async () => rows;
  await $("view-report").onclick();
  const first = deferred();
  month("2026-10");
  assert.equal($("report-area").hidden, true);
  $("download").onclick();
  assert.equal(downloads.length, 0);
  answer = () => first.promise;
  const firstReport = $("view-report").onclick();
  month("2026-09");
  answer = async () => [{ ...rows[0], days: 3 }];
  await $("view-report").onclick();
  first.resolve(rows);
  await firstReport;
  assert.equal($("report-total").textContent, "1 person, 3 check-ins");
  $("download").onclick();
  assert.equal(downloads.at(-1).download, "furnace-attendance-2026-09.csv");
  URL.revokeObjectURL(downloads.at(-1).href);
});

test("failed monthly report offers a retry and never exposes the previous CSV", async () => {
  answer = async () => ({ ...me, is_coordinator: true });
  await open();
  answer = async () => rows;
  await $("view-report").onclick();
  month("2024-10");
  answer = async () => { throw new TypeError("Offline"); };
  await $("view-report").onclick();
  assert.equal($("report-area").hidden, true);
  assert.equal($("retry").hidden, false);
  answer = async () => rows;
  await $("retry").onclick();
  assert.equal($("report-area").hidden, false);
  assert.equal($("retry").hidden, true);
});

test("empty, invalid and future months never request a report", async () => {
  await open();
  for (const value of ["", "2026-13", "0000-01", "2027-01", "October 2024"]) {
    month(value);
    await $("view-report").onclick();
    assert.ok($("month").validationMessage);
  }
  assert.equal(requests.length, 1);
});
