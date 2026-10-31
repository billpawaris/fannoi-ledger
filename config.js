// ตั้งค่าการเชื่อมต่อ Supabase
// ค่าทั้งสองดูได้ที่ Supabase → Project Settings → API
// anon key ออกแบบมาให้เปิดเผยในหน้าเว็บได้ ข้อมูลถูกป้องกันด้วย Row Level Security ใน supabase/schema.sql
// ห้ามใส่ service_role key ในไฟล์นี้เด็ดขาด
window.FANNOI_CONFIG = {
  supabaseUrl: "https://YOUR-PROJECT.supabase.co",
  supabaseAnonKey: "YOUR-ANON-KEY"
};
