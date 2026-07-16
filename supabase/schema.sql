-- Habit Tracker sync schema.
-- Run this once in your Supabase project's SQL editor (Dashboard → SQL).

create table if not exists public.habits (
  user_id     uuid    not null default auth.uid(),
  id          text    not null,
  name        text    not null,
  color       text    not null,
  target      int     not null,
  created_day text    not null,
  deleted     boolean not null default false, -- tombstone so deletes propagate across devices
  updated_ms  bigint  not null,               -- client clock, ms; last-write-wins key
  primary key (user_id, id)
);

create table if not exists public.checks (
  user_id    uuid    not null default auth.uid(),
  habit_id   text    not null,
  day        text    not null,               -- 'YYYY-MM-DD'
  done       boolean not null,
  updated_ms bigint  not null,
  primary key (user_id, habit_id, day)
);

alter table public.habits enable row level security;
alter table public.checks enable row level security;

create policy "own habits" on public.habits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own checks" on public.checks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Live updates between devices (optional but recommended).
alter publication supabase_realtime add table public.habits;
alter publication supabase_realtime add table public.checks;

create index if not exists habits_updated_idx on public.habits (user_id, updated_ms);
create index if not exists checks_updated_idx on public.checks (user_id, updated_ms);
