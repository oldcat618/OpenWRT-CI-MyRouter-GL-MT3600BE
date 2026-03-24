#!/usr/bin/env bash
set -e

# =====================================
# 自定义固件默认设置
# =====================================

# 参数兜底
: "${WRT_IP:=192.168.8.1}"
: "${WRT_PW:=password}"
: "${WRT_THEME:=argon}"
: "${WRT_NAME:=OpenWrt}"
: "${WRT_SSID:=OpenWrt}"
: "${WRT_WORD:=12345678}"

# 1. 修改默认管理地址
sed -i "s/192.168.1.1/${WRT_IP}/g" package/base-files/files/bin/config_generate || true
sed -i "s/192.168.1.1/${WRT_IP}/g" package/base-files/luci2/bin/config_generate || true

# 2. 修改默认 root 密码
# 这里使用 openssl passwd -1 生成 md5 crypt
if command -v openssl >/dev/null 2>&1; then
    HASHED_PW="$(openssl passwd -1 "${WRT_PW}")"
    sed -i "s#^root::0:0:99999:7:::#root:${HASHED_PW}:0:0:99999:7:::#" package/base-files/files/etc/shadow || true
fi

# 3. 修改主机名
sed -i "s/hostname='.*'/hostname='${WRT_NAME}'/g" package/base-files/files/bin/config_generate || true

# 4. 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-${WRT_THEME}/g" feeds/luci/collections/luci/Makefile || true
sed -i "s/luci-theme-bootstrap/luci-theme-${WRT_THEME}/g" feeds/luci/collections/luci-nginx/Makefile || true

# 5. 预置 Wi-Fi 名称与密码（如首次生成无线配置可生效）
if [ -f package/kernel/mac80211/files/lib/wifi/mac80211.sh ]; then
    sed -i "s/ssid=OpenWrt/ssid=${WRT_SSID}/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh || true
fi

# 6. 固件版本标识
DATE_TAG="$(date +%Y.%m.%d)"
if [ -f package/lean/default-settings/files/zzz-default-settings ]; then
    sed -i "s/OpenWrt /OpenWrt ${WRT_NAME} ${DATE_TAG} @ /g" package/lean/default-settings/files/zzz-default-settings || true
fi

# 7. 写入默认 Wi-Fi 密码说明到 banner（仅提示）
if [ -f package/base-files/files/etc/banner ]; then
    {
        echo ""
        echo "Default WiFi SSID: ${WRT_SSID}"
        echo "Default WiFi Key : ${WRT_WORD}"
    } >> package/base-files/files/etc/banner
fi

# 8. 生成 defconfig
make defconfig
