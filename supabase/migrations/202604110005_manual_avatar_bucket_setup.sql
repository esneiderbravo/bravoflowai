-- BravoFlow AI — Manual avatar storage setup (idempotent)
-- Date: 2026-04-11
--
-- Purpose:
--   Run this manually in Supabase SQL Editor when avatar upload fails with
--   "Bucket not found" or policy issues.
--
-- Safe to re-run:
--   - Bucket creation uses ON CONFLICT DO NOTHING
--   - Policies are dropped if they already exist, then recreated

-- 1) Ensure avatars bucket exists
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- 2) Recreate avatar policies to avoid duplicate-name failures
-- NOTE: policies live on storage.objects

drop policy if exists "avatar_read_own_folder" on storage.objects;
create policy "avatar_read_own_folder" on storage.objects
  for select
  using (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

drop policy if exists "avatar_insert_own_folder" on storage.objects;
create policy "avatar_insert_own_folder" on storage.objects
  for insert
  with check (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

drop policy if exists "avatar_update_own_folder" on storage.objects;
create policy "avatar_update_own_folder" on storage.objects
  for update
  using (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

drop policy if exists "avatar_delete_own_folder" on storage.objects;
create policy "avatar_delete_own_folder" on storage.objects
  for delete
  using (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

-- 3) Optional sanity checks
-- select id, name, public from storage.buckets where id = 'avatars';
-- select policyname, cmd from pg_policies
-- where schemaname = 'storage' and tablename = 'objects' and policyname like 'avatar_%';

