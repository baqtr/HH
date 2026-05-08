#!/usr/bin/env bash
set -euo pipefail
APP_NAME="${1:-afdaa}"
heroku ps -a "$APP_NAME"
heroku config -a "$APP_NAME" | grep -E 'XMR_POOL|WORKER_NAME|XMR_THREADS' || true
