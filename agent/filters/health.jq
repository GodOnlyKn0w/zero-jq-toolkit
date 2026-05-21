# agent/filters/health.jq — 单文件编译健康摘要
# category: agent
# input:  zero check --json <file>
# output: normative JSON, consumed by human/filters/health.jq
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
