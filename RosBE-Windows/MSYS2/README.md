# BosDE on native Windows MSYS2

This directory adds a native MSYS2 host setup for the BlastmasterOS Development
Environment (BosDE). It does not replace RosBE and does not build or install
cross-compilers.

## Design

BosDE uses a **hybrid** toolchain model:

- MSYS2 MSYS provides the POSIX shell and host-side build utilities.
- The matching RosBE toolchain provides the target GCC/binutils programs.
- The BlastmasterOS source repository remains authoritative for CMake
  configuration and architecture support.

Use the **MSYS2 MSYS** shell, not the MINGW64, UCRT64, or CLANG64 shell. The
current BlastmasterOS Windows toolchain file expects the compiler commands
below to resolve from the active PATH. Put the selected RosBE toolchain's
`bin` directory before the MSYS2 paths so the target compiler is selected
instead of an MSYS host compiler.

## Install host dependencies

From the repository root in an MSYS2 MSYS shell:

```bash
bash RosBE-Windows/MSYS2/install-dependencies.sh
```

MSYS2 may ask you to close and reopen the terminal during a core update. If so,
reopen the MSYS2 MSYS shell and run the command again.

The installer provisions host utilities (CMake, Ninja, Git, Make, Python,
Perl, Bison, Flex, and common archive/patch tools). It deliberately does not
install a generic MinGW-w64 compiler: using an unrelated compiler can silently
select the wrong ABI or binutils for BlastmasterOS.

## Configure the target compiler environment

Activate the RosBE environment that contains the compiler set for the desired
target. Confirm that its `bin` directory is first on PATH, ahead of
`/usr/bin`. The existing OS-side `toolchain-gcc.cmake` currently looks for:

| Target | Required command prefix on Windows |
|---|---|
| i386 | no prefix (for example, `gcc`, `g++`) |
| amd64 | `x86_64-w64-mingw32-` |
| ARM | `arm-mingw32ce-` |
| PowerPC | not defined yet |

All currently defined target toolchains must provide GCC, G++, windmc, windres,
dlltool, and objcopy.

## Validate the environment

Check the host tools and all four requested architecture targets:

```bash
bash RosBE-Windows/MSYS2/check-environment.sh all
```

Or check one currently defined target:

```bash
bash RosBE-Windows/MSYS2/check-environment.sh i386
bash RosBE-Windows/MSYS2/check-environment.sh amd64
bash RosBE-Windows/MSYS2/check-environment.sh arm
```

PowerPC is included in the all-target diagnostic so its current unsupported
state is visible. It is not marked as supported: the current
BlastmasterOS `toolchain-gcc.cmake` has no PowerPC prefix or PowerPC branch.
PowerPC enablement requires coordinated changes in the **BlastmasterOS source
repository**, including the compiler/binutils naming contract and CMake
architecture support. This environment repository must not guess those names.

## Build BlastmasterOS

Clone the BlastmasterOS source repository alongside this repository, activate
the appropriate RosBE target environment, then follow the source repository's
configure/build instructions. For example, from the OS source root:

```bash
./configure.sh
cmake --build output-MinGW-i386 --parallel
```

The output directory shown is only an example for an i386 configuration.
Use the directory reported by the configure script for the selected target.
Do not infer build or boot success from compiler discovery alone.

## Scope of this first stage

This stage establishes and diagnoses the native MSYS2 host. It intentionally
does not:

- replace or rewrite the existing RosBE compiler build process;
- pin a new GCC/binutils release without checking compatibility with the OS;
- claim PowerPC support before the OS repository defines it;
- remove the legacy Docker/MSYS2 files.

The next stage can make compiler activation reproducible per target and add
build/boot smoke tests once the exact RosBE toolchain packages and PowerPC
compiler contract are established.
