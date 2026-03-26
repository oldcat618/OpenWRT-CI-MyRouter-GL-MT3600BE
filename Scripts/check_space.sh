#!/usr/bin/env bash
set -e

echo "========== Disk space before cleanup =========="
df -hT

echo "========== Memory =========="
free -h || true
