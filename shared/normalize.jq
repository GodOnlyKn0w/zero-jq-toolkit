# normalize.jq - standard check result format
# tested on zero v0.1.1
# usage: zero check --json <file> | jq -c -f shared/normalize.jq

{
  file: ($file // .sourceFile),
  ok: .ok,
  diags: (.diagnostics | length),
  elapsedMs: ([(.compilerPhases // [])[].elapsedMs] | add // 0),
  cacheHits: ([(.compilerCaches // [])[] | select(.hit == true)] | length),
  cacheMisses: ([(.compilerCaches // [])[] | select(.hit == false)] | length),
  errors: [.diagnostics[] | {code, message, line, column}]
}
