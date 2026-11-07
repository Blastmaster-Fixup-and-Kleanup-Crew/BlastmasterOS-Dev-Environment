#!/usr/bin/env bash
#
# Clean generated BlastmasterOS build outputs.
# Part of the BlastmasterOS Dev Environment for Unix-based Operating Systems.
# Released under GNU GPL v2 or any later version.

if [ -z "${BLASTMASTEROS_BUILD_DIR:-}" ]; then
    echo "ERROR: BLASTMASTEROS_BUILD_DIR is not set."
    echo "Activate the environment or set it to the BlastmasterOS CMake build directory."
    exit 1
fi

if [ ! -f "$BLASTMASTEROS_BUILD_DIR/CMakeCache.txt" ]; then
    echo "ERROR: No configured BlastmasterOS CMake build directory found at:"
    echo "  $BLASTMASTEROS_BUILD_DIR"
    exit 1
fi

echo "Cleaning BlastmasterOS build outputs..."
cmake --build "$BLASTMASTEROS_BUILD_DIR" --target clean
