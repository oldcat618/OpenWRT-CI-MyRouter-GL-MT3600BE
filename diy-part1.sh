#!/bin/bash
# 1. 添加第三方插件源 (kenzo 仓库包含 OpenClash, MosDNS 等)
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

# 2. 【核心变更】确保 HomeProxy 使用 ImmortalWrt 原生推荐版本
# 这样可以避免编译时出现 sing-box 依赖版本不匹配的报错
rm -rf package/feeds/luci/luci-app-homeproxy
git clone https://github.com/immortalwrt/homeproxy package/homeproxy
