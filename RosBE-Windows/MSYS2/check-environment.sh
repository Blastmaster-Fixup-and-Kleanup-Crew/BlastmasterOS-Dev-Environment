#!/usr/bin/env bash
#
# Validate the native MSYS2 host and available RosBE target tools.
# Copyright 2026 BlastmasterOS contributors
# SPDX-License-Identifier: GPL-2.0-or-later
#

set -uo pipefail

if [[ "${MSYSTEM:-}" != "MSYS" ]]; then
    echo "ERROR: Use the MSYS2 MSYS shell (MSYSTEM=MSYS)." >&2
    exit 1
fi

host_tools=(bash git cmake ninja make python perl)
missing_host=0
missing_target=0

echo "BosDE native MSYS2 environment"
echo "MSYSTEM: $MSYSTEM"
echo "Host:    $(uname -srm)"
echo

echo "Host tools:"
for tool in "${host_tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf '  OK      %s: %s\n' "$tool" "$(command -v "$tool")"
    else
        printf '  MISSING %s\n' "$tool"
        missing_host=1
    fi
done

check_target() {
    local arch="$1"
    local prefix="$2"
    local tool
    local failed=0
    local tools=(gcc g++ windmc windres dlltool objcopy)

    echo
    echo "$arch target tools (prefix: ${prefix:-<none>}):"
    for tool in "${tools[@]}"; do
        if command -v "${prefix}${tool}" >/dev/null 2>&1; then
            printf '  OK      %s: %s\n' "${prefix}${tool}" "$(command -v "${prefix}${tool}")"
        else
            printf '  MISSING %s\n' "${prefix}${tool}"
            failed=1
        fi
    done

    if (( failed )); then
        missing_target=1
    fi
}

requested="${1:-all}"
case "$requested" in
    all|i386|amd64|arm|ppc) ;;
    *)
        echo "Usage: $0 [all|i386|amd64|arm|ppc]" >&2
        exit 2
        ;;
esac

if [[ "$requested" == all || "$requested" == i386 ]]; then
    # On Windows the current OS toolchain file uses an empty prefix for i386.
    check_target i386 ""
fi
if [[ "$requested" == all || "$requested" == amd64 ]]; then
    check_target amd64 "x86_64-w64-mingw32-"
fi
if [[ "$requested" == all || "$requested" == arm ]]; then
    check_target arm "arm-mingw32ce-"
fi
if [[ "$requested" == all || "$requested" == ppc ]]; then
    echo
    echo "ppc target: NOT IMPLEMENTED in the current BlastmasterOS toolchain-gcc.cmake."
    echo "A PowerPC compiler prefix and OS-side CMake/toolchain support must be defined"
    echo "before this target can pass validation."
    missing_target=1
fi

echo
if (( missing_host )); then
    echo "RESULT: host setup incomplete. Run ./install-dependencies.sh."
elif (( missing_target )); then
    echo "RESULT: host setup is present, but one or more requested target toolchains are incomplete."
    exit 1
else
    echo "RESULT: requested host and target commands are present."
fi

(( missing_host == 0 && missing_target == 0 ))
