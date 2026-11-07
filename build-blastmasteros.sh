#!/bin/sh
set -eu

# Build BlastmasterOS using the configure script in the OS source repository.
# Expected default layout:
#   workspace/BlastmasterOS
#   workspace/BlastmasterOS-Dev-Environment

DEV_ENV_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ -n "${BLASTMASTEROS_SOURCE_DIR:-}" ]; then
    OS_SOURCE_DIR=$BLASTMASTEROS_SOURCE_DIR
else
    OS_SOURCE_DIR=$(CDPATH= cd -- "$DEV_ENV_DIR/../BlastmasterOS" 2>/dev/null && pwd) || {
        echo "ERROR: BlastmasterOS source tree was not found." >&2
        echo "Clone it beside this repository or set BLASTMASTEROS_SOURCE_DIR." >&2
        exit 1
    }
fi

if [ ! -f "$OS_SOURCE_DIR/CMakeLists.txt" ] || [ ! -f "$OS_SOURCE_DIR/configure.sh" ]; then
    echo "ERROR: '$OS_SOURCE_DIR' is not a valid BlastmasterOS source tree." >&2
    exit 1
fi

if [ -z "${ROS_ARCH:-}" ]; then
    echo "ERROR: ROS_ARCH is not set. Activate RosBE-Unix and select a target architecture." >&2
    exit 1
fi

command -v cmake >/dev/null 2>&1 || {
    echo "ERROR: CMake was not found on PATH." >&2
    exit 1
}
command -v ninja >/dev/null 2>&1 || {
    echo "ERROR: Ninja was not found on PATH." >&2
    exit 1
}

BUILD_DIR=${BLASTMASTEROS_BUILD_DIR:-"$DEV_ENV_DIR/build/BlastmasterOS"}
export BLASTMASTEROS_BUILD_DIR="$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo
echo "=== Configuring BlastmasterOS ==="
echo "Source: $OS_SOURCE_DIR"
echo "Build:  $BUILD_DIR"
echo

sh "$OS_SOURCE_DIR/configure.sh" "$@"

echo
echo "=== Building BlastmasterOS ==="
cmake --build . --parallel

echo
echo "BlastmasterOS build completed successfully."
echo "Build output: $BUILD_DIR"
echo
echo "To build a bootable ISO, run:"
echo "  cmake --build \"$BUILD_DIR\" --target bootcd --parallel"
