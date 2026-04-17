---
name: mock
description: "基于稳定 PRD 与 Page Structure 生成交互式 HTML 评审原型，严格不脑补上游事实。"
---

# PM Mock

## 目标

基于稳定 PRD 与 Page Structure 生成交互式 HTML 评审原型，用于与研发对齐需求。

- 原型不是独立需求源，而是 PRD 的可视化表达与交互承载
- 第一目标是“能点能走能复现关键流程”，不是“视觉高保真”
- 默认使用 `shared.css` / `shared.js` 复用通用 UI 与交互壳，降低 token 与返工

## 输入

- 当前稳定 PRD
- 当前稳定 Page Structure
- 当前稳定 Feature List（用于校验覆盖，避免漏页/漏能力）

## 输出

- 写入 `docs/prototypes/`
  - `shared.css`：通用样式壳（基于 Ant Design 6.x 风格 token）
  - `shared.js`：通用交互壳（不承载业务逻辑）
  - `mock-index.md`：页面索引与待确认清单（供分块与一致性检查使用）
  - `index.html`：（推荐）原型入口页，用于跳转各页面
  - `ps-__-<slug>.html`：每个页面一个 HTML

## 生成原则

- 速度优先：先完成结构与交互闭环，再谈视觉微调
- AI 负责从 0 到 70 分；视觉精修建议导入 Figma 处理
- 同一项目内页面必须共享统一视觉壳：所有页面引用同一份 `shared.css/shared.js`
- 不做 HTML 片段注入；共享通过 `shared.css/shared.js` 完成（最省 token、最快）
- `shared.css/shared.js` **不在 mock 阶段重复生成**：必须从模板复制得到
  - 模板来源：`templates/prototype-shared.css`、`templates/prototype-shared.js`
  - 生成前执行：`.\scripts\ensure-prototype-shared.ps1`（缺失时复制；存在则不覆盖）
  - 如需强制更新模板版本：`.\scripts\ensure-prototype-shared.ps1 -Force`

## 防幻觉门禁（必须遵守）

一句话门禁：
- **任何字段/按钮/交互/状态/跳转，必须能在 PRD 或 Page Structure 找到依据；找不到就占位并标记待确认，不得脑补。**

允许的细化（不改变事实）：
- 布局排列方式（横排/竖排/两栏）
- 元素大小比例与响应式断点
- 占位文案（提示/空态文案，不引入业务规则）
- 图标选择（不暗示业务含义）
- 导航形态（侧边栏/顶部导航），但页面集合仍锁死 Page Structure

禁止的细化（改变事实）：
- 新增 Page Structure 没有的页面/区域/元素（含按钮/菜单项）
- 新增 PRD 没有的字段、状态、校验规则、权限分支
- 新增 PRD 未定义的跳转链路或弹窗流程
- 用模拟数据暗示 PRD 没有的业务规则

发现幻觉/信息不足时的处理：
- PRD 或 Page Structure 不足以支撑表达：在页面标注 `待确认` 占位说明，并写入 `mock-index.md` 的待确认清单
- PRD 与 Page Structure 冲突：停止该区域生成，明确建议回退到 `prd` 或 `page`

## shared.js 交互壳边界（会议结论版）

默认提供壳（不需要 PRD 明确，但只有当页面中存在对应组件时才启用）：
- modal 打开/关闭
- drawer 打开/关闭
- toast 显示/消失
- tabs 切换
- loading 状态切换
- 空态渲染

必须 PRD 明确才实现业务逻辑：
- 表单校验规则（除“必填为空提示”壳外）
- 提交后的业务状态变更
- 权限控制逻辑
- 数据联动

表单校验（PRD 未写规则时）：
- 只做必填壳：空值提交提示“请填写 XXX”，不做格式/联动校验

错误/异常态（通用壳）：
- 默认提供通用错误壳：不解释原因，仅提示“操作失败，请稍后重试”
- 可额外提供“不可用/无权限”占位态（不解释原因），用于评审时解释按钮不可用/不可见

## 页面命名规范（固定）

- 文件名：`ps-{两位编号}-{slug}.html`，例如 `ps-01-shenqing-liebiao.html`
- `ps-xx` 编号以 Page Structure 的 PS 编号为准，不可变
- `slug` 仅用于可读性，可变更但不作为主键

## 分块生成协议（避免上下文爆炸）

当页面数超过 3 个时，必须启用分块生成。每页循环如下：

1. 只读当前页面相关 PRD 片段（不读全文）：
   - 页面章节（第 5 章对应小节）
   - 本页涉及字段（页面章节声明 + 数据字典定义）
   - 本页权限规则（权限矩阵中相关片段）
   - 与本页相关的横切规则
2. 只读当前页面 Page Structure（页面目标、区域、元素清单）
3. 不回读已生成页面 HTML 源码；只回读 `mock-index.md` 的索引摘要
4. 确保 `docs/prototypes/shared.css` 与 `docs/prototypes/shared.js` 存在并引用
5. 生成当前页面 `ps-xx-*.html` 并保存
6. 追加/更新 `mock-index.md` 的页面索引与待确认清单

短项目免处理：
- 若页面数不超过 3 个，可不分块，但仍必须遵守防幻觉门禁

## 页面索引格式（mock-index.md）

每个页面生成完毕后，写入一条索引（供后续一致性检查使用）：

```text
### PS-__ [页面名称]
- 文件：docs/prototypes/ps-__-xxx.html
- 区域：[...]
- 字段：[...]
- 动作：[...]
- 状态：[...]
- 跳转到：PS-__
- 被跳转自：PS-__
- 待确认：
  - [ ] ...
```

## 跨页面一致性检查（收尾门禁）

基于 `mock-index.md`（不读 HTML 源码）检查：
- 跳转关系双向一致
- 每页是否都引用同一份 `shared.css/shared.js`
- 同一字段跨页面展示命名一致（以 `data-field` 为准）
- 权限可见性与 PRD 规则一致（仅“有/无/禁用”层面）

## 规则（回退）

- PRD 不足以支撑交互表达：回退到 `prd`
- Page Structure 不足以支撑页面结构：回退到 `page`
- 只有纯表现层问题才允许停留在 `mock` 修订

## 状态更新

- 更新 `latest_artifacts.prototypes`
- 如本轮原型成为稳定版，刷新 `stable_baselines.prototype`
- 下一步默认推荐 `rev` 或 `note`










