#!/usr/bin/env bash
set -euo pipefail

# 中文备注：这个脚本用于“第一次拉代码后的一键启动”。
# 目标人群：不熟悉 iOS 工程配置的新手同学。

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[1/4] 检查 Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  echo "未检测到 Command Line Tools，请先执行：xcode-select --install"
  exit 1
fi

echo "[2/4] 检查 Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew，请先安装：https://brew.sh/"
  exit 1
fi

echo "[3/4] 检查并安装 xcodegen..."
if ! command -v xcodegen >/dev/null 2>&1; then
  brew install xcodegen
fi

echo "[4/4] 生成 Xcode 工程并打开..."
xcodegen generate
open MoFang-IOS.xcodeproj

echo "完成 ✅：请在 Xcode 里选择 iPhone 模拟器，然后点击 Run。"
