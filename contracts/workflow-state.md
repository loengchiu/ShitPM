# Workflow State

项目状态文件路径：

- `docs/project-status.json`

## 最小结构

```json
{
  "current_stage": "",
  "last_action": "",
  "next_recommended": "",
  "context_summary": "",
  "stable_baselines": {
    "feature_list": "",
    "page_structure": "",
    "prd": "",
    "prototype": "",
    "visual_baseline": ""
  },
  "scope_decomposition": {
    "required": false,
    "reason": "",
    "subprojects": []
  },
  "prd_partition": {
    "required": false,
    "reason": "",
    "units": []
  },
  "latest_artifacts": {
    "briefs": [],
    "mindmap": "",
    "feature_list": "",
    "page_structure": "",
    "prd": "",
    "prototypes": [],
    "prototype_annotations": []
  },
  "blockers": [],
  "pending_confirmations": []
}
```

## 字段说明

| 字段 | 说明 |
| --- | --- |
| `current_stage` | 当前所处 PM 阶段，如 `pm-fl` / `pm-prd` / `pm-rv` |
| `last_action` | 上一轮实际完成的动作，一句话描述，如"完成 PRD v2 分块写作" |
| `next_recommended` | 本轮结束时推荐的下一步，如"执行 pm-rv 进行评审" |
| `context_summary` | 项目摘要，用于新对话恢复上下文，100字以内，描述项目目标、当前进展和待处理事项 |

## 规则

1. 用户显式给出的当前文件路径优先于 `stable_baselines`
2. 新版本确认替代旧版本后，必须刷新对应 `stable_baselines`
3. 下游生成时禁止新旧版本混用
4. 若版本关系未判清，必须停止推进
5. PRD 分块生成时，必须记录 `prd_partition`
6. Prototype 进入稳定版后，刷新 `stable_baselines.prototype`
7. 视觉基线形成后，刷新 `stable_baselines.visual_baseline`
8. **`stable_baselines` 写入约束**：`-BaselinePath` 指向的文件必须已存在于磁盘。`status-write.ps1` 在写入 `stable_baselines` 前会强制校验，文件不存在时直接报错退出（exit 1）且不落盘，防止状态污染。
9. **blockers / pending_confirmations 约束**：存在未清除的阻塞项或待确认项时，`stage-gate.ps1` 对所有有状态阶段（pm-ps 及以后）均直接阻止推进，并输出每条具体内容。

## 写入时机

每个 Skill 执行完毕后，**必须输出最新的 `project-status.json` 完整内容**（或明确标出变更字段），同步更新：

- `current_stage`：改为本轮实际到达的阶段
- `last_action`：改为本轮实际完成的动作
- `next_recommended`：改为本轮推荐的下一步
- `context_summary`：如有重大进展则更新摘要
- `latest_artifacts`：将本轮产物路径写入对应字段
- `stable_baselines`：如本轮产物已被用户确认为稳定版，写入对应锚点路径
- `blockers` / `pending_confirmations`：如本轮新增或解决了阻塞/待确认项，同步变更

**写入格式要求：** 每个 Skill 执行完毕后，输出一个可直接运行的 `status-write.ps1` 调用块（而非整段 JSON），由用户执行后落盘。只需写明本轮实际变更的字段，未变更字段不传参。

示例：

```powershell
# 在项目根目录执行
.\scripts\status-write.ps1 `
  -Stage        "pm-fl" `
  -LastAction   "完成功能清单 v1" `
  -NextRecommended "执行 pm-ps" `
  -ContextSummary  "客服工单系统，FL v1 完成，待 PS" `
  -ArtifactField   "feature_list" `
  -ArtifactPath    "docs/feature-lists/2026-04-12_fl-v1.md"

# 若本轮产物已被用户确认为稳定版，追加一条 baseline 写入：
.\scripts\status-write.ps1 `
  -BaselineField "feature_list" `
  -BaselinePath  "docs/feature-lists/2026-04-12_fl-v1.md"
```

> `status-write.ps1` 执行 patch 写入，只覆盖传入的字段，不影响其余字段。
> `status-read.ps1` 可随时读取当前状态或单个字段（例：`.\scripts\status-read.ps1 -Field stable_baselines`）。
