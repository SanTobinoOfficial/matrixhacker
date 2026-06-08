# =====================================================================
# ULTRA MATRIX TERMINAL — Launcher (WinForms GUI + CLI fallback)
# =====================================================================
param(
    [switch]$CLI,
    [string]$Mode,
    [switch]$Help
)

$scriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path $MyInvocation.MyCommand.Path -Parent }

# Source engine
. "$scriptPath\engine\themes.ps1"
. "$scriptPath\engine\helpers.ps1"
. "$scriptPath\engine\core.ps1"

# Source all modes silently
Get-ChildItem "$scriptPath\modes" -Filter *.ps1 | ForEach-Object { . $_.FullName }

$modes = @(
    @{ Id = "realistic"; Name = "Realistic Terminal"; Desc = "Authentic Linux terminal session" }
    @{ Id = "hollywood"; Name = "Hollywood Hacker"; Desc = "Hollywood-style hacking simulation" }
    @{ Id = "cyberpunk"; Name = "Cyberpunk 2077"; Desc = "Netrunner in Night City" }
    @{ Id = "matrix"; Name = "The Matrix"; Desc = "Wake up, Neo..." }
    @{ Id = "mrrobot"; Name = "Mr. Robot"; Desc = "F Society strikes again" }
    @{ Id = "outage"; Name = "Production Outage"; Desc = "Handle a SEV-1 incident" }
    @{ Id = "tutorial"; Name = "Linux Tutorial"; Desc = "Learn Linux basics interactively" }
    @{ Id = "pentest"; Name = "Pentest Report"; Desc = "Penetration testing simulation" }
    @{ Id = "sysadmin"; Name = "SysAdmin Simulator"; Desc = "Manage servers and backups" }
    @{ Id = "heist"; Name = "Data Heist"; Desc = "Steal data, cover your tracks" }
    @{ Id = "horror"; Name = "Horror Terminal"; Desc = "Something is watching you" }
    @{ Id = "polska"; Name = "Polska Hacker"; Desc = "Polski hacker w akcji" }
    @{ Id = "darkweb"; Name = "Dark Web"; Desc = "Navigate the darknet" }
    @{ Id = "ctf_mode"; Name = "CTF Challenge"; Desc = "Find the hidden flag" }
    @{ Id = "screensaver"; Name = "Matrix Screensaver"; Desc = "Infinite Matrix rain" }
)

if ($Help) {
    Write-Host "Ultra Matrix Terminal Launcher" -ForegroundColor Cyan
    Write-Host "USAGE: .\launcher.ps1 [options]" -ForegroundColor Gray
    Write-Host "  -CLI           Launch in CLI mode (no GUI)" -ForegroundColor Gray
    Write-Host "  -Mode <id>     Launch mode directly by ID" -ForegroundColor Gray
    Write-Host "  -Help          Show this help" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Available modes:" -ForegroundColor Yellow
    foreach ($m in $modes) { Write-Host "  $($m.Id.PadRight(14)) $($m.Name)" -ForegroundColor Green }
    return
}

$modeMap = @{}
foreach ($m in $modes) { $modeMap[$m.Id] = $m }

if ($Mode) {
    if (-not $modeMap.ContainsKey($Mode)) { Write-Host "Unknown mode: $Mode" -ForegroundColor Red; return }
    $info = $modeMap[$Mode]
    $theme = Get-Theme $Mode
    $funcName = "Build-$($Mode.ToUpper())COMMANDS"
    $func = Get-Item -LiteralPath "function:$funcName" -ErrorAction SilentlyContinue
    if (-not $func) { Write-Host "Error: mode function $funcName not found" -ForegroundColor Red; return }
    Start-TerminalSession -CommandBuilder ([scriptblock]::Create("`$function:$funcName")) -Theme $theme -ModeName $info.Name
    return
}

if (-not $CLI) {
    try { Show-GuiLauncher $modes; return } catch { }
}

Show-CliLauncher $modes

function Show-GuiLauncher {
    param($modes)
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Ultra Matrix Terminal"
    $form.Size = New-Object Drawing.Size(820, 620)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false

    $title = New-Object System.Windows.Forms.Label
    $title.Text = "ULTRA MATRIX TERMINAL"
    $title.Font = New-Object Drawing.Font("Consolas", 18, [Drawing.FontStyle]::Bold)
    $title.ForeColor = [Drawing.Color]::Lime
    $title.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $title.TextAlign = "MiddleCenter"
    $title.Size = New-Object Drawing.Size(780, 40)
    $title.Location = New-Object Drawing.Point(20, 15)
    $form.Controls.Add($title)

    $sub = New-Object System.Windows.Forms.Label
    $sub.Text = "Select a terminal mode to launch"
    $sub.Font = New-Object Drawing.Font("Consolas", 10)
    $sub.ForeColor = [Drawing.Color]::Gray
    $sub.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $sub.TextAlign = "MiddleCenter"
    $sub.Size = New-Object Drawing.Size(780, 25)
    $sub.Location = New-Object Drawing.Point(20, 55)
    $form.Controls.Add($sub)

    $x = 25; $y = 95; $i = 0
    foreach ($m in $modes) {
        $themeColor = $script:Themes[$m.Id].promptColor
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = "$($m.Name)"
        $btn.Size = New-Object Drawing.Size(240, 55)
        $btn.Location = New-Object Drawing.Point($x, $y)
        $btn.BackColor = [Drawing.Color]::FromArgb(20, 20, 20)
        $btn.ForeColor = [Drawing.Color]::$themeColor
        $btn.Font = New-Object Drawing.Font("Consolas", 9, [Drawing.FontStyle]::Bold)
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor = [Drawing.Color]::FromArgb(60, 60, 60)
        $btn.FlatAppearance.MouseOverBackColor = [Drawing.Color]::FromArgb(40, 40, 40)
        $btn.Cursor = [Windows.Forms.Cursors]::Hand
        $id = $m.Id
        $btn.Add_Click({ Start-Mode $id })
        $form.Controls.Add($btn)

        $i++
        $x += 255
        if ($i % 3 -eq 0) { $x = 25; $y += 70 }
    }

    $ver = New-Object System.Windows.Forms.Label
    $ver.Text = "v2.0 | Escape to exit any session | github.com/ultra-matrix-terminal"
    $ver.Font = New-Object Drawing.Font("Consolas", 8)
    $ver.ForeColor = [Drawing.Color]::DarkGray
    $ver.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $ver.TextAlign = "MiddleCenter"
    $ver.Size = New-Object Drawing.Size(780, 20)
    $ver.Location = New-Object Drawing.Point(20, 540)
    $form.Controls.Add($ver)

    $form.ShowDialog() | Out-Null
}

function Start-Mode {
    param([string]$Id)
    $mode = $modeMap[$Id]
    $theme = Get-Theme $Id
    $funcName = "Build-$($Id.ToUpper())COMMANDS"
    $func = Get-Item -LiteralPath "function:$funcName" -ErrorAction SilentlyContinue
    if (-not $func) { [System.Windows.Forms.MessageBox]::Show("Mode function not found: $funcName", "Error") | Out-Null; return }
    Start-TerminalSession -CommandBuilder ([scriptblock]::Create("`$function:$funcName")) -Theme $theme -ModeName $mode.Name
}

function Show-CliLauncher {
    param($modes)
    $Host.UI.RawUI.BackgroundColor = "Black"
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   ULTRA MATRIX TERMINAL" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    $i = 1
    foreach ($m in $modes) {
        $num = "$i".PadLeft(2)
        Write-Host "  [$num] $($m.Name)" -ForegroundColor Yellow
        Write-Host "        $($m.Desc)" -ForegroundColor Gray
        $i++
    }
    Write-Host ""
    Write-Host "  [Q] Quit" -ForegroundColor Red
    Write-Host ""
    $choice = Read-Host "Select mode (1-$($modes.Length))"

    if ($choice -eq 'q' -or $choice -eq 'Q') { return }

    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $modes.Length) {
        $mode = $modes[$num - 1]
        $theme = Get-Theme $mode.Id
        $funcName = "Build-$($mode.Id.ToUpper())COMMANDS"
        $func = Get-Item -LiteralPath "function:$funcName" -ErrorAction SilentlyContinue
        if (-not $func) { Write-Host "Error: mode function not found: $funcName" -ForegroundColor Red; return }
        Start-TerminalSession -CommandBuilder ([scriptblock]::Create("`$function:$funcName")) -Theme $theme -ModeName $mode.Name
    } else {
        Write-Host "Invalid choice." -ForegroundColor Red
        Start-Sleep -Milliseconds 500
        Show-CliLauncher $modes
    }
}
