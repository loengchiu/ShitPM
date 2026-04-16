# Host Contract

## 首发宿主

- GitHub Copilot
- Codex

## 宿主最小要求

1. 能暴露 `skills`
2. 能暴露共享 `templates` 与 `contracts`
3. 能暴露 `commands`
4. 能在已初始化项目中读取项目根 `AGENTS.md`

## 状态集成能力

若宿主希望输出“真实状态判断”而不是“上下文推断”，至少需要以下证据之一：

1. 本轮真实读取 `docs/project-status.json`
2. 本轮真实执行门禁校验
3. 本轮真实更新状态文件

若证据不存在，只能输出“基于上下文 / 基于当前已知状态”的判断。

## 最小桥接校验

- `scope` 可见
- `prd` 可见
- `rev` 可见
- `commands` 可见
- `templates` 可见
- `contracts` 可见
