# agent/filters/health.jq — 单文件编译健康摘要
# 输入: zero check --json <file>
# 输出: JSON, schemaVersion 1
# tested on zero v0.1.1
#
# 用法:
#   zero check --json src/main.0 | jq -f agent/filters/health.jq

{
  schemaVersion: 1,
  file: .sourceFile,
  ok: .ok,
  diags: (.diagnostics | length),
  elapsedMs: ([(.compilerPhases // [])[].elapsedMs] | add // 0),
  cacheHits: ([(.compilerCaches // [])[] | select(.hit == true)] | length),
  cacheMisses: ([(.compilerCaches // [])[] | select(.hit == false)] | length)
}
