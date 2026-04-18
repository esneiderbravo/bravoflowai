-- BravoFlow AI — Profile auto-creation trigger
-- Date: 2026-04-11
--
-- Problem solved:
--   The Flutter client cannot upsert into public.profiles during sign-up when
--   email confirmation is required, because no session exists at that point and
--   the RLS policy (auth.uid() = id) rejects the anonymous request (code 42501).
--
-- Solution:
--   A SECURITY DEFINER trigger fires AFTER INSERT ON auth.users inside the same
--   database transaction as the Supabase Auth sign-up call. It runs as the
--   database owner, bypasses RLS, and guarantees the profile row always exists
--   by the time the API response reaches the client.
--
-- Name is read from raw_user_meta_data passed in the Flutter signUp call:
--   client.auth.signUp(email: ..., password: ..., data: {'name': '<value>'})

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, currency)
  values (
    new.id,
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
      split_part(new.email, '@', 1)
    ),
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'currency'), ''),
      'USD'
    )
  )
  on conflict (id) do nothing; -- idempotent: skip if profile already exists

  insert into public.accounts (user_id, name, type, initial_balance, currency, is_default)
  values (new.id, 'Cash', 'cash', 0, coalesce(nullif(trim(new.raw_user_meta_data ->> 'currency'), ''), 'USD'), true);

  return new;
end;
$$;

-- Drop the trigger first so the migration is re-runnable in dev environments.
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

