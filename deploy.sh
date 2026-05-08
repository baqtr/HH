#!/usr/bin/env bash
set -euo pipefail

if [ ! -f config.env ]; then
  echo "❌ config.env غير موجود."
  exit 1
fi

# shellcheck disable=SC1091
source ./config.env

APP_NAME="${APP_NAME:-afdaa}"
XMR_POOL="${XMR_POOL:-pool.supportxmr.com:3333}"
WORKER_NAME="${WORKER_NAME:-heroku-afdaa-1}"
XMR_THREADS="${XMR_THREADS:-2}"

if [ -z "${XMR_WALLET:-}" ] || [ "$XMR_WALLET" = "PUT_YOUR_XMR_RECEIVE_ADDRESS_HERE" ]; then
  echo "ضع عنوان محفظة XMR من زر Receive:"
  read -r XMR_WALLET
fi

if [ -z "$XMR_WALLET" ]; then
  echo "❌ لم يتم وضع عنوان XMR."
  exit 1
fi

if ! command -v heroku >/dev/null 2>&1; then
  echo "❌ Heroku CLI غير مثبت أو غير موجود في PATH."
  echo "ثبّت Heroku CLI وسجّل الدخول ثم أعد تشغيل السكربت."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "❌ git غير مثبت. ثبته ثم أعد المحاولة."
  exit 1
fi

echo "✅ تطبيق Heroku: $APP_NAME"
echo "🔧 ضبط stack إلى container لحل خطأ: No default language could be detected"
heroku stack:set container -a "$APP_NAME"

echo "🔐 رفع إعدادات التعدين إلى Heroku Config Vars..."
heroku config:set \
  XMR_WALLET="$XMR_WALLET" \
  XMR_POOL="$XMR_POOL" \
  WORKER_NAME="$WORKER_NAME" \
  XMR_THREADS="$XMR_THREADS" \
  -a "$APP_NAME"

if [ ! -d .git ]; then
  git init
fi

git config user.email >/dev/null 2>&1 || git config user.email "afdaa@example.local"
git config user.name >/dev/null 2>&1 || git config user.name "afdaa-deploy"

git branch -M main || true
git remote remove heroku >/dev/null 2>&1 || true
heroku git:remote -a "$APP_NAME"

git add Dockerfile heroku.yml Procfile start.sh README_AR.md CHECKLIST_AR.md config.env .gitignore deploy.sh quick_start.sh logs.sh scale_worker.sh stop.sh status.sh 2>/dev/null || git add .
if git diff --cached --quiet; then
  echo "ℹ️ لا توجد تغييرات جديدة للـ commit."
else
  git commit -m "deploy authorized heroku xmr worker"
fi

echo "🚀 رفع المشروع إلى Heroku..."
git push heroku HEAD:main

echo "⚙️ تشغيل worker dyno..."
heroku ps:scale worker=1 -a "$APP_NAME"

echo "✅ تم النشر. راقب السجل بهذا الأمر:"
echo "heroku logs --tail -a $APP_NAME"
heroku logs --tail -a "$APP_NAME"
