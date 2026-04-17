# 使用说明

## 默认入口

- 自然语言
- 或短命令：`/start /sum /mind /feat /page /prd /mock /rev /fix /note`

## 推荐口径

- 新项目先 `/start`
- 之后直接说需求
- 想进入明确阶段时再用短命令

## 示例

### 新需求

```text
老板让我做一个供应商准入审批流程
```

### 继续推进

```text
继续下一步
```

### 进入具体阶段

```text
/feat
/page
/prd
/rev
```

### 手工改稿后判断回写

```text
我刚手改了 PRD，帮我判断要不要回写
```

## 状态与门禁

- 当前阶段保存在 `docs/project-status.json`
- 从 `page` 开始，推进前检查阻塞项、待确认项和稳定锚点
