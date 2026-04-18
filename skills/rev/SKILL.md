---
name: rev
description: "对 Mindmap、Feature List、Page Structure 和 PRD 做分层评审与跨产物评审，并给出回写与回退建议。支持 AI 自检模式与多角色评审会模式。"
---

# PM RV

## 输入

- 用户显式给出的当前文件路径
- `stable_baselines`
- 目录扫描结果
- 前置检查遵循 `contracts/stage-gates.md`

## 输出

- 输出评审结论、回写建议、回退建议与下一步动作
- 写入 `docs/review-meetings/YYYY-MM-DD_review-<topic>.md`
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

评审前读取：
1. `contracts/rev-review-rules.md`

输出与状态更新前读取：
1. `contracts/rev-output-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与评审对象
2. 读取评审规则
3. 完成评审、定性与回写判定
4. 读取输出检查清单
5. 输出结论并更新状态
