# agent/filters/size.jq — 编译体积分析
# 输入: zero size --json <file>
# 输出: JSON, schemaVersion 1
# tested on zero v0.1.1
#
# 用法:
#   zero size --json src/main.0 | jq -f agent/filters/size.jq

{
  schemaVersion: 1,
  file: (.sourceFile // "?"),
  sections: [.sections[] | {name, kind, bytes}],
  totalBytes: ([.sections[].bytes] | add // 0)
}
