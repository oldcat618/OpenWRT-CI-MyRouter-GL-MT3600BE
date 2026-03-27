#!/usr/bin/env bash
set -e

echo "==> Start custom settings"

#--------------------------------------------------
# 1. 基础变量
#--------------------------------------------------
WRT_IP="${WRT_IP:-192.168.68.1}"
WRT_NAME="${WRT_NAME:-MT3600BE-LEDE}"

TOPDIR="$(pwd)"

echo "TOPDIR: $TOPDIR"
echo "WRT_IP: $WRT_IP"
echo "WRT_NAME: $WRT_NAME"

#--------------------------------------------------
# 2. 修改默认 IP / 主机名
#--------------------------------------------------
sed -i "s/192.168.1.1/${WRT_IP}/g" package/base-files/files/bin/config_generate || true
sed -i "s/hostname='.*'/hostname='${WRT_NAME}'/g" package/base-files/files/bin/config_generate || true

#--------------------------------------------------
# 3. 清理旧目录，避免重复克隆冲突
#--------------------------------------------------
rm -rf package/custom
mkdir -p package/custom

#--------------------------------------------------
# 4. 拉取额外软件包
#--------------------------------------------------

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

# USB Printer：改用 svn 从 LEDE 主树直接拉
svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/custom/luci-app-usb-printer

# Vlmcsd：也建议直接从 LEDE 主树拉，和 LEDE 更一致
svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-vlmcsd package/custom/luci-app-vlmcsd
svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/vlmcsd package/custom/vlmcsd

#--------------------------------------------------
# 5. 重新安装 feeds，纳入依赖
#--------------------------------------------------
./scripts/feeds update -a
./scripts/feeds install -a

#--------------------------------------------------
# 6. 打印确认
#--------------------------------------------------
echo "==> Custom package list"
find package/custom -maxdepth 2 -type d | sort || true

echo "==> Custom settings done"
