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
- **Local & portable data** — everything is stored in `localStorage`;
  export/import as JSON from the footer.

## Usage

1. Open `index.html`.
2. Add habits under **Manage habits**, choosing a weekly goal for each.
3. Check habits off in the **Today** list, or click any past day in the
   **This week** grid.

Data never leaves the browser. Use **Export data** to back up and
**Import data** to restore or move between devices.
