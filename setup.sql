-- Run once in Supabase SQL Editor
create extension if not exists pgcrypto;
create table if not exists public.expenses (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 legacy_id text, expense_date date not null, merchant text not null, amount numeric(12,2) not null check(amount>0),
 currency char(3) not null default 'MYR', category text not null default 'Others', payment_method text, notes text,
 receipt_path text, ocr_merchant text, ocr_date date, ocr_amount numeric(12,2), created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(user_id,legacy_id));
create table if not exists public.user_settings (user_id uuid primary key references auth.users(id) on delete cascade,default_currency char(3) not null default 'MYR',monthly_budget numeric(12,2) check(monthly_budget is null or monthly_budget>=0),updated_at timestamptz not null default now());
alter table public.expenses enable row level security; alter table public.user_settings enable row level security;
create policy "own expenses select" on public.expenses for select to authenticated using ((select auth.uid())=user_id);
create policy "own expenses insert" on public.expenses for insert to authenticated with check ((select auth.uid())=user_id);
create policy "own expenses update" on public.expenses for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
create policy "own expenses delete" on public.expenses for delete to authenticated using ((select auth.uid())=user_id);
create policy "own settings select" on public.user_settings for select to authenticated using ((select auth.uid())=user_id);
create policy "own settings insert" on public.user_settings for insert to authenticated with check ((select auth.uid())=user_id);
create policy "own settings update" on public.user_settings for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
insert into storage.buckets(id,name,public) values('receipts','receipts',false) on conflict(id) do update set public=false;
create policy "own receipt read" on storage.objects for select to authenticated using (bucket_id='receipts' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "own receipt insert" on storage.objects for insert to authenticated with check (bucket_id='receipts' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "own receipt update" on storage.objects for update to authenticated using (bucket_id='receipts' and (storage.foldername(name))[1]=(select auth.uid())::text) with check (bucket_id='receipts' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "own receipt delete" on storage.objects for delete to authenticated using (bucket_id='receipts' and (storage.foldername(name))[1]=(select auth.uid())::text);
