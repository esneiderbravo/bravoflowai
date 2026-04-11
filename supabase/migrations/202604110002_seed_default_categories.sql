-- Seed default categories per new profile
-- Date: 2026-04-11

create or replace function public.seed_default_categories_for_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.categories (user_id, name, icon, color, is_default)
  values
    (new.id, 'Food', 'restaurant', '#3A86FF', true),
    (new.id, 'Transport', 'directions_car', '#7B61FF', true),
    (new.id, 'Bills', 'receipt_long', '#00D4FF', true),
    (new.id, 'Entertainment', 'movie', '#EF4444', true),
    (new.id, 'Health', 'monitor_heart', '#10B981', true),
    (new.id, 'Salary', 'payments', '#F59E0B', true);

  return new;
end;
$$;

drop trigger if exists trg_seed_default_categories on public.profiles;

create trigger trg_seed_default_categories
after insert on public.profiles
for each row
execute function public.seed_default_categories_for_user();

