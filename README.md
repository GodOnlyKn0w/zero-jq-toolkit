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
zero --json
  │
  ├──→ agent/health.jq       → human/health.jq      单文件报告
  ├──→ shared/normalize.jq → agent/batch.jq        → human/batch.jq     批量检查
  │                       → agent/diagnostics.jq  → human/diagnostics.jq 诊断分布
  └──→ agent/size.jq         → human/size.jq        体积报告
```

- `agent/` filters 输出**规范 JSON**（order-1 投影）
- `human/` filters 消费 agent JSON，输出**格式化文本**（纯渲染，不做判断）

## 快速开始

```bash
# 单文件健康
zero check --json src/main.0 | jq -f agent/filters/health.jq \
  | jq -r -f human/filters/health.jq

# 批量检查（含预期失败标记）
./examples/check-all.sh <project-dir> "src/*.0" --expected-codes APP001

# 诊断分布
./examples/check-all.sh <project-dir> "conformance/fail/*.0" \
  | jq -s -f agent/filters/diagnostics.jq | jq -r -f human/filters/diagnostics.jq
```

## 依赖

- `zero` — Zero 编译器
- `jq` — JSON 查询工具

## 项目结构

```
agent/filters/    规范 JSON 投影（order-1）
human/filters/    格式化渲染（消费 agent JSON）
shared/           规范输入格式 + 公共函数
examples/         使用脚本
```


