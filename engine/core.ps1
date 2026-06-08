# =====================================================================
# CORE ENGINE — Matrix-Rain, Type-Command, Show-Output, Session Loop
# =====================================================================

# =====================================================================
# MATRIX-RAIN v3 — multi-style, overlay typing, batch rendering
# =====================================================================
function Matrix-Rain {
    param([int]$DurationSeconds = 20, [switch]$Infinite, [hashtable]$Theme)

    $width = $Host.UI.RawUI.WindowSize.Width
    $height = $Host.UI.RawUI.WindowSize.Height
    if ($width -lt 40) { $width = 80 }
    if ($height -lt 10) { $height = 25 }

    $chars = if ($Theme.chars) { $Theme.chars } else { "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+=" }
    $overlayMsgs = if ($Theme.overlayMsgs) { $Theme.overlayMsgs } else { @("ACCESS GRANTED") }

    function Show-OverlayTyped {
        param([string]$Msg, [int]$X, [int]$Y, [string]$Color)
        $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($X, $Y)
        for ($oi = 0; $oi -lt $Msg.Length; $oi++) {
            Write-Host -NoNewline $Msg[$oi] -ForegroundColor $Color
            Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 60)
            if ([Console]::KeyAvailable) { $k = [Console]::ReadKey($true); if ($k.Key -eq "Escape") { return $true } }
        }
        return $false
    }

    $drops = @()
    for ($i = 0; $i -lt $width; $i++) {
        $drops += @{ x = $i; y = Get-Random -Minimum -$height -Maximum 0; speed = Get-Random -Minimum 1 -Maximum 4; length = Get-Random -Minimum 8 -Maximum 30 }
    }

    $lastFrame = @{}
    $startTime = Get-Date
    $overlayTimer = 0

    while ($true) {
        if (-not $Infinite -and ((Get-Date) - $startTime).TotalSeconds -gt $DurationSeconds) { break }
        if ([Console]::KeyAvailable) { $k = [Console]::ReadKey($true); if ($k.Key -eq "Escape") { return } }

        $overlayTimer++
        $overlayChance = if ($Infinite) { 50 } else { 80 }
        $showOverlay = ($overlayTimer -ge 15 -and (Get-Random -Maximum $overlayChance) -eq 0)
        if ($showOverlay) { $overlayTimer = 0 }

        $overlayInfo = $null
        if ($showOverlay -and $overlayMsgs.Length -gt 0 -and $overlayMsgs[0] -ne "") {
            $msg = $overlayMsgs[(Get-Random -Maximum $overlayMsgs.Length)]
            $ox = Get-Random -Minimum 2 -Maximum ($width - $msg.Length - 2)
            $oy = Get-Random -Minimum 3 -Maximum ($height - 4)
            $oColor = if ($msg -match "ERROR|WARNING|fault|broni|zabroniony|DONT|RUN|BEHIND") { "Red" } elseif ($msg -match "GRANTED|SHELL|OPEN|ESTABLISHED|RCE|nawiazane|zainstalowany|WHITE|RED PILL") { "Cyan" } else { "Yellow" }
            $overlayInfo = @{ x = $ox; y = $oy; msg = $msg; color = $oColor }
        }

        $currentFrame = @{}
        for ($i = 0; $i -lt $drops.Length; $i++) {
            $col = $drops[$i]
            $eraseY = $col.y - $col.length
            if ($eraseY -ge 0 -and $eraseY -lt $height) {
                $currentFrame["$i,$eraseY"] = @{ char = " "; color = "Black" }
            }
            $col.y += $col.speed
            for ($t = 0; $t -le [Math]::Min(6, $col.length); $t++) {
                $ty = $col.y - $t
                if ($ty -ge 0 -and $ty -lt $height) {
                    $c = $chars[(Get-Random -Maximum $chars.Length)]
                    $colColor = switch ($t) {
                        0 { if ((Get-Random -Maximum 6) -eq 0) { $Theme.matrixHead } else { $Theme.matrixBright } }
                        1 { $Theme.matrixBody }
                        default { $Theme.matrixTail }
                    }
                    $currentFrame["$i,$ty"] = @{ char = $c; color = $colColor }
                }
            }
            if ($col.y -gt $height + $col.length) {
                $drops[$i] = @{ x = $i; y = Get-Random -Minimum -$height -Maximum 0; speed = Get-Random -Minimum 1 -Maximum 4; length = Get-Random -Minimum 8 -Maximum 30 }
            }
        }

        $dirtyKeys = @{}
        foreach ($k in $currentFrame.Keys) {
            if (-not $lastFrame.ContainsKey($k)) { $dirtyKeys[$k] = $true; continue }
            if ($currentFrame[$k].char -ne $lastFrame[$k].char -or $currentFrame[$k].color -ne $lastFrame[$k].color) { $dirtyKeys[$k] = $true }
        }
        foreach ($k in $lastFrame.Keys) { if (-not $currentFrame.ContainsKey($k)) { $dirtyKeys[$k] = $true } }

        $dirtyByY = @{}
        foreach ($k in $dirtyKeys.Keys) {
            $parts = $k.Split(','); $xi = [int]$parts[0]; $yi = [int]$parts[1]
            if (-not $dirtyByY.ContainsKey($yi)) { $dirtyByY[$yi] = @() }
            $dirtyByY[$yi] += $xi
        }
        foreach ($yi in ($dirtyByY.Keys | Sort-Object)) {
            foreach ($xi in ($dirtyByY[$yi] | Sort-Object -Unique)) {
                $entry = $currentFrame["$xi,$yi"]
                $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($xi, $yi)
                if ($entry) { Write-Host -NoNewline $entry.char -ForegroundColor $entry.color }
                else { Write-Host -NoNewline " " -ForegroundColor Black }
            }
        }
        if ($overlayInfo) {
            if (Show-OverlayTyped -Msg $overlayInfo.msg -X $overlayInfo.x -Y $overlayInfo.y -Color $overlayInfo.color) { return }
            for ($oi = 0; $oi -lt $overlayInfo.msg.Length; $oi++) {
                $currentFrame["$($overlayInfo.x + $oi),$($overlayInfo.y)"] = @{ char = $overlayInfo.msg[$oi]; color = $overlayInfo.color }
            }
        }
        $lastFrame = $currentFrame
        Start-Sleep -Milliseconds 33
    }
}

# =====================================================================
# TYPE-COMMAND — realistic typing with typos and corrections
# =====================================================================
function Type-Command {
    param([string]$Text)
    $mistakeAt = -1
    $hasTypo = $Text.Length -gt 6 -and (Rand 0 10) -lt 3
    if ($hasTypo) { $mistakeAt = Rand 3 ([Math]::Min($Text.Length - 2, 15)) }

    for ($i = 0; $i -lt $Text.Length; $i++) {
        if ([Console]::KeyAvailable) {
            $k = [Console]::ReadKey($true)
            if ($k.Key -eq "Escape") { return $true }
            if ($k.Key -eq "Enter") { return $false }
        }

        $ch = $Text[$i]

        if ($i -eq $mistakeAt) {
            $wrong = $Text[$i + 1]
            if ($wrong -eq $ch) { $wrong = if ($ch -eq 'a') { 'x' } else { 'a' } }
            Write-Host -NoNewline $wrong -ForegroundColor White
            Start-Sleep -Milliseconds 180

            $pos = $Host.UI.RawUI.CursorPosition
            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
            Write-Host -NoNewline " " -ForegroundColor White
            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
            Start-Sleep -Milliseconds 120
        }

        Write-Host -NoNewline $ch -ForegroundColor White

        $speed = if ($i -eq $mistakeAt) { 60 } elseif ($ch -match '[\s/\.-]') { Rand 30 80 } elseif ($i -lt 3) { Rand 50 120 } else { Rand 8 45 }
        Start-Sleep -Milliseconds $speed

        if ($i -lt $Text.Length - 1 -and $ch -eq ' ' -and (Rand 0 8) -eq 0) {
            Start-Sleep -Milliseconds 250
        }
    }
    return $false
}

# =====================================================================
# SHOW-OUTPUT — colored output with ls emulation and pager
# =====================================================================
function Show-Output {
    param([string[]]$Lines, [hashtable]$Theme, [switch]$NoPager)

    $lineCount = $Lines.Length
    $termHeight = $Host.UI.RawUI.WindowSize.Height
    $linesPrinted = 0
    $accent = if ($Theme) { $Theme.accent } else { "Cyan" }

    foreach ($line in $Lines) {
        if ([Console]::KeyAvailable) {
            $k = [Console]::ReadKey($true)
            if ($k.Key -eq "Escape") { return }
        }

        # Pager for long output
        $linesPrinted++
        if (-not $NoPager -and $lineCount -gt 8 -and $linesPrinted -gt ($termHeight - 3) -and $linesPrinted -lt $lineCount) {
            $pct = [Math]::Floor(($linesPrinted / $lineCount) * 100)
            Write-Host "--More--($pct%)--" -NoNewline -ForegroundColor Gray
            $pagerWait = $true
            while ($pagerWait) {
                if ([Console]::KeyAvailable) {
                    $pk = [Console]::ReadKey($true)
                    if ($pk.Key -eq "Escape") { return }
                    $pagerWait = $false
                }
                Start-Sleep -Milliseconds 30
            }
            $pos = $Host.UI.RawUI.CursorPosition
            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(0, $pos.Y)
            Write-Host (" " * 30) -NoNewline
            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(0, $pos.Y)
            $linesPrinted = 0
        }

        $color = "Green"
        if ([string]::IsNullOrEmpty($line)) { $color = "Green" }
        elseif ($line -match "error|fail|denied|fault|refused|not found|broni|nie znaleziono") { $color = "Red" }
        elseif ($line -match "success|granted|\[\+\]|\[\*\]|established|connected|open|OK|200|ESTABLISHED") { $color = $accent }
        elseif ($line -match "warning|warn|HINT|TIP") { $color = "Yellow" }
        elseif ($line -match "^\s*[\[\<]" -or $line -match "^\s*(PORT|USER|PID|Proto|tcp|Proto|State|UNIT)") { $color = "Gray" }
        elseif ($line -match "root@" -or $line -match "\bLast\b|Last login") { $color = "DarkYellow" }
        elseif ($line -match "drwx|lrwx|brw|-rw") {
            if ($line -match "^d") { $color = "Cyan" }
            elseif ($line -match "^l") { $color = "DarkCyan" }
            elseif ($line -match "^-r.*x") { $color = "Green" }
            else { $color = "Gray" }
        }
        elseif ($line -match "^\s+\S+/\S+\(|\s+\d+\.\d+\.\d+\.\d+:\d+") { $color = "Gray" }
        Write-Host $line -ForegroundColor $color
        Start-Sleep -Milliseconds $(if ($line -match "scan report|Nmap done|Connecting|Saving") { Rand 60 200 } else { Rand 8 50 })
    }
}

# =====================================================================
# PRESS-TO-REVEAL TYPING LOOP — shared by all modes
# =====================================================================
function Invoke-PressToReveal {
    param([string]$Text, [string]$PromptColor)

    $revealed = 0; $escaped = $false; $autoRemaining = $false
    $promptLen = $Host.UI.RawUI.CursorPosition.X

    while ($revealed -lt $Text.Length) {
        if ([Console]::KeyAvailable) {
            $k = [Console]::ReadKey($true)
            if ($k.Key -eq "Escape") { return $true }
            if ($k.Key -eq "Enter") { $autoRemaining = $true; break }
            if ($k.Key -eq "Backspace" -and $revealed -gt 0) {
                $revealed--
                $pos = $Host.UI.RawUI.CursorPosition
                $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
                Write-Host -NoNewline " "
                $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
                continue
            }
            if ($k.KeyChar -ne "`0" -and $k.Key -ne "Tab" -and $k.Key -ne "ShiftKey" -and $k.Key -ne "ControlKey") {
                if ($k.Key -eq "UpArrow") {
                    # Simulate history recall
                    if ($script:commandHistory.Count -gt 0) {
                        $recalled = $script:commandHistory[-1]
                        for ($j = 0; $j -lt $revealed; $j++) {
                            $pos = $Host.UI.RawUI.CursorPosition
                            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
                            Write-Host -NoNewline " "
                            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($pos.X - 1, $pos.Y)
                        }
                        $revealed = 0
                        for ($j = 0; $j -lt [Math]::Min($recalled.Length, $text.Length); $j++) {
                            Write-Host -NoNewline $recalled[$j] -ForegroundColor White
                            $revealed++
                        }
                    }
                    continue
                }
                Write-Host -NoNewline $text[$revealed] -ForegroundColor White
                $revealed++
            }
        }
        Start-Sleep -Milliseconds 10
    }

    if ($autoRemaining) {
        if (Type-Command $text) { return $true }
    }
    return $false
}

# =====================================================================
# MAIN TERMINAL SESSION — shared by all modes
# =====================================================================
function Start-TerminalSession {
    param(
        [scriptblock]$CommandBuilder,
        [hashtable]$Theme,
        [string]$ModeName,
        [string]$TargetHost = "server",
        [string]$TargetDomain = "local",
        [string]$TargetIP = "10.0.0.1",
        [string]$TargetCompany = "Company",
        [string]$TargetLocation = "DC",
        [string]$TargetOS = "Linux",
        [string]$OSPrompt = "user@host:~$ ",
        [string]$OSPromptShort = "user@host",
        [int]$MatrixIntroDuration = 4,
        [int]$TimeoutMinutes = 6,
        [string]$BriefingTitle = "",
        [string[]]$BriefingLines = @(),
        [switch]$NoMOTD,
        [switch]$ShowBriefing,
        [string]$CustomPrompt = "",
        [switch]$AllowFailures,
        [int]$FailChance = 20
    )

    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    [console]::CursorVisible = $false
    $Host.UI.RawUI.WindowTitle = "$ModeName - $TargetHost.$TargetDomain"
    $script:simDir = "~"
    $script:commandHistory = @()
    $script:S_IS_ROOT = $false

    # Matrix intro
    Matrix-Rain -DurationSeconds $MatrixIntroDuration -Theme $Theme
    Clear-Host

    # Briefing screen
    if ($ShowBriefing -and $BriefingLines.Count -gt 0) {
        Write-Host ""
        Write-Host "  +-$("-" * ($BriefingTitle.Length + 2))-+" -ForegroundColor $Theme.briefColor
        Write-Host "  |  $BriefingTitle  |" -ForegroundColor $Theme.briefColor
        Write-Host "  +-$("-" * ($BriefingTitle.Length + 2))-+" -ForegroundColor $Theme.briefColor
        Write-Host ""
        foreach ($bl in $BriefingLines) {
            Write-Host "  $bl" -ForegroundColor $Theme.briefColor
            Start-Sleep -Milliseconds 100
        }
        Write-Host ""
        Start-Sleep -Milliseconds 1200
        Write-Host "Press ENTER to begin..." -ForegroundColor DarkGray
        while ($true) {
            if ([Console]::KeyAvailable) { $k = [Console]::ReadKey($true); if ($k.Key -eq "Enter" -or $k.Key -eq "Escape") { break } }
            Start-Sleep -Milliseconds 50
        }
        Clear-Host
    }

    # Connection header
    Write-Host "Connecting to $TargetHost.$TargetDomain [$TargetIP]..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 300
    if ($TargetCompany) { Write-Host "Target: $TargetCompany ($TargetLocation)" -ForegroundColor DarkGray; Start-Sleep -Milliseconds 200 }
    Write-Host "Connected." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 150
    Write-Host ""

    # MOTD
    if (-not $NoMOTD) {
        Write-Host "$TargetOS ($(Get-Date -Format 'ddd MMM dd HH:mm:ss'))" -ForegroundColor DarkGray
        Start-Sleep -Milliseconds 150
        Write-Host "Last login: $(RandDate) from $(RandIP)" -ForegroundColor DarkGray
        Start-Sleep -Milliseconds 200
        if (Rand 0 1) {
            Write-Host "System: $(Rand 100 500) procs | load: $(Rand 0 4).$(Rand 00 99) $(Rand 0 3).$(Rand 00 99) $(Rand 0 2).$(Rand 00 99) | mem: $((Get-Random -Min 20 -Max 90))%" -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 250
        }
        Write-Host ""
    }

    # Build command list
    $commandList = & $CommandBuilder
    $sessionStart = Get-Date
    $maxDuration = [TimeSpan]::FromMinutes($TimeoutMinutes)
    $cmdIndex = 0
    $totalCmds = $commandList.Length

    # Main loop
    while ($cmdIndex -lt $totalCmds) {
        if ((Get-Date) - $sessionStart -gt $maxDuration) { Write-Host ""; Write-Host "Session timeout." -ForegroundColor DarkGray; break }

        # System noise
        if ((Rand 1 12) -eq 1) {
            Write-Host (Get-SystemNoise $TargetHost) -ForegroundColor Gray
            Start-Sleep -Milliseconds (Rand 300 700)
        }

        # Prompt
        if ($CustomPrompt) { Write-Host -NoNewline $CustomPrompt -ForegroundColor $Theme.promptColor }
        else { Write-Host -NoNewline (Get-DynamicPrompt $OSPrompt $script:simDir $script:S_IS_ROOT) -ForegroundColor $Theme.promptColor }

        $text = $commandList[$cmdIndex].Command
        $escaped = Invoke-PressToReveal $text $Theme.promptColor
        if ($escaped) { break }
        $script:commandHistory += $text
        Write-Host ""

        # Directory tracking
        if ($text -match '^cd\s+') {
            $target = ($text -replace '^cd\s+', '').Trim()
            if ($target -eq '~' -or $target -eq '') { $script:simDir = "~" }
            elseif ($target -match '\.\.|-' ) { $script:simDir = '~' }
            elseif ($target.StartsWith('/')) { $script:simDir = $target }
            else { $script:simDir = "~/$target" }
        } elseif ($text -match 'sudo su|su\s') { $script:S_IS_ROOT = $true; $script:simDir = "~" }
        elseif ($text -match 'exit|logout') { $script:S_IS_ROOT = $false; $script:simDir = "~" }

        # Smart delay
        $delay = if ($text -match 'nmap|wget|curl.*http|john|msfconsole|searchsploit|exploit|find ') { Rand 400 1500 }
                 elseif ($text -match 'ping|mysql|ssh') { Rand 300 800 }
                 elseif ($text -match 'cat.*shadow|cat.*passwd|strings|history') { Rand 150 500 }
                 else { Rand 50 250 }
        Start-Sleep -Milliseconds $delay

        # Random failure
        if ($AllowFailures -and (Rand 1 100) -le $FailChance) {
            $failPatterns = @(
                @{ Pattern = 'nmap|ping'; Msgs = @("Host seems down.", "Failed to resolve.", "No open ports found.") }
                @{ Pattern = 'ssh|wget|curl|python3'; Msgs = @("Connection refused.", "Connection timed out.", "Permission denied.") }
                @{ Pattern = 'exploit|msfconsole'; Msgs = @("Exploit failed.", "Segmentation fault.", "Module not compatible.") }
                @{ Pattern = 'mysql|psql|sql'; Msgs = @("Access denied.", "ERROR 2003: Can't connect.", "ERROR 1045: Access denied.") }
            )
            $matched = $null
            foreach ($fp in $failPatterns) { if ($text -match $fp.Pattern) { $matched = ($fp.Msgs | Get-Random); break } }
            if (-not $matched) { $matched = @("Permission denied.", "Command failed.", "Error: code $(Rand 1 255)") | Get-Random }
            Write-Host $matched -ForegroundColor Red
            Write-Host ""
            Start-Sleep -Milliseconds (Rand 300 900)
            $cmdIndex++
            Continue
        }

        # Show output
        Show-Output -Lines $commandList[$cmdIndex].Output -Theme $Theme
        $cmdIndex++
        Write-Host ""
        Start-Sleep -Milliseconds (Rand 60 300)
    }

    # Outro
    Write-Host ""
    Write-Host "Connection to $TargetHost closed." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 800
    Clear-Host

    Matrix-Rain -Infinite -Theme $Theme
    Start-Sleep -Milliseconds 500
    [console]::CursorVisible = $true
}
