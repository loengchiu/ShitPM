---
name: pm-go
description: "ShitPM 的唯一主入口。调用内部技能 `pm-scope` 判定范围、锚点、阶段与 PRD 写作粒度，并编排后续 PM 链路。"
---

# PM Go

## 目标

把 `pm-go` 作为工作项目的唯一 PM 入口。它负责：

1. 识别当前项目阶段
2. 调用内部技能 `pm-scope`
3. 判断是否需要拆子项目
4. 判定当前应进入的 PM 阶段
5. 在进入 PRD 前判断是否需要分块写作
6. 更新 `docs/project-status.json`
7. 推荐或继续调用下一技能

## 上下文恢复协议

**每次进入 `pm-go` 时，第一步必须执行恢复检查。**

### 步骤

1. 确认用户提供的项目目录路径（如未提供，主动询问）
2. 检查 `<项目目录>/docs/project-status.json` 是否存在
3. **若存在**：读取文件，输出标准恢复摘要（见下方格式），再继续后续判定
4. **若不存在**：说明这是新项目，跳过恢复，直接进入范围判定

### 恢复摘要格式

```
📋 项目状态恢复
─────────────────────────────
项目：<项目目录>
当前阶段：<current_stage>
上次动作：<last_action>
上下文：<context_summary>

锚点状态：
  Feature List : <stable_baselines.feature_list 或"未设定">
  Page Structure: <stable_baselines.page_structure 或"未设定">
  PRD           : <stable_baselines.prd 或"未设定">
  Prototype     : <stable_baselines.prototype 或"未设定">

待处理：
  阻塞项：<blockers 数量及首条描述，无则"无">
  待确认：<pending_confirmations 数量及首条描述，无则"无">

建议下一步：<next_recommended>
─────────────────────────────
```

### 恢复后行为

- 若 `blockers` 不为空：询问用户是否先处理阻塞项，还是忽略继续
- 若 `pending_confirmations` 不为空：询问用户是否逐条确认
- 其余情况：按 `next_recommended` 推进，或等待用户指示

## 输入

最小输入：

- 项目目录
- 自然语言任务

可选输入：

- 当前 Feature List 路径
- 当前 Page Structure 路径
- 当前 PRD 路径
- 当前 Prototype 路径

## 锚点优先级

1. 用户显式给出的当前文件路径
2. `docs/project-status.json` 中的 `stable_baselines`
3. 目录扫描结果

## 版本迭代处理

若用户说明当前是在已有版本基础上做新版本迭代（如 v1.0 已上线，现在做 v1.1）：

- 主动请用户提供或确认 v1.0 的产物路径（FL / PS / PRD）
- 将上一版产物作为**参考上下文**读入，不作为本轮稳定锚点
- 告知后续 Skill：上一版内容仅用于理解已有功能边界，本轮产物需全新生成
- `pm-mm` 阶段将聚焦于**本轮新增或变化**的部分，避免重复发散已有功能

## 默认主链

`pm-scope -> brief -> pm-mm -> pm-fl -> pm-ps -> pm-prd -> pm-rv -> pm-pt -> pm-pa`

## 必做判定

### 1. 范围判定

在进入 PM 主链前，默认先调用内部技能 `pm-scope`。

判断是否需要拆子项目。满足以下任一情况时，不直接进入主链：

- 同时覆盖多个独立业务域
- 同时要求多个可独立交付的大模块
- 存在多套主流程
- 单一 Brief / Feature List / PRD 已无法保持边界清晰

若需要拆分，必须输出：

- 子项目名称
- 子项目目标
- 子项目依赖关系
- 推荐顺序
- 当前优先进入主链路的子项目

### 2. 阶段判定

根据显式输入、稳定锚点和目录产物判断当前所处阶段：

- 无稳定产物：先形成轻量项目简介，再进入 `pm-mm`
- 已有思维导图：可进入 `pm-fl`
- 已有功能清单：可进入 `pm-ps`
- 已有功能清单和页面清单：可进入 `pm-prd`
- 已有 PRD：优先进入 `pm-rv`
- 已有稳定 PRD：可进入 `pm-pt`
- 已有稳定 PRD 与 Prototype：可进入 `pm-pa`

### 3. PRD 规模判定

进入 `pm-prd` 前必须判断：

- 是否整体生成
- 是否分块生成

若满足多项强信号则必须先做分块计划：

- 模块数量较多
- 页面数量较多
- 多角色协同明显
- 状态流转复杂
- 异常分支较多
- 预计单次生成会明显超过高质量上下文承载范围

分块原则：

- 按业务场景或模块拆
- 先给分块计划
- 再逐块写
- 最后汇总

### 4. 人工改稿判定

若用户手动修改了 PRD：

- 不从头重跑
- 先判定当前 PRD 与稳定锚点的关系
- 再判断这次修改只影响 PRD，还是穿透到 `pm-ps` / `pm-fl`

### 5. 前置整理判定

在 `pm-scope` 之后，如当前项目缺少可继续推进的基础总览，应先形成轻量项目简介，至少覆盖：

- 项目背景
- 范围边界
- 用户与角色
- 关键流程
- 关键规则
- 需求变更记录
- 风险与待确认项

### 6. 二次访谈判定

如思维导图中仍存在足以阻塞 `Feature List` 的待确认节点，应先形成二次访谈问题清单，或在当前会话完成一轮澄清后再进入 `pm-fl`。

## 输出要求

每次执行后必须明确输出：

- 当前阶段
- 本轮实际采用的锚点
- 是否触发拆子项目
- 是否触发 PRD 分块
- 推荐下一动作
- 是否存在阻塞点

## 状态更新

每次执行后必须输出 `project-status.json` 更新块，至少更新：

- `current_stage`
- `last_action`：本轮实际完成的动作，一句话
- `next_recommended`：本轮推荐的下一步
- `context_summary`：如有重大进展则更新，100字以内
- `stable_baselines`
- `scope_decomposition`
- `prd_partition`
- `latest_artifacts`
- `blockers`
- `pending_confirmations`

## 阻塞场景

以下情况不得继续推进：

- 上游锚点冲突
- 多版本混用
- 稳定锚点未刷新
- Page Structure 缺失
- PRD 规模过大但未形成分块计划

## 编排规则

- PM 阶段全程由 `pm-go` 主导
- 新需求、范围不清、怀疑任务过大时，先调用 `pm-scope`
