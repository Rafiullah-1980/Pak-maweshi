# پاک مویشی ڈاٹ کام: لانچ گائیڈ

اس فولڈر میں صرف یہ فائلیں ہیں: `index.html` (پوری ویب سائٹ، تصاویر سمیت)، `config.js` (آپ کی ترتیبات)، `supabase-setup.sql` (ڈیٹا بیس)، `.nojekyll` اور `robots.txt`۔
کوئی `icons` فولڈر نہیں، اس لیے موبائل سے بھی اپ لوڈ ہو سکتی ہے۔

## مرحلہ 1: Supabase (ڈیٹا بیس، مفت)
1. supabase.com پر سائن اپ کریں → **New project**۔ نام `pak-meshi`، ایک مضبوط ڈیٹا بیس پاس ورڈ لکھ کر محفوظ کر لیں، علاقہ قریب ترین (مثلاً Singapore یا Mumbai) چنیں۔
2. پروجیکٹ بننے کے بعد بائیں مینو میں **SQL Editor** → New query۔ `supabase-setup.sql` کا **پورا** متن پیسٹ کر کے **Run** دبائیں۔ "Success" آنا چاہیے۔
3. **Project Settings → API** میں سے دو چیزیں نقل کریں: **Project URL** اور **anon public** کلید۔
4. **Authentication → Providers → Email**: "Confirm email" بند کریں تاکہ سائن اپ فوراً چلے۔ (آن رکھیں تو ہر صارف کو ای میل کا لنک کھولنا ہو گا۔)

## مرحلہ 2: config.js بھریں
`config.js` کھول کر `PASTE_YOUR_SUPABASE_URL` اور `PASTE_YOUR_SUPABASE_ANON_KEY` کی جگہ اپنی دو چیزیں لگائیں۔ واٹس ایپ نمبر لگا ہوا ہے، دیکھ لیں کہ درست ہے۔
**صرف anon کلید لگائیں۔ `service_role` کلید کبھی نہیں۔**

## مرحلہ 3: GitHub پر لگائیں
1. github.com پر اکاؤنٹ بنائیں → **New repository** → نام `pak-meshi` → **Public** → Create۔
2. **uploading an existing file** (یا Add file → Upload files) دبائیں، اس فولڈر کی سب فائلیں چنیں (`.nojekyll` چھپی فائل ہے، نہ ملے تو چھوڑ دیں) اور **Commit changes**۔
3. **Settings → Pages**: Source = *Deploy from a branch*، Branch = `main`، Folder = `/ (root)` → Save۔
4. 1 سے 3 منٹ بعد اوپر آپ کا لنک آ جائے گا: `https://آپ-کا-نام.github.io/pak-meshi/`

## مرحلہ 4: لنک Supabase کو بتائیں
Supabase → **Authentication → URL Configuration**: **Site URL** میں اپنا GitHub Pages لنک لگائیں اور Save۔ (پاس ورڈ بدلنے کا ای میل اسی لنک پر لے جائے گا۔)

## مرحلہ 5: جانچ (لانچ سے پہلے)
- لنک کھولیں، اوپر کی پیلی "نمونہ موڈ" پٹی **غائب** ہونی چاہیے۔ اگر نظر آئے تو `config.js` کی دونوں چیزیں دوبارہ دیکھیں۔
- سائن اپ کریں → "+" سے ایک اشتہار لگائیں (تصویر سمیت) → ہوم پر نظر آئے → کسی دوسرے فون سے بھی دیکھیں۔
- "میرے اشتہار" سے حذف کر کے دیکھیں۔

## پریمیم اکاؤنٹ فعال کرنا
صارف ہوم پر "پریمیم اکاؤنٹ" دبا کر آپ کو واٹس ایپ کرتا ہے۔ ادائیگی (جاز کیش/ایزی پیسہ) ملنے پر:
Supabase → **Authentication → Users** سے صارف کی `User UID` نقل کریں → **Table Editor → premium_users → Insert row**: `user_id` = وہ UID، `until` = ختم ہونے کی تاریخ۔ اس کے بعد اس کے **نئے** اشتہار "نمایاں جانور" میں آئیں گے۔

## اپنا ڈومین pak-meshi.com (اختیاری، بعد میں)
ڈومین خرید کر repository کی جڑ میں `CNAME` نام کی فائل بنائیں جس میں صرف `pak-meshi.com` لکھا ہو، پھر ڈومین کی DNS میں GitHub Pages کے ریکارڈ لگائیں (GitHub Docs میں "Custom domain" دیکھیں)۔ پھر Supabase کی Site URL بھی نئے ایڈریس پر بدل دیں۔

## یاد رکھنے کی باتیں
- اشتہار میں دیا گیا فون نمبر ہر دیکھنے والے کو نظر آتا ہے۔
- مفت Supabase پلان کی ایک حد ہے (تصاویر اور ڈیٹا کی جگہ)؛ سائٹ بڑھے تو اپ گریڈ دیکھ لیں۔
- غلط یا جعلی اشتہار ہٹانے کے لیے Supabase → Table Editor → `ads` میں قطار حذف کر دیں۔
