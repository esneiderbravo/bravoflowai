-- BravoFlow AI — Manual RLS/Storage Validation for Profile Feature
-- Date: 2026-04-11
--
-- Task target: 1.5 Validate RLS and storage policies with manual SQL checks
--
-- IMPORTANT:
--   Run these checks in Supabase SQL Editor with an authenticated JWT context
--   for each user (or via client-side calls with different logged-in users).
--   Some checks require two different users: user_a and user_b.

-- -----------------------------------------------------------------------------
-- 0) Pre-check: policies and bucket exist
-- -----------------------------------------------------------------------------
select id, name, public
from storage.buckets
where id = 'avatars';

select policyname, cmd
from pg_policies
where schemaname = 'public'
  and tablename = 'profiles'
order by policyname, cmd;

select policyname, cmd
from pg_policies
where schemaname = 'storage'
  and tablename = 'objects'
  and policyname like 'avatar_%'
order by policyname, cmd;

-- -----------------------------------------------------------------------------
-- 1) Profiles RLS checks (run as user_a)
-- -----------------------------------------------------------------------------
-- Expected: returns exactly one row for own profile
select id, full_name, email, avatar_url
from public.profiles
where id = auth.uid();

-- Save this value for cross-user tests
-- select auth.uid();

-- -----------------------------------------------------------------------------
-- 2) Profiles cross-user denial (run as user_a, using user_b id)
-- -----------------------------------------------------------------------------
-- Replace <USER_B_UUID>
-- Expected: UPDATE affects 0 rows or is denied by policy
update public.profiles
set full_name = full_name
where id = nullif('<USER_B_UUID>', '<USER_B_UUID>')::uuid;

-- -----------------------------------------------------------------------------
-- 3) Avatar storage own-folder allow (run as user_a via client upload)
-- -----------------------------------------------------------------------------
-- Upload target path must be: <USER_A_UUID>/avatar.png
-- Example validation query after upload:
select bucket_id, name
from storage.objects
where bucket_id = 'avatars'
  and split_part(name, '/', 1) = auth.uid()::text
order by created_at desc
limit 5;

-- -----------------------------------------------------------------------------
-- 4) Avatar storage cross-user denial (run as user_a via client upload)
-- -----------------------------------------------------------------------------
-- Attempt upload to: <USER_B_UUID>/avatar.png
-- Expected: denied by storage policy (401/403-like error from API)

-- -----------------------------------------------------------------------------
-- 5) Result template (copy into PR / task notes)
-- -----------------------------------------------------------------------------
-- [ ] Own profile select allowed
-- [ ] Cross-user profile update denied
-- [ ] Own-folder avatar upload allowed
-- [ ] Cross-user avatar upload denied

