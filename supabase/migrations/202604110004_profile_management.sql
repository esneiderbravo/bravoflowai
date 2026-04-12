-- BravoFlow AI — User Profile Management
-- Date: 2026-04-11

-- 1) Extend profiles table for profile management
alter table public.profiles
  add column if not exists full_name text,
  add column if not exists email text,
  add column if not exists avatar_url text;

-- 2) Backfill full_name from legacy name values
update public.profiles
set full_name = name
where coalesce(trim(full_name), '') = '';

-- Keep full_name required for new writes.
alter table public.profiles
  alter column full_name set not null;

-- 3) Backfill email from auth.users when missing
update public.profiles p
set email = u.email
from auth.users u
where p.id = u.id
  and coalesce(trim(p.email), '') = '';

-- 4) Update auto-profile trigger to persist full_name + email metadata
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, full_name, email, currency)
  values (
    new.id,
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
      split_part(new.email, '@', 1)
    ),
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
      nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
      split_part(new.email, '@', 1)
    ),
    new.email,
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'currency'), ''),
      'USD'
    )
  )
  on conflict (id) do update
    set full_name = excluded.full_name,
        email = excluded.email;

  return new;
end;
$$;

-- 5) Create avatars bucket if missing
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- 6) Storage policies: each user can only manage objects in own folder prefix
create policy "avatar_read_own_folder" on storage.objects
  for select
  using (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "avatar_insert_own_folder" on storage.objects
  for insert
  with check (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

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

create policy "avatar_delete_own_folder" on storage.objects
  for delete
  using (
    bucket_id = 'avatars'
    and split_part(name, '/', 1) = auth.uid()::text
  );

-- 7) Manual verification snippets (run in SQL editor as needed)
-- SELECT id, name, full_name, email, avatar_url FROM public.profiles LIMIT 5;
-- SELECT bucket_id, name FROM storage.objects WHERE bucket_id = 'avatars' LIMIT 20;

