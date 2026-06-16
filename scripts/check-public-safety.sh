#!/usr/bin/env bash
set -euo pipefail

patterns=(
  "/Users/"
  "datasci/junk"
  "joom-team.slack.com"
  "joom-team.atlassian.net"
  "notion.so/joomteam"
  "admin.joom"
  "vault"
  "secret"
  "token"
  "password"
  "GIT_PASSWORD"
  "GOOGLE_APPLICATION_CREDENTIALS"
)

for pattern in "${patterns[@]}"; do
  if grep -RIn \
    --exclude-dir=.git \
    --exclude="$(basename "$0")" \
    --exclude="CONTRIBUTING.md" \
    --exclude="SECURITY.md" \
    --exclude="PULL_REQUEST_TEMPLATE.md" \
    "$pattern" .; then
    echo "Public-safety check failed for pattern: $pattern" >&2
    exit 1
  fi
done

echo "Public-safety grep passed."
