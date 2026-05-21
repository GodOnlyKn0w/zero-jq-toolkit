# agent/filters/diagnostics.jq — 诊断码聚合分析
# category: agent
# input:  jq -s shared/normalize.jq output stream
# output: normative JSON, consumed by human/filters/diagnostics.jq
# tested on zero v0.1.1
#
# 用法:
#   for f in src/*.0; do
#     zero check --json "$f" | jq -c --arg file "$f" -f shared/normalize.jq
#   done | jq -s -c -f agent/filters/diagnostics.jq

[.[] | select(.errors | length > 0) | .errors[] as $e | {file: .file, code: $e.code, message: $e.message, line: $e.line}]
| group_by(.code)
| map({
    code: .[0].code,
    count: length,
    message: .[0].message,
    files: [.[] | .file] | unique
  })
| sort_by(-.count)
| { schemaVersion: 1, checkedAt: (now | strflocaltime("%Y-%m-%d %H:%M")), total_codes: length, total_occurrences: ([.[].count] | add // 0), codes: . }
