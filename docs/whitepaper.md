# ShitPM 白皮书

## 一、定位

ShitPM 是一个独立的 PM 工作流项目。它以内置 PM 主入口和内置范围探索为起点，围绕分析简报、思维导图、功能清单、页面结构、PRD、原型、标注原型与评审建立产物链。

## 二、为什么独立

旧版 PM 扩展已验证能力可用，但也暴露出明显问题：

- 安装和映射复杂
- 不同宿主环境下能力暴露不一致
- 目录结构耦合度高
- 升级和排障成本高

因此 `ShitPM` 改为独立项目发布。

## 三、目标

- 形成可安装、可验证、可演进的 PM 技能系统
- 保留以产物为中心的阶段化工作流
- 让 `pm-go` 成为默认自然语言主入口
- 继续保留内部阶段能力，避免退回单体大提示词

## 四、当前主链

`pm-go -> pm-scope -> analysis -> mindmap -> feature-list -> page-structure -> prd -> review -> prototype -> annotation`

## 五、核心机制

### 1. 范围判定

`pm-go` 默认先调用内置技能 `pm-scope`，判断是否需要拆子项目。

### 2. 分析中间层

在范围确认后，先形成正式分析简报，再进入思维导图。分析简报负责沉淀项目总览、关键流程文字版、关键规则、变更留痕、风险与待确认项。

### 3. 双锚点 PRD

PRD 的上游锚点是：

- `Feature List`
- `Page Structure`

### 4. 稳定锚点

项目状态文件维护：

- `stable_baselines.feature_list`
- `stable_baselines.page_structure`
- `stable_baselines.prd`

### 5. PRD 分块生成

当模块、页面、状态或角色规模过大时，PRD 不整体生成，而先生成分块计划，再逐块写作并汇总。

### 6. 人工改稿回写判定

用户可直接手改 PRD。改后通过 `pm-fix` 判定是否只影响 PRD，还是需要回写 `Page Structure` 或 `Feature List`。

## 六、当前能力范围

当前包含：

- `pm-go`
- `pm-analysis`
- `pm-mm`
- `pm-fl`
- `pm-ps`
- `pm-prd`
- `pm-rv`
- `pm-fix`
- `pm-pt`
- `pm-pa`

## 七、宿主策略

首发支持：

- GitHub Copilot
- Codex

Trae 后续单独评估，如有必要单独出适配版本。
