-- =============================================
-- SUPABASE SCHEMA - Travel App
-- Chạy file này trong Supabase SQL Editor
-- =============================================

-- 1. PROFILES TABLE
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  first_name text,
  last_name text,
  avatar_url text,
  role text default 'Traveler',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Auto-create profile khi user đăng ký
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, first_name, last_name)
  values (new.id, '', '');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. TRIPS TABLE
create table public.trips (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade,
  location text not null,
  date date,
  from_time text,
  to_time text,
  number_of_travelers int default 1,
  fee numeric(10,2) default 0,
  guide_language text,
  guide_name text,
  attractions jsonb default '[]',
  status text default 'pending', -- pending | finished
  created_at timestamptz default now()
);

-- 3. PAYMENTS TABLE
create table public.payments (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade,
  trip_id uuid references public.trips(id) on delete cascade,
  card_holder text,
  card_last4 text,
  amount numeric(10,2),
  status text default 'pending', -- pending | success | failed
  created_at timestamptz default now()
);

-- 4. ROW LEVEL SECURITY
alter table public.profiles enable row level security;
alter table public.trips enable row level security;
alter table public.payments enable row level security;

-- Profiles: chỉ đọc/sửa của chính mình
create policy "Users can view own profile" on public.profiles
  for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles
  for update using (auth.uid() = id);

-- Trips: chỉ xem/tạo/sửa của chính mình
create policy "Users can view own trips" on public.trips
  for select using (auth.uid() = user_id);
create policy "Users can insert own trips" on public.trips
  for insert with check (auth.uid() = user_id);
create policy "Users can update own trips" on public.trips
  for update using (auth.uid() = user_id);

-- Payments: chỉ xem/tạo của chính mình
create policy "Users can view own payments" on public.payments
  for select using (auth.uid() = user_id);
create policy "Users can insert own payments" on public.payments
  for insert with check (auth.uid() = user_id);
