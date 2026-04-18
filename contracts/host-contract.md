# Host Contract

## 首发宿主

- GitHub Copilot
- Codex

## 宿主最小要求

1. 能暴露 `skills`
2. 能暴露完整 `shitpm` bundle 目录树
3. bundle 内需保留 `skills / contracts / templates / commands` 的相对关系
4. 能在已初始化项目中读取项目根 `AGENTS.md`

## Bundle 解析

- `shitpm/...` 均按当前 AI 宿主根目录解析
- 不得按当前项目工作区解析这些路径
- 不得假设 `contracts / templates / commands` 被拆到不同目录
- 典型宿主根目录示例：
  - `.agents/`
  - `.codex/`
  - `.copilot/`
- 例如：
  - `shitpm/templates/prd.md`
  - `shitpm/contracts/done-criteria.md`
  - `shitpm/commands/prd.md`
  都表示“宿主根目录下的 ShitPM bundle 路径”，而不是项目里的相对路径

## 状态集成能力

若宿主希望输出“真实状态判断”而不是“上下文推断”，至少需要以下证据之一：

1. 本轮真实读取 `docs/project-status.json`
2. 本轮真实执行门禁校验
3. 本轮真实更新状态文件

若证据不存在，只能输出“基于上下文 / 基于当前已知状态”的判断。

## 最小桥接校验

- `shitpm/skills/scope/SKILL.md` 可见
- `shitpm/skills/prd/SKILL.md` 可见
- `shitpm/skills/rev/SKILL.md` 可见
- `shitpm/commands` 可见
- `shitpm/templates` 可见
- `shitpm/contracts` 可见
