---
name: sum
description: "把范围澄清后的材料整理为可进入思维导图的项目简报，沉淀项目总览、资料分析结论、关键流程文字版、补充修正与留痕。"
---

# PM Analysis

## 输入

按以下优先级读取：
1. 当前项目目录与已有上下文
2. 范围澄清结论
3. 来源材料索引
4. 会议纪要
5. 原始需求点、补充说明与参考材料
6. 如存在，二次访谈或补充澄清信息
7. 当前稳定锚点与最新产物
8. 前置检查遵循 `contracts/stage-gates.md`

## 输出

将项目简报写入工作项目的 `docs/briefs/` 目录。

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

生成前读取：
1. `contracts/sum-generation-rules.md`
2. `contracts/host-contract.md`
3. `contracts/artifact-schema.md`

自审与状态更新前读取：
1. `contracts/sum-review-checklist.md`
2. `contracts/done-criteria.md`
3. `contracts/error-handling.md`
4. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与简报模板
2. 必要时先处理长材料缓存
3. 读取生成规则并生成项目简报
4. 读取自审规则
5. 执行自审并更新状态

