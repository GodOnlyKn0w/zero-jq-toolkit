# human/filters/size.jq — 编译体积报告渲染
# 输入: agent/filters/size.jq 的 JSON 输出（规范格式）
# 输出: 格式化文本（纯排版，不做判断）
# tested on zero v0.1.1
#
# 用法:
#   zero size --json src/main.0 | jq -f agent/filters/size.jq | jq -r -f human/filters/size.jq

def hr: "----------------------------------------";

hr,
"size: \(.file)",
hr,
.sections[] | "  \(.name): \(.bytes) B  (\(.kind))",
hr,
"  total: \(.totalBytes) B",
hr,
""
