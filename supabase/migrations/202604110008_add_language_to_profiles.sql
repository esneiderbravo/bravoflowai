-- BravoFlow AI — Add language preference to profiles
-- Date: 2026-04-11

alter table public.profiles
  add column if not exists language_code text;

update public.profiles
set language_code = 'es'
where coalesce(trim(language_code), '') = '';

alter table public.profiles
  alter column language_code set default 'es',
  alter column language_code set not null;

