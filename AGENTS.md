# ShitPM 工作流

当用户提出产品经理相关工作需求时：
1. 先读取当前项目的 `docs/project-status.json` 了解当前项目状态和阶段
   - 如果该文件不存在，告知用户："当前项目尚未初始化 ShitPM，请执行 `/start` 或回复“初始化 ShitPM”来启动"
2. 根据用户意图和当前状态，读取 `skills/{阶段}/SKILL.md` 获取执行规则
3. 按该 skill 的规则执行任务
4. 完成后更新当前项目的 `docs/project-status.json`

## ShitPM Bundle 路径规则

ShitPM 的运行时资源按完整 bundle 暴露在宿主根目录下的 `shitpm/` 中。

- 读取共享资源时，优先使用 `shitpm/templates/...`、`shitpm/contracts/...`、`shitpm/commands/...`
- 不得假设 `contracts / templates / commands` 被拆到不同目录
- 不得按当前项目工作区解析这些路径
- 具体解析规则见 `contracts/host-contract.md`

## 短命令路由

当用户输入以下命令时，直接路由到对应阶段：

| 命令 | 对应阶段 | 说明 |
|------|----------|------|
| `/start` | 初始化项目 | 在当前项目创建 `docs/project-status.json`，写入初始状态 |
| `/sum` | 项目简报 | `sum` |
| `/mind` | 思维导图 | `mind` |
| `/feat` | 功能清单 | `feat` |
| `/page` | 页面结构 | `page` |
| `/prd` | PRD | `prd` |
| `/mock` | 原型 | `mock` |
| `/rev` | 评审 | `rev` |
| `/fix` | 修复 | `fix` |
| `/note` | 原型注释 | `note` |

## 自然语言路由

当用户不使用命令，而是用自然语言描述需求时：

- 描述一个新需求 → `scope`
- "继续" / "下一步" → 读取 `project-status.json`，根据 `current_stage` 加载下一阶段
- "做到哪了" / "当前什么阶段" → 读取 `project-status.json`，汇报当前阶段和进度
- 明确指定阶段（"写 PRD" "做功能清单" "开始评审"）→ 对应 skill
- 变更修复 → `fix`

## 阶段流程

`scope -> sum -> mind -> feat -> page -> prd -> rev -> mock -> note`

## 门禁规则

从 `page` 开始，进入下一阶段前必须检查：
1. 读取 `docs/project-status.json`
2. `blockers` 是否为空（有阻塞则拒绝推进，告知用户）
3. `pending_confirmations` 是否为空（有待确认则拒绝推进，告知用户）
4. `stable_baselines` 中对应的上游锚点文件是否存在（缺失则拒绝推进，告知用户）

不满足任一条件时，明确告知用户缺什么，不得假装通过。

## 禁止事项

- 不得替用户做范围决策
- 不得跳过前置条件直接推进
- 不得一次性问用户多个问题
- 未真实读取状态文件时，不得表述成“已确认可推进”
