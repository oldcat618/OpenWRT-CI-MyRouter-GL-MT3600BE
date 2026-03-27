#!/usr/bin/env bash
set -e

echo "==> Start custom settings"

WRT_IP="${WRT_IP:-192.168.68.1}"
WRT_NAME="${WRT_NAME:-MT3600BE-LEDE}"

TOPDIR="$(pwd)"

echo "TOPDIR: $TOPDIR"
echo "WRT_IP: $WRT_IP"
echo "WRT_NAME: $WRT_NAME"

# 修改默认 IP / 主机名
sed -i "s/192.168.1.1/${WRT_IP}/g" package/base-files/files/bin/config_generate || true
sed -i "s/hostname='.*'/hostname='${WRT_NAME}'/g" package/base-files/files/bin/config_generate || true

# 清理旧目录
rm -rf package/custom
mkdir -p package/custom

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/custom/openclash
rm -rf package/custom/openclash/.git package/custom/openclash/.github

# HomeProxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy.git package/custom/homeproxy
rm -rf package/custom/homeproxy/.git package/custom/homeproxy/.github

# MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/custom/mosdns-packages
rm -rf package/custom/mosdns-packages/.git package/custom/mosdns-packages/.github

# WolPlus
git clone --depth=1 https://github.com/siwind/luci-app-wolplus.git package/custom/wolplus
rm -rf package/custom/wolplus/.git package/custom/wolplus/.github

# NetSpeedTest
git clone --depth=1 https://github.com/sirpdboy/netspeedtest.git package/custom/netspeedtest
rm -rf package/custom/netspeedtest/.git package/custom/netspeedtest/.github

# PartExp
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/custom/partexp
rm -rf package/custom/partexp/.git package/custom/partexp/.github

# Vlmcsd - LuCI 页面
git clone --depth=1 https://github.com/cokebar/luci-app-vlmcsd.git package/custom/luci-app-vlmcsd
rm -rf package/custom/luci-app-vlmcsd/.git package/custom/luci-app-vlmcsd/.github

# Vlmcsd - 核心程序
git clone --depth=1 https://github.com/cokebar/openwrt-vlmcsd.git package/custom/vlmcsd
rm -rf package/custom/vlmcsd/.git package/custom/vlmcsd/.github

# 重新纳入 feeds 依赖
./scripts/feeds update -a
./scripts/feeds install -a

echo "==> Custom package list"
find package/custom -maxdepth 2 -type d | sort || true

echo "==> Custom settings done"
