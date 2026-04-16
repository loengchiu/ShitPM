# Copilot 项目指令

本项目使用 **ShitPM** 进行 PM 工作流管理。

## 使用方式

- 默认入口是 **自然语言 + 项目根目录 `AGENTS.md`**
- 当前项目已初始化时，模型应优先读取 `docs/project-status.json`
- 若用户使用短命令，则直接按命令进入对应阶段：
  - `/init /sum /mind /feat /page /prd /mock /rev /fix /note`
- 若用户使用自然语言，则按 `AGENTS.md` 的自然语言路由规则执行
- 若未真实读取状态或未完成门禁检查，不得表述为“已确认可推进”

## 关键阶段前置自检

以下阶段除遵守 `AGENTS.md` 外，还应执行各自 skill 内的最小前置检查：

- `page`
- `prd`
- `rev`
- `fix`

## 产物目录约定

所有产物生成在项目的 `docs/` 目录下，按类型分子目录：

```text
docs/
  briefs/
  mindmaps/
  feature-lists/
  page-structures/
  prd/
  prototypes/
  prototype-annotations/
  review-meetings/
  fix-records/
```

## 状态文件

`docs/project-status.json` 记录当前阶段、稳定锚点和待处理事项。不存在时代表当前项目尚未初始化。
