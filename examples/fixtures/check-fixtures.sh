#!/usr/bin/env bash
# 验证 fixtures 在本地 zero 编译器下能跑通
set -euo pipefail

ZERO="${ZERO:-zero}"
JQ="${JQ:-jq}"
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/../.." && pwd)"

echo "=== fixtures ==="
for f in "$DIR"/*.0; do
  name=$(basename "$f")
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$name" -f "$ROOT/shared/normalize.jq" 2>/dev/null \
    || echo "  FAIL: $name (not a valid Zero program or zero not on PATH)"
done
echo ""

# 完整 pipeline 演示
echo "=== batch (no expected codes) ==="
for f in "$DIR"/*.0; do
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$(basename "$f")" -f "$ROOT/shared/normalize.jq" 2>/dev/null
done | $JQ -s -c -f "$ROOT/agent/filters/batch.jq" 2>/dev/null \
  | $JQ -r -f "$ROOT/human/filters/batch.jq" 2>/dev/null

echo ""
echo "=== batch (APP001 expected) ==="
for f in "$DIR"/*.0; do
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$(basename "$f")" -f "$ROOT/shared/normalize.jq" 2>/dev/null
done | $JQ -s --argjson expected_fail_codes '["APP001"]' -c -f "$ROOT/agent/filters/batch.jq" 2>/dev/null \
  | $JQ -r -f "$ROOT/human/filters/batch.jq" 2>/dev/null
