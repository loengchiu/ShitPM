---
name: pm-fix
description: "在用户手动修改 PRD 后做定向版本判定，判断是否需要回写 Page Structure 或 Feature List，并修正稳定锚点。"
---

# PM FIX

## 目标

在用户手动修改 PRD 后，不直接重跑整条 PM 链路，而是先做影响范围判定。

若本轮修正已自动改动其他生成物，必须同步留下改动记录，避免后续无法追溯“是谁、因为什么、改了哪些上游产物”。

## 输入优先级

1. 用户显式给出的当前 PRD 路径
2. `docs/project-status.json` 中的 `stable_baselines.prd`
3. 项目目录扫描到的候选 PRD 中，结合命名、版本信息、修改时间和当前上下文判定出的当前工作稿；若仍无法判清，不自动认定，停止推进并要求用户确认

## 必做判定

### 1. 当前 PRD 版本关系

- 当前 PRD 是否已经替代 `stable_baselines.prd`
- 是否存在新版已生成但稳定锚点仍指向旧版的情况

### 2. 修改层级判定

- 仅 PRD 层表达修订
- 业务流程 / 结构层修订
- 页面承载层修订
- 能力边界层修订

### 3. 回写判定

- 仅 PRD 层：停留在 PRD
- 影响业务流程、判断节点、状态分支或系统结构：回写 `pm-mm`
- 影响页面承载：回写 `pm-ps`
- 影响能力边界：回写 `pm-fl`，必要时再回写 `pm-mm` 与 `pm-ps`

## 输出要求

必须明确输出：

- 本轮实际采用的当前 PRD 路径
- 当前 PRD 与 `stable_baselines.prd` 的关系
- 修改属于哪一层
- 是否需要回写 `pm-ps`
- 是否需要回写 `pm-fl`
- 是否需要回写 `pm-mm`
- 是否需要刷新 `stable_baselines`
- 推荐下一动作

若本轮已自动改动其他生成物，还必须输出一份修正记录，写入 `docs/fix-records/`。

结构参考：`../../templates/fix-record.md`

修正记录至少包含：

- 本轮实际采用的 PRD 路径
- 当前 PRD 与 `stable_baselines.prd` 的关系
- 判定出的影响层级
- 本轮自动改动了哪些生成物
- 每个生成物的改动原因、改动范围、改动后路径
- 是否刷新了对应 `stable_baselines`
- 未自动改动但需要人工确认的项

## 状态更新

- 如当前 PRD 已替代旧版，刷新 `stable_baselines.prd`
- 如需回写，写入 `pending_confirmations` 或 `blockers`
- 如本轮已生成修正记录，更新 `latest_artifacts.fix_records`

## 禁止事项

- 不得在未判清版本关系前直接引用旧 PRD
- 不得在未判清影响层级前直接重写上游
- 不得自动改动其他生成物却不留修正记录
- 不得将影响业务流程、判断节点或系统结构的 PRD 改动只当作页面或文案问题处理
