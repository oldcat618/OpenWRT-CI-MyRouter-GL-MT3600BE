#!/usr/bin/env bash
set -e

# 默认 IP
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate || true

# 默认主机名
sed -i "s/hostname='OpenWrt'/hostname='MT3600BE'/g" package/base-files/files/bin/config_generate || true

# 默认主题（仅在 Argon 已存在时替换）
if grep -q 'luci-theme-argon' feeds/luci/collections/luci/Makefile 2>/dev/null; then
  sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile || true
fi
