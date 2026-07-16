# Habit Tracker

A self-contained, single-file habit tracking web app. Open `index.html` in any
modern browser — no build step, no server, no dependencies.

## Features

- **Daily check-off** — mark each habit done for today with one tap.
- **Weekly grid** — see and edit the whole week per habit, navigate to past
  weeks, and track progress against each habit's weekly goal (1–7× per week).
- **Streaks** — current streak per habit (today doesn't break a streak until
  the day is over) and best-ever streak.
- **Consistency heatmap** — daily completion rate over the last 20 weeks.
- **Weekly completion chart** — completion rate for the last 8 weeks.
- **Backfill-aware stats** — checking off days before a habit was created
  extends its history, so imported or retroactive data counts.
- **Light & dark themes** — follows the OS setting, with a manual toggle.
- **Installable (PWA)** — add to home screen on Android/iOS; the app shell
  works offline after the first visit (requires serving over HTTPS).
- **Daily reminders** — optional notification at a time you pick if habits
  are still unchecked. Fires only while the app is open in a tab or running
  as an installed app; there is no push server, so a fully closed app cannot
  be notified. (True push would need a service-worker push subscription plus
  a backend endpoint — flagged as future work.)
- **Local & portable data** — everything is stored in `localStorage`;
  export/import as JSON from the footer.

## Usage

1. Open `index.html`.
2. Add habits under **Manage habits**, choosing a weekly goal for each.
3. Check habits off in the **Today** list, or click any past day in the
   **This week** grid.

Without an account, data never leaves the browser. Use **Export data** to back
up and **Import data** to restore or move between devices.

## Cloud sync (optional, Supabase)

The app is local-first: it always works offline from `localStorage`. If you
configure Supabase, users can sign in (email/password or magic link) to back
up their data and sync it across devices. Not configured → the sync UI is
hidden entirely and the app behaves exactly as before.

Setup:

1. Create a free project at [supabase.com](https://supabase.com).
2. In the dashboard, open **SQL Editor** and run `supabase/schema.sql` from
   this repo (creates the `habits`/`checks` tables, row-level security so each
   user can only touch their own rows, and realtime publications).
3. Copy `supabase-config.example.js` to `supabase-config.js` and fill in your
   project URL and anon public key (**Settings → API**). The anon key is safe
   to ship to browsers; row-level security is what protects the data.
4. Serve the app over HTTP(S) (e.g. `npx http-server` or GitHub Pages).
   Auth works best on a real URL; magic-link redirects don't work from
   `file://` pages.

How sync behaves:

- **Local-first** — every change saves to `localStorage` instantly and is
  queued in an outbox; the outbox flushes in the background when online and
  signed in, and remote changes are pulled on load, on reconnect, on tab
  focus, and live via realtime.
- **Conflicts** — resolved per record (per habit, and per habit-day check) by
  last-write-wins on the client timestamp. The merge lives in two small
  functions (`applyRemoteHabit`, `applyRemoteCheck`) so a smarter strategy can
  be swapped in later.
- **First sign-in** — existing local data is migrated into the account
  automatically.
- **Deletes** — propagate via tombstone rows, so a habit deleted on one
  device disappears from the others.

The Supabase JS client loads on demand from a CDN only when sync is
configured — the app itself still has zero build steps and no bundled
dependencies.
