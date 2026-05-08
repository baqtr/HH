#!/usr/bin/env bash
set -euo pipefail
APP_NAME="${1:-afdaa}"
heroku ps:scale worker=0 -a "$APP_NAME"
echo "✅ تم إيقاف worker."
