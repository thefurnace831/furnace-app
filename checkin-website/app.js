// The page: sign in, check in, and the monthly report for coordinators.
// Keep it snappy: no animations or timers here (see "Speed and reliability" in the README).
import { SUPABASE_URL } from "./config.js";
import * as supabase from "./supabase.js";

const $ = (id) => document.getElementById(id);
let report = { month: "", rows: [] };
let reportRequest = 0;
let refreshing = false;
let checkingIn = false;

$("sign-in").onclick = supabase.signIn;
$("check-in").onclick = checkIn;
$("download").onclick = download;
$("view-report").onclick = showReport;
$("month").oninput = () => {
  reportRequest++;
  $("report-area").hidden = true;
};
$("sign-out").onclick = async () => {
  await supabase.signOut();
  location.reload();
};

// Refresh on return, without resetting the admin's selected report month.
const resume = () => !document.hidden && start();
addEventListener("focus", resume);
document.addEventListener("visibilitychange", resume);
addEventListener("pageshow", (event) => event.persisted && resume());

start();

async function start() {
  if (SUPABASE_URL.includes("YOUR-PROJECT")) return show("setup");
  if (refreshing || checkingIn) return;

  refreshing = true;
  $("check-in").disabled = true;
  $("problem").hidden = true;
  $("retry").hidden = true;
  if ($("signed-in").hidden) show("loading");
  try {
    supabase.finishSignIn();
    if (!supabase.isSignedIn()) {
      $("sign-out").hidden = true;
      return show("signed-out");
    }
    showStatus(await supabase.call("my_status"));
  } catch (error) {
    $("signed-in").hidden = true;
    problem(error, "Couldn't load the page", start);
  } finally {
    refreshing = false;
    $("check-in").disabled = false;
  }
}

// `me` comes from my_status() in schema.sql.
function showStatus(me) {
  $("name").textContent = (me.name || "").split(" ")[0] || "there";
  $("today").textContent = new Date(me.today + "T12:00")
    .toLocaleDateString([], { weekday: "long", month: "long", day: "numeric" });

  $("check-in").hidden = Boolean(me.checked_in_at);
  $("checked-in").hidden = !me.checked_in_at;
  if (me.checked_in_at) {
    $("checked-in").textContent = `✓ Checked in at ${time(me.checked_in_at)}`;
  }
  $("this-month").textContent =
    `${me.days_this_month} ${me.days_this_month === 1 ? "day" : "days"} this month`;

  $("month").max = me.today.slice(0, 7);
  if (!$("month").value) $("month").value = $("month").max;
  show("signed-in", me.is_coordinator && "coordinator");
  $("sign-out").hidden = false;
}

async function checkIn() {
  if (refreshing || checkingIn) return;
  checkingIn = true;
  $("check-in").disabled = true;
  $("problem").hidden = true;
  $("retry").hidden = true;
  try {
    showStatus(await supabase.call("check_in"));
  } catch (error) {
    problem(error, "Check-in didn't go through");
  } finally {
    checkingIn = false;
    $("check-in").disabled = false;
  }
}

async function showReport() {
  const input = $("month");
  // Also validate browsers that display month inputs as plain text.
  input.setCustomValidity(/^\d{4}-(0[1-9]|1[0-2])$/.test(input.value)
    && input.value >= "0001-01" && input.value <= input.max ? "" : "Choose a month up to this month (YYYY-MM).");
  if (!input.reportValidity()) return;
  const month = input.value + "-01";
  const request = ++reportRequest;
  $("problem").hidden = true;
  $("retry").hidden = true;
  $("report-area").hidden = true;
  try {
    const rows = await supabase.call("monthly_report", { month_start: month });
    if (request !== reportRequest) return;
    report = { month, rows };
  } catch (error) {
    if (request === reportRequest) problem(error, "Couldn't load the report", showReport);
    return;
  }

  const checkIns = report.rows.reduce((sum, row) => sum + row.days, 0);
  $("report-total").textContent =
    `${report.rows.length} ${report.rows.length === 1 ? "person" : "people"}, ${checkIns} check-ins`;
  $("report").replaceChildren(...report.rows.map(personRow));
  $("download").hidden = report.rows.length === 0;
  $("report-area").hidden = false;
}

// <li><span avatar>SS</span> <div>Name<small>email</small></div> <span>4 days</span></li>
function personRow(row) {
  const name = row.name ?? "";
  const avatar = element("span", "avatar", name.split(" ").map((word) => word[0]).join("").slice(0, 2));
  const who = element("div", "who", name);
  who.append(element("small", "", row.email));
  const days = element("span", "days", `${row.days} ${row.days === 1 ? "day" : "days"}`);

  const li = document.createElement("li");
  li.append(avatar, who, days);
  return li;
}

function element(tag, className, text) {
  const el = document.createElement(tag);
  el.className = className;
  el.textContent = text ?? "";
  return el;
}

// Save the report as a CSV file, which Excel and Google Sheets open.
function download() {
  if ($("report-area").hidden) return;
  const lines = [["Name", "Email", "Days", "Dates"]]
    .concat(report.rows.map((row) => [row.name, row.email, row.days, row.dates]));
  const csv = lines.map((line) => line.map(csvCell).join(",")).join("\r\n");

  const link = document.createElement("a");
  link.href = URL.createObjectURL(new Blob(["\ufeff" + csv], { type: "text/csv" }));
  link.download = `furnace-attendance-${report.month.slice(0, 7)}.csv`;
  link.click();
}

function csvCell(value) {
  let text = String(value ?? "");
  // A cell starting with = + - or @ would run as a formula in a spreadsheet.
  if (/^[=+\-@]/.test(text)) text = "'" + text;
  return `"${text.replaceAll('"', '""')}"`;
}

// Show only the named sections of the page.
function show(...names) {
  for (const section of document.querySelectorAll("section")) {
    section.hidden = !names.includes(section.id);
  }
}

function problem(error, what, retry) {
  console.error(error);
  $("loading").hidden = true;
  const signedOut = error instanceof supabase.SignedOut || !supabase.isSignedIn();
  if (signedOut) {
    show("signed-out");
    $("sign-out").hidden = true;
  }
  $("retry").hidden = signedOut || !retry;
  $("retry").onclick = retry;
  const why =
    error.name === "TimeoutError" ? "the connection is too slow"
    : error instanceof TypeError ? "no internet connection"  // how fetch() reports being offline
    : error.message;
  $("problem").textContent = error instanceof supabase.SignedOut
    ? error.message
    : `${what}: ${why}. Please try again.`;
  $("problem").hidden = false;
}

function time(timestamp) {
  return new Date(timestamp).toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });
}
