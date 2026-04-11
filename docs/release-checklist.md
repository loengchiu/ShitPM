# 发布检查表

在打包和发布新版本之前，按顺序完成以下所有检查项。

## 1. 版本与变更记录

- [ ] `VERSION` 文件已更新为新版本号（格式：`x.y.z` 或 `x.y.z-alpha`）
- [ ] `CHANGELOG.md` 已补充本次版本的变更说明
- [ ] `README.md` 中版本相关描述已同步更新（如有）

## 2. 代码质量

- [ ] `scripts\smoke-test.ps1` 执行通过（Exit Code 0）

  ```powershell
  powershell -File .\scripts\smoke-test.ps1
  ```

- [ ] `scripts\_check-links.ps1` 执行通过（Exit Code 0）

  ```powershell
  powershell -File .\scripts\_check-links.ps1
  ```

- [ ] 已搜索所有文件，确认无 Superpowers、detect-superpowers 等废弃关键词残留

## 3. 安装器验证

- [ ] Copilot 安装器可正常运行：

  ```powershell
  powershell -File .\installers\copilot\install.ps1
  powershell -File .\installers\copilot\verify.ps1
  ```

- [ ] Codex 安装器可正常运行：

  ```powershell
  powershell -File .\installers\codex\install.ps1
  powershell -File .\installers\codex\verify.ps1
  ```

- [ ] 通用安装器探测逻辑正常：

  ```powershell
  powershell -File .\installers\install.ps1
  ```

## 4. 打包测试

- [ ] 打包脚本可正常执行，生成 `dist/ShitPM-<version>.zip`：

  ```powershell
  powershell -File .\scripts\package-release.ps1
  ```

- [ ] 检查 zip 包，确认 `dist/` 和 `.git/` 目录未被包含
- [ ] 解压后可在全新目录执行安装器

## 5. 文档完整性

- [ ] `docs\install.md` 安装步骤与当前安装脚本行为一致
- [ ] `docs\usage.md` 指令列表与 `commands/` 目录匹配
- [ ] `docs\troubleshooting.md` 常见问题已覆盖

## 6. 发布

- [ ] 提交所有变更，版本 tag 已打：`git tag v<version>`
- [ ] 将 zip 包上传至发布渠道

---

所有检查项完成后方可发布。
# 发布检查表

## 一、结构检查

- `scripts/smoke-test.ps1` 返回结构校验通过
- `skills/` 仅暴露公开短技能：
  - `pm-go`
  - `pm-mm`
  - `pm-fl`
  - `pm-ps`
  - `pm-prd`
  - `pm-rv`
  - `pm-fix`
  - `pm-pt`
  - `pm-pa`
- `commands/` 与技能短名一致
- 宿主已映射 `shitpm-commands`
- `templates/`、`contracts/`、`docs/` 齐全

## 二、规则检查

- `pm-go` 已包含：
  - 范围判定
  - 阶段判定
  - PRD 规模判定
  - 锚点优先级
- `pm-prd` 已包含：
  - 双锚点规则
  - 内容来源优先级
  - PRD 分块规则
  - 数据规范
  - 界面承载说明
- `pm-fix` 已包含：
  - 当前 PRD 路径优先
  - 版本关系判定
  - 回写判定
- `pm-pt` 已包含原型与视觉基线规则
- `pm-pa` 已包含交互标注与增量更新规则

## 三、安装器检查

- `installers/copilot/install.ps1` 可运行
- `installers/copilot/verify.ps1` 返回 `verify:ok`
- `installers/codex/install.ps1` 可运行
- `installers/codex/verify.ps1` 返回 `verify:ok`
- uninstall 只卸载 `ShitPM`

## 四、文档检查

- `README.md`
- `docs/whitepaper.md`
- `docs/install.md`
- `docs/usage.md`
- `docs/troubleshooting.md`
- `docs/host-matrix.md`
- `docs/real-project-test.md`
- `templates/prototype-visual-baseline.md`
- `templates/prototype-annotation.md`

## 五、真实项目前检查

- ShitPM 已安装
- 宿主可见 `pm-go`
- 真实项目中存在 `docs/` 目录

## 六、发布前动作

- 更新 `VERSION`
- 更新 `CHANGELOG.md`
- 如需产出发布包，再运行打包脚本
- 如已产出发布包，再检查输出目录中的文件完整性
