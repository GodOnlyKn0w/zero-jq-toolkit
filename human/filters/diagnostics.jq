# human/filters/diagnostics.jq — 诊断报告渲染
# 输入: agent/filters/diagnostics.jq 的 JSON 输出（规范格式）
# 输出: 格式化文本（纯排版，不做判断）
# tested on zero v0.1.1
#
# 用法:
#   for f in src/*.0; do
#     zero check --json "$f" | jq -c --arg file "$f" -f shared/normalize.jq
#   done | jq -s -c -f agent/filters/diagnostics.jq \
#     | jq -r -f human/filters/diagnostics.jq

def hr: "----------------------------------------";

(hr,
"diagnostics  \(.checkedAt // ""): \(.total_codes) codes, \(.total_occurrences) occurrences",
hr),
(if (.codes | length) == 0 then
  "  (none)"
 else
  (.codes[] |
    "  \(.code) x\(.count): \(.message)",
    (if (.files | length) <= 3 then
       "    " + (.files | join(", "))
     else
       "    " + ([.files[:3][]] | join(", ")) + " ...and \(.files | length - 3) more"
     end),
    "")
 end)
