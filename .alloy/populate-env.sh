#!/usr/bin/env bash
# Idempotent: creates .env and sqlite db for local dev without overwriting existing values.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] || cp .env.example .env
if ! grep -qE '^APP_KEY=base64:.+' .env; then
  key="base64:$(openssl rand -base64 32)"
  sed -i "s|^APP_KEY=.*|APP_KEY=${key}|" .env
fi
grep -q '^IS_ALLOY=' .env || echo "IS_ALLOY=${IS_ALLOY:-false}" >> .env
mkdir -p database && touch database/database.sqlite
