#!/usr/bin/env bash
set -e

# Default LAN IP
sed -i 's/192\.168\.1\.1/192.168.8.1/g' package/base-files/files/bin/config_generate || true

# Default hostname
sed -i "s/hostname='.*'/hostname='MT3600BE'/g" package/base-files/files/bin/config_generate || true

# Default theme
find package feeds -type f -path "*/collections/luci/Makefile" -exec sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' {} + || true
