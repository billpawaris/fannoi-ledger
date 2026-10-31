-- ที่เก็บรูปใบเสร็จ (Supabase Storage)
-- วิธีใช้: SQL Editor → New query → วางทั้งไฟล์ → Run (รันหลัง schema.sql)
-- bucket เป็นแบบ private เปิดรูปได้เฉพาะสมาชิกผ่านลิงก์ชั่วคราว (หมดอายุใน 1 ชั่วโมง)

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('receipts', 'receipts', false, 5242880, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

drop policy if exists "receipts select" on storage.objects;
drop policy if exists "receipts insert" on storage.objects;
drop policy if exists "receipts delete" on storage.objects;
create policy "receipts select" on storage.objects for select to authenticated
  using (bucket_id = 'receipts' and public.is_member());
create policy "receipts insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'receipts' and public.is_member());
create policy "receipts delete" on storage.objects for delete to authenticated
  using (bucket_id = 'receipts' and public.is_member());
