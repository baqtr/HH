#!/bin/sh
set -eu

: "${XMR_WALLET:?ERROR: XMR_WALLET is required. Put it in Heroku Config Vars or config.env then run deploy.sh}"
: "${XMR_POOL:=pool.supportxmr.com:3333}"
: "${WORKER_NAME:=heroku-afdaa-1}"
: "${XMR_THREADS:=2}"

MASKED_WALLET="$(printf '%s' "$XMR_WALLET" | cut -c1-8)***$(printf '%s' "$XMR_WALLET" | rev | cut -c1-8 | rev)"

echo "============================================================"
echo "🚀 Starting authorized XMRig worker on Heroku"
echo "⛏️  Pool: ${XMR_POOL}"
echo "👷 Worker: ${WORKER_NAME}"
echo "🧵 Threads: ${XMR_THREADS}"
echo "💼 Wallet: ${MASKED_WALLET}"
echo "============================================================"

exec /opt/xmrig/xmrig \
  -o "$XMR_POOL" \
  -u "$XMR_WALLET" \
  -p "$WORKER_NAME" \
  --coin monero \
  --threads="$XMR_THREADS" \
  --donate-level=1 \
  --print-time=30
