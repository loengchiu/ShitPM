# ShitPM 安装指令（供 AI 执行）

你正在为用户安装 ShitPM。请按以下步骤执行：

## 1. 克隆仓库

将 ShitPM 克隆到用户主目录下的 `ShitPM` 文件夹。

- macOS/Linux：`~/ShitPM`
- Windows：`%USERPROFILE%\\ShitPM`

## 2. 创建全局规则文件

将 `{SHITPM_PATH}` 替换为实际的 ShitPM 安装路径。  
将 `{USER_HOME}` 替换为用户主目录路径。

### VS Code Copilot

创建文件：`{USER_HOME}/.copilot/instructions/shitpm-global.instructions.md`  
如果 `.copilot/instructions` 目录不存在，先创建。

内容：

```md
---
applyTo: "**"
---
# ShitPM 全局规则

如果当前项目根目录存在 docs/project-status.json，
请读取 {SHITPM_PATH}/AGENTS.md 并严格遵循其中的所有规则。
如果不存在 docs/project-status.json，忽略本规则，不执行任何 ShitPM 相关操作。
```

### Cursor

创建文件：`{USER_HOME}/.claude/CLAUDE.md`  
如果该文件已存在，在文件末尾追加以下内容（不要覆盖已有内容）。  
如果不存在，直接创建。

追加内容：

```md
# ShitPM 全局规则

如果当前项目根目录存在 docs/project-status.json，
请读取 {SHITPM_PATH}/AGENTS.md 并严格遵循其中的所有规则。
如果不存在 docs/project-status.json，忽略本规则，不执行任何 ShitPM 相关操作。
```

### Codex

创建文件：`{USER_HOME}/.codex/AGENTS.md`  
如果该文件已存在，在文件末尾追加以下内容（不要覆盖已有内容）。  
如果不存在，直接创建。

追加内容：

```md
# ShitPM 全局规则

如果当前项目根目录存在 docs/project-status.json，
请读取 {SHITPM_PATH}/AGENTS.md 并严格遵循其中的所有规则。
如果不存在 docs/project-status.json，忽略本规则，不执行任何 ShitPM 相关操作。
```

### Antigravity

创建文件：`{USER_HOME}/.antigravity/rules/shitpm-global.md`  
如果 `.antigravity/rules` 目录不存在，先创建。

内容同 VS Code Copilot 的规则内容。

### Trae

创建文件：`{USER_HOME}/.trae/rules/shitpm-global.md`
如果 `.trae/rules` 目录不存在，先创建。

内容：

```md
---
alwaysApply: true
---
# ShitPM 全局规则

如果当前项目根目录存在 docs/project-status.json，
请读取 {SHITPM_PATH}/AGENTS.md 并严格遵循其中的所有规则。
如果不存在 docs/project-status.json，忽略本规则，不执行任何 ShitPM 相关操作。
```

### Trae CN

创建文件：`{USER_HOME}/.trae-cn/rules/shitpm-global.md`
如果 `.trae-cn/rules` 目录不存在，先创建。

内容：

```md
---
alwaysApply: true
---
# ShitPM 全局规则

如果当前项目根目录存在 docs/project-status.json，
请读取 {SHITPM_PATH}/AGENTS.md 并严格遵循其中的所有规则。
如果不存在 docs/project-status.json，忽略本规则，不执行任何 ShitPM 相关操作。
```

## 3. 完成后告知用户

```text
ShitPM 已安装完成。
- 安装路径：{SHITPM_PATH}
- 已配置全局规则的 IDE：VS Code Copilot、Cursor、Codex、Antigravity、Trae、Trae CN
- 使用方式：打开任何项目，输入'初始化 ShitPM'即可开始使用。
```
