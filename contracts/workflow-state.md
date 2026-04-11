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

## 写入时机

每个 Skill 执行完毕后，**必须输出最新的 `project-status.json` 完整内容**（或明确标出变更字段），同步更新：

- `current_stage`：改为本轮实际到达的阶段
- `last_action`：改为本轮实际完成的动作
- `next_recommended`：改为本轮推荐的下一步
- `context_summary`：如有重大进展则更新摘要
- `latest_artifacts`：将本轮产物路径写入对应字段
- `stable_baselines`：如本轮产物已被用户确认为稳定版，写入对应锚点路径
- `blockers` / `pending_confirmations`：如本轮新增或解决了阻塞/待确认项，同步变更

**写入格式要求：** 输出时以代码块包裹完整 JSON，标题为 `project-status.json 更新`，方便用户直接保存。
