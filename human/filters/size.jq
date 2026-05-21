# human/filters/size.jq — 编译体积报告渲染（纯排版）
# category: human
# input:  agent/filters/size.jq JSON
# output: formatted text
# upstream: agent/filters/size.jq
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
