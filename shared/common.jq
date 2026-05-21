# 公共函数 — agent 和 human 版本共享
#
# 版本断言: tested on zero v0.1.1
# 如果 zero --version 变更了 major/minor 号，重新验证所有 filter

# 从 compilerPhases 提取总耗时
def total_elapsed:
  [.compilerPhases[].elapsedMs] | add // 0;

# 统计缓存命中数
def cache_hits:
  [.compilerCaches[] | select(.hit == true)] | length;

# 统计缓存未命中数
def cache_misses:
  [.compilerCaches[] | select(.hit == false)] | length;

# 提取诊断按码分组
def diags_by_code:
  .diagnostics
  | group_by(.code)
  | map({code: .[0].code, count: length, severity: .[0].severity});

# 提取诊断按严重级别分组
def diags_by_severity:
  .diagnostics
  | group_by(.severity)
  | map({severity: .[0].severity, count: length})
  | from_entries;

# 编译阶段摘要
def phase_summary:
  [.compilerPhases[] | {name, elapsedMs}];
