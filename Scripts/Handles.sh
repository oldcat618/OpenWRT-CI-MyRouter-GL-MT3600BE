#!/usr/bin/env bash
set -e

# 这里放一些冲突处理、包替换、清理逻辑。
# 当前先保留为轻量脚本，后续你可以继续往这里加：
# 1. 删除重复主题
# 2. 替换 golang 依赖
# 3. 替换/锁定 sing-box / xray / tailscale 版本
# 4. 加入 ModemManager / FM350 / modemband

# 删除一些可能重复或不需要的主题，减少冲突概率
rm -rf ./feeds/luci/themes/luci-theme-bootstrap 2>/dev/null || true

# 如存在 feed 内置 argon 与外部 argon 重复，可在此处理
# 示例：
# rm -rf ./feeds/luci/themes/luci-theme-argon 2>/dev/null || true
