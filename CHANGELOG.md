# Changelog

## 0.2.0-alpha

### 重构与清理
- **与 Superpowers 框架完全解耦**：移除全项目所有 Superpowers 相关引用、描述与配置项
- **删除** `scripts/detect-superpowers.ps1`，替换为通用的 `scripts/detect-hosts.ps1`
- **移除"头脑风暴自动桥接"功能**：从各 SKILL.md 中清除该实验性特性，降低不可控发散风险

### 新功能
- **多宿主环境探测**（`detect-hosts.ps1`）：支持自动识别 GitHub Copilot、Cursor、Windsurf、Codex、Trae 等主流 AI IDE 工作环境
- **快速安装方案（方向1）**：提供无需 AI 辅助的纯脚本化快速部署路径，降低上手门槛
- **会话上下文持久化**：新增 `docs/pm-context.md` 机制，将 AI 会话关键上下文写入项目目录，跨会话恢复工作现场

### 优化
- **README 全面重写**：准确描述 ShitPM 的定位、核心特性与各指令职责，移除过时表述
- **VSCode Copilot 兼容性提升**：针对 VSCode Copilot 宿主环境做系列适配，提升技能注册与调用稳定性
- **安装文档更新**（`docs/install.md`）：补充快速安装方案说明与多平台操作步骤

---

## 0.1.0-alpha

- 初始化 `ShitPM` 项目骨架
- 建立 `pm-go` 主入口与内置范围探索规则
- 建立 `pm-mm / pm-fl / pm-ps / pm-prd / pm-rv / pm-fix` 首发主链
- 建立 `pm-pt / pm-pa` 第二期能力
- 建立工作流契约、状态契约与稳定锚点机制
- 建立 Copilot / Codex 安装器、卸载器与 verify 脚本
- 建立真实项目测试手册、安装说明与发布检查表
