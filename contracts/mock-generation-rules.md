# Mock Generation Rules

用于 `mock` 阶段的原型生成规则。

## 目标与定位

- 原型是稳定 PRD 与 Page Structure 的可视化表达，不是独立需求源
- 第一目标是“能点能走能复现关键流程”，不是视觉高保真
- 同一项目所有页面共享同一份 `shared.css` 与 `shared.js`

## 输入与模板

- 事实源只来自稳定 `prd`、`page structure`、`feature list`
- 共享壳优先读取宿主 bundle：`shitpm/templates/prototype-shared.css`、`shitpm/templates/prototype-shared.js`
- 宿主 bundle 解析遵循 `contracts/host-contract.md`
- 若宿主不支持 bundle 路径，再回退到 `templates/prototype-shared.css`、`templates/prototype-shared.js`
- 生成前执行 `scripts/ensure-prototype-shared.ps1`；缺失时复制，存在则不覆盖；强制更新时使用 `-Force`

## 防幻觉门禁

- 任何字段、按钮、交互、状态、跳转都必须能在 PRD 或 Page Structure 中找到依据
- 找不到依据时，只能做 `待确认` 占位，不得脑补

允许的细化：

- 布局排列方式
- 元素大小比例与响应式断点
- 不引入业务规则的占位文案
- 不暗示业务含义的图标
- 不改变页面集合事实的导航形态

禁止的细化：

- 新增 Page Structure 没有的页面、区域、元素
- 新增 PRD 没有的字段、状态、校验规则、权限分支
- 新增 PRD 未定义的跳转链路或弹窗流程
- 用模拟数据暗示 PRD 没有的业务规则

## 交互壳边界

默认可提供的通用壳：

- modal / drawer 打开关闭
- toast 显示消失
- tabs 切换
- loading 切换
- 空态渲染

必须以 PRD 为依据才实现：

- 表单校验规则
- 提交后的业务状态变更
- 权限控制逻辑
- 数据联动

PRD 未写表单规则时，只做必填壳，不做格式或联动校验。

## 文件命名与分块

- 页面文件名固定为 `ps-{两位编号}-{slug}.html`
- `ps-xx` 必须与 Page Structure 编号一致
- 页面数超过 3 个时，必须按页面分块生成

每页循环：

1. 只读当前页面相关 PRD 片段
2. 只读当前页面 Page Structure
3. 只回读 `mock-index.md` 摘要，不回读已生成 HTML 源码
4. 确保共享壳存在并被引用
5. 生成当前页面 HTML
6. 更新 `mock-index.md`

## 页面索引

`mock-index.md` 至少记录：

- 页面编号与名称
- 文件路径
- 区域、字段、动作、状态
- 跳转到 / 被跳转自
- 待确认项

## 回退规则

- PRD 不足以支撑交互表达：回退到 `prd`
- Page Structure 不足以支撑页面结构：回退到 `page`
- 纯表现层问题才允许停留在 `mock`
