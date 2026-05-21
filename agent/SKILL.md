---
name: zero-jq-health
description: "使用 zero --json + jq 对 Zero 项目做只读健康检查。输出规范 JSON（order-1 投影），供 human 渲染器或下游脚本消费。"
---

# zero-jq-health — agent 规范 JSON 投影

## 架构

```
zero --json → agent/filters/*.jq → 规范 JSON → human/filters/*.jq → 格式化文本
```

agent filter 只管投影（order-1）。human filter 只管渲染（排版，不做判断）。
新增输出格式只需要写新的渲染器，复用 agent 的规范 JSON。

## filter 清单

| filter | 输入 | 输出 |
|--------|------|------|
| health.jq | `zero check --json` | 单文件编译健康 |
| batch.jq | `normalize.jq` 行流 + `-s` + `--argjson expected_fail_codes` | 批量汇总（含预期标记） |
| diagnostics.jq | `normalize.jq` 行流 + `-s` | 诊断码聚合 |
| size.jq | `zero size --json` | 编译体积 |

## 用法

```bash
# 单文件健康（规范 JSON → human 渲染）
zero check --json src/main.0 | jq -f agent/filters/health.jq \
  | jq -r -f human/filters/health.jq

# 批量检查（normalize → agent/batch → human/batch）
for f in src/*.0; do
  zero check --json "$f" | jq -c --arg file "$f" -f shared/normalize.jq
done | jq -s --argjson expected_fail_codes '["APP001"]' -c -f agent/filters/batch.jq \
  | jq -r -f human/filters/batch.jq

# 诊断分布
for f in conformance/fail/*.0; do
  zero check --json "$f" | jq -c --arg file "$f" -f shared/normalize.jq
done | jq -s -c -f agent/filters/diagnostics.jq \
  | jq -r -f human/filters/diagnostics.jq
```

## 预期失败标记

通过 `--argjson expected_fail_codes '["APP001","CIMP001"]'` 传入。
如果文件的所有错误码都在预期列表中，`.expected` 为 true。
混合已知+未知错误：`.expected` 为 false，计入 `not_ok_count`。

## 与 human 版的关系

| agent | human |
|-------|-------|
| 输出规范 JSON | 输出格式化文本 |
| 做投影（order-1） | 做渲染（排版，不做判断） |
| 版本升级时最先修 | 只消费 agent 的 JSON，schema 不变就不改 |
