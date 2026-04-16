# 安装说明

## 快速安装

在 ShitPM 仓库目录执行：

```powershell
powershell -File .\installers\install.ps1
```

## 安装结果

安装器会：

- 连接宿主的 `skills / commands / templates / contracts`
- 校验宿主映射
- 使宿主能够在已初始化项目中读取 `AGENTS.md`

## 项目启用

在业务项目里执行：

```text
/init
```

系统会创建 `docs/project-status.json`，从此该项目进入 ShitPM 工作流。

## 入口

安装完成后，公开入口为：

`/init /sum /mind /feat /page /prd /mock /rev /fix /note`

也支持直接自然语言。
