#!/usr/bin/env bash
set -e

# 仅保留当前项目真正会用到的额外主题源，减少 feeds 风险。
cat >> feeds.conf.default <<'FEEDS'
src-git argon https://github.com/jerrykuku/luci-theme-argon.git
FEEDS
