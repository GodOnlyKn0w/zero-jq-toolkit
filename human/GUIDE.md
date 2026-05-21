# 使用手册

## 文件

| 文件 | 消费谁的输出 | 输出 |
|------|-------------|------|
| `health.jq` | `agent/health.jq` | 单文件编译指标 |
| `batch.jq` | `agent/batch.jq` | 批量检查汇总 |
| `diagnostics.jq` | `agent/diagnostics.jq` | 诊断分布 |
| `size.jq` | `agent/size.jq` | 体积指标 |

## 原则

human filter 是**纯渲染器**。不做判断、不重算统计、不推导含义。
只决定字段排列和空白。

所有语义边界都在 agent filter 里确定。human filter 看到的是 order-1 已定的数据。

## 输出示例

### health.jq

```
----------------------------------------
compile report
----------------------------------------
  file   : src/main.0
  diags  : 0
  time   : 4 ms
  cache  : 4/5
----------------------------------------
```

### batch.jq

```
----------------------------------------
  total    : 65
  ok       : 63
  not ok   : 0
  expected : 2
  elapsed  : 318 ms
----------------------------------------
  examples/config-shape.0:
    CIMP001 extern c header could not be read  line 2
  examples/web-response.0:
    APP001 missing main function  line 1
```

### diagnostics.jq

```
----------------------------------------
diagnostics  2026-05-21: 39 codes, 52 occurrences
----------------------------------------
  TYP002 x4: array literal type mismatch
    examples/a.0, examples/b.0, examples/c.0 ...and 1 more

  MAT002 x3: non-exhaustive match
    ...
```

### size.jq

```
----------------------------------------
size: src/main.0
----------------------------------------
  lowered-ir: 2224 B  (ir)
  total: 2224 B
----------------------------------------
```
