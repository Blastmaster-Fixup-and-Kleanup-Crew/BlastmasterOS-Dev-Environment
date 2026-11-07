# BlastmasterOS Dev Environment

This repository provides the Windows and Unix build-environment components used to compile **BlastmasterOS**.

> **The operating-system source lives in a separate repository:**  
> https://github.com/Blastmaster-Fixup-and-Kleanup-Crew/BlastmasterOS

This repository is the toolchain and build-helper repository. It is not a replacement OS source tree and does not contain the authoritative kernel, drivers, subsystems, or desktop source.

## Repository layout

- `RosBE-Windows/` — Windows BlastmasterOS Dev Environment components.
- `RosBE-Unix/` — Unix build-environment components.
- `RosBE-PPC/` — PowerPC build-environment components.
- `Tools/` — build-environment utilities.
- `Patches/` — patches used by the environment.

The OS repository contains the CMake project, architecture toolchain files, and the configure scripts. Keep OS-specific build logic there; keep compiler/toolchain provisioning and convenience wrappers here.

## Quick start — Windows

1. Clone both repositories side by side:

   ```text
   workspace/
     BlastmasterOS/
     BlastmasterOS-Dev-Environment/
   ```

   The helper defaults to this layout. If your folders are elsewhere, set `BLASTMASTEROS_SOURCE_DIR` to the OS repository path.

2. Install or activate the Windows build environment supplied/configured by this repository. Open its build shell so compiler tools and `ROS_ARCH` are available. Alternatively, use a supported Visual Studio Developer Command Prompt.

3. Ensure CMake and Ninja are on `PATH`.

4. From this repository, run:

   ```bat
   build-blastmasteros.cmd
   ```

The helper creates an isolated `build\BlastmasterOS` directory, invokes the OS repository's own `configure.cmd`, then builds the configured targets with CMake.

To select CMake options, pass them through to the configure script, for example:

```bat
build-blastmasteros.cmd -DDBG:BOOL=0
```

The configure script determines the target architecture from the active build environment. For RosBE, `ROS_ARCH` must be set (for example, `i386` or `amd64`). For Visual Studio, run from a supported Developer Command Prompt.

## Quick start — Unix

1. Clone both repositories side by side.
2. Install/activate RosBE-Unix and ensure CMake and Ninja are on `PATH`.
3. Set `ROS_ARCH` to the desired supported target architecture.
4. Run:

   ```sh
   ./build-blastmasteros.sh
   ```

You may pass CMake options through to the OS configure script:

```sh
./build-blastmasteros.sh -DDBG:BOOL=0
```

## Build a bootable ISO

After a successful configuration and normal build, build the ISO target from the generated build directory:

**Windows (from this repository):**

```bat
cmake --build build\BlastmasterOS --target bootcd --parallel
```

**Unix (from this repository):**

```sh
cmake --build build/BlastmasterOS --target bootcd --parallel
```

Use the actual build directory if you configured elsewhere. Check the build output for the exact ISO artifact path; do not assume an artifact name or treat an untested image as release-ready.

## Important notes

- Build the OS from the **BlastmasterOS** source repository, not from this repository's root.
- Do not copy or maintain a second CMake project here. The helper scripts deliberately call the OS repository's configure scripts.
- Use a source path without spaces when using the current Windows configure script; it explicitly rejects spaces in the source path.
- The first build may take a long time and require substantial disk space.
- Test bootable images in a virtual machine using a disposable virtual disk. BlastmasterOS is experimental; do not test on a disk containing important data.
- A successful compile does not prove that the OS boots, that drivers work, or that an ISO is installable. Boot-test and record the tested commit and configuration.

## Upstream relationship

BlastmasterOS is based on the ReactOS codebase. Respect the licenses and notices for ReactOS and all bundled third-party components when using or redistributing the build environment or generated artifacts.
