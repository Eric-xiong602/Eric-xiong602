# MoFang-IOS

一个面向 iOS 的 3D 魔方小游戏（SwiftUI + SceneKit）。

## 你是新手？先看这里（Mac 5 分钟跑起来）
> 你只需要会复制命令。

1. 安装 Xcode（App Store）并首次打开一次。  
2. 打开终端，进入仓库目录：
   ```bash
   cd /你的路径/MoFang-IOS
   ```
3. 执行一键脚本：
   ```bash
   make mac-setup
   ```
4. Xcode 会自动打开 `MoFang-IOS.xcodeproj`，选择一个 iPhone 模拟器后点 Run（▶）。

如果你不想自动打开 Xcode，只想先生成工程：
```bash
make generate-project
```

---

## 项目目标
- 在 iPhone / iPad 上提供流畅、可交互的 3D 魔方体验。
- 提供基础打乱、复位、标准转动（R/L/U/D/F/B）功能。
- 为后续加入计时、教学、复盘、算法提示打好结构基础。

## 当前功能（MVP）
- 3D 视图展示 3x3x3 魔方。
- 支持标准单步转动：`R L U D F B`。
- 支持随机打乱与复位。
- 使用 SceneKit 驱动 3D 动画。

## 代码结构
- `MoFang-IOS/App`：应用入口与主界面。
- `MoFang-IOS/Core`：魔方状态、旋转规则与动画调度。
- `MoFang-IOS/UI`：SceneKit 与 SwiftUI 的桥接。
- `MoFang-IOS/Resources`：App 基础资源（如 `Info.plist`）。
- `scripts/setup_mac.sh`：Mac 一键初始化脚本（安装 xcodegen + 生成工程 + 打开 Xcode）。
- `project.yml`：xcodegen 的工程定义文件。
- `docs/ROADMAP.md`：阶段规划与里程碑。

## 常见问题（新手版）
- **提示没有 `brew`**：先安装 Homebrew（https://brew.sh）。
- **提示没有 Command Line Tools**：运行 `xcode-select --install`。
- **打开后不能运行**：在 Xcode 中检查 `Signing & Capabilities`，使用你的 Apple ID 自动签名。

## 下一步建议
- 接入计时器与历史步骤记录。
- 增加手势转层（拖拽某一面直接旋转）。
- 增加“自动还原演示”（先实现回放，再接入还原算法）。
