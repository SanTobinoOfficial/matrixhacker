$repoOwner = "SanTobinoOfficial"
$repoName = "matrixhacker"
$branch = "main"

function Get-InstallerPlatform {
    if ($IsWindows) { return "Windows" }
    if ($IsMacOS) { return "macOS" }
    if ($IsLinux) { return "Linux" }
    if ($env:OS -match "Windows") { return "Windows" }
    $p = [System.Environment]::OSVersion.Platform
    if ($p -eq [System.PlatformID]::Unix) { return "Linux" }
    if ($p -eq 6) { return "macOS" }
    return "Unix"
}

$p = Get-InstallerPlatform
$isWin = $p -eq "Windows"
$installDir = if ($isWin) { "$env:LOCALAPPDATA\UltraMatrixTerminal" } else { "$env:HOME/.local/share/ultra-matrix-terminal" }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ULTRA MATRIX TERMINAL INSTALLER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($isWin) {
    try {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Host "[!] Some features (PATH, shortcut) may require admin." -ForegroundColor Yellow
            Write-Host "    Run PowerShell as Administrator for full setup." -ForegroundColor Yellow
            Write-Host ""
        }
    } catch { }
}

Write-Host "[*] Installing Ultra Matrix Terminal on $p ..." -ForegroundColor Gray
Write-Host "[*] Target: $installDir" -ForegroundColor Gray

if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }

$zipUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$branch.zip"
$zipPath = [System.IO.Path]::GetTempPath() + "ultra-matrix-terminal.zip"

try {
    Write-Host "[*] Downloading from $zipUrl ..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Host "[!] Download failed: $_" -ForegroundColor Red
    Write-Host "[!] Check your internet connection and try again." -ForegroundColor Yellow
    Write-Host "    URL: $zipUrl" -ForegroundColor Yellow
    exit 1
}

if (Test-Path $zipPath) {
    Write-Host "[*] Extracting..." -ForegroundColor Gray
    $tempExtract = [System.IO.Path]::GetTempPath() + "umt-extract"
    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
    Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force
    $extracted = Get-ChildItem "$tempExtract/$repoName-$branch" -ErrorAction SilentlyContinue
    if ($extracted) {
        Copy-Item "$tempExtract/$repoName-$branch/*" $installDir -Recurse -Force
        Remove-Item $tempExtract -Recurse -Force
    } else {
        Write-Host "[!] Extraction path mismatch. Trying fallback..." -ForegroundColor Yellow
        $topDir = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
        if ($topDir) {
            Copy-Item "$($topDir.FullName)/*" $installDir -Recurse -Force
            Remove-Item $tempExtract -Recurse -Force
        }
    }
    Remove-Item $zipPath -Force
}

$launcherPath = if ($isWin) { "$installDir\launcher.ps1" } else { "$installDir/launcher.ps1" }

# Source platform module for platform utilities
. "$installDir/engine/platform.ps1"

# Desktop shortcut
$shortcutOK = New-DesktopShortcut -InstallDir $installDir -LauncherPath $launcherPath
if ($shortcutOK) {
    if ($isWin) { Write-Host "[+] Desktop shortcut created." -ForegroundColor Green }
    else { Write-Host "[+] Desktop launcher created." -ForegroundColor Green }
} else {
    Write-Host "[!] Could not create desktop launcher." -ForegroundColor Yellow
}

# Add to PATH
$pathOK = Add-ToPath $installDir
if ($pathOK) {
    Write-Host "[+] Added to PATH (restart terminal to use 'ultra-matrix' command)." -ForegroundColor Green
} else {
    Write-Host "[!] Could not add to PATH." -ForegroundColor Yellow
}

# Wrapper script
$wrapperPath = New-WrapperScript -InstallDir $installDir -LauncherPath $launcherPath
Write-Host "[+] Wrapper script: $wrapperPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Launch via:  $launcherPath" -ForegroundColor Yellow
if ($shortcutOK) {
    if ($isWin) { Write-Host "  Desktop:     Ultra Matrix Terminal shortcut" -ForegroundColor Yellow }
    else { Write-Host "  Desktop:     ultra-matrix-terminal.desktop" -ForegroundColor Yellow }
}
Write-Host "  CLI:         $launcherPath -CLI" -ForegroundColor Yellow
Write-Host "  Direct:      $launcherPath -Mode realistic" -ForegroundColor Yellow
Write-Host "  Help:        $launcherPath -Help" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Press any key to launch now..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey([System.Management.Automation.Host.ReadKeyOptions]::NoEcho -bor [System.Management.Automation.Host.ReadKeyOptions]::IncludeKeyDown)

& $launcherPath
