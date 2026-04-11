# 宿主支持矩阵

| 宿主 | 是否支持 | 安装方式 | 探测目录 | 备注 |
| --- | --- | --- | --- | --- |
| GitHub Copilot | 是 | 自动/单装 | `~/.copilot` | 主线 |
| Codex | 是 | 自动/单装 | `~/.agents` | 主线 |
| Antigravity | 是 | 自动（通用 junction） | `~/.gemini/antigravity` | 首发支持 |
| Cursor | 部分 | 自动（通用 junction） | `~/.cursor` | 待验证规则加载机制 |
| Windsurf | 部分 | 自动（通用 junction） | `~/.windsurf` | 待验证 |
| Trae | 待定 | 待定 | `~/.trae` | 单独评估 |

## 宿主最小要求

- 宿主需能暴露短技能名
- 宿主需允许共享 `shitpm-templates` 与 `shitpm-contracts`
