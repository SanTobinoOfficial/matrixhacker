# =====================================================================
# Ultra Matrix Terminal — One-liner Installer
# Run: irm https://raw.githubusercontent.com/<user>/ultra-matrix-terminal/main/install.ps1 | iex
# =====================================================================

$repoOwner = "SanTobinoOfficial"
$repoName = "matrixhacker"
$branch = "main"
$installDir = "$env:LOCALAPPDATA\UltraMatrixTerminal"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ULTRA MATRIX TERMINAL INSTALLER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] Some features (PATH, shortcut) may require admin." -ForegroundColor Yellow
    Write-Host "    Run PowerShell as Administrator for full setup." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "[*] Installing Ultra Matrix Terminal..." -ForegroundColor Gray
Write-Host "[*] Target: $installDir" -ForegroundColor Gray

# Create install directory
if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }

# Download repo as zip
$zipUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$branch.zip"
$zipPath = "$env:TEMP\ultra-matrix-terminal.zip"

try {
    Write-Host "[*] Downloading from $zipUrl ..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Host "[!] Download failed: $_" -ForegroundColor Red
    Write-Host "[!] Check your internet connection and try again." -ForegroundColor Yellow
    Write-Host "    URL attempted: $zipUrl" -ForegroundColor Yellow
    exit 1
}

if (Test-Path $zipPath) {
    Write-Host "[*] Extracting..." -ForegroundColor Gray
    if (Get-Command "Expand-Archive" -ErrorAction SilentlyContinue) {
        $tempExtract = "$env:TEMP\umt-extract"
        if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
        Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force
        $extracted = Get-ChildItem "$tempExtract\$repoName-$branch" -ErrorAction SilentlyContinue
        if ($extracted) {
            Copy-Item "$tempExtract\$repoName-$branch\*" $installDir -Recurse -Force
            Remove-Item $tempExtract -Recurse -Force
        }
    } else {
        $shell = New-Object -ComObject Shell.Application
        $zip = $shell.NameSpace($zipPath)
        $dest = $shell.NameSpace($installDir)
        $dest.CopyHere($zip.Items(), 16)
    }
    Remove-Item $zipPath -Force
}

# Create desktop shortcut
try {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktop\Ultra Matrix Terminal.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$installDir\launcher.ps1`""
    $shortcut.WorkingDirectory = $installDir
    $shortcut.Description = "Ultra Matrix Terminal Launcher"
    $shortcut.Save()
    Write-Host "[+] Desktop shortcut created." -ForegroundColor Green
} catch {
    Write-Host "[!] Could not create desktop shortcut: $_" -ForegroundColor Yellow
}

# Add to PATH
try {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$installDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$installDir", "User")
        Write-Host "[+] Added to PATH (restart terminal to use 'ultra-matrix' command)." -ForegroundColor Green
    }
} catch {
    Write-Host "[!] Could not add to PATH: $_" -ForegroundColor Yellow
}

# Create wrapper script
$wrapperPath = "$installDir\ultra-matrix.cmd"
@"
@echo off
powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\UltraMatrixTerminal\launcher.ps1" %*
"@ | Out-File -FilePath $wrapperPath -Encoding ascii
Write-Host "[+] Wrapper script created: $wrapperPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Launch via:  .\launcher.ps1" -ForegroundColor Yellow
Write-Host "  Desktop:     Ultra Matrix Terminal shortcut" -ForegroundColor Yellow
Write-Host "  CLI:         launcher.ps1 -CLI" -ForegroundColor Yellow
Write-Host "  Direct:      launcher.ps1 -Mode realistic" -ForegroundColor Yellow
Write-Host "  Help:        launcher.ps1 -Help" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Press any key to launch now..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

& "$installDir\launcher.ps1"
