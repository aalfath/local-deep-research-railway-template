#!/bin/bash
# Railway wrapper around the upstream entrypoint. Runs as root, sets the
# Railway defaults, then lets upstream fix /data ownership and drop to ldruser.
set -euo pipefail

# Railway injects PORT; LDR listens on LDR_WEB_PORT (default 5000).
export LDR_WEB_PORT="${PORT:-${LDR_WEB_PORT:-5000}}"
export LDR_WEB_HOST="${LDR_WEB_HOST:-0.0.0.0}"
# TLS ends at Railway's edge proxy: trust its X-Forwarded-* headers so
# cookies get the Secure flag and the WebSocket origin check accepts https.
export TRUST_PROXY_HEADERS="${TRUST_PROXY_HEADERS:-true}"
# The admin account is created below, so open sign-up stays off by default.
export LDR_APP_ALLOW_REGISTRATIONS="${LDR_APP_ALLOW_REGISTRATIONS:-false}"

exec /usr/local/bin/ldr_entrypoint.sh /usr/local/bin/railway-run-as-user.sh "$@"
