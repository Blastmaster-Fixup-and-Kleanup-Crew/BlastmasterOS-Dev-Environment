::
:: PROJECT:     RosBE - BlastmasterOS Dev Environment for Windows
:: LICENSE:     GNU General Public License v2. (see LICENSE.txt)
:: FILE:        Root/Clean.cmd
:: PURPOSE:     Clean generated BlastmasterOS build outputs.
:: COPYRIGHT:   Copyright 2026 Daniel Reimer <reimer.daniel@freenet.de>
::                             Peter Ward <dralnix@gmail.com>
::                             Colin Finck <colin@reactos.org>
::

@echo off
if not defined _ROSBE_DEBUG set _ROSBE_DEBUG=0
if %_ROSBE_DEBUG% == 1 (
    @echo on
)

setlocal enabledelayedexpansion
title Cleaning...

set ROS_CMAKE_BUILD=%BLASTMASTEROS_BUILD_DIR%

if "%1" == "" (
    call :BIN
) else if /i "%1" == "logs" (
    call :LOG
) else if /i "%1" == "all" (
    call :BIN
) else (
    call :MODULE %*
)
goto :EOC

:MODULE
    if "%1" == "" goto :EOF
    call "%_ROSBE_BASEDIR%\Make.cmd" %1_clean
    shift /1
    echo.
    GOTO :MODULE %*

:: Check if we have any logs to clean, if so, clean them.
:LOG
if exist "%ROS_CMAKE_BUILD%\%_ROSBE_LOGDIR%\*.txt" (
    echo Cleaning build logs...
    del /f "%ROS_CMAKE_BUILD%\%_ROSBE_LOGDIR%\*.txt" 1> NUL 2> NUL
    echo Done cleaning build logs.
) else (
    echo ERROR: There are no logs to clean.
)
goto :EOF


:: Check if we have any binaries to clean, if so, clean them.
:BIN
:: Clean the configured BlastmasterOS CMake build directory.
:: Consider that we also want to clean half-complete builds, so don't depend on too many existing files.

if "%ROS_CMAKE_BUILD%" == "" goto :NOBUILD
if exist "%ROS_CMAKE_BUILD%\CMakeCache.txt" (
    echo Cleaning BlastmasterOS build outputs...
    cmake --build "%ROS_CMAKE_BUILD%" --target clean
    if errorlevel 1 echo ERROR: BlastmasterOS clean failed.
) else (
    echo ERROR: BlastmasterOS CMake build directory was not found.
    echo Set BLASTMASTEROS_BUILD_DIR or run build-blastmasteros.cmd first.
)
goto :EOF

:NOBUILD
echo ERROR: BLASTMASTEROS_BUILD_DIR is not set.
echo Set it to the configured BlastmasterOS CMake build directory.
goto :EOF

:EOC
title BlastmasterOS Dev Environment %_ROSBE_VERSION%
endlocal
