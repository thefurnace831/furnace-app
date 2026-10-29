// Everything that talks to Supabase: signing in with Google, staying signed
// in, and calling the database functions in schema.sql. Plain fetch(), no SDK.
import { SUPABASE_KEY, SUPABASE_URL } from "./config.js";

const SAVED_SIGN_IN = "furnace-sign-in";
// Give up on a request after this long, so a weak signal never leaves the
// page waiting forever. The person sees a "try again" message instead.
const TIME_LIMIT_MS = 10_000;

export class SignedOut extends Error {
  constructor() {
    super("Please sign in again.");
  }
}

// Send the person to Google. Supabase brings them back to this page.
export function signIn() {
  const back = encodeURIComponent(location.origin + location.pathname);
  location.assign(`${SUPABASE_URL}/auth/v1/authorize?provider=google&redirect_to=${back}`);
}

// Back from Google, the sign-in (or an error) is in the page address.
// Save it and tidy the address bar.
export function finishSignIn() {
  const result = new URLSearchParams(location.hash.slice(1) + "&" + location.search.slice(1));
  if (!result.has("access_token") && !result.has("error")) return;

  history.replaceState(null, "", location.origin + location.pathname);
  if (result.has("error")) {
    throw new Error(result.get("error_description") || result.get("error"));
  }
  save(result.get("access_token"), result.get("refresh_token"));
}

export function isSignedIn() {
  return load() !== null;
}

export async function signOut() {
  try {
    await send("/auth/v1/logout");
  } catch {
    // Offline: forgetting the sign-in on this device is what matters.
  }
  localStorage.removeItem(SAVED_SIGN_IN);
}

// Run one of the functions in schema.sql, e.g. call("check_in").
export async function call(name, args = {}) {
  let response = await send(`/rest/v1/rpc/${name}`, args);

  // Sign-ins last an hour. When one runs out, renew it and try once more.
  if (response.status === 401) {
    await renew();
    response = await send(`/rest/v1/rpc/${name}`, args);
  }
  if (response.status === 401) throw forget();
  if (!response.ok) throw new Error(await errorText(response));
  return response.json();
}

function send(path, body = {}) {
  const saved = load();
  if (!saved) throw new SignedOut();

  return fetch(SUPABASE_URL + path, {
    method: "POST",
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${saved.access_token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
    signal: AbortSignal.timeout(TIME_LIMIT_MS),
  });
}

// Each renewal code works once, so requests that fail together share one
// renewal. Other tabs pick up the result because it's saved, and every
// request reads the saved sign-in fresh.
let renewing = null;

function renew() {
  renewing ??= renewNow().finally(() => (renewing = null));
  return renewing;
}

async function renewNow() {
  const saved = load();
  if (!saved) throw new SignedOut();

  const response = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=refresh_token`, {
    method: "POST",
    headers: { apikey: SUPABASE_KEY, "Content-Type": "application/json" },
    body: JSON.stringify({ refresh_token: saved.refresh_token }),
    signal: AbortSignal.timeout(TIME_LIMIT_MS),
  });
  if (response.status === 400 || response.status === 401) throw forget();
  if (!response.ok) throw new Error(await errorText(response));

  const renewed = await response.json();
  save(renewed.access_token, renewed.refresh_token);
}

function save(access_token, refresh_token) {
  localStorage.setItem(SAVED_SIGN_IN, JSON.stringify({ access_token, refresh_token }));
}

function load() {
  try {
    const saved = JSON.parse(localStorage.getItem(SAVED_SIGN_IN));
    return saved?.access_token && saved?.refresh_token ? saved : null;
  } catch {
    return null;
  }
}

function forget() {
  localStorage.removeItem(SAVED_SIGN_IN);
  return new SignedOut();
}

async function errorText(response) {
  const body = await response.json().catch(() => ({}));
  return body.message || body.msg || body.error_description || `Server error ${response.status}`;
}
