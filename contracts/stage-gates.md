# Stage Gates

主链：
`pm-go -> pm-scope -> pm-mm -> pm-fl -> pm-ps -> pm-prd -> pm-rv -> pm-pt -> pm-pa`

## Runtime 校验

进入每个阶段前，可执行 `stage-gate.ps1` 进行前置条件的运行时校验：

```powershell
# 示例：校验是否满足进入 pm-prd 的前置条件
.\scripts\stage-gate.ps1 -Target pm-prd
```

校验通过（exit 0）后模型再开始生成。校验失败（exit 1）时输出阻塞原因，不进入该阶段。

**强制门禁内容（所有有状态阶段均适用）：**

1. `blockers` 非空时直接阻止，并列出每条阻塞文本
2. `pending_confirmations` 非空时直接阻止，并列出每条待确认文本
3. 对应上游产物的稳定版文件必须在磁盘上实际存在

`pm-go / pm-scope / pm-mm / pm-fl` 为软阶段，无强制文件前置，直接放行。

## 门禁

- `pm-scope` 前：已有项目目录和当前任务描述
- `pm-mm` 前：范围判定已完成，如项目仍缺少基础总览，应先形成轻量项目简介
- `pm-fl` 前：需求结构应已清晰到足以形成能力清单
- `pm-ps` 前：功能清单应已稳定，且未再频繁变动能力边界
- `pm-prd` 前：功能清单与页面清单都应稳定，且功能清单中的模块角色与版本边界已足以支撑 PRD 落位
- `pm-rv` 前：当前 PRD 应已形成可评审版本，并完成版本判定
- `pm-pt` 前：PRD 应已形成稳定版，且页面承载信息足以支撑原型页面与关键区域映射
- `pm-pa` 前：PRD 与 Prototype 应已形成稳定组合

## 回退

- 能力边界问题：回退 `pm-fl`
- 页面承载问题：回退 `pm-ps`
- 执行规格问题：留在 `pm-prd`
- 表现层问题：留在 `pm-pt`
- 标注层问题：留在 `pm-pa`
