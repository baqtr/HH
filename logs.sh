#!/usr/bin/env bash
set -euo pipefail
APP_NAME="${1:-afdaa}"
heroku logs --tail -a "$APP_NAME"
