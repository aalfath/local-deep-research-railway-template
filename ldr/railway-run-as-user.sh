#!/bin/bash
# Runs as ldruser (after the upstream entrypoint): create the first admin
# account once, then start the app.
set -euo pipefail
python /usr/local/bin/railway_create_admin.py
exec "$@"
