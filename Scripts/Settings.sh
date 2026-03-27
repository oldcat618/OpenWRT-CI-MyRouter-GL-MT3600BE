#!/usr/bin/env bash
set -e

echo "==> Start custom settings"

#--------------------------------------------------
# 1. 基础变量
#--------------------------------------------------
WRT_IP="${WRT_IP:-192.168.68.1}"
WRT_NAME="${WRT_NAME:-MT3600BE-LEDE}"

# 当前目录应为 openwrt 根目录
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
# 3. 清理可能冲突的旧包目录
#    避免重复克隆或同名包冲突
#--------------------------------------------------
rm -rf package/openclash
rm -rf package/homeproxy
rm -rf package/mosdns-packages
rm -rf package/wolplus
rm -rf package/netspeedtest
rm -rf package/partexp
rm -rf package/usb-printer
rm -rf package/vlmcsd
rm -rf feeds/luci/applications/luci-app-wolplus
rm -rf feeds/luci/applications/luci-app-netspeedtest
rm -rf feeds/luci/applications/luci-app-partexp
rm -rf feeds/luci/applications/luci-app-usb-printer
rm -rf feeds/luci/applications/luci-app-vlmcsd

mkdir -p package/custom

#--------------------------------------------------
# 4. 拉取你 .config 里需要、但主树里不一定自带的包
#--------------------------------------------------

# OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/custom/openclash
rm -rf package/custom/openclash/.git
rm -rf package/custom/openclash/.github

# HomeProxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy.git package/custom/homeproxy
rm -rf package/custom/homeproxy/.git
rm -rf package/custom/homeproxy/.github

# MosDNS（含 luci-app-mosdns）
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/custom/mosdns-packages
rm -rf package/custom/mosdns-packages/.git
rm -rf package/custom/mosdns-packages/.github

# WolPlus
git clone --depth=1 https://github.com/sirpdboy/luci-app-wolplus.git package/custom/wolplus
rm -rf package/custom/wolplus/.git
rm -rf package/custom/wolplus/.github

# NetSpeedTest
git clone --depth=1 https://github.com/sirpdboy/luci-app-netspeedtest.git package/custom/netspeedtest
rm -rf package/custom/netspeedtest/.git
rm -rf package/custom/netspeedtest/.github

# PartExp
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/custom/partexp
rm -rf package/custom/partexp/.git
rm -rf package/custom/partexp/.github

# USB Printer
git clone --depth=1 https://github.com/lisaac/luci-app-usb-printer.git package/custom/usb-printer
rm -rf package/custom/usb-printer/.git
rm -rf package/custom/usb-printer/.github

# Vlmcsd
git clone --depth=1 https://github.com/sirpdboy/luci-app-vlmcsd.git package/custom/vlmcsd
rm -rf package/custom/vlmcsd/.git
rm -rf package/custom/vlmcsd/.github

#--------------------------------------------------
# 5. 再安装一遍 feeds，确保新包依赖被纳入
#--------------------------------------------------
./scripts/feeds update -a
./scripts/feeds install -a

#--------------------------------------------------
# 6. 打印目录确认
#--------------------------------------------------
echo "==> Custom package list"
find package/custom -maxdepth 2 -type d | sort || true

echo "==> Custom settings done"
