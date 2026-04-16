# 故障排查

## 1. `/init` 没生效

检查：

- 当前会话是否绑定到正确项目目录
- 当前项目下是否生成 `docs/project-status.json`

## 2. 短命令看不到

检查：

- 宿主是否已安装 ShitPM
- `scripts/verify-mappings.ps1` 是否通过

## 3. 不能继续推进

检查：

- `blockers`
- `pending_confirmations`
- `stable_baselines`
- 锚点文件是否真实存在

## 4. 评审或修复阶段被阻止

`page / prd / rev / fix` 除全局路由外，还保留各自的最小前置自检。

## 5. 旧项目阶段名还是 `pm-*`

执行：

```powershell
powershell -File .\scripts\migrate-stage-names.ps1
```
