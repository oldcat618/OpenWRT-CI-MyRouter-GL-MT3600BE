#!/usr/bin/env bash
set -e

# Keep the master-tracking build conservative.
# No third-party feeds are added here by default because recent argon feed metadata was broken
# and caused package index generation failures.

echo "Using upstream feeds only for master auto-fix build."
