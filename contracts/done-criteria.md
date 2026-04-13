# Done Criteria

## pm-go

- 已识别当前阶段
- 已识别当前锚点
- 已完成范围判定
- 如缺少基础总览，已形成轻量项目简介
- 已完成 PRD 规模判定
- 已输出下一动作或阻塞点
- **已输出 `project-status.json` 更新块**，含 `current_stage` / `last_action` / `next_recommended` / `context_summary`

## pm-scope

- 已澄清当前任务目标
- 已完成范围与拆分判定
- 如需拆分，已给出子项目名称、目标、依赖和推荐顺序
- 如缺少基础总览，已补齐轻量项目简介所需字段
- 已明确返回 `pm-go` 的下一动作
- **已输出 `project-status.json` 更新块**，含 `scope_decomposition` 变更

## pm-analysis

- 已形成正式项目简报
- 简报包含背景、资料分析结论、范围、角色、关键流程、关键规则、二次访谈补充与修正、变更与修正留痕、风险与待确认项
- 已区分已确认事实、高可信推断和冲突/待核实信息
- 未扩写成第二份 PRD
- 产物足以支撑后续思维导图
- 若待确认项足以阻塞下游，未将本阶段标记为完成
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.briefs`

## pm-mm

- 已形成结构化思维导图，而不是散点列表
- 导图覆盖范围、主流程、模块、系统结构、关键判断点、状态分支、风险点和待澄清问题
- 二次访谈或澄清后的关键修订已回写导图
- 无页面结构内容混入
- 待确认节点已标记清楚
- 导图足以直接支撑 `pm-fl`
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.mindmap`

## pm-fl

- 使用页面/能力级颗粒度
- 未混入步骤级内容
- 模块级已写涉及角色
- 主表字段完整
- 未混入页面区域或原型映射
- 版本边界明确
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.feature_list`；若已确认为稳定版则同步 `stable_baselines.feature_list`

## pm-ps

- 每个页面都有页面目标
- 每个区域都含对应功能点、作用、关键操作、关键状态
- 无过程性说明
- `对应功能点` 只做映射
- 未越权描述优先级或版本边界
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.page_structure`；若已确认为稳定版则同步 `stable_baselines.page_structure`

## pm-prd

- 已使用 `Feature List + Page Structure` 双锚点
- 已严格按模板主骨架输出
- 详细需求说明已覆盖真实存在的关键展示、操作、输入、加载、弹窗、异常和数据规则
- 界面承载说明中的页面与区域全部可回溯到 `Page Structure`
- 已继承 `Feature List` 的角色、范围与关键业务属性
- 复杂流程或状态已补 Mermaid 图
- 如规模过大，已先给出分块计划而不是直接整篇硬写
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.prd` 和 `prd_partition`；若已确认为稳定版则同步 `stable_baselines.prd`

## pm-rv

- 已列出实际采用路径
- 已判断与稳定锚点关系
- 已指出冲突、回退或回写建议
- 若为多角色评审模式：已逐角色输出评审结论，已给出整体结论（通过 / 带条件通过 / 阻塞）
- 若评审后存在待回答问题：已完成逐条问答，所有问题已路由处理或写入 `blockers` / `pending_confirmations`
- **已输出 `project-status.json` 更新块**，含 `blockers` / `pending_confirmations` 变更及 `last_action` / `next_recommended`

## pm-fix

- 已识别当前 PRD 路径
- 已完成版本关系判断
- 已完成回写判定
- 已输出稳定锚点修正建议
- **已输出 `project-status.json` 更新块**，含受影响的 `stable_baselines` 字段

## pm-pt

- 已基于稳定 PRD 输出原型
- 已覆盖当前评审所需关键页面、关键流程和关键状态
- 已形成或继承统一视觉基线
- 未脱离 PRD 自由发明需求
- 每个关键页面能回溯到 `Page Structure` 的页面目标
- 每个关键区域能回溯到 `Page Structure` 的区域定义
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.prototypes`；若已确认为稳定版则同步 `stable_baselines.prototype`

## pm-pa

- 已明确初始化标注或增量更新模式
- 同一模块未出现重复视角
- 浮窗信息足以替代对应 PRD 阅读
- 点击打开、拖拽、关闭、刷新同步均满足
- **已输出 `project-status.json` 更新块**，含 `latest_artifacts.prototype_annotations`
