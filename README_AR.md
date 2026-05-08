# ملفات تعدين XMR على Heroku للتطبيق afdaa

هذه الحزمة مخصصة لتشغيل XMRig كـ `worker dyno` على Heroku بعد حصولك على موافقة مكتوبة من الشركة.

## سبب فشل النسخة السابقة

خطأ:

```text
No default language could be detected for this app
```

يظهر لأن Heroku حاول اكتشاف لغة التطبيق تلقائياً على Heroku-24 ولم يجد Node/Python/Ruby إلخ. هذه النسخة تستخدم `heroku.yml` مع Docker، لذلك يجب ضبط التطبيق على stack اسمه `container`.

## الملفات المهمة

- `Dockerfile` يبني صورة XMRig.
- `heroku.yml` يخبر Heroku أن هذا تطبيق Docker ويشغّل process اسمه `worker`.
- `start.sh` يبدأ التعدين.
- `config.env` تضع فيه عنوان محفظة XMR واسم التطبيق.
- `deploy.sh` يضبط Heroku container stack، يرفع Config Vars، ينشر، ثم يشغّل worker.

## أين أضع عنوان المحفظة؟

افتح:

```bash
nano config.env
```

غيّر هذا السطر:

```bash
XMR_WALLET="PUT_YOUR_XMR_RECEIVE_ADDRESS_HERE"
```

إلى عنوان محفظتك من زر **Receive / استلام**:

```bash
XMR_WALLET="عنوان_XMR_الخاص_بك"
```

لا تضع أبداً:

- Seed Phrase
- Private Key
- كلمة مرور المحفظة
- عنوان Binance
- عنوان USDT أو BTC

## طريقة التشغيل

```bash
unzip heroku_xmr_afdaa_v2.zip
cd heroku_xmr_afdaa_v2
chmod +x *.sh
nano config.env
bash quick_start.sh
```

أو يدوياً:

```bash
heroku stack:set container -a afdaa
heroku config:set XMR_WALLET="عنوان_XMR" XMR_POOL="pool.supportxmr.com:3333" WORKER_NAME="heroku-afdaa-1" XMR_THREADS="2" -a afdaa
git init
git branch -M main
heroku git:remote -a afdaa
git add .
git commit -m "deploy authorized worker"
git push heroku HEAD:main
heroku ps:scale worker=1 -a afdaa
heroku logs --tail -a afdaa
```

## كيف أعرف أنه يعمل؟

في السجل ابحث عن:

```text
accepted
```

إذا ظهرت، فالتعدين يعمل والـ Pool يقبل المشاركات.

## إيقاف التعدين

```bash
bash stop.sh
```

أو:

```bash
heroku ps:scale worker=0 -a afdaa
```
