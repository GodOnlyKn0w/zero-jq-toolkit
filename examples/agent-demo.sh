#!/usr/bin/env bash
# 演示: zero --json → agent filter → 规范 JSON
set -euo pipefail

ZERO="${ZERO:-node scripts/zero-cli.mjs}"
JQ="${JQ:-$(command -v jq)}"
[ -z "$JQ" ] && { echo "jq not found" >&2; exit 1; }

ROOT="${ZERO_ROOT:-.}"
FILTERS="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

echo "=== 1. health.jq (规范 JSON) ==="
$ZERO check --json examples/hello.0 2>/dev/null \
  | $JQ -f "$FILTERS/agent/filters/health.jq"

echo ""
echo "=== 2. batch.jq (规范 JSON) ==="
for f in examples/hello.0 examples/add.0; do
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$f" -f "$FILTERS/shared/normalize.jq"
done | $JQ -s --argjson expected_fail_codes '["APP001"]' -c -f "$FILTERS/agent/filters/batch.jq"
