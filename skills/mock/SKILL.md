---
name: mock
description: "基于稳定 PRD 与 Page Structure 生成交互式 HTML 评审原型，严格不脑补上游事实。"
---

# PM Mock

## 输入

- 当前稳定 PRD
- 当前稳定 Page Structure
- 当前稳定 Feature List（用于校验覆盖，避免漏页/漏能力）
- 前置检查遵循 `contracts/stage-gates.md`

## 输出

- 写入 `docs/prototypes/`
## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

生成前读取：
1. `contracts/mock-generation-rules.md`
2. `contracts/host-contract.md`
3. `contracts/workflow-state.md`

自审与状态更新前读取：
1. `contracts/mock-review-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与稳定锚点
2. 读取生成规则与共享壳来源
3. 按页面分块生成原型与 `mock-index.md`
4. 读取自审规则
5. 执行一致性检查并更新状态










