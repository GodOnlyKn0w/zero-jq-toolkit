# human/filters/diagnostics.jq — 诊断报告渲染（纯排版）
# category: human
# input:  agent/filters/diagnostics.jq JSON
# output: formatted text
# upstream: agent/filters/diagnostics.jq
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
