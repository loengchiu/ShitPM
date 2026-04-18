---
name: prd
description: 基于稳定 Feature List 与 Page Structure 生成和修订 PRD，并把 PRD 作为后续 Prototype 与评审的主规格锚点。
---

# PM PRD

## 输入

按以下优先级读取：
1. 稳定 Feature List
2. 稳定 Page Structure
3. 稳定项目简报中的关键业务对象与字段线索
4. 稳定思维导图中的判断字段 / 状态字段 / 权限字段线索
5. 影响范围、优先级、规则表述或验收口径的补充澄清信息
6. 历史 cards / interviews / 旧稿（仅作补充参考，不得覆盖当前稳定锚点）

如存在 `docs/project-status.json`，优先继承：
- `stable_baselines.feature_list`
- `stable_baselines.page_structure`

前置检查遵循 `contracts/stage-gates.md`

## 输出

- 将 PRD 写入工作项目的 `docs/prd/` 目录
- 模板优先读取：`shitpm/templates/prd.md`
- 若宿主不支持 bundle 路径，再回退到 ShitPM 仓库中的 `templates/prd.md`
- 如存在复杂流程、状态流转、多角色顺序交互或系统边界说明，同时生成图表文件到 `docs/diagrams/prd/`
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

详细规则不要在本文件展开，统一按以下 contracts 执行：

前置检查前读取：
1. `shitpm/contracts/stage-gates.md`

生成前读取：
1. `shitpm/contracts/prd-generation-rules.md`
2. `shitpm/contracts/artifact-schema.md`
3. `shitpm/contracts/diagram-style.md`
4. `shitpm/contracts/host-contract.md`

自审与状态更新前读取：
1. `shitpm/contracts/prd-review-checklist.md`
2. `shitpm/contracts/done-criteria.md`
3. `shitpm/contracts/error-handling.md`
4. `shitpm/contracts/workflow-state.md`

若宿主不支持 bundle 路径，再回退到 ShitPM 仓库中的：

前置检查前：
1. `contracts/stage-gates.md`

生成前：
1. `contracts/prd-generation-rules.md`
2. `contracts/artifact-schema.md`
3. `contracts/diagram-style.md`
4. `contracts/host-contract.md`

自审与状态更新前：
1. `contracts/prd-review-checklist.md`
2. `contracts/done-criteria.md`
3. `contracts/error-handling.md`
4. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与稳定锚点
2. 读取模板与生成规则 contracts
3. 生成 PRD 正文与必要图表
4. 读取自审规则 contracts
5. 执行一致性校验与自审
6. 更新状态文件
