---
name: mock
description: "基于稳定 PRD 生成高保真 HTML 原型，并始终以 PRD 为事实源。"
---

# PM PT

## 目标

基于稳定 PRD 生成或修订高保真 HTML 原型。
Prototype 不是独立需求源，而是 PRD 的可视化表达和交互承载。

## 输入

- 当前稳定 PRD
- 当前稳定 `Page Structure`（用于页面承载校验）

## 输出

- 写入 `docs/prototypes/`
- 如项目中不存在视觉基线，同时生成或更新 `docs/prototypes/visual-baseline.md`

## 规则

- 始终以 PRD 为事实源
- 在页面布局、组件选型、间距体系、信息层级、表单设计、表格设计，弹窗、按钮，导航、反馈状态等方面，优先遵循Ant Design 6.x的风格。
- 输出的UI 应保持简洁、理性、现代、专业，符合中后台与企业级产品的视觉习惯.
- 使用清晰的信息结构：规整的栅格系统，统一的圆角与留白，遛免过度装饰化，强烈渐变，夸张动效和实验性布局。
- 同一项目内原型必须共享统一视觉基线
- 如果已有视觉基线，后续页面继承它，而不是重新发明一套风格
- 每个原型页面都必须能回溯到当前 `Page Structure` 的页面目标
- 每个原型页面中的关键区域都必须能回溯到当前 `Page Structure` 的关键区域定义
- 原型允许在表现层细化，但不允许新增 `Page Structure` 中不存在的主页面或关键区域
- 如果 PRD 不足以支撑页面表达，回退到 `prd`
- 如果页面承载事实不足以支撑原型结构，回退到 `page`
- 只在纯表现层问题时，允许停留在 Prototype 阶段修订

## 状态更新

- 更新 `latest_artifacts.prototypes`
- 若 `stable_baselines.visual_baseline` 为空字符串，将本轮视觉基线路径（`docs/prototypes/visual-baseline.md`）写入；若已有值，不覆盖，继承使用
- 如本轮原型成为稳定版，刷新 `stable_baselines.prototype`
- 下一步默认推荐 `rev` 或 `note`










