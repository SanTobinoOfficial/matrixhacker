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
)

$learningDifficulties = @(
    @{ Id = "beginner"; Name = "Poczatkujacy"; Tasks = 5; Desc = "Podstawy terminala — ls, cd, cat, mkdir, touch" }
    @{ Id = "intermediate"; Name = "Sredniozaawansowany"; Tasks = 5; Desc = "Zarzadzanie systemem — grep, ps, chmod, tar, ping" }
    @{ Id = "advanced"; Name = "Zaawansowany"; Tasks = 5; Desc = "Administracja — systemctl, find -exec, awk, sed, cron" }
    @{ Id = "expert"; Name = "Ekspert"; Tasks = 5; Desc = "Ekspert systemowy — strace, tcpdump, selinux, perf" }
)

function Build-LEARNINGCOMMANDS {
    return @()
}

function Show-LearningSelector {
    Clear-Host
    $Host.UI.RawUI.BackgroundColor = "Black"
    Write-Host ""
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "     TRYB NAUKI — Wybor systemu" -ForegroundColor Green
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host ""
    $i = 1
    foreach ($sys in $learningSystems) {
        Write-Host "  [$("{0:D2}" -f $i)] $($sys.Name)" -ForegroundColor Yellow
        $i++
    }
    Write-Host ""
    Write-Host "  [Q] Powrot do menu glownego" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "  Wybierz system (1-$($learningSystems.Count))"
    if ($choice -eq 'q' -or $choice -eq 'Q') { return $null }

    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $learningSystems.Count) {
        return $learningSystems[$num - 1]
    }
    Write-Host "  Nieprawidlowy wybor." -ForegroundColor Red
    Start-Sleep -Milliseconds 500
    return Show-LearningSelector
}

function Show-DifficultySelector {
    param($SystemInfo)
    Clear-Host
    Write-Host ""
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "     $($SystemInfo.Name) — Poziom trudnosci" -ForegroundColor Green
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host ""
    $i = 1
    foreach ($diff in $learningDifficulties) {
        Write-Host "  [$i] $($diff.Name) — $($diff.Desc)" -ForegroundColor Yellow
        $i++
    }
    Write-Host ""
    Write-Host "  [Q] Powrot do wyboru systemu" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "  Wybierz poziom (1-4)"
    if ($choice -eq 'q' -or $choice -eq 'Q') { return $null }

    $num = 0
    if ([int]::TryParse($choice, [ref]$num) -and $num -ge 1 -and $num -le $learningDifficulties.Count) {
        return $learningDifficulties[$num - 1]
    }
    Write-Host "  Nieprawidlowy wybor." -ForegroundColor Red
    Start-Sleep -Milliseconds 500
    return Show-DifficultySelector $SystemInfo
}

function Start-LearningMode {
    param([string]$SystemId, [string]$Difficulty)

    $theme = Get-Theme "learning"
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
