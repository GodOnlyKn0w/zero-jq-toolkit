# human/filters/health.jq — 编译报告渲染（纯排版）
# category: human
# input:  agent/filters/health.jq JSON
# output: formatted text
# upstream: agent/filters/health.jq
# tested on zero v0.1.1
#
# 用法:
#   zero check --json src/main.0 | jq -f agent/filters/health.jq | jq -r -f human/filters/health.jq

def hr: "----------------------------------------";

hr,
"compile report",
hr,
"  file   : \(.file)",
"  diags  : \(.diags)",
"  time   : \(.elapsedMs) ms",
(if .cacheHits + .cacheMisses > 0 then
   "  cache  : \(.cacheHits)/\(.cacheHits + .cacheMisses)"
 else "" end),
hr,
""
