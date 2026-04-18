alter table public.transactions add column if not exists account_id uuid references public.accounts(id);
