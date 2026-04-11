# ShitPM 白皮书

## 一、定位

ShitPM 是一个独立的 PM 工作流项目。它以内置 PM 主入口和内置范围探索为起点，围绕项目简介、思维导图、功能清单、页面清单、PRD、原型、注释原型与评审建立产物链。

## 二、为什么独立

旧版 PM 扩展已验证能力可用，但也暴露出明显问题：

- 安装和映射复杂
- 不同宿主环境下能力暴露不一致
- 目录结构耦合度高
- 升级和排障成本高

因此 `ShitPM` 改为独立项目发布。

## 四、当前主链

`pm-go -> pm-scope -> brief -> mindmap -> feature-list -> page-structure -> prd -> review -> prototype -> annotation`

## 五、核心机制

### 1. 范围判定

`pm-go` 默认先调用内部技能 `pm-scope`，判断是否需要拆子项目。

### 2. 双锚点 PRD

PRD 的上游锚点是：

- `Feature List`
- `Page Structure`

### 3. 稳定锚点

项目状态文件维护：

- `stable_baselines.feature_list`
- `stable_baselines.page_structure`
- `stable_baselines.prd`

### 4. PRD 分块生成

当模块、页面、状态或角色规模过大时，PRD 不整体生成，而先生成分块计划，再逐块写作并汇总。

### 5. 人工改稿回写判定

用户可直接手改 PRD。改后通过 `pm-fix` 判定是否只影响 PRD，还是需要回写 `Page Structure` 或 `Feature List`。

## 六、当前能力范围

当前包含：

- `pm-go`
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
