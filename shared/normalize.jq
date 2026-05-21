# normalize.jq - standard check result format
# category: shared
# input:  zero check --json <file>
# output: one JSON line per file, consumed by agent/filters/batch.jq and agent/filters/diagnostics.jq
# tested on zero v0.1.1
#
# usage:
#   zero check --json <file> | jq -c -f shared/normalize.jq
#   echo '{"ok":true...}' | jq -c --arg file "src/main.0" -f shared/normalize.jq
#
# pipeline:
#   zero check --json → shared/normalize.jq → agent/filters/batch.jq → human/filters/batch.jq

{
  file: ($file // .sourceFile),
  ok: .ok,
  diags: (.diagnostics | length),
  elapsedMs: ([(.compilerPhases // [])[].elapsedMs] | add // 0),
  cacheHits: ([(.compilerCaches // [])[] | select(.hit == true)] | length),
  cacheMisses: ([(.compilerCaches // [])[] | select(.hit == false)] | length),
  errors: [.diagnostics[] | {code, message, line, column}]
}
