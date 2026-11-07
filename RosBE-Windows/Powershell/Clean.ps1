#
# PROJECT:     RosBE - BlastmasterOS Dev Environment for Windows
# LICENSE:     GNU General Public License v2. (see LICENSE.txt)
# FILE:        Root/Clean.ps1
# PURPOSE:     Clean generated BlastmasterOS build outputs.
# COPYRIGHT:   Copyright 2026 Daniel Reimer <reimer.daniel@freenet.de>
#

$host.ui.RawUI.WindowTitle = "Cleaning..."

function remlog {
    # Check if we have any logs to clean, if so, clean them.
    if (Test-Path "$ENV:ROS_CMAKE_BUILD\$_ROSBE_LOGDIR") {
        "Cleaning build logs..."
        $null = (Remove-Item -path "$ENV:ROS_CMAKE_BUILD\$_ROSBE_LOGDIR\*.txt" -force)
        "Done cleaning build logs."
    } else {
        throw {"ERROR: There are no logs to clean."}
    }
}

function rembin {
    # Check if we have any binaries to clean, if so, clean them.

    if ($ENV:ROS_CMAKE_BUILD -and (Test-Path (Join-Path $ENV:ROS_CMAKE_BUILD "CMakeCache.txt"))) {
        "Cleaning BlastmasterOS build outputs..."
        cmake --build "$ENV:ROS_CMAKE_BUILD" --target clean
        if ($LASTEXITCODE -ne 0) { throw "ERROR: BlastmasterOS clean failed." }
    } else {
        throw "ERROR: BlastmasterOS CMake build directory was not found. Set BLASTMASTEROS_BUILD_DIR or run build-blastmasteros first."
    }
}

function end {
    $host.ui.RawUI.WindowTitle = "BlastmasterOS Dev Environment $_ROSBE_VERSION"
    exit
}

$ENV:ROS_CMAKE_BUILD = $ENV:BLASTMASTEROS_BUILD_DIR

if ("$args" -eq "") {
    rembin
}
elseif ("$args" -eq "logs") {
    remlog
}
elseif ("$args" -eq "all") {
    rembin
}
elseif ("$args" -ne "") {
    $argindex = 0
    while ( "$($args[$argindex])" -ne "") {
        $cl = "$($args[$argindex])" + "_clean"
        make $cl
        $argindex += 1
    }
    remove-variable cl
}
end
