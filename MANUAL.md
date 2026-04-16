# 使用手册

## 入口

当前默认入口不是 `pm-go`，而是：

- 自然语言
- 或短命令 `/init /sum /mind /feat /page /prd /mock /rev /fix /note`

项目根目录存在 `docs/project-status.json` 时，ShitPM 自动激活并读取 `AGENTS.md`。

## 最短路径

```text
/init
老板让我做一个供应商准入审批流程
继续下一步
/feat
/page
/prd
/rev
```

## 什么时候用短命令

- 想明确进入某阶段时，直接用短命令
- 不想切阶段时，直接自然语言描述需求或说“继续下一步”

## 常见问法

- `现在做到哪个阶段了？`
- `当前能不能继续推进？`
- `继续下一步`
- `/feat`
- `/prd`
- `/rev`
- `我刚手改了 PRD，帮我判断要不要回写`

## 当前阶段

当前阶段由 `docs/project-status.json` 中的 `current_stage` 维护，取值为：

`scope / sum / mind / feat / page / prd / rev / mock / note`

## 门禁

从 `page` 开始，推进前默认检查：

- `blockers`
- `pending_confirmations`
- `stable_baselines`
- 锚点文件是否真实存在

如果不满足，会直接阻止继续并说明缺什么。

## 变更修复

手改功能清单、页面结构、PRD 或其他产物后，直接说：

```text
我刚手改了 PRD，帮我判断影响范围和最小回写路径
```

或：

```text
/fix
```

## 初始化

`/init` 会在当前项目创建 `docs/project-status.json`，作为 ShitPM 激活开关和状态源。
