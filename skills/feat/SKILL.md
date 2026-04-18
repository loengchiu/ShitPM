---
name: feat
description: "把思维导图、项目简报和必要补充信息收敛为稳定功能清单，作为页面结构与 PRD 的能力事实源。"
---

# PM FL

## 输入

- 项目目录
- 当前项目简报或范围结论
- 思维导图中的范围、流程、角色、判断节点和风险点
- 必要的补充澄清信息
- 当前稳定锚点（如存在）
- 前置检查遵循 `contracts/stage-gates.md`

## 输出

- 将功能清单写入工作项目的 `docs/feature-lists/` 目录
- 模板优先读取：`shitpm/templates/feature-list.md`
- 若宿主不支持 bundle 路径，再回退到 `templates/feature-list.md`
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

生成前读取：
1. `contracts/feat-generation-rules.md`

自审与状态更新前读取：
1. `contracts/feat-review-checklist.md`
2. `contracts/done-criteria.md`
3. `contracts/error-handling.md`
4. `contracts/host-contract.md`
5. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与稳定锚点
2. 读取模板与生成规则
3. 先基于模板搭结构，再替换为真实模块与功能点
4. 生成功能清单
5. 在保存前执行一次成稿清洗，删除占位功能点、空模块和模板示例
6. 读取自审规则
7. 执行自审与状态更新
