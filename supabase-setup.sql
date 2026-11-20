-- Supabase → SQL Editor میں یہ پورا کوڈ چلائیں۔ اسے بار بار چلانا محفوظ ہے۔
create table if not exists public.ads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  animal text not null,
  title text not null check (char_length(title) <= 120),
  price bigint not null check (price > 0),
  province text,
  city text not null,
  age text,
  weight int,
  phone text not null,
  descr text check (char_length(descr) <= 2000),
  images text[] not null default '{}',
  featured boolean not null default false,
  created_at timestamptz not null default now()
);
alter table public.ads add column if not exists featured boolean not null default false;
create index if not exists ads_created on public.ads (created_at desc);
create index if not exists ads_filter on public.ads (animal, city, price);

alter table public.ads enable row level security;
drop policy if exists "ads_read_all" on public.ads;
create policy "ads_read_all"   on public.ads for select using (true);
drop policy if exists "ads_insert_own" on public.ads;
create policy "ads_insert_own" on public.ads for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "ads_update_own" on public.ads;
create policy "ads_update_own" on public.ads for update to authenticated using (user_id = auth.uid());
drop policy if exists "ads_delete_own" on public.ads;
create policy "ads_delete_own" on public.ads for delete to authenticated using (user_id = auth.uid());

-- تصاویر کے لیے بکٹ
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('ad-images','ad-images', true, 2097152, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

drop policy if exists "img_read" on storage.objects;
create policy "img_read"   on storage.objects for select using (bucket_id = 'ad-images');
drop policy if exists "img_insert" on storage.objects;
create policy "img_insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'ad-images' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "img_delete" on storage.objects;
create policy "img_delete" on storage.objects for delete to authenticated
  using (bucket_id = 'ad-images' and (storage.foldername(name))[1] = auth.uid()::text);

-- پریمیم اکاؤنٹ: صرف آپ (ایڈمن) Table Editor سے اس ٹیبل میں قطار ڈال سکتے ہیں
create table if not exists public.premium_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  until timestamptz not null
);
alter table public.premium_users enable row level security;
drop policy if exists "prem_read_own" on public.premium_users;
create policy "prem_read_own" on public.premium_users for select to authenticated using (user_id = auth.uid());

-- پریمیم صارف کا اشتہار خود بخود "نمایاں" ہو جاتا ہے، کوئی اور نہیں کر سکتا
create or replace function public.set_featured() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.featured := exists (select 1 from public.premium_users p where p.user_id = new.user_id and p.until > now());
  return new;
end $$;
drop trigger if exists ads_set_featured on public.ads;
create trigger ads_set_featured before insert or update on public.ads
  for each row execute function public.set_featured();
create index if not exists ads_featured on public.ads (featured, created_at desc);

-- روزانہ اشتہار کی حد: عام صارف 5، پریمیم صارف 20 (24 گھنٹے میں)
create or replace function public.limit_daily_ads() returns trigger
language plpgsql security definer set search_path = public as $$
declare n int; lim int;
begin
  select count(*) into n from public.ads where user_id = new.user_id and created_at > now() - interval '24 hours';
  select case when exists (select 1 from public.premium_users p where p.user_id = new.user_id and p.until > now()) then 20 else 5 end into lim;
  if n >= lim then raise exception 'daily_limit'; end if;
  return new;
end $$;
drop trigger if exists ads_limit_daily on public.ads;
create trigger ads_limit_daily before insert on public.ads
  for each row execute function public.limit_daily_ads();
