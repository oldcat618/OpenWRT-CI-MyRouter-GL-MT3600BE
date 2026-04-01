#!/bin/bash

# 1. 修改默认 IP 为 192.168.10.1
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i 's/OpenWrt/QWRT/g' package/base-files/files/bin/config_generate

# 3. 设置默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 4. 强制删除旧配置 (ImmortalWrt 下 Beryl 7 识别 2.4G 的关键)
rm -f package/base-files/files/etc/config/wireless

# 5. 【初始化脚本】仅负责开启无线、设置 US 区域和 160MHz
# 我们去掉了 sed 抹除密码，改为纯粹的无线优化
mkdir -p package/base-files/files/etc/uci-defaults/
cat <<EOF > package/base-files/files/etc/uci-defaults/99-init-settings
#!/bin/sh
# 这里的 sleep 是为了给驱动加载留出时间
sleep 5

# 开启 5G (radio0) 并锁定 US 区域与 160MHz
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.country='US'
uci set wireless.radio0.bandwidth='160'

# 开启 2.4G (radio1) 并锁定 US 区域
uci set wireless.radio1.disabled='0'
uci set wireless.radio1.country='US'

uci commit wireless
wifi up
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-init-settings

# 6. 开启 MTK WED 硬件转发加速
echo "CONFIG_NET_MEDIATEK_SOC_WED=y" >> .config
