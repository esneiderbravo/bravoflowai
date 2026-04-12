-- BravoFlow AI initial schema
-- Date: 2026-04-11

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  currency text not null default 'USD',
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  icon text,
  color text,
  is_default boolean not null default false
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category_id uuid references public.categories(id),
  amount numeric(12,2) not null,
  type text not null check (type in ('income', 'expense')),
  description text,
  date date not null,
  created_at timestamptz not null default now()
);

create table if not exists public.budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category_id uuid references public.categories(id),
  amount numeric(12,2) not null,
  period text not null check (period in ('monthly', 'weekly', 'yearly')),
  starts_at date not null
);

create table if not exists public.ai_insights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null,
  title text not null,
  body text not null,
  confidence numeric(3,2) not null default 1.0,
  generated_at timestamptz not null default now(),
  related_transaction_ids uuid[] not null default '{}'
);

-- Enable RLS
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets enable row level security;
alter table public.ai_insights enable row level security;

-- Policies
create policy "own_profile" on public.profiles
  for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "own_categories" on public.categories
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "own_transactions" on public.transactions
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "own_budgets" on public.budgets
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "own_ai_insights" on public.ai_insights
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

