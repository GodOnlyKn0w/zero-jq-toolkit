#!/usr/bin/env bash
# 批量检查指定目录下的所有 .0 文件
# 用法: ./examples/check-all.sh <zero-project-dir> [pattern] [--expected-codes CODE1,CODE2]
# 示例: ./examples/check-all.sh ~/zero-source "examples/*.0" --expected-codes APP001,CIMP001
set -euo pipefail

ZERO="${ZERO:-node scripts/zero-cli.mjs}"
JQ="${JQ:-$(command -v jq)}"
if [ -z "$JQ" ]; then
  echo "ERROR: jq not found. Install jq (https://jqlang.org) or set JQ env var." >&2
  exit 1
fi

FILTERS="$(cd "$(dirname "$0")/.." && pwd)"

ZERO_DIR="${1:?usage: check-all.sh <project-dir> [pattern] [--expected-codes C1,C2]}"
PATTERN="${2:-examples/**/*.0}"
shift 2 || true

EXPECTED_CODES=()
if [ "${1:-}" = "--expected-codes" ] && [ -n "${2:-}" ]; then
  IFS=',' read -ra EXPECTED_CODES <<< "$2"
fi

EXPECTED_JSON="["
SEP=""
for code in "${EXPECTED_CODES[@]}"; do
  EXPECTED_JSON+="${SEP}\"${code}\""
  SEP=","
done
EXPECTED_JSON+="]"

cd "$ZERO_DIR"
TMP=$(mktemp)
trap "rm -f $TMP" EXIT

for f in $PATTERN; do
  [ -f "$f" ] || continue
  $ZERO check --json "$f" 2>/dev/null \
    | $JQ -c --arg file "$f" -f "$FILTERS/shared/normalize.jq" 2>/dev/null || true
done > "$TMP"

count=$(wc -l < "$TMP")
echo "checked: $count files" >&2

# agent 输出（规范 JSON）
echo "--- agent ---" >&2
if [ ${#EXPECTED_CODES[@]} -gt 0 ]; then
  $JQ -s --argjson expected_fail_codes "$EXPECTED_JSON" -c -f "$FILTERS/agent/filters/batch.jq" "$TMP"
else
  $JQ -s -c -f "$FILTERS/agent/filters/batch.jq" "$TMP"
fi

# human 渲染
echo "--- human ---" >&2
if [ ${#EXPECTED_CODES[@]} -gt 0 ]; then
  $JQ -s --argjson expected_fail_codes "$EXPECTED_JSON" -c -f "$FILTERS/agent/filters/batch.jq" "$TMP" \
    | $JQ -r -f "$FILTERS/human/filters/batch.jq"
else
  $JQ -s -c -f "$FILTERS/agent/filters/batch.jq" "$TMP" \
    | $JQ -r -f "$FILTERS/human/filters/batch.jq"
fi
