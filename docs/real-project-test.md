# 真实项目测试

## 测试口径

默认入口为：

- 自然语言
- 或短命令 `/start /sum /mind /feat /page /prd /mock /rev /fix /note`

## 最小全链路

```text
/start
老板让我做一个供应商准入审批流程，采购部提需求，财务部审批，通过后自动建档。
继续下一步
/feat
/page
/prd
/rev
我刚手改了 PRD，帮我判断要不要回写
/mock
/note
```

## 检查项

- `docs/project-status.json` 已创建
- 自然语言能路由到 `scope`
- `/feat /page /prd /rev /fix /mock /note` 能进入正确阶段
- `page / prd / rev / fix` 前置自检有效
- 不再需要 `/pm-go`
