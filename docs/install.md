# 安装说明

## 快速安装（推荐）

在 ShitPM 项目目录执行一条命令，安装脚本会自动探测当前机器已安装的 AI 工具，一次完成所有宿主的安装：

```powershell
powershell -File .\installers\install.ps1
```

安装完成后会输出每个宿主的安装结果，`ok` 表示成功。

## 自动探测逻辑

安装脚本会探测以下目录是否存在：

| 宿主 | 探测目录 |
| --- | --- |
| GitHub Copilot | `~/.copilot` |
| Codex | `~/.agents` |
| Cursor | `~/.cursor` |
| Windsurf | `~/.windsurf` |
| Trae | `~/.trae` |
| Antigravity | `~/.gemini/antigravity` |

存在哪个就安装哪个，不存在的跳过。

## 手动指定宿主

如果需要只安装某一个宿主：

```powershell
# 只安装 Copilot
powershell -File .\installers\install.ps1 -Hosts copilot

# 只安装 Cursor
powershell -File .\installers\install.ps1 -Hosts cursor

# 指定多个
powershell -File .\installers\install.ps1 -Hosts copilot,cursor
```

## 单宿主安装器（高级）

Copilot 和 Codex 有独立的安装器，直接调用：

```powershell
powershell -File .\installers\copilot\install.ps1
powershell -File .\installers\codex\install.ps1
```

## 校验

一键安装自带校验。如需单独校验：

```powershell
# Copilot
powershell -File .\installers\copilot\verify.ps1

# Codex
powershell -File .\installers\codex\verify.ps1
```

## 卸载

```powershell
powershell -File .\installers\uninstall.ps1
```

同样支持 `-Hosts` 参数指定单个宿主卸载。

## 安装动作说明

- 清理旧 PM 扩展遗留的长技能名映射
- 为每个宿主创建 skills junction，指向 ShitPM 源目录
- 安装共享目录：`shitpm-commands`、`shitpm-templates`、`shitpm-contracts`
- 自动 verify 校验

稳定入口始终是短技能名：`pm-go / pm-prd / pm-rv` 等。

## 在工作项目中启用 ShitPM（VSCode Copilot）

VSCode Copilot 支持项目级指令文件 `.github/copilot-instructions.md`，可告知 AI 当前项目使用 ShitPM。

将 `templates/copilot-instructions.md` 复制到工作项目的 `.github/` 目录：

```powershell
New-Item -ItemType Directory -Force -Path '<工作项目>\.github'
Copy-Item '.\templates\copilot-instructions.md' '<工作项目>\.github\copilot-instructions.md'
```

配置后，Copilot 在该项目中会感知 ShitPM 的存在，遇到 PM 任务时自动从 `pm-go` 进入。
