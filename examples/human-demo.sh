#!/usr/bin/env bash
# 演示: zero --json → agent → human 全链路
set -euo pipefail

ZERO="${ZERO:-node scripts/zero-cli.mjs}"
JQ="${JQ:-$(command -v jq)}"
[ -z "$JQ" ] && { echo "jq not found" >&2; exit 1; }

ROOT="${ZERO_ROOT:-.}"
FILTERS="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

echo "=== 1. 单文件报告 ==="
$ZERO check --json examples/hello.0 2>/dev/null \
  | $JQ -f "$FILTERS/agent/filters/health.jq" \
  | $JQ -r -f "$FILTERS/human/filters/health.jq"

echo ""
echo "=== 2. 批量检查 ==="
TMP=$(mktemp)
trap "rm -f $TMP" EXIT
for f in examples/hello.0 examples/add.0 examples/point.0; do
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$f" -f "$FILTERS/shared/normalize.jq"
done > "$TMP"

# agent → human 全链路
$JQ -s --argjson expected_fail_codes '["APP001"]' -c -f "$FILTERS/agent/filters/batch.jq" "$TMP" \
  | $JQ -r -f "$FILTERS/human/filters/batch.jq"
