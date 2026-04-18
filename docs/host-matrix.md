# 宿主支持矩阵

| 宿主 | 是否支持 | 安装方式 | 探测目录 | 备注 |
| --- | --- | --- | --- | --- |
| GitHub Copilot | 是 | 自动/单装 | `~/.copilot` | 主线 |
| Codex | 是 | 自动/单装 | `~/.codex`（兼容 `~/.agents`） | 主线；需同时暴露 `shitpm` bundle 与宿主根 `skills` |
| Antigravity | 是 | 自动（通用 junction） | `~/.gemini/antigravity` | 首发支持 |
| Cursor | 部分 | 自动（通用 junction） | `~/.cursor` | 待验证规则加载机制 |
| Windsurf | 部分 | 自动（通用 junction） | `~/.windsurf` | 待验证 |
| Trae | 是 | 自动/单装 | `~/.trae` | 规则文件注入 |
| Trae CN | 是 | 自动/单装 | `~/.trae-cn` | 规则文件注入；需同时暴露 `shitpm` bundle 与宿主根 `skills` |

## 宿主最小要求

- 宿主需能暴露短技能名
- 宿主需允许映射完整 `shitpm` 目录树
- 对依赖宿主根短技能名的宿主，还需在宿主根下暴露 `skills/<stage>`
- bundle 位于宿主根目录下，例如 `.agents/shitpm`、`.codex/shitpm`、`.copilot/shitpm`
- skill 中出现的 `shitpm/...` 路径均应按宿主根目录解析，不按当前项目工作区解析
