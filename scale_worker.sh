#!/usr/bin/env bash
set -euo pipefail
APP_NAME="${1:-afdaa}"
COUNT="${2:-1}"
heroku ps:scale worker="$COUNT" -a "$APP_NAME"
