#!/usr/bin/env bash
set -e

# 追加常用第三方软件源
cat >> feeds.conf.default <<'FEEDS'
src-git argon https://github.com/jerrykuku/luci-theme-argon.git
src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git
FEEDS
