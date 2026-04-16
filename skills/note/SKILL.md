---
name: note
description: "在稳定版 PRD 与 HTML 原型上构建可交互需求标注层，让研发通过页面浮窗即可获得完整开发指令。"
---

# PM PA

## 目标

把稳定版 PRD 的需求点，以模块化聚合方式挂载到原型 HTML 页面中。
输出目标是“带交互标注层的原型 HTML”，而不是普通注释文档。

## 输入

- 稳定版 PRD
- 稳定版 Prototype HTML
- 用户明确指令：初始化标注，或增量更新

## 输出

- 写入 `docs/prototype-annotations/`
- 如要求编号回写，同步更新对应 PRD

## 任务判定

先判定：
- 初始化标注
- 增量更新

未判定前，不得擅自修改原型 HTML。

## 规则

- 同一组件或模块只保留一个角标
- 默认点击打开，不使用 hover 自动弹出
- 浮窗支持拖拽
- 只能通过 `X` 按钮关闭
- 页面切换、弹窗打开/关闭后必须同步标注状态
- 浮窗内容必须足以替代对应 PRD 内容阅读
- 若只是标注内容问题，停留在本阶段修订
- 若发现需求冲突，回退到 `prd` 或 `mock`

## 状态更新

- 更新 `latest_artifacts.prototype_annotations`
- 如本轮涉及编号回写，同步更新 `latest_artifacts.prd`
- 下一步默认推荐 `rev`

