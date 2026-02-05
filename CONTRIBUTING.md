# Contributing

欢迎共建 MoFang-IOS。

## 分支策略
- `main`：稳定分支
- `feature/*`：功能分支
- `fix/*`：修复分支

## 提交流程
1. 提交 Issue 说明问题/需求。
2. 新建分支开发。
3. 提交 PR，填写模板并附验证说明。

## 本地开发（Mac）
- 推荐使用：`make mac-setup`
- 该命令会调用 `scripts/setup_mac.sh`，自动安装/检查 xcodegen 并生成工程。

## 代码约定
- 保持模块职责清晰（UI、Core 分离）。
- 关键逻辑写中文注释，解释“为什么这样做”。
- 小步提交，提交信息清晰表达目的。

## 建议的 Commit 前检查
- 能编译通过（Xcode Run 成功）。
- 关键流程可操作（转动、打乱、复位）。
- 文档同步更新。
