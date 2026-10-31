// ตั้งค่าการเชื่อมต่อ Supabase
// ค่าทั้งสองดูได้ที่ Supabase → Project Settings → API (ใช้ Publishable key แทน anon key ได้)
// anon key ออกแบบมาให้เปิดเผยในหน้าเว็บได้ ข้อมูลถูกป้องกันด้วย Row Level Security ใน supabase/schema.sql
// ห้ามใส่ service_role key ในไฟล์นี้เด็ดขาด
window.FANNOI_CONFIG = {
  supabaseUrl: "https://vozgfizyooffdevezjrr.supabase.co",
  supabaseAnonKey: "sb_publishable_ecThLvqUYRK4vL7ynbWoZQ_R1b7thHq"
};
