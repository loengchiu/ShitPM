# Mock Review Checklist

用于 `mock` 阶段的自审与收尾检查。

## 一致性检查

- 页面集合是否与 Page Structure 一致
- 关键能力是否覆盖稳定 Feature List
- 跳转关系是否双向一致
- 每页是否都引用同一份 `shared.css` 与 `shared.js`
- 同一字段跨页面展示命名是否一致
- 权限可见性是否与 PRD 一致
- `待确认` 项是否已写入 `mock-index.md`

## 完成门禁

- 缺少共享壳、关键页面、关键流程闭环时，不得标记完成
- 发现事实不足或上游冲突时，不得继续润色，应回退上游
- 状态更新遵循 `contracts/workflow-state.md`
