---
name: pm-go
description: "ShitPM 的唯一主入口。调用内部技能 pm-scope 判定范围、锚点、阶段与 PRD 写作粒度，并编排后续 PM 链路。"
---

# PM Go

## 目标

将 pm-go 作为 PM 链路唯一入口，负责：

- 恢复项目状态
- 判定是否必须先进入 pm-scope
- 在范围已确认后判定阶段与下一技能
- 在进入 pm-prd 前判定是否需要分块
- 更新 docs/project-status.json

## Hard Gate

- 触发 pm-scope 条件时，必须先进入 pm-scope。
- 范围未确认前，不进入 pm-mm / pm-fl / pm-ps / pm-prd。
- 范围未确认前，不输出下游产物结论。
- 仅当 pm-scope 完成且用户确认范围结论或拆分方案后，才继续阶段判定。

## 上下文恢复

每次进入 pm-go，先做恢复：

1. 确认项目目录。
2. 检查 <项目目录>/docs/project-status.json。
3. 若存在，读取并输出恢复摘要：当前阶段、上次动作、锚点、阻塞项、待确认、建议下一步。
4. 若不存在，按新项目进入范围判定。

恢复后处理：

- blockers 不为空：先询问是否处理阻塞。
- pending_confirmations 不为空：先询问是否逐条确认。
- 其余情况：按 next_recommended 推进或等待用户指示。

锚点优先级：用户显式路径 > stable_baselines > 目录扫描结果。

## 与 pm-scope 的衔接

### 必须进入 pm-scope

满足任一条件时，不得跳过：

- 目标模糊，仅有方向描述
- 同时覆盖多个模块、子系统或独立业务域
- 要求同时规划多个可独立交付的大模块
- 当前版本边界不清
- 单一 Brief / Feature List / PRD 难以承载清晰边界
- 会话出现“先做完整平台”“一起规划完”等大范围信号

### 可跳过 pm-scope

仅当以下条件同时成立才可跳过：

- 目标清晰
- 版本边界清晰
- 当前对象是单一模块或单一子项目
- 不存在明显拆分需求
- 锚点或稳定产物足以恢复上下文

若任一条件不满足，默认进入 pm-scope。

### pm-scope 返回后

pm-go 只做三件事：

1. 记录范围判定与拆分结果
2. 判断是否先补轻量项目简介
3. 在已确认范围内继续阶段判定

若仍有未确认问题，停在确认环节，不推进后续技能。

## 阶段判定

仅在范围已确认或允许跳过 pm-scope 时执行：

- 无稳定产物：先补轻量项目简介，再进入 pm-mm
- 已有思维导图：进入 pm-fl
- 已有功能清单：进入 pm-ps
- 已有功能清单和页面清单：进入 pm-prd
- 已有 PRD：优先进入 pm-rv
- 已有稳定 PRD：进入 pm-pt
- 已有稳定 PRD 与 Prototype：进入 pm-pa

## 关键判定

| 场景 | 判定与动作 |
|------|------------|
| 进入 pm-prd | 若模块/页面较多、多角色协同明显、状态或异常复杂、或单次写作超上下文承载，先给分块计划，再逐块写，最后汇总 |
| 用户手动改 PRD | 不从头重跑；先对齐稳定锚点，再判断影响层级是 pm-prd 还是穿透到 pm-ps / pm-fl |
| 基础总览缺失 | 先补轻量项目简介（背景、范围、角色、流程、规则、变更、风险与待确认） |
| 思维导图仍有阻塞节点 | 先产出二次访谈问题清单，或补一轮澄清后再进入 pm-fl |

## 输出要求

每次执行后必须明确：

- 本轮是否进入 pm-scope，或为什么允许跳过
- 当前阶段
- 本轮采用的锚点
- 是否触发拆分
- 是否触发 PRD 分块
- 推荐下一动作
- 是否存在阻塞

## 状态更新

每次执行后，至少更新 project-status.json 以下字段：

- current_stage
- last_action
- next_recommended
- context_summary
- stable_baselines
- scope_decomposition
- prd_partition
- latest_artifacts
- blockers
- pending_confirmations

## 阻塞场景

以下情况不得继续推进：

- pm-scope 尚未完成确认
- 上游锚点冲突
- 多版本混用
- 稳定锚点未刷新
- Page Structure 缺失
- PRD 规模过大但未形成分块计划

## 编排规则

- PM 阶段全程由 pm-go 主导，范围判定优先由 pm-scope 完成。
- 范围不清或任务过大时，必须先过 pm-scope，不得越过确认环节。
