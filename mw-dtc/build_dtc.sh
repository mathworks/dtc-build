#!/bin/bash
# =============================================================================
# build_dtc.sh - Build dtc for Windows and/or Linux
# Cross-compiles for Windows from Ubuntu (WSL) using MinGW-w64 and Meson
# Builds natively for Linux
# DTC Version: 1.7.2
#
# Usage:
#   ./build_dtc.sh                # Build for both platforms (default)
#   ./build_dtc.sh Windows        # Build Windows dtc.exe only
#   ./build_dtc.sh Linux          # Build Linux dtc only
# Arguments are case-insensitive (Windows/WINDOWS/windows all work)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/dtc-1.7.2"
CROSS_FILE="${SCRIPT_DIR}/mingw-w64-cross.txt"
OUTPUT_DIR="${SCRIPT_DIR}/output"
MESON_OPTS="-Dtests=false -Dtools=true -Dyaml=disabled -Dpython=disabled"

TARGET=$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')

build_windows() {
    echo "============================================="
    echo "  Building dtc.exe 1.7.2 for Windows"
    echo "============================================="

    local BUILD_DIR="${OUTPUT_DIR}/build-win"

    echo ""
    echo "[1/3] Configuring with Meson (Windows cross-compile)..."
    rm -rf "${BUILD_DIR}"
    meson setup --cross-file "${CROSS_FILE}" ${MESON_OPTS} "${BUILD_DIR}" "${SOURCE_DIR}"

    echo ""
    echo "[2/3] Compiling..."
    meson compile -C "${BUILD_DIR}"

    echo ""
    echo "[3/3] Windows build complete!"
    chmod 777 "${BUILD_DIR}/dtc.exe"
    echo "Output: ${BUILD_DIR}/dtc.exe"
    ls -lh "${BUILD_DIR}/dtc.exe"
}

build_linux() {
    echo "============================================="
    echo "  Building dtc 1.7.2 for Linux"
    echo "============================================="

    local BUILD_DIR="${OUTPUT_DIR}/build-lin"

    echo ""
    echo "[1/3] Configuring with Meson (native Linux)..."
    rm -rf "${BUILD_DIR}"
    meson setup ${MESON_OPTS} "${BUILD_DIR}" "${SOURCE_DIR}"

    echo ""
    echo "[2/3] Compiling..."
    meson compile -C "${BUILD_DIR}"

    echo ""
    echo "[3/3] Linux build complete!"
    chmod 777 "${BUILD_DIR}/dtc"
    echo "Output: ${BUILD_DIR}/dtc"
    ls -lh "${BUILD_DIR}/dtc"
}

case "${TARGET}" in
    windows)
        build_windows
        ;;
    linux)
        build_linux
        ;;
    "")
        build_linux
        echo ""
        build_windows
        ;;
    *)
        echo "Error: Invalid argument '${1}'"
        echo ""
        echo "Usage: $0 [Windows|Linux]"
        echo "  (no argument) - Build for both platforms"
        echo "  Windows       - Build Windows dtc.exe (cross-compile with MinGW)"
        echo "  Linux         - Build native Linux dtc"
        exit 1
        ;;
esac

echo ""
echo "============================================="
echo "  All builds finished!"
echo "============================================="
