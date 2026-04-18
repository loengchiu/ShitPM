# Start Processing Rules

用于 `start` 阶段的初始化规则。

## 初始化规则

- 若 `docs/project-status.json` 已存在，视为已初始化，不重复覆盖，除非用户明确要求重置
- 写入内容必须符合 `contracts/workflow-state.md`
- 宿主映射解析遵循 `contracts/host-contract.md`
- 默认将 `current_stage` 设为 `scope`

## 输出

- 确保 `docs/` 目录存在
- 生成 `docs/project-status.json`
- 初始化完成后，提示用户可直接进入 `scope` 或使用短命令进入明确阶段
