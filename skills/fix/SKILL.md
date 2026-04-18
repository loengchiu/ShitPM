---
name: fix
description: "在已确认的产物变更后做版本关系判定、回写建议、稳定锚点修正与修正留痕。"
---

# PM FIX

## 输入

1. 用户显式给出的当前变更产物路径
2. `docs/project-status.json` 中与该产物对应的稳定基线
3. 项目目录扫描得到的候选产物

前置检查遵循 `contracts/stage-gates.md`；`fix` 目标是否允许继续处理，再按 `fix-processing-rules.md` 判定。

## 输出

- 输出版本关系、影响层级、回写建议和推荐下一动作
- 如本轮已自动改动其他生成物，生成修正记录并写入 `docs/fix-records/`
- 状态更新遵循 `contracts/workflow-state.md`

## 规则来源

前置检查前读取：
1. `contracts/stage-gates.md`

处理前读取：
1. `contracts/fix-processing-rules.md`

输出与状态更新前读取：
1. `contracts/fix-output-checklist.md`
2. `contracts/error-handling.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取输入与稳定基线
2. 读取处理规则
3. 完成判定与影响分析
4. 如需生成修正记录，先基于模板填写，再清理占位字段、空项和示例值
5. 读取输出检查清单
6. 输出结论并更新状态
