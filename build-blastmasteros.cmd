@echo off
setlocal

rem Build BlastmasterOS using the configure script in the OS source repository.
rem Expected default layout:
rem   workspace\BlastmasterOS
rem   workspace\BlastmasterOS-Dev-Environment

set "DEV_ENV_DIR=%~dp0"

if defined BLASTMASTEROS_SOURCE_DIR (
    set "OS_SOURCE_DIR=%BLASTMASTEROS_SOURCE_DIR%"
) else (
    for %%I in ("%DEV_ENV_DIR%..\BlastmasterOS") do set "OS_SOURCE_DIR=%%~fI"
)

if not exist "%OS_SOURCE_DIR%\CMakeLists.txt" (
    echo ERROR: BlastmasterOS source tree was not found.
    echo Expected: "%OS_SOURCE_DIR%"
    echo Clone BlastmasterOS beside this repository, or set BLASTMASTEROS_SOURCE_DIR.
    exit /b 1
)

if not exist "%OS_SOURCE_DIR%\configure.cmd" (
    echo ERROR: "%OS_SOURCE_DIR%\configure.cmd" is missing.
    echo This helper must use the configure script from the BlastmasterOS repository.
    exit /b 1
)

where cmake >nul 2>nul
if errorlevel 1 (
    echo ERROR: CMake was not found on PATH. Activate/install the build environment first.
    exit /b 1
)

where ninja >nul 2>nul
if errorlevel 1 (
    echo ERROR: Ninja was not found on PATH. Install it or activate the supported build environment.
    exit /b 1
)

if defined BLASTMASTEROS_BUILD_DIR (
    set "BUILD_DIR=%BLASTMASTEROS_BUILD_DIR%"
) else (
    set "BUILD_DIR=%DEV_ENV_DIR%build\BlastmasterOS"
)
set "BLASTMASTEROS_BUILD_DIR=%BUILD_DIR%"
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if errorlevel 1 (
    echo ERROR: Could not create build directory "%BUILD_DIR%".
    exit /b 1
)

pushd "%BUILD_DIR%"
if errorlevel 1 exit /b 1

echo.
echo === Configuring BlastmasterOS ===
echo Source: "%OS_SOURCE_DIR%"
echo Build:  "%BUILD_DIR%"
echo.

call "%OS_SOURCE_DIR%\configure.cmd" %*
if errorlevel 1 (
    echo.
    echo ERROR: BlastmasterOS configuration failed.
    popd
    exit /b 1
)

echo.
echo === Building BlastmasterOS ===
cmake --build . --parallel
set "BUILD_RESULT=%ERRORLEVEL%"

popd

if not "%BUILD_RESULT%"=="0" (
    echo.
    echo ERROR: BlastmasterOS build failed with exit code %BUILD_RESULT%.
    exit /b %BUILD_RESULT%
)

echo.
echo BlastmasterOS build completed successfully.
echo Build output: "%BUILD_DIR%"
echo.
echo To build a bootable ISO, run:
echo   cmake --build "%BUILD_DIR%" --target bootcd --parallel
exit /b 0
