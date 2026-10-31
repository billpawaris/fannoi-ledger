-- สมุดบัญชีฟันน้อย: โครงสร้างฐานข้อมูล Supabase
-- วิธีใช้: Supabase → SQL Editor → New query → วางทั้งไฟล์ → Run

-- 1) รายชื่อสมาชิกที่มีสิทธิ์ (บิล และ Gym)
create table if not exists public.members (
  email  text primary key,
  person text not null check (person in ('bill', 'gym'))
);

-- 2) ข้อมูลทั้งหมดของสมุดบัญชี เก็บเป็นเอกสาร JSON
--    path = "<collection>/<id>" เช่น ledger/abc123, shared/xyz, settings/main
create table if not exists public.docs (
  path       text primary key,
  coll       text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create index if not exists docs_coll_idx on public.docs (coll);

-- 3) Row Level Security: อ่าน/เขียนได้เฉพาะอีเมลที่อยู่ใน members
alter table public.members enable row level security;
alter table public.docs    enable row level security;

create or replace function public.is_member() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.members m
    where lower(m.email) = lower(auth.jwt() ->> 'email')
  );
$$;

drop policy if exists "members read self" on public.members;
create policy "members read self" on public.members
  for select to authenticated
  using (lower(email) = lower(auth.jwt() ->> 'email'));

drop policy if exists "docs select" on public.docs;
drop policy if exists "docs insert" on public.docs;
drop policy if exists "docs update" on public.docs;
drop policy if exists "docs delete" on public.docs;
create policy "docs select" on public.docs for select to authenticated using (public.is_member());
create policy "docs insert" on public.docs for insert to authenticated with check (public.is_member());
create policy "docs update" on public.docs for update to authenticated using (public.is_member()) with check (public.is_member());
create policy "docs delete" on public.docs for delete to authenticated using (public.is_member());

-- 4) ซิงก์แบบเรียลไทม์ระหว่างเครื่อง
alter table public.docs replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null;
end $$;

-- 5) เพิ่มอีเมลของบิลและ Gym (แก้อีเมลก่อนกด Run)
insert into public.members (email, person) values
  ('EMAIL-OF-BILL@example.com', 'bill'),
  ('EMAIL-OF-GYM@example.com',  'gym')
on conflict (email) do update set person = excluded.person;
