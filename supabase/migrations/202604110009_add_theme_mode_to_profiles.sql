-- BravoFlow AI - Add theme preference to profiles
-- Date: 2026-04-11

alter table public.profiles
  add column if not exists theme_mode text;

update public.profiles
set theme_mode = 'system'
where coalesce(trim(theme_mode), '') = '';

alter table public.profiles
  alter column theme_mode set default 'system',
  alter column theme_mode set not null;

