param(
    [switch]$CLI,
    [string]$Mode,
    [string]$Theme,
    [switch]$Help
)

$scriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path $MyInvocation.MyCommand.Path -Parent }

. "$scriptPath/engine/themes.ps1"
. "$scriptPath/engine/helpers.ps1"
. "$scriptPath/engine/platform.ps1"
. "$scriptPath/engine/settings.ps1"
. "$scriptPath/engine/core.ps1"
. "$scriptPath/engine/learning_engine.ps1"

$userSettings = Get-Settings
$script:savedTheme = if ($Theme) { $Theme } else { $userSettings.theme }

Get-ChildItem "$scriptPath/modes" -Filter *.ps1 | ForEach-Object { . $_.FullName }

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
    @{ Id = "learning"; Name = "Tryb Nauki"; Desc = "Interaktywny symulator terminala (17 systemow)" }
)

$modeMap = @{}
foreach ($m in $modes) { $modeMap[$m.Id] = $m }

function Start-Mode {
    param([string]$Id, [string]$ThemeId)
    $mode = $modeMap[$Id]
    if (-not $mode) { Write-Host "Error: unknown mode '$Id'" -ForegroundColor Red; return }
    if (-not $ThemeId) { $ThemeId = $script:savedTheme }

    if ($Id -eq "learning") {
        $sys = Show-LearningSelector
        if ($sys) {
            $diff = Show-DifficultySelector $sys
            if ($diff) { Start-LearningMode -SystemId $sys.Id -Difficulty $diff.Id -ThemeId $ThemeId }
            elseif ($sys) { Start-LearningMode -SystemId $sys.Id -ThemeId $ThemeId }
        }
        return
    }

    $theme = Get-Theme $ThemeId
    $funcName = "Build-$($Id.ToUpper())COMMANDS"
    $func = Get-Item -LiteralPath "function:$funcName" -ErrorAction SilentlyContinue
    if (-not $func) { Write-Host "Error: mode function $funcName not found" -ForegroundColor Red; return }
    Start-TerminalSession -CommandBuilder ([scriptblock]::Create($funcName)) -Theme $theme -ModeName $mode.Name
}

function Show-GuiLauncher {
    param($modes)
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Ultra Matrix Terminal v2.0"
    $form.Size = New-Object Drawing.Size(820, 700)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [Drawing.Color]::FromArgb(8, 8, 8)
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false
    $form.KeyPreview = $true
    $form.Add_KeyDown({
        if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Escape) { $form.Close() }
    })

    $title = New-Object System.Windows.Forms.Label
    $title.Text = "ULTRA MATRIX TERMINAL"
    $title.Font = New-Object Drawing.Font("Consolas", 18, [Drawing.FontStyle]::Bold)
    $title.ForeColor = [Drawing.Color]::Lime
    $title.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $title.TextAlign = "MiddleCenter"
    $title.Size = New-Object Drawing.Size(780, 40)
    $title.Location = New-Object Drawing.Point(20, 15)
    $form.Controls.Add($title)

    $currentTheme = Get-Theme $script:savedTheme

    $themeLabel = New-Object System.Windows.Forms.Label
    $themeLabel.Text = "Theme: $($currentTheme.name)"
    $themeLabel.Font = New-Object Drawing.Font("Consolas", 9)
    $themeLabel.ForeColor = [Drawing.Color]::FromName($currentTheme.promptColor)
    $themeLabel.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $themeLabel.TextAlign = "MiddleLeft"
    $themeLabel.Size = New-Object Drawing.Size(200, 25)
    $themeLabel.Location = New-Object Drawing.Point(25, 55)
    $form.Controls.Add($themeLabel)

    $sub = New-Object System.Windows.Forms.Label
    $sub.Text = "Select a mode to launch"
    $sub.Font = New-Object Drawing.Font("Consolas", 10)
    $sub.ForeColor = [Drawing.Color]::Gray
    $sub.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $sub.TextAlign = "MiddleLeft"
    $sub.Size = New-Object Drawing.Size(300, 25)
    $sub.Location = New-Object Drawing.Point(230, 55)
    $form.Controls.Add($sub)

    $x = 25; $y = 95; $i = 0
    foreach ($m in $modes) {
        $themeEntry = $script:Themes[$m.Id]
        $themeColor = if ($themeEntry -and $themeEntry.promptColor) { $themeEntry.promptColor } else { "Gray" }
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = "$($m.Name)`n$($m.Desc)"
        $btn.Tag = $m.Id
        $btn.Size = New-Object Drawing.Size(240, 60)
        $btn.Location = New-Object Drawing.Point($x, $y)
        $btn.BackColor = [Drawing.Color]::FromArgb(18, 18, 18)
        $btn.ForeColor = [Drawing.Color]::$themeColor
        $btn.Font = New-Object Drawing.Font("Consolas", 8, [Drawing.FontStyle]::Bold)
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor = [Drawing.Color]::FromArgb(50, 50, 50)
        $btn.FlatAppearance.MouseOverBackColor = [Drawing.Color]::FromArgb(35, 35, 35)
        $btn.FlatAppearance.BorderSize = 1
        $btn.Cursor = [Windows.Forms.Cursors]::Hand
        $btn.TextAlign = "MiddleCenter"
        $btn.Add_Click({
            $script:selectedMode = $this.Tag
            $script:selectedTheme = $script:savedTheme
            $form.Close()
        })
        $form.Controls.Add($btn)

        $i++
        $x += 255
        if ($i % 3 -eq 0) { $x = 25; $y += 72 }
    }

    $ver = New-Object System.Windows.Forms.Label
    $ver.Text = "v2.0 | Escape to exit | github.com/SanTobinoOfficial/matrixhacker"
    $ver.Font = New-Object Drawing.Font("Consolas", 8)
    $ver.ForeColor = [Drawing.Color]::DarkGray
    $ver.BackColor = [Drawing.Color]::FromArgb(10, 10, 10)
    $ver.TextAlign = "MiddleCenter"
    $ver.Size = New-Object Drawing.Size(780, 20)
    $ver.Location = New-Object Drawing.Point(20, 620)
    $form.Controls.Add($ver)

    $form.ShowDialog() | Out-Null
}

function Show-ThemeSelector {
    param([array]$Themes, [string]$CurrentId)
    Write-Host "  --- Wybierz theme (kolory terminala) ---" -ForegroundColor Cyan
    $themeList = @()
    $idx = 0
    foreach ($t in $Themes) { $themeList += $t; $idx++ }
    $tnum = 1
    foreach ($t in $themeList) {
        $mark = if ($t.id -eq $CurrentId) { " <--" } else { "" }
        Write-Host "  [$("{0:D2}" -f $tnum)] $($t.name)$mark" -ForegroundColor $t.promptColor
        $tnum++
    }
    Write-Host ""
    Write-Host "  [Q] Nie zmieniaj" -ForegroundColor Red
    Write-Host ""
    $tchoice = Read-Host "Wybierz theme (1-$($themeList.Count))"
    if ($tchoice -eq 'q' -or $tchoice -eq 'Q') { return $CurrentId }
    $tnum = 0
    if ([int]::TryParse($tchoice, [ref]$tnum) -and $tnum -ge 1 -and $tnum -le $themeList.Count) {
        return $themeList[$tnum - 1].id
    }
    return $CurrentId
}

function Show-CliLauncher {
    param($modes)
    if ($modes.Count -eq 0) { Write-Host "No modes available." -ForegroundColor Red; return }
    $platform = Get-Platform
    $Host.UI.RawUI.BackgroundColor = "Black"
    Clear-Host

    $currentTheme = Get-Theme $script:savedTheme
    $tc = $currentTheme.promptColor
    $border = [char]0x2550; $tl = [char]0x2554; $tr = [char]0x2557
    $bl = [char]0x255A; $br = [char]0x255D; $vb = [char]0x2551
    $lm = [char]0x2560; $rm = [char]0x2563; $w = 60

    Write-Host ""
    Write-Host "  $tl$([string]$border * $w)$tr" -ForegroundColor Cyan
    Write-Host "  $vb$("  ULTRA MATRIX TERMINAL  v2.0".PadRight($w))$vb" -ForegroundColor Green
    Write-Host "  $vb$("  $platform  |  Theme: $($currentTheme.name)".PadRight($w))$vb" -ForegroundColor $tc
    Write-Host "  $lm$([string]$border * $w)$rm" -ForegroundColor Cyan

    # Category groups
    $groups = @(
        @{ Label = "  ENTERTAINMENT"; Color = "Green"; Ids = @("realistic","hollywood","cyberpunk","matrix","mrrobot") }
        @{ Label = "  SCENARIOS"; Color = "Yellow"; Ids = @("outage","pentest","sysadmin","heist") }
        @{ Label = "  ATMOSPHERE"; Color = "Magenta"; Ids = @("horror","polska","darkweb","ctf_mode") }
        @{ Label = "  SPECIALS"; Color = "Cyan"; Ids = @("screensaver","tutorial","learning") }
    )
    $modeMap2 = @{}
    foreach ($m in $modes) { $modeMap2[$m.Id] = $m }
    $idx = 1
    foreach ($grp in $groups) {
        Write-Host "  $vb$($grp.Label.PadRight($w))$vb" -ForegroundColor $grp.Color
        foreach ($id in $grp.Ids) {
            $m = $modeMap2[$id]
            if (-not $m) { continue }
            $line = "    [{0:D2}] {1,-22} {2}" -f $idx, $m.Name, $m.Desc
            Write-Host "  $vb$($line.PadRight($w))$vb" -ForegroundColor White
            $idx++
        }
    }
    Write-Host "  $lm$([string]$border * $w)$rm" -ForegroundColor Cyan
    Write-Host "  $vb$("  [T] Zmien theme   [Q] Wyjdz".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $bl$([string]$border * $w)$br" -ForegroundColor Cyan
    Write-Host ""
    $choice = Read-Host "  Wybierz tryb (1-$($modes.Length))"

    if ($choice -eq 'q' -or $choice -eq 'Q') { return }
    if ($choice -eq 't' -or $choice -eq 'T') {
        $allThemes = Get-AllThemes
        $newTheme = Show-ThemeSelector $allThemes $script:savedTheme
        if ($newTheme -ne $script:savedTheme) {
            Set-Setting "theme" $newTheme
            $script:savedTheme = $newTheme
        }
        Show-CliLauncher $modes
        return
    }

    # Build ordered list matching the display order
    $orderedIds = @()
    foreach ($grp in $groups) { foreach ($id in $grp.Ids) { if ($modeMap2[$id]) { $orderedIds += $id } } }
    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $orderedIds.Count) {
        Start-Mode $orderedIds[$num - 1] $script:savedTheme
    } elseif ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $modes.Length) {
        Start-Mode $modes[$num - 1].Id $script:savedTheme
    } else {
        Write-Host "  Nieprawidlowy wybor." -ForegroundColor Red
        Start-Sleep -Milliseconds 400
        Show-CliLauncher $modes
    }
}

if ($Help) {
    Write-Host "Ultra Matrix Terminal Launcher" -ForegroundColor Cyan
    Write-Host "USAGE: .\launcher.ps1 [options]" -ForegroundColor Gray
    Write-Host "  -CLI           Launch in CLI mode (no GUI)" -ForegroundColor Gray
    Write-Host "  -Mode <id>     Launch mode directly by ID" -ForegroundColor Gray
    Write-Host "  -Theme <id>    Use specific theme (default: saved in settings)" -ForegroundColor Gray
    Write-Host "  -Help          Show this help" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Available modes:" -ForegroundColor Yellow
    foreach ($m in $modes) { Write-Host "  $($m.Id.PadRight(14)) $($m.Name)" -ForegroundColor Green }
    Write-Host ""
    Write-Host "Available themes:" -ForegroundColor Yellow
    $allThemes = Get-AllThemes
    foreach ($t in $allThemes) { Write-Host "  $($t.id.PadRight(20)) $($t.name)" -ForegroundColor $t.promptColor }
    return
}

if ($Mode) {
    if (-not $modeMap.ContainsKey($Mode)) { Write-Host "Unknown mode: $Mode" -ForegroundColor Red; return }
    Start-Mode $Mode $script:savedTheme
    return
}

$platform = Get-Platform
if (-not $CLI -and $platform -eq "Windows") {
    $script:selectedMode = $null
    $script:selectedTheme = $script:savedTheme
    try { Show-GuiLauncher $modes } catch { }
    if ($script:selectedMode) {
        Start-Mode $script:selectedMode $script:selectedTheme
    }
    return
}

Show-CliLauncher $modes
