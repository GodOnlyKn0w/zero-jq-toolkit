# agent/graph/modules.jq — 模块依赖清单
# 输入: zero graph --json <package>
# 输出: JSON 格式模块列表 + 依赖

{
  schemaVersion: 1,
  modules: [.modules[] | {
    name,
    imports,
    symbols: (.publicSymbols | length)
  }]
}
