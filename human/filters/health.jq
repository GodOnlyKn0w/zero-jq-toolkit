# human/filters/health.jq — 编译报告渲染
# 输入: agent/filters/health.jq 的 JSON 输出（规范格式）
# 输出: 格式化文本（纯排版，不做判断）
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
