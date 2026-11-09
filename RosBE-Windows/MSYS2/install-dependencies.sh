#!/usr/bin/env bash
#
# BosDE native MSYS2 host dependency bootstrap.
# Install host-side build utilities only; cross-compilers remain supplied by RosBE.
# Copyright 2026 BlastmasterOS contributors
# SPDX-License-Identifier: GPL-2.0-or-later
#

set -euo pipefail

if [[ "${MSYSTEM:-}" != "MSYS" ]]; then
    echo "Run this script from the MSYS2 MSYS shell (not MINGW64/UCRT64)." >&2
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman was not found. Install MSYS2 and retry." >&2
    exit 1
fi

# Update the MSYS2 base first. If pacman asks for the shell to close, close it,
# reopen the MSYS2 MSYS shell, and run this script again.
pacman -Syu --noconfirm

# These are host utilities, not target compilers. In particular, do not install
# a MinGW-w64 toolchain here: BosDE uses the matching RosBE cross-toolchains.
pacman -S --needed --noconfirm \
    base-devel \
    git \
    cmake \
    ninja \
    python \
    perl \
    bison \
    flex \
    diffutils \
    patch \
    wget \
    unzip \
    zip \
    rsync \
    ccache

echo
echo "BosDE MSYS2 host dependencies are installed."
echo "Next: put the matching RosBE target-toolchain bin directory first on PATH,"
echo "then run ./check-environment.sh all."
