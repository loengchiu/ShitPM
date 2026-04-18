# Done Criteria

## scope

- 已澄清当前任务目标
- 已完成范围与拆分判定
- 如需拆分，已给出子项目名称、目标、依赖和推荐顺序
- 已明确当前建议优先推进的子项目
- 如缺少基础总览，已补齐轻量项目简介所需字段
- 已明确返回统一路由入口后的下一动作
- 已输出 `project-status.json` 更新块，含 `scope_decomposition`

## sum

- 已形成可进入思维导图阶段的项目简报
- 简报已覆盖背景、资料分析结论、范围、角色、关键流程、关键规则、风险与待确认项、变更与修正留痕
- 如存在二次访谈或补充修正，已写入对应章节
- 已区分已确认事实、高可信推断和冲突/待核实信息
- 未扩写成第二份 PRD
- 产物足以支撑后续思维导图
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.briefs`

## mind

- 已形成结构化思维导图，而不是散点列表
- 导图覆盖范围、主流程、模块、系统结构、关键判断点、状态分支、风险点和待澄清问题
- 二次访谈或澄清后的关键修订已回写导图
- 无页面结构内容混入
- 导图足以直接支撑 `feat`
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.mindmap`

## feat

- 使用页面/能力级颗粒度
- 未混入步骤级内容
- 模块级已写涉及角色
- 主表字段完整
- 未混入页面区域或原型映射
- 版本边界明确
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.feature_list`
- 如已确认为稳定版，已同步 `stable_baselines.feature_list`

## page

- 每个页面都有页面目标
- 每个区域都含对应功能点、作用、关键操作、关键状态
- 无过程性说明
- 未越权描述优先级或版本边界
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.page_structure`
- 如已确认为稳定版，已同步 `stable_baselines.page_structure`

## prd

- 已使用 `Feature List + Page Structure` 双锚点
- 已按模板稳定主骨架输出；按需章节仅在形成真实约束时出现，未为凑完整度机械补写
- 详细需求说明已覆盖关键展示、操作、输入、加载、弹窗、异常、交互逻辑和数据规则，但未机械套用固定栏目
- 页面说明已按业务语义组织，顺序流程使用编号、并列规则使用点列，页面目标默认控制为一句话
- 通用 B 端能力仅在存在特殊规则时展开
- 文中出现的页面、入口和区域名称全部可回溯到 `Page Structure`
- 已继承 `Feature List` 的角色、范围与关键业务属性
- 复杂流程、状态或多角色交互已先写中文说明，并同步生成 `.drawio` 与 `.svg`
- 如规模过大，已先给出分块计划
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.prd` 和 `prd_partition`
- 如已确认为稳定版，已同步 `stable_baselines.prd`

## rev

- 已列出实际采用路径
- 已判清当前评审对象，而不是默认按 PRD 处理
- 已判断与稳定锚点关系
- 已对当前评审对象完成分层质量判断
- 已指出冲突、回退或回写建议
- 如评审对象存在 blocker / pending_confirmation 引用，已正确判定是否允许继续评审
- 如涉及字段链问题，已检查 `mind -> feat -> page(关联字段) -> prd` 是否完整
- 如为多角色评审模式，已明确评审团组合并给出整体结论
- 如存在待处理问题，已按 `真实风险 / 过度担忧 / 待观察项` 完成定性
- 如待处理问题较多，已先完成归并、去重和阻塞度排序
- 如评审后存在待回答问题，已完成逐条问答并完成路由或写入 `blockers / pending_confirmations`
- 如问答后的答案已改变事实源，已将正式处理路由到 `fix`
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.reviews`

## fix

- 已识别当前变更产物路径
- 已完成版本关系判断
- 已完成回写判定
- 已完成影响分析与回写粒度判定
- 如存在锚点冲突，已按“评审驱动 / 用户手动修改 / 来源待确认”完成定性
- 如路径来自目录候选集，已结合命名、版本信息、修改时间和上下文完成判定；若无从判清，已停止推进
- 已输出稳定锚点修正建议
- 如本轮自动改动了 `Mindmap`、`Feature List`、`Page Structure` 或其他相关生成物，已生成修正记录并写明原因、范围和改动后路径
- 已输出 `project-status.json` 更新块，含受影响的 `stable_baselines` 以及 `latest_artifacts.fix_records`

## mock

- 已基于稳定 PRD 输出原型
- 已覆盖当前评审所需关键页面、关键流程和关键状态
- 已形成或继承统一视觉基线
- 未脱离 PRD 自由发明需求
- 每个关键页面与区域均可回溯到 `Page Structure`
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.prototypes`
- 如已确认为稳定版，已同步 `stable_baselines.prototype`

## note

- 已明确初始化标注或增量更新模式
- 同一模块未出现重复视角
- 浮窗信息足以替代对应 PRD 阅读
- 点击打开、拖拽、关闭、刷新同步均满足
- 已输出 `project-status.json` 更新块，含 `latest_artifacts.prototype_annotations`

