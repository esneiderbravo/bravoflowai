-- BravoFlow AI — Fix missing avatar_url in schema cache (PGRST204)
-- Date: 2026-04-11
--
-- Run this manually in Supabase SQL Editor if you see:
-- "Could not find the 'avatar_url' column of 'profiles' in the schema cache"

-- 1) Ensure required profile columns exist (safe, idempotent)
alter table public.profiles
  add column if not exists full_name text,
  add column if not exists email text,
  add column if not exists avatar_url text;

-- 2) Backfill full_name if needed
update public.profiles
set full_name = name
where coalesce(trim(full_name), '') = '';

-- 3) Reload PostgREST schema cache so new columns are visible immediately
notify pgrst, 'reload schema';

-- 4) Optional verification
-- select column_name
-- from information_schema.columns
-- where table_schema = 'public' and table_name = 'profiles'
-- order by ordinal_position;

