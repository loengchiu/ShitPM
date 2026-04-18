---
name: page
description: "基于稳定功能清单生成页面与区域结构，作为页面锚点。"
---

# PM PS

## 输入

- 稳定功能清单
- 思维导图中的业务闭环信息
- 当前稳定锚点（如存在）
- 前置检查遵循 `contracts/stage-gates.md`

## 输出

- 将页面结构写入工作项目对应目录
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

生成前读取：
1. `contracts/page-generation-rules.md`

自审与状态更新前读取：
1. `contracts/page-review-checklist.md`
2. `contracts/done-criteria.md`
3. `contracts/error-handling.md`
4. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与稳定锚点
2. 读取生成规则
3. 先基于模板搭页面与区域骨架
4. 生成页面结构
5. 在保存前执行一次成稿清洗，删除占位页面、占位区域、示例关系项和教学说明
6. 读取自审规则
7. 执行自审与状态更新
