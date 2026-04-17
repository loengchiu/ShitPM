---
name: start
description: "在当前项目初始化 ShitPM：创建 docs/project-status.json 并写入初始状态。"
---

# PM Start

## 目标

在当前项目中创建 `docs/project-status.json`，作为 ShitPM 工作流的激活开关和状态源。

## 规则

- 若 `docs/project-status.json` 已存在，视为已初始化，不重复覆盖（除非用户明确要求重置）。
- 写入的 JSON 必须符合 `contracts/workflow-state.md` 的最小结构。
- 默认把 `current_stage` 设为 `scope`，以便后续自然语言描述可直接进入范围探索。

## 输出

1. 确保 `docs/` 目录存在
2. 生成 `docs/project-status.json`

## 初始化模板

```json
{
  "current_stage": "scope",
  "last_action": "初始化 ShitPM",
  "next_recommended": "scope",
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
    "fix_records": [],
    "reviews": [],
    "prototypes": [],
    "prototype_annotations": []
  },
  "blockers": [],
  "pending_confirmations": []
}
```

## 状态更新

初始化完成后，提示用户下一步直接用自然语言描述需求（将路由到 `scope`），或使用短命令进入明确阶段（如 `/sum`）。
