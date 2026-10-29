// Speed rules for this site, checked on every change. If one fails, the
// change made the site slower or heavier: fix the change, not the rule.
import assert from "node:assert/strict";
import { readFileSync, statSync } from "node:fs";
import { test } from "node:test";

const root = new URL("../", import.meta.url);
const read = (file) => readFileSync(new URL(file, root), "utf8");
const PAGE = ["index.html", "style.css", "app.js", "supabase.js", "config.js", "logo.png"];

test("the whole page weighs under 40 KB", () => {
  const bytes = PAGE.reduce((sum, file) => sum + statSync(new URL(file, root)).size, 0);
  assert.ok(bytes < 40_000, `the page is ${bytes} bytes`);
});

test("no JavaScript animations or timers", () => {
  for (const file of ["app.js", "supabase.js"]) {
    assert.doesNotMatch(read(file), /requestAnimationFrame|\.animate\(|setInterval|setTimeout/, file);
  }
});

test("no CSS transitions", () => {
  assert.doesNotMatch(read("style.css"), /transition\s*:/);
});

test("nothing loads from other websites", () => {
  assert.doesNotMatch(read("index.html"), /(src|href)="(https?:)?\/\//);
});
