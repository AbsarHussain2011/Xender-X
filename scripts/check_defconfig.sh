#!/usr/bin/env bash
# Check that every BR2_ option in a Buildroot defconfig landed in the generated .config.
# Usage: check_defconfig.sh BUILDROOT_DOT_CONFIG DEFCONFIG
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 BUILDROOT_DOT_CONFIG DEFCONFIG" >&2
  exit 2
fi

HERE="$(cd "$(dirname "$0")" && pwd)"
PREFIX=BR2 exec bash "$HERE/check_kernel_config.sh" "$1" "$2"
