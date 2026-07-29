#!/bin/bash
# =============================================================================
# build_dtc.sh - Build dtc.exe for Windows
# Cross-compiles from Ubuntu (WSL) using MinGW-w64 and Meson
# DTC Version: 1.7.2
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/dtc-1.7.2"
CROSS_FILE="${SCRIPT_DIR}/mingw-w64-cross.txt"

echo "============================================="
echo "  Building dtc.exe 1.7.2 for Windows"
echo "============================================="

echo ""
echo "[1/3] Configuring with Meson..."
cd "${SOURCE_DIR}"
rm -rf build-win
meson setup --cross-file "${CROSS_FILE}" \
    -Dtests=false \
    -Dtools=true \
    -Dyaml=disabled \
    -Dpython=disabled \
    build-win

echo ""
echo "[2/3] Compiling..."
meson compile -C build-win

echo ""
echo "[3/3] Build complete!"
echo "Output: ${SOURCE_DIR}/build-win/dtc.exe"
ls -lh build-win/dtc.exe
