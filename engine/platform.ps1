function Get-Platform {
    if ($IsWindows) { return "Windows" }
    if ($IsMacOS) { return "macOS" }
    if ($IsLinux) { return "Linux" }
    if ($env:OS -match "Windows") { return "Windows" }
    $p = [System.Environment]::OSVersion.Platform
    if ($p -eq [System.PlatformID]::Unix) { return "Linux" }
    if ($p -eq 6) { return "macOS" }
    return "Unix"
}

function Get-InstallDir {
    $p = Get-Platform
    if ($p -eq "Windows") { return "$env:LOCALAPPDATA\UltraMatrixTerminal" }
    else { return "$env:HOME/.local/share/ultra-matrix-terminal" }
}

function Get-DesktopPath {
    return [Environment]::GetFolderPath("Desktop")
}

function New-DesktopShortcut {
    param([string]$InstallDir, [string]$LauncherPath)
    $p = Get-Platform
    if ($p -eq "Windows") {
        try {
            $desktop = Get-DesktopPath
            $shell = New-Object -ComObject WScript.Shell
            $s = $shell.CreateShortcut("$desktop\Ultra Matrix Terminal.lnk")
            $s.TargetPath = "powershell.exe"
            $s.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$LauncherPath`""
            $s.WorkingDirectory = $InstallDir
            $s.Description = "Ultra Matrix Terminal Launcher"
            $s.Save()
            return $true
        } catch { return $false }
    } elseif ($p -eq "Linux") {
        try {
            $desktop = Get-DesktopPath
            $content = @"
[Desktop Entry]
Type=Application
Name=Ultra Matrix Terminal
Comment=15 cinematic terminal simulation modes
Exec=pwsh -NoExit -ExecutionPolicy Bypass -File "$LauncherPath"
Icon=$InstallDir/assets/icon.png
Terminal=true
Categories=Utility;System;
"@
            $content | Out-File "$desktop/ultra-matrix-terminal.desktop" -Encoding utf8
            bash -c "chmod +x '$desktop/ultra-matrix-terminal.desktop'" 2>$null
            return $true
        } catch { return $false }
    } elseif ($p -eq "macOS") {
        try {
            $desktop = Get-DesktopPath
            $content = @"
#!/bin/bash
pwsh -NoExit -ExecutionPolicy Bypass -File "$LauncherPath"
"@
            $content | Out-File "$desktop/Ultra Matrix Terminal.command" -Encoding utf8
            bash -c "chmod +x '$desktop/Ultra Matrix Terminal.command'" 2>$null
            return $true
        } catch { return $false }
    }
}

function Add-ToPath {
    param([string]$InstallDir)
    $p = Get-Platform
    if ($p -eq "Windows") {
        try {
            $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
            if ($currentPath -notlike "*$InstallDir*") {
                [Environment]::SetEnvironmentVariable("Path", "$currentPath;$InstallDir", "User")
                return $true
            }
        } catch { }
    } else {
        try {
            $profileFile = if ($p -eq "macOS") { "$env:HOME/.zshrc" } else { "$env:HOME/.bashrc" }
            $line = "export PATH=`"`$PATH:$InstallDir`""
            if (Test-Path $profileFile) {
                $content = Get-Content $profileFile -Raw
                if ($content -notmatch [regex]::Escape($InstallDir)) {
                    Add-Content $profileFile "`n$line"
                }
            } else {
                $line | Out-File $profileFile -Encoding utf8
            }
            return $true
        } catch { return $false }
    }
}

function New-WrapperScript {
    param([string]$InstallDir, [string]$LauncherPath)
    $p = Get-Platform
    if ($p -eq "Windows") {
        $path = "$InstallDir\ultra-matrix.cmd"
        @"
@echo off
powershell -ExecutionPolicy Bypass -File "$InstallDir\launcher.ps1" %*
"@ | Out-File $path -Encoding ascii
    } else {
        $path = "$InstallDir/ultra-matrix"
        @(
            "#!/usr/bin/env pwsh",
            "# Ultra Matrix Terminal - cross-platform launcher",
            "& '$LauncherPath' @args"
        ) -join "`n" | Out-File $path -Encoding utf8
        bash -c "chmod +x '$path'" 2>$null
    }
    return $path
}
