---
name: pm-fix
description: "在用户手动修改 PRD 后做定向版本判定，判断是否需要回写 Page Structure 或 Feature List，并修正稳定锚点。"
---

# PM FIX

## 目标

在用户手动修改 PRD 后，不直接重跑整条 PM 链路，而是先做影响范围判定。

## 输入优先级

1. 用户显式给出的当前 PRD 路径
2. `docs/project-status.json` 中的 `stable_baselines.prd`
3. 项目目录扫描到的最新 PRD

## 必做判定

### 1. 当前 PRD 版本关系

- 当前 PRD 是否已经替代 `stable_baselines.prd`
- 是否存在新版已生成但稳定锚点仍指向旧版的情况

### 2. 修改层级判定

- 仅 PRD 层表达修订
- 页面承载层修订
- 能力边界层修订

### 3. 回写判定

- 仅 PRD 层：停留在 PRD
- 影响页面承载：回写 `pm-ps`
- 影响能力边界：回写 `pm-fl`，必要时再回写 `pm-ps`

## 输出要求

必须明确输出：

- 本轮实际采用的当前 PRD 路径
- 当前 PRD 与 `stable_baselines.prd` 的关系
- 修改属于哪一层
- 是否需要回写 `pm-ps`
- 是否需要回写 `pm-fl`
- 是否需要刷新 `stable_baselines`
- 推荐下一动作

## 状态更新

- 如当前 PRD 已替代旧版，刷新 `stable_baselines.prd`
- 如需回写，写入 `pending_confirmations` 或 `blockers`

## 禁止事项

- 不得在未判清版本关系前直接引用旧 PRD
- 不得在未判清影响层级前直接重写上游
