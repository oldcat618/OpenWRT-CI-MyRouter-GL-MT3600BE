#!/usr/bin/env bash
set -e

TARGET_DIR="$(find ./bin/targets -type d | tail -n 1)"
if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR" ]; then
    echo "未找到 bin/targets 输出目录，跳过空间检查。"
    exit 0
fi

FW_FILE="$(find "$TARGET_DIR" -type f \( -name "*sysupgrade.bin" -o -name "*.itb" -o -name "*.bin" \) | head -n 1)"
if [ -z "$FW_FILE" ] || [ ! -f "$FW_FILE" ]; then
    echo "未找到固件文件，跳过空间检查。"
    exit 0
fi

FW_SIZE_BYTES=$(stat -c%s "$FW_FILE")
FW_SIZE_MB=$((FW_SIZE_BYTES / 1024 / 1024))

# 粗略按 512MB NAND 估算，仅用于日志提示
TOTAL_MB=512
LEFT_MB=$((TOTAL_MB - FW_SIZE_MB))

echo "=============================="
echo "固件文件: $FW_FILE"
echo "固件大小: ${FW_SIZE_MB} MB"
echo "NAND 剩余空间（粗略估算）: ${LEFT_MB} MB"
echo "=============================="
