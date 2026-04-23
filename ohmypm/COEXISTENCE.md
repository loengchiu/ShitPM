# ShitPM 与 Oh My PM 最小共存方案

## 1. 目标

本方案的目标不是立刻把 `ShitPM` 和 `Oh My PM` 做成深度集成系统，而是先保证：

- 当前可以并行存在
- 后续真要共存时，不需要大规模返工
- 两边不会争抢主状态、主流程和正式产物目录

一句话原则：

**先做目录分离、状态分离、单向交接，不做双向共管。**

---

## 2. 主从关系

当前阶段，建议固定为：

- `Oh My PM`：前置协作层
- `ShitPM`：正式项目层

### 2.1 Oh My PM 负责

- 需求接收
- 回应/校验循环
- ask-back
- 模块拆分
- 粗估与排期影响判断
- preflight
- 第一版原型与 PRD skeleton

### 2.2 ShitPM 负责

- 正式项目主线
- 正式阶段推进
- 正式产物树
- 正式 PRD
- 正式评审与基线

### 2.3 共存原则

- 不允许 `Oh My PM` 与 `ShitPM` 平级共管同一条主流程
- 不允许两边同时维护同一个正式项目状态文件
- 不允许 `Oh My PM` 的中间材料直接污染 `ShitPM` 的正式产物树

---

## 3. 状态文件分离

这是共存方案中必须优先落地的一条。

### 3.1 ShitPM 保持不变

`ShitPM` 继续使用：

- `docs/project-status.json`

它仍是正式项目层的唯一权威状态文件。

### 3.2 Oh My PM 独立命名

`Oh My PM` 不再占用 `docs/project-status.json`，改为独立状态：

- `docs/ohmypm/ohmypm-status.json`
- `docs/ohmypm/ohmypm-memory.md`

### 3.3 强规则

- `project-status.json` 永远只属于 `ShitPM`
- `Oh My PM` 不得再写入 `project-status.json`
- `Oh My PM` 的轮次、fallback、change、ask-back 等内部运行时状态，全部留在自己的状态文件中

---

## 4. 产物目录分离

### 4.1 ShitPM 正式产物目录

`ShitPM` 继续维护正式项目产物目录，不做此处改动。

### 4.2 Oh My PM 独立目录

建议 `Oh My PM` 使用独立目录：

- `docs/ohmypm/status/`
- `docs/ohmypm/memory/`
- `docs/ohmypm/alignment/`
- `docs/ohmypm/deliverables/`
- `docs/ohmypm/cache/`

### 4.3 建议映射

当前 `Oh My PM` 中的以下内容，后续应逐步迁入独立目录：

- 状态文件
- 项目记忆
- 对齐 note
- handoff note
- stable alignment package
- prototype / prd skeleton
- ask-back 记录
- preflight 记录

### 4.4 强规则

- `Oh My PM` 的 note、handoff、sample、prototype、prd skeleton 不得直接混入主 `docs/` 的正式产物区
- 只有在明确进入正式项目层后，才允许有选择地把结果提升到 `ShitPM` 正式产物树

---

## 5. 单向交接点

当前阶段只做单向交接：

- `Oh My PM` -> `ShitPM`

不做双向同步。

### 5.1 触发时机

当 `Oh My PM` 满足以下条件时，可生成交接包：

- 当前版本方案稳定
- preflight 通过
- 原型已有可展示版本
- PRD skeleton 已形成
- 关键待确认项已收敛到不阻塞正式进入

### 5.2 最小交接对象

建议定义一份交接文件，例如：

- `docs/ohmypm/handoff.json`
  或
- `docs/ohmypm/handoff.md`

其最小字段至少包含：

- 当前需求任务
- 当前版本号
- 已确认事实
- 当前版本方案摘要
- 当前模块清单
- 当前工时/排期判断
- 原型路径
- PRD skeleton 路径
- 尚未阻塞正式进入的待确认项

### 5.3 当前约束

- 交接包是 `ShitPM` 的输入，不是 `ShitPM` 状态文件本身
- `ShitPM` 是否采纳交接包、如何转写成正式阶段状态，仍由 `ShitPM` 处理

---

## 6. 术语隔离

`Oh My PM` 内部有一套运行时术语，例如：

- `round_result`
- `fallback_type`
- `change_category`
- `internal_repair`
- `need_materials`
- `reopen_alignment`

这些术语可以存在于 `Oh My PM` 内部状态中，但不应直接污染 `ShitPM` 的正式项目语言。

### 6.1 规则

- `Oh My PM` 内部术语 = 运行时语言
- `ShitPM` 正式状态与正式文档语言 = 项目语言

### 6.2 交接时的翻译原则

从 `Oh My PM` 向 `ShitPM` 交接时：

- 不直接把内部枚举值原样抛给 `ShitPM`
- 必须翻译成项目可读的结论，例如：
  - 当前已确认范围
  - 当前建议推进动作
  - 当前阻塞点
  - 当前是否已可进入正式产物阶段

---

## 7. 路由优先级

为了避免同一句话同时命中两套系统，建议采用以下优先级。

### 7.1 默认走 Oh My PM

当用户意图更像：

- 新需求
- 先回应一下
- 继续对齐
- 把待确认点问我
- 先估一下工作量
- 看新增内容算什么变化

默认优先进入 `Oh My PM`。

### 7.2 默认走 ShitPM

当用户意图更像：

- 进入正式 PRD
- 进入正式原型
- 进入正式评审
- 看当前正式阶段
- 继续正式项目主线

默认优先进入 `ShitPM`。

### 7.3 模糊指令

对于“继续”“下一步”这类模糊指令：

- 如果当前仍未进入正式项目主线，优先由 `Oh My PM` 接管
- 如果已进入正式项目主线，优先由 `ShitPM` 接管

建议后续保留一个内部字段表示当前主控权，例如：

- `workflow_owner = ohmypm | shitpm`

当前阶段可先不实现，只保留设计位。

---

## 8. 现在必须做的事

为了避免以后大改，当前阶段至少应立即执行以下三项：

1. `Oh My PM` 改状态文件名，不再占用 `docs/project-status.json`
2. `Oh My PM` 改产物目录，迁入 `docs/ohmypm/`
3. 先定义 `Oh My PM -> ShitPM` 的最小 handoff 对象

---

## 9. 现在不要做的事

当前阶段不建议做：

- 双向状态同步
- 双主流程共管
- 自动把 `Oh My PM` 产物升级为 `ShitPM` 正式产物
- 让两边共用同一个 `project-status.json`
- 让 `ShitPM` 直接消费 `Oh My PM` 的全部内部枚举和中间状态

---

## 10. 一句话结论

`Oh My PM` 与 `ShitPM` 能共存，但必须是：

**OMP 前置协作，ShitPM 后置正式化；状态分离，目录分离，单向交接。**
