# ShitPM

ShitPM 是一套运行在 AI IDE 中的 PM 工作流系统。  
项目初始化后，默认入口变为 **自然语言 + 项目根目录 `AGENTS.md`**，也支持短命令：

`/init /sum /mind /feat /page /prd /mock /rev /fix /note`

## 主链

`scope -> sum -> mind -> feat -> page -> prd -> rev -> mock -> note`

## 阶段与产物

| 阶段 | 产物 | 作用 |
| --- | --- | --- |
| `scope` | 范围结论 | 判断目标、边界、是否拆分 |
| `sum` | 项目简报 | 整理原始资料、结论、留痕 |
| `mind` | 思维导图 | 收敛流程、模块、判断点 |
| `feat` | 功能清单 | 固定能力边界与版本范围 |
| `page` | 页面结构 | 固定页面与区域承载 |
| `prd` | PRD | 展开为可执行规格 |
| `rev` | 评审结果 | 检查一致性、回退或回写 |
| `mock` | 原型 | 将 PRD 可视化 |
| `note` | 原型注释 | 形成可评审交付层 |

## 使用方式

1. 安装 ShitPM
2. 在业务项目中执行 `/init`
3. 后续直接自然语言工作，或使用短命令快速进入阶段

示例：

```text
/init
老板让我做一个供应商准入审批流程
/feat
/page
/prd
/rev
```

## 关键规则

- 只有存在 `docs/project-status.json` 的项目才会激活 ShitPM
- 从 `page` 开始，推进前必须检查：
  - `blockers`
  - `pending_confirmations`
  - `stable_baselines`
  - 锚点文件真实存在
- `page / prd / rev / fix` 还保留最小前置自检，作为全局路由失效时的兜底

## 目录

- `AGENTS.md`：统一路由入口
- `INSTALL.md`：全局安装指令
- `skills/`：阶段 skill
- `commands/`：短命令入口
- `templates/`：产物模板
- `contracts/`：状态、门禁、完成定义
- `scripts/`：状态脚本、门禁脚本、验证脚本

## 宿主支持

- 正式支持：GitHub Copilot、Cursor、Antigravity
- 实验支持：Codex

详细实操见 [MANUAL.md](./MANUAL.md) 与 [docs/usage.md](./docs/usage.md)。
