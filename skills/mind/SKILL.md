---
name: mind
description: "基于项目简报生成并迭代思维导图，沉淀范围、主流程、模块、结构、待澄清问题和修订结果，作为功能清单前的结构化事实层。"
---

# PM 思维导图

## 输入

按以下优先级读取：

1. 稳定项目简报
2. 二次访谈补充与修正
3. 来源材料补充说明
4. 当前思维导图版本
5. 当前稳定锚点与最新产物
6. 前置检查遵循 `contracts/stage-gates.md`

## 输出

将思维导图产物写入工作项目的 `docs/mindmaps/` 目录。

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

生成前读取：
1. `contracts/mind-generation-rules.md`
2. `contracts/host-contract.md`

自审与状态更新前读取：
1. `contracts/mind-review-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与导图模板
2. 读取生成规则
3. 基于模板生成导图或按模块分块生成
4. 在保存前清理模板示例节点、空分支和教学说明
5. 读取自审规则
6. 执行自审并更新状态

