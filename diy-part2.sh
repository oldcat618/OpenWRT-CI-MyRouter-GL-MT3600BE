#!/bin/bash

# 1. 修改默认 IP 为 192.168.18.1
sed -i 's/192.168.1.1/192.168.18.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名为 Beryl7-LEDE
sed -i 's/OpenWrt/Beryl7-LEDE/g' package/base-files/files/bin/config_generate

# 3. 设置默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 4. 强制删除预设无线配置 (解决双频 WiFi 识别不全的关键)
# 这一步会让系统在首次开机时根据驱动重新探测 radio0 和 radio1
rm -f package/base-files/files/etc/config/wireless

# 5. 开启硬件转发优化
echo "CONFIG_NET_MEDIATEK_SOC_WED=y" >> .config

# 强制设置 root 密码为 password 使用lede默认密码 "password"
# echo "password" | (passwd root <<EOF password password EOF)

# 6. 修改版本号标识 (可选)
sed -i "s/OpenWrt /Built by YourName $(date +%Y-%m-%d) /g" package/base-files/files/etc/banner
