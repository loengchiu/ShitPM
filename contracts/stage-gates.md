# Stage Gates

主链：`scope -> sum -> mind -> feat -> page -> prd -> rev -> mock -> note`

## Runtime 校验

进入每个阶段前，可执行：

```powershell
.\scripts\stage-gate.ps1 -Target prd
```

## 软阶段

`scope / sum / mind / feat` 为软阶段，无强制文件前置，直接放行。

## 强制门禁

从 `page` 开始：

1. `blockers` 必须为空
2. `pending_confirmations` 必须为空
3. 所需 `stable_baselines` 必须存在
4. 锚点文件必须真实存在

## 阶段前置

- `scope`：已有项目目录和当前任务描述
- `sum`：范围判定已完成
- `mind`：分析简报已足以支撑结构化表达
- `feat`：需求已清晰到足以形成能力清单
- `page`：功能清单已稳定
- `prd`：功能清单与页面结构已稳定
- `rev`：当前评审对象已形成可评审版本
- `mock`：PRD 已稳定
- `note`：PRD 与 Prototype 已形成稳定组合
