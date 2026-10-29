// The page: sign in, check in, and the monthly report for coordinators.
// Keep it snappy: no animations or timers here (see "Speed and reliability" in the README).
import { SUPABASE_URL } from "./config.js";
import * as supabase from "./supabase.js";

const $ = (id) => document.getElementById(id);
let report = { month: "", rows: [] };

$("sign-in").onclick = supabase.signIn;
$("check-in").onclick = checkIn;
$("download").onclick = download;
$("sign-out").onclick = async () => {
  await supabase.signOut();
  location.reload();
};

// The Back button can show an old copy of this page. Reload to be current.
addEventListener("pageshow", (event) => event.persisted && location.reload());

start();

async function start() {
  if (SUPABASE_URL.includes("YOUR-PROJECT")) return show("setup");

  try {
    supabase.finishSignIn();
    if (!supabase.isSignedIn()) return show("signed-out");
    showStatus(await supabase.call("my_status"));
  } catch (error) {
    problem(error, "Couldn't load the page");
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

  if (me.is_coordinator && !$("months").hasChildNodes()) addMonths(me.today);
  show("signed-in", me.is_coordinator && "coordinator");
  $("sign-out").hidden = false;
}

async function checkIn() {
  $("check-in").disabled = true;
  $("problem").hidden = true;
  try {
    showStatus(await supabase.call("check_in"));
  } catch (error) {
    problem(error, "Check-in didn't go through");
  }
  $("check-in").disabled = false;
}

// Month pills: this month and the 11 before it. Tapping one shows its report.
function addMonths(today) {
  const [year, month] = today.split("-").map(Number);
  for (let back = 0; back < 12; back++) {
    const first = new Date(year, month - 1 - back, 1);
    const button = document.createElement("button");
    button.type = "button";
    button.textContent = first.toLocaleDateString([], { month: "short", year: "numeric" });
    button.dataset.month = `${first.getFullYear()}-${String(first.getMonth() + 1).padStart(2, "0")}-01`;
    button.setAttribute("aria-pressed", "false");
    button.onclick = () => showReport(button);
    $("months").append(button);
  }
}

async function showReport(button) {
  $("problem").hidden = true;
  for (const pill of $("months").children) pill.setAttribute("aria-pressed", pill === button);
  try {
    const month = button.dataset.month;
    report = { month, rows: await supabase.call("monthly_report", { month_start: month }) };
  } catch (error) {
    return problem(error, "Couldn't load the report");
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

function problem(error, what) {
  console.error(error);
  $("loading").hidden = true;
  if (error instanceof supabase.SignedOut) {
    show("signed-out");
    $("sign-out").hidden = true;
  }
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
