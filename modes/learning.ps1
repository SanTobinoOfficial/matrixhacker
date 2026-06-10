. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"
. "$PSScriptRoot/../engine/learning_engine.ps1"

Get-ChildItem "$PSScriptRoot/learning" -Filter *.ps1 | ForEach-Object { . $_.FullName }

$learningSystems = @(
    @{ Id = "ubuntu"; Name = "Ubuntu 24.04 LTS"; Prompt = "student@ubuntu:~$"; Hostname = "ubuntu"; User = "student"; OsName = "Ubuntu 24.04 LTS" }
    @{ Id = "debian"; Name = "Debian 12"; Prompt = "student@debian:~$"; Hostname = "debian"; User = "student"; OsName = "Debian GNU/Linux 12 (bookworm)" }
    @{ Id = "centos"; Name = "CentOS 9 / Rocky Linux"; Prompt = "student@centos:~$"; Hostname = "centos"; User = "student"; OsName = "Rocky Linux 9.4" }
    @{ Id = "arch"; Name = "Arch Linux"; Prompt = "student@arch:~$"; Hostname = "arch"; User = "student"; OsName = "Arch Linux (rolling)" }
    @{ Id = "kali"; Name = "Kali Linux"; Prompt = "student@kali:~$"; Hostname = "kali"; User = "student"; OsName = "Kali GNU/Linux 2026.1" }
    @{ Id = "alpine"; Name = "Alpine Linux"; Prompt = "student@alpine:~$"; Hostname = "alpine"; User = "student"; OsName = "Alpine Linux 3.20" }
    @{ Id = "opensuse"; Name = "openSUSE Tumbleweed"; Prompt = "student@opensuse:~$"; Hostname = "opensuse"; User = "student"; OsName = "openSUSE Tumbleweed" }
    @{ Id = "windows"; Name = "Windows 11 (PowerShell)"; Prompt = "PS C:\Users\student>"; Hostname = "WIN11-PC"; User = "student"; OsName = "Windows 11 Pro 24H2" }
    @{ Id = "winserver"; Name = "Windows Server 2022"; Prompt = "PS C:\Users\Admin>"; Hostname = "SRV-DC01"; User = "Admin"; OsName = "Windows Server 2022 Standard" }
    @{ Id = "cisco"; Name = "Cisco IOS"; Prompt = "Router>"; Hostname = "Router"; User = ""; OsName = "Cisco IOS XE 17.9" }
    @{ Id = "macos"; Name = "macOS Terminal"; Prompt = "student@macbook:~$"; Hostname = "macbook"; User = "student"; OsName = "macOS 15 Sequoia" }
    @{ Id = "ctf_mode"; Name = "CTF Challenge Mode"; Prompt = "player@ctf-box:~$"; Hostname = "ctf-box"; User = "player"; OsName = "CTF Challenge Lab 2026" }
    @{ Id = "docker"; Name = "Docker Admin"; Prompt = "admin@docker-host:~$"; Hostname = "docker-host"; User = "admin"; OsName = "Ubuntu 24.04 LTS (Docker Host)" }
    @{ Id = "cloud"; Name = "Cloud DevOps"; Prompt = "devops@cloud-box:~$"; Hostname = "cloud-box"; User = "devops"; OsName = "Cloud Workstation 24.04" }
    @{ Id = "webdev"; Name = "Web Developer"; Prompt = "dev@dev-machine:~$"; Hostname = "dev-machine"; User = "dev"; OsName = "Ubuntu 24.04 LTS (Dev Machine)" }
    @{ Id = "sql"; Name = "SQL Database Admin"; Prompt = "dba@db-server:~$"; Hostname = "db-server"; User = "dba"; OsName = "Ubuntu 24.04 LTS (Database Server)" }
    @{ Id = "iot"; Name = "IoT Hacker"; Prompt = "hacker@iot-device:~$"; Hostname = "iot-device"; User = "hacker"; OsName = "OpenWrt 23.05.3 (Embedded)" }
)

$learningDifficulties = @(
    @{ Id = "beginner"; Name = "Poczatkujacy"; Tasks = 5; Desc = "Podstawy terminala - ls, cd, cat, mkdir, touch" }
    @{ Id = "intermediate"; Name = "Sredniozaawansowany"; Tasks = 5; Desc = "Zarzadzanie systemem - grep, ps, chmod, tar, ping" }
    @{ Id = "advanced"; Name = "Zaawansowany"; Tasks = 5; Desc = "Administracja - systemctl, find -exec, awk, sed, cron" }
    @{ Id = "expert"; Name = "Ekspert"; Tasks = 5; Desc = "Ekspert systemowy - strace, tcpdump, selinux, perf" }
)

function Build-LEARNINGCOMMANDS {
    return @()
}

function Show-LearningSelector {
    Clear-Host
    $Host.UI.RawUI.BackgroundColor = "Black"
    $border = [char]0x2550; $tl = [char]0x2554; $tr = [char]0x2557
    $bl = [char]0x255A; $br = [char]0x255D; $vb = [char]0x2551
    $lm = [char]0x2560; $rm = [char]0x2563
    $w = 52
    Write-Host ""
    Write-Host "  $tl$([string]$border * $w)$tr" -ForegroundColor Cyan
    Write-Host "  $vb$("  ULTRA MATRIX TERMINAL  |  TRYB NAUKI".PadRight($w))$vb" -ForegroundColor Green
    Write-Host "  $vb$("  Wybierz system do nauki".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $lm$([string]$border * $w)$rm" -ForegroundColor Cyan

    $categories = @(
        @{ Label = "  LINUX DISTROS"; Color = "Green"; Ids = @("ubuntu","debian","centos","arch","kali","alpine","opensuse") }
        @{ Label = "  WINDOWS"; Color = "Cyan"; Ids = @("windows","winserver") }
        @{ Label = "  SIECI / SPRZET"; Color = "Yellow"; Ids = @("cisco") }
        @{ Label = "  MACOS"; Color = "Magenta"; Ids = @("macos") }
        @{ Label = "  DEVOPS / CLOUD"; Color = "DarkYellow"; Ids = @("docker","cloud","webdev") }
        @{ Label = "  BAZY DANYCH / IOT / CTF"; Color = "Red"; Ids = @("sql","iot","ctf_mode") }
    )
    $i = 1
    $indexMap = @{}
    foreach ($cat in $categories) {
        Write-Host "  $vb$($cat.Label.PadRight($w))$vb" -ForegroundColor $cat.Color
        foreach ($sysId in $cat.Ids) {
            $sys = $learningSystems | Where-Object { $_.Id -eq $sysId }
            if ($sys) {
                $label = "    [{0:D2}] {1}" -f $i, $sys.Name
                Write-Host "  $vb$($label.PadRight($w))$vb" -ForegroundColor White
                $indexMap[$i] = $sys
                $i++
            }
        }
    }
    Write-Host "  $bl$([string]$border * $w)$br" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [Q] Powrot do menu glownego" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "  Wybierz system (1-$($i-1))"
    if ($choice -eq 'q' -or $choice -eq 'Q') { return $null }

    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $indexMap.ContainsKey($num)) {
        return $indexMap[$num]
    }
    Write-Host "  Nieprawidlowy wybor." -ForegroundColor Red
    Start-Sleep -Milliseconds 400
    return Show-LearningSelector
}

function Show-DifficultySelector {
    param($SystemInfo)
    Clear-Host
    $border = [char]0x2550; $tl = [char]0x2554; $tr = [char]0x2557
    $bl = [char]0x255A; $br = [char]0x255D; $vb = [char]0x2551
    $lm = [char]0x2560; $rm = [char]0x2563
    $w = 52
    Write-Host ""
    Write-Host "  $tl$([string]$border * $w)$tr" -ForegroundColor Cyan
    $header = "  $($SystemInfo.Name)"
    Write-Host "  $vb$($header.PadRight($w))$vb" -ForegroundColor Green
    Write-Host "  $vb$("  Wybierz poziom trudnosci".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $lm$([string]$border * $w)$rm" -ForegroundColor Cyan

    $diffColors = @{ "beginner" = "Green"; "intermediate" = "Yellow"; "advanced" = "DarkYellow"; "expert" = "Red" }
    $i = 1
    foreach ($diff in $learningDifficulties) {
        $col = if ($diffColors.ContainsKey($diff.Id)) { $diffColors[$diff.Id] } else { "Gray" }
        $stars = switch ($diff.Id) { "beginner" { "[*   ]" } "intermediate" { "[**  ]" } "advanced" { "[*** ]" } "expert" { "[****]" } default { "[    ]" } }
        $line = "  [$i] $stars $($diff.Name.PadRight(22)) $($diff.Tasks) zadan"
        Write-Host "  $vb$($line.PadRight($w))$vb" -ForegroundColor $col
        $descLine = "      $($diff.Desc)"
        Write-Host "  $vb$($descLine.PadRight($w))$vb" -ForegroundColor DarkGray
        $i++
    }
    Write-Host "  $bl$([string]$border * $w)$br" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [A] Wszystkie poziomy (20 zadan)" -ForegroundColor Cyan
    Write-Host "  [Q] Powrot do wyboru systemu" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "  Wybierz poziom (1-4, A, Q)"
    if ($choice -eq 'q' -or $choice -eq 'Q') { return $null }
    if ($choice -eq 'a' -or $choice -eq 'A') { return @{ Id = "all"; Name = "Wszystkie poziomy"; Tasks = 20 } }

    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $learningDifficulties.Count) {
        return $learningDifficulties[$num - 1]
    }
    Write-Host "  Nieprawidlowy wybor." -ForegroundColor Red
    Start-Sleep -Milliseconds 400
    return Show-DifficultySelector $SystemInfo
}

function Start-LearningMode {
    param([string]$SystemId, [string]$Difficulty, [string]$ThemeId)

    if (-not $ThemeId) { $ThemeId = "learning" }
    $theme = Get-Theme $ThemeId
    $sysInfo = $learningSystems | Where-Object { $_.Id -eq $SystemId }
    if (-not $sysInfo) { Write-Host "Unknown system: $SystemId" -ForegroundColor Red; return }

    $diffName = if ($Difficulty) { $Difficulty } else { "beginner" }

    $contentFuncName = "Get-LearningContent-$($sysInfo.Id)"
    $contentFunc = Get-Item -LiteralPath "function:$contentFuncName" -ErrorAction SilentlyContinue
    if (-not $contentFunc) {
        Write-Host "System content not loaded: $contentFuncName" -ForegroundColor Red
        return
    }

    $content = & $contentFuncName $diffName
    if (-not $content -or -not $content.Filesystem -or -not $content.Tasks) {
        Write-Host "Invalid content for $($sysInfo.Id)/$diffName" -ForegroundColor Red
        return
    }

    New-LearningFS $content.Filesystem

    Start-LearningSession `
        -SystemName $sysInfo.Name `
        -Hostname $sysInfo.Hostname `
        -Username $sysInfo.User `
        -OsName $sysInfo.OsName `
        -PromptString $sysInfo.Prompt `
        -Filesystem $content.Filesystem `
        -Tasks $content.Tasks `
        -Theme $theme
}

# Interactive selector
if ($MyInvocation.InvocationName -ne '.') {
    $sys = Show-LearningSelector
    if ($sys) {
        $diff = Show-DifficultySelector $sys
        if ($diff) {
            Start-LearningMode -SystemId $sys.Id -Difficulty $diff.Id
        }
    }
}
