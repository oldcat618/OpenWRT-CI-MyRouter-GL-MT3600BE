#!/usr/bin/env bash
set -e

echo "===== Disk space before cleanup ====="
df -h

sudo rm -rf /usr/share/dotnet /usr/local/lib/android /opt/ghc /opt/hostedtoolcache/CodeQL || true
sudo apt-get clean || true

echo "===== Disk space after cleanup ====="
df -h
