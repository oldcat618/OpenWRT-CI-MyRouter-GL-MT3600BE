#!/usr/bin/env bash
set -e

# 当前目录默认在 lede/package
PKG_DIR="$(pwd)"

clone_git_sparse() {
    local repo_url="$1"
    local branch="$2"
    local sparse_path="$3"
    local dest_name="$4"

    rm -rf /tmp/pkg_sparse_clone
    git clone --depth=1 -b "$branch" --filter=blob:none --sparse "$repo_url" /tmp/pkg_sparse_clone
    cd /tmp/pkg_sparse_clone
    git sparse-checkout init --cone
    git sparse-checkout set "$sparse_path"
    if [ -d "$sparse_path" ]; then
        cp -rf "$sparse_path" "$PKG_DIR/$dest_name"
    fi
    cd "$PKG_DIR"
    rm -rf /tmp/pkg_sparse_clone
}

# =========================
# 外部插件
# =========================

# OpenClash
if [ ! -d "$PKG_DIR/luci-app-openclash" ]; then
    clone_git_sparse https://github.com/vernesong/OpenClash.git master luci-app-openclash luci-app-openclash || true
fi

# Argon 主题（兜底补充）
if [ ! -d "$PKG_DIR/luci-theme-argon" ]; then
    git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git "$PKG_DIR/luci-theme-argon" || true
fi

# Argon Config（可选）
if [ ! -d "$PKG_DIR/luci-app-argon-config" ]; then
    git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git "$PKG_DIR/luci-app-argon-config" || true
fi

# MosDNS（外部补充，避免源内不存在时失效）
if [ ! -d "$PKG_DIR/mosdns" ]; then
    clone_git_sparse https://github.com/sbwml/luci-app-mosdns.git v5 package/mosdns mosdns || true
fi
if [ ! -d "$PKG_DIR/luci-app-mosdns" ]; then
    clone_git_sparse https://github.com/sbwml/luci-app-mosdns.git v5 luci-app-mosdns luci-app-mosdns || true
fi
