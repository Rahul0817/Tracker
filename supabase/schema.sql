-- Habit Tracker sync schema.
-- Run this once in your Supabase project's SQL editor (Dashboard → SQL).

create table if not exists public.habits (
  user_id     uuid    not null default auth.uid(),
  id          text    not null,
  name        text    not null,
  color       text    not null,
  target      int     not null,
  created_day text    not null,
  archived    boolean not null default false, -- soft-delete: hidden from views, history kept
  sort        int     not null default 0,     -- display order
  deleted     boolean not null default false, -- tombstone so deletes propagate across devices
  updated_ms  bigint  not null,               -- client clock, ms; last-write-wins key
  primary key (user_id, id)
);

create table if not exists public.checks (
  user_id    uuid    not null default auth.uid(),
  habit_id   text    not null,
  day        text    not null,               -- 'YYYY-MM-DD'
  done       boolean not null,
  note       text,                           -- optional per-day note
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

-- Already ran an earlier version of this schema? Apply just the additions:
-- alter table public.habits add column if not exists archived boolean not null default false;
-- alter table public.habits add column if not exists sort int not null default 0;
-- alter table public.checks add column if not exists note text;
