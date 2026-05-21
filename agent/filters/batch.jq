# agent/filters/batch.jq — 批量检查聚合（order-1 投影，不做判断）
# 输入: jq -s 合并后的 normalized 结果数组
# 参数: --argjson expected_fail_codes '["APP001"]'（可选）
# 输出: JSON, schemaVersion 1
# tested on zero v0.1.1

($expected_fail_codes // []) as $codes

| map(.expected = (
    if .ok == false then
      ([.errors[].code] | unique) as $err_codes
      | if ($err_codes - $codes) == [] then true else false end
    else false end
  ))

| {
  schemaVersion: 1,
  ok_count: [.[] | select(.ok == true)] | length,
  not_ok_count: [.[] | select(.ok == false and .expected == false)] | length,
  expected_count: [.[] | select(.ok == false and .expected == true)] | length,
  total: length,
  total_elapsed_ms: ([.[].elapsedMs] | add),
  files: [.[] | {
    file: .file,
    ok: .ok,
    diags: .diags,
    elapsed_ms: .elapsedMs,
    errors: (.errors // []),
    expected: .expected
  }]
}
