.PHONY: mac-setup generate-project

mac-setup:
	# 中文备注：给 Mac 新手准备的一键初始化入口。
	bash scripts/setup_mac.sh

generate-project:
	# 中文备注：仅生成 Xcode 工程，不自动打开。
	xcodegen generate
