create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text,
  phone text,
  department text,
  study_level text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, phone, department, study_level)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', 'Student'),
    new.email,
    new.raw_user_meta_data ->> 'phone',
    new.raw_user_meta_data ->> 'department',
    new.raw_user_meta_data ->> 'study_level'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

drop policy if exists "Students can view own profile" on public.profiles;
create policy "Students can view own profile" on public.profiles
for select to authenticated using (auth.uid() = id);

drop policy if exists "Students can update own profile" on public.profiles;
create policy "Students can update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

grant select, update on public.profiles to authenticated;
