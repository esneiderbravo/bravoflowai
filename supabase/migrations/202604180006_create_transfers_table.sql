create table if not exists public.transfers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  from_account_id uuid not null references public.accounts(id),
  to_account_id uuid not null references public.accounts(id),
  amount numeric(12,2) not null check (amount > 0),
  date date not null,
  note text,
  created_at timestamptz not null default now(),
  constraint transfers_different_accounts check (from_account_id <> to_account_id)
);
alter table public.transfers enable row level security;
create policy "own_transfers" on public.transfers
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
