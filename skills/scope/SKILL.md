---
name: scope
description: "ShitPM 内置范围探索能力。用于先读上下文、一问一答澄清目标、判断范围、拆分子项目并形成轻量项目简介。"
---

# PM Scope

## 输入

- 当前项目目录与已有上下文
- 用户本轮目标描述
- 已有材料与参考文档
- 如存在，当前 `docs/project-status.json`

## 执行顺序

1. 读取现有上下文
2. 先判断任务是否明显过大、是否应拆分
3. 信息不足时逐轮澄清
4. 形成范围结论或拆分方案
5. 用户确认后返回统一路由入口

## 输出

- 输出范围结论、拆分建议、当前优先子项目与下一步动作
- 如本轮补齐轻量项目简介，可写入 `docs/briefs/`
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

处理前读取：
1. `contracts/scope-processing-rules.md`

输出与状态更新前读取：
1. `contracts/scope-output-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

