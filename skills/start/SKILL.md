---
name: start
description: "在当前项目初始化 ShitPM：创建 docs/project-status.json 并写入初始状态。"
---

# PM Start

## 输入

- 当前项目目录
- 用户是否明确要求重置初始化状态

## 输出

- 确保 `docs/` 目录存在
- 生成 `docs/project-status.json`
- 提示下一步进入 `scope` 或使用短命令进入明确阶段

## 规则来源

处理前读取：
1. `contracts/start-processing-rules.md`
2. `contracts/host-contract.md`
3. `contracts/workflow-state.md`

## 执行顺序

1. 读取初始化规则与状态契约
2. 检查是否已初始化
3. 生成状态文件
4. 输出下一步提示
