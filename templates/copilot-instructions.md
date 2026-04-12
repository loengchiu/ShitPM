# Copilot 项目指令

本项目使用 **ShitPM** 进行 PM 工作流管理。

## 遇到 PM 相关任务时

- 所有 PM 工作统一从 `pm-go` 进入，不要跳过主入口直接进入子技能
- 每次进入 `pm-go` 时，先运行 `.\scripts\status-read.ps1` 读取当前状态（如文件存在），恢复项目上下文后再继续
- 进入任何阶段前，建议先运行 `.\scripts\stage-gate.ps1 -Target <skill>` 校验前置条件
- 每个技能执行完毕后，必须输出一个可直接运行的 `.\scripts\status-write.ps1` 调用块，只包含本轮实际变更的字段

## 当前可用技能

| 技能 | 作用 |
| --- | --- |
| `pm-go` | 总入口，识别阶段、编排主链 |
| `pm-mm` | 生成思维导图 |
| `pm-fl` | 生成功能清单 |
| `pm-ps` | 生成页面清单 |
| `pm-prd` | 生成 PRD |
| `pm-rv` | 评审产物 |
| `pm-fix` | 人工改稿后判定影响范围 |
| `pm-pt` | 生成原型 |
| `pm-pa` | 生成注释原型 |

## 产物目录约定

所有产物生成在项目的 `docs/` 目录下，按类型分子目录：

```
docs/
  briefs/
  mindmaps/
  feature-lists/
  page-structures/
  prd/
  prototypes/
  prototype-annotations/
  reviews/
```

## 状态文件

`docs/project-status.json` 记录当前项目阶段、稳定锚点和待处理事项。不存在时代表新项目。
