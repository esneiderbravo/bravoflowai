update public.transactions t
set account_id = (
  select a.id from public.accounts a
  where a.user_id = t.user_id and a.is_default = true
  limit 1
)
where t.account_id is null;
