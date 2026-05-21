# zero-jq-toolkit

**tested on zero v0.1.1** — 升级后运行 `examples/agent-demo.sh` 验证。

Zero 编译器结构化输出与 jq 查询的复合使用工具集。

## 三阶框架

```
order-0:  Zero 源码（事实原料）
order-1:  zero --json | jq（结构化投影，不做判断）
order-2:  判断（agent 或人，记录到日志或任务系统）
```

order-1 只回答"有什么"，不回答"怎么办"。

## pipeline

```
zero check --json
  ├──→ agent/health.jq       → human/health.jq      单文件指标
  ├──→ shared/normalize.jq   → agent/batch.jq        → human/batch.jq     批量汇总
  │                         → agent/diagnostics.jq  → human/diagnostics.jq 诊断分布
  └──→ agent/size.jq         → human/size.jq        体积指标
```

### normalize.jq 的作用

`shared/normalize.jq` 把 `zero check --json` 的输出统一成**每文件一行**的规范格式。
它解决的是"批量消费"的问题——每个文件产生一行 JSON，`jq -s` 收拢成数组后
由 agent filter 做聚合投影。

`health.jq` 和 `size.jq` 不走 normalize，因为它们本身就是单文件操作，
不需要行格式。但它们的输出字段名（`diags`, `elapsedMs`）与 normalize 保持一致，
所以 human renderer 看到的是同一套命名约定。

如果 `zero --json` 的 schema 在后续版本变了，**只改 `shared/normalize.jq` 一处**，
agent 和 human filter 都不需要动。

## 快速开始

```bash
# 单文件健康
zero check --json src/main.0 | jq -f agent/filters/health.jq \
  | jq -r -f human/filters/health.jq

# 批量检查 + 预期失败标记
./examples/check-all.sh <project-dir> "src/*.0" --expected-codes APP001

# 带 fixtures 的验证
cd examples/fixtures
zero check --json hello.0 | jq -f ../../agent/filters/health.jq
zero check --json broken.0 | jq -f ../../agent/filters/health.jq
```

### --expected-codes 用法

项目里有些文件预期会失败（库模块无 main、缺 C 编译器），
不属于回归。用 `--expected-codes` 标记它们：

```bash
# 标记 APP001 和 CIMP001 为预期失败
./examples/check-all.sh . "*.0" --expected-codes APP001,CIMP001

# 输出中预期失败的显示为 not_ok + expected
# 真正意外的失败才会显示为 not_ok
```

## 依赖

- `zero` 编译器（https://zerolang.ai）
- `jq`（https://jqlang.org）

## 项目结构

```
agent/filters/    规范 JSON 投影（order-1）
human/filters/    格式化渲染（消费 agent JSON）
shared/           规范输入格式 normalize + 公共函数
examples/         使用脚本 + fixtures
```
