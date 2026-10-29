# The Furnace Check-In

> **A standalone website, separate from the rest of this repo.** It doesn't
> use Flutter, Dart, Parse/Back4App or any file outside this folder, and it
> has its own database. Check-ins made here don't appear in the mobile app,
> and the reverse.

Daily attendance for the Furnace Teen Center:

1. A student scans the QR code at the door with their phone's camera.
2. The website opens. They sign in with Google and tap **I'm here today**.
3. At the end of the month, a coordinator picks the month and downloads a
   spreadsheet of who came and how many days.

## Speed and reliability come first

Teens open this page standing in a doorway, often on a weak signal. It has to
load instantly, react the moment it's tapped, and never get stuck. Every
change must keep these rules:

- **Tiny.** The whole page is under 25 KB, logo included. The tests fail if
  it passes 40 KB.
- **No JavaScript animations, no timers, no CSS transitions.** Buttons react
  the instant they're touched. The tests fail if any of these appear.
- **Nothing from other websites.** No frameworks, packages, web fonts, CDNs
  or trackers, and no build step. If another site goes down, this one
  doesn't notice.
- **One request to show the page and one to check in.** The scripts all
  download at once, not one after another.
- **Never stuck.** Every request gives up after 10 seconds and shows a
  "try again" message. Losing signal never signs anyone out.
- **Phones first.** Every button is at least 44px tall, nothing scrolls
  sideways, and it also works with a mouse on a laptop.

## Files

| File | What it does |
|---|---|
| `config.js` | Your Supabase address and public key. **The only file you edit.** |
| `index.html` | The page |
| `style.css` | How it looks |
| `app.js` | What the page does: check in, show the report, download it |
| `supabase.js` | Talks to Supabase: Google sign-in and database calls |
| `schema.sql` | The database: one table, three functions and the security rules |
| `tests/` | Automated tests for sign-in handling and the speed rules |

**Supabase** (free) runs the database and Google sign-in. **GitHub Pages**
(free) hosts the site.

### What the database guarantees

- One check-in per person per day. Tapping twice still counts once.
- The date comes from the database (Pacific time), not the phone, so nobody
  can check in for a different day.
- The website can't read or change the tables directly. It can only call the
  functions in `schema.sql`, and each one checks who is asking.
- Only coordinators can see the report.
- Each check-in stores a name, email, date and time. Nothing else.

## Setup (about an hour, once)

### 1. Supabase

1. Create a free project at [supabase.com](https://supabase.com).
2. In **SQL Editor**, paste all of `schema.sql` and click **Run**.
3. In **Project Settings → API**, copy two values into `config.js`:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** (or **publishable**) key → `SUPABASE_KEY`

   Never use the **service_role** or **secret** key.

### 2. Google sign-in

1. In [Google Cloud Console](https://console.cloud.google.com), create a project.
2. **APIs & Services → OAuth consent screen**: choose **External**, enter the
   app name and your email, then **publish** it. While it says "Testing", only
   people you list can sign in.
3. **Credentials → Create credentials → OAuth client ID → Web application.**
   Under **Authorized redirect URIs**, add the callback URL shown in Supabase
   under **Authentication → Sign In / Providers → Google**. It looks like
   `https://YOUR-PROJECT.supabase.co/auth/v1/callback`.
4. Paste the client ID and secret into that Supabase page and turn Google on.
5. Turn **off** every other sign-in method in Supabase.

### 3. GitHub Pages

1. On GitHub, open the repo's **Settings → Pages** and set **Source** to
   **GitHub Actions**. (Free Pages needs a public repo.)
2. Push to `main`. The workflow `.github/workflows/checkin-website.yml` runs
   the tests and publishes this folder only if they pass.
3. The site is live at `https://thefurnace831.github.io/furnace-app/`.
4. In Supabase, **Authentication → URL Configuration**: set **Site URL** to
   that address and add it under **Redirect URLs**. If sign-in sends people
   to the wrong page, this is almost always why.

From then on, every push to `main` that changes this folder updates the site.

### 4. Add coordinators

Sign in on the site once. Then in Supabase, open **Table Editor →
coordinators** and add a row with your Google email. Reload the site and the
monthly report appears. Delete the row to remove access.

### 5. Print the QR code

`qr-code.png` in this folder is a ready-to-print poster: a QR code with the
Furnace logo that opens `https://thefurnace831.github.io/furnace-app/`. Print
it and post it at the door. If the site's address ever changes, make a new
code; this one only knows the old address.

## Working on it

Commands run from the repo root. Tests need Node 22 or newer; nothing to install.

```sh
cd checkin-website
python3 -m http.server 8000   # then open http://localhost:8000
node --test                   # run the tests
```

- **Google sign-in on your computer:** add `http://localhost:8000` to
  Supabase's **Redirect URLs**. Opening `index.html` straight from the folder
  won't work; the browser needs a web address.
- **On your phone:** run the server with `--bind 0.0.0.0`, then open
  `http://YOUR-COMPUTER'S-IP:8000` on a phone on the same Wi-Fi, and add that
  address to **Redirect URLs** too.
- **Changed `schema.sql`?** Paste the whole file into the Supabase SQL Editor
  and run it again. It's safe to re-run.
- **A speed test failed?** `tests/budget.test.js` holds the rules above. Fix
  the change, not the rule.

## Good to know

- **Free Supabase projects pause after a week with no visits**, e.g. over
  summer break. Click **Restore** in the Supabase dashboard; nothing is lost.
- **Some school Google accounts are blocked** by the district from signing in
  to outside sites. Personal Gmail always works.
- **Anyone with the link can check in from anywhere.** If that becomes a
  problem, a daily code in the QR link is the next step.
- **Tracking sessions later:** add a `sessions` table and a `session_id`
  column to `attendance`, and pass the session to `check_in()` from a
  per-session QR code.
