# Mac 快速启动指南（给 0 基础同学）

## 前置要求
- macOS 13+
- Xcode 15+
- 已安装 Homebrew

## 步骤 1：安装命令行工具
```bash
xcode-select --install
```

## 步骤 2：进入项目目录
```bash
cd /你的本地路径/MoFang-IOS
```

## 步骤 3：一键生成并打开工程
```bash
make mac-setup
```

## 步骤 4：运行
1. 在 Xcode 顶部选择一个 iPhone 模拟器（例如 iPhone 15）。
2. 点击左上角 Run（▶）。
3. 看到 3D 魔方即可开始测试。

## 遇到报错怎么办
- 报签名错误：
  - 进入 `Target -> Signing & Capabilities`
  - 勾选 `Automatically manage signing`
  - 选择你的 Apple ID 团队
- 报 xcodegen 不存在：
  - 执行 `brew install xcodegen`

## 你现在可以做什么
- 点按钮执行 R/L/U/D/F/B 转动。
- 点“随机打乱”练习。
- 点“复位”恢复初始状态。
