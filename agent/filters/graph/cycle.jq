# agent/graph/cycle.jq — 循环依赖检测
# 输入: zero graph --json <package>
# 输出: JSON 格式循环依赖报告（待实现）
# 
# zero graph --json 当前不直接输出循环依赖信息。
# 此 filter 预留接口，后续实现从模块 import 图推导循环引用。

{
  schemaVersion: 1,
  cycles: [],
  note: "cycle detection requires import graph traversal — pending zero graph output enrichment"
}
