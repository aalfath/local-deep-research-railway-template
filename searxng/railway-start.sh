#!/bin/sh
# Writes settings.yml for a private SearXNG used only by Local Deep Research,
# then hands over to the upstream entrypoint. The secret key comes from
# SEARXNG_SECRET. Listens on [::]:8080 (Railway's private network).
set -eu

conf_dir="${__SEARXNG_CONFIG_PATH:-/etc/searxng}"
settings="$conf_dir/settings.yml"

# A Railway service named "searxng" could leak a non-numeric SEARXNG_PORT.
case "${SEARXNG_PORT:-}" in
    *[!0-9]*) unset SEARXNG_PORT ;;
esac

mkdir -p "$conf_dir"
cat > "$settings" <<'YAML'
# Written by the Railway template on every boot. Reference:
# https://docs.searxng.org/admin/settings/index.html
use_default_settings: true

general:
  # Some engines (Wikipedia, Wikidata) need a contact URL for their
  # User-Agent policy.
  contact_url: "https://github.com/LearningCircuit/local-deep-research"

server:
  limiter: false
  image_proxy: false

search:
  formats:
    - html
    - json
YAML

exec /usr/local/searxng/entrypoint.sh "$@"
