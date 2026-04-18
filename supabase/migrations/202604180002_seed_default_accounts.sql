insert into public.accounts (user_id, name, type, initial_balance, currency, is_default)
select id, 'Cash', 'cash', 0, currency, true
from public.profiles
where not exists (select 1 from public.accounts where accounts.user_id = profiles.id and accounts.is_default = true);
