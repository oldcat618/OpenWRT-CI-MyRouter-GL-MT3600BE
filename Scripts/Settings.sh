#!/usr/bin/env bash
set -e

# Basic customization only; avoid touching theme defaults that depend on external feeds.
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate || true
sed -i "s/hostname='OpenWrt'/hostname='MT3600BE'/g" package/base-files/files/bin/config_generate || true
