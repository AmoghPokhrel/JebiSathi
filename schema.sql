drop table if exists category_budgets cascade;
drop table if exists budgets cascade;
drop table if exists expenses cascade;
drop table if exists periods cascade;

create table periods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  name text not null,
  budget numeric not null default 0,
  started_at timestamptz not null default now(),
  ended_at timestamptz
);
alter table periods enable row level security;
create policy "own periods" on periods for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  period_id uuid references periods(id) not null,
  amount numeric not null,
  category text not null,
  note text,
  created_at timestamptz default now()
);
alter table expenses enable row level security;
create policy "own expenses" on expenses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table category_budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  period_id uuid references periods(id) not null,
  category text not null,
  expected numeric not null default 0,
  unique(period_id, category)
);
alter table category_budgets enable row level security;
create policy "own category budgets" on category_budgets for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
