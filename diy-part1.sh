#!/bin/bash
# 添加常用的第三方插件源
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

# 如果需要最新版的 HomeProxy 也可以单独拉取（可选）
# git clone https://github.com/immortalwrt/homeproxy package/homeproxy
