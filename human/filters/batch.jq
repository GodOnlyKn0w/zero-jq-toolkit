# human/filters/batch.jq — 批量检查结果渲染（纯排版，不做判断）
# 输入: agent/filters/batch.jq 的 JSON 输出
# 输出: 格式化文本
# tested on zero v0.1.1

def hr: "----------------------------------------";

.files as $files
| hr,
"  total    : \(.total)",
"  ok       : \(.ok_count)",
"  not ok   : \(.not_ok_count)",
"  expected : \(.expected_count)",
"  elapsed  : \(.total_elapsed_ms) ms",
hr,
($files[] | select(.ok == false) |
  "  \(.file):",
  ([.errors[] | "    \(.code) \(.message)  line \(.line)"] | join("\n"))),
""
