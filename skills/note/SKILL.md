---
name: note
description: "在稳定版 PRD 与 HTML 原型上构建可交互需求标注层，让研发通过页面浮窗即可获得完整开发指令。"
---

# PM PA

## 输入

- 稳定版 PRD
- 稳定版 Prototype HTML
- 用户明确指令：初始化标注，或增量更新
- 前置检查遵循 `contracts/stage-gates.md`

## 输出

- 写入 `docs/prototype-annotations/`
- 如要求编号回写，同步更新对应 PRD

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

处理前读取：
1. `contracts/note-processing-rules.md`

输出与状态更新前读取：
1. `contracts/note-output-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入并判定初始化或增量更新
2. 读取处理规则
3. 生成或更新标注层
4. 读取输出检查清单
5. 输出结果并更新状态

