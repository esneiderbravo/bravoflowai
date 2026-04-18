create table if not exists public.accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  type text not null check (type in ('checking', 'savings', 'cash', 'investment', 'other')),
  initial_balance numeric(12,2) not null default 0,
  currency text not null default 'USD',
  color text,
  icon text,
  is_default boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.accounts enable row level security;
create policy "own_accounts" on public.accounts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
