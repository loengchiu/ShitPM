---
name: pm-scope
description: "ShitPM 内置范围探索能力。用于澄清目标、判断范围、拆分子项目和形成轻量项目简介。"
---

# PM Scope

## 目标

在 PM 主链开始前，先完成最小必要的范围探索和拆分判定，避免直接进入后续产物生成。

## 负责内容

- 澄清当前任务目标
- 判断是否属于单一 PM 任务
- 判断是否需要拆成多个子项目
- 形成轻量项目简介所需的基础信息

## 输出要求

每次执行后至少明确：

- 当前任务目标
- 范围边界
- 是否需要拆子项目
- 若拆分，子项目名称、目标、依赖、顺序
- 当前优先进入主链的子项目
- 如缺少基础总览，补齐轻量项目简介字段
- 推荐返回 `pm-go` 继续推进的下一动作

## 下一步回流

`pm-scope` 不是独立终点。执行完成后必须把控制权回流到 `pm-go`，由 `pm-go` 继续：

- 记录当前范围判定结果
- 识别当前阶段
- 决定进入 `pm-mm` / `pm-fl` / `pm-ps` / `pm-prd`
- 或在阻塞时停下等待确认

## 状态更新

至少更新：

- `current_stage`
- `scope_decomposition`
- `latest_artifacts.briefs`（如本轮补齐了轻量项目简介）
- `blockers`
- `pending_confirmations`

## 不负责

- 不写 spec
- 不进入 `writing-plans`
- 不替代 `pm-mm` / `pm-fl` / `pm-prd`
