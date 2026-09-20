const SUPABASE_URL = "https://khnbzvgthxbihhatoyov.supabase.co";

const SUPABASE_PUBLISHABLE_KEY =
  "sb_publishable_ffK5ICyv4m37UjGA6C2zTA_Y799O2oB";

window.SUPABASE_URL = SUPABASE_URL;
window.SUPABASE_PUBLISHABLE_KEY = SUPABASE_PUBLISHABLE_KEY;

const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY
);
