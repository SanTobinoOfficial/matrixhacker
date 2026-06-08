# =====================================================================
# HELPERS — shared utility functions for all modes
# =====================================================================

# Cross-platform console key reader (safe in ISE, SSH, remote)
function Read-ConsoleKey {
    try {
        if (-not [Console]::KeyAvailable) { return $null }
        return [Console]::ReadKey($true)
    } catch {
        try {
            if (-not $Host.UI.RawUI.KeyAvailable) { return $null }
            $k = $Host.UI.RawUI.ReadKey([System.Management.Automation.Host.ReadKeyOptions]::NoEcho -bor [System.Management.Automation.Host.ReadKeyOptions]::IncludeKeyDown)
            $vc = $k.VirtualKeyCode
            if ($vc -eq 27) { return @{ Key = "Escape"; KeyChar = "`0" } }
            if ($vc -eq 13) { return @{ Key = "Enter"; KeyChar = "`r" } }
            if ($vc -eq 8)  { return @{ Key = "Backspace"; KeyChar = "`b" } }
            if ($vc -eq 38) { return @{ Key = "UpArrow"; KeyChar = "`0" } }
            if ($vc -eq 9)  { return @{ Key = "Tab"; KeyChar = "`t" } }
            if ($vc -eq 16 -or $vc -eq 17) { return @{ Key = "Modifier"; KeyChar = "`0" } }
            return @{ Key = $k.Character.ToString().ToUpper(); KeyChar = $k.Character }
        } catch { return $null }
    }
}

# Safe cursor position getter (fallback to origin)
function Get-CursorPosition {
    try { return $Host.UI.RawUI.CursorPosition } catch { return @{ X = 0; Y = 0 } }
}

# Safe cursor position setter
function Set-CursorPosition {
    param([int]$X, [int]$Y)
    try { $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($X, $Y) } catch { }
}

function Rand { param($a,$b) if ($a -ge $b) { $t=$a;$a=$b;$b=$t }; Get-Random -Minimum $a -Maximum $b }

function RandIP { "$(Rand 10 255).$(Rand 10 255).$(Rand 10 255).$(Rand 10 255)" }

function RandDate {
    $d = (Get-Date).AddDays(-(Rand 0 14)).AddHours(-(Rand 0 23)).AddMinutes(-(Rand 0 59))
    $d.ToString("MMM dd HH:mm:ss")
}

function RandHex($len=8) {
    -join ((1..$len) | ForEach-Object { '{0:x}' -f (Rand 0 16) })
}

function C($c, $o) { @{ Command = $c; Output = $o } }

function Cprog($c, $o) { @{ Command = $c; Output = $o; Progress = $true } }

# Dynamic prompt with directory tracking
function Get-DynamicPrompt {
    param([string]$PromptBase, [string]$SimDir, [bool]$IsRoot)
    $dir = if ($SimDir -eq "~") { "~" } else { $SimDir }
    $userHost = $PromptBase -replace '[:~$#>].*', ''
    $suffix = if ($IsRoot) { '#' } else { '$' }
    return "$userHost`:$dir$suffix "
}

# System noise generator (evaluated at call time)
function Get-SystemNoise {
    param([string]$Hostname)
    $msgs = @(
        "You have mail in /var/mail/mailcheck"
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): sshd[$(Rand 1000 9999)]: Failed password for root from $(RandIP) port $(Rand 40000 60000) ssh2"
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): kernel: [$(Rand 1000000 9999999).$(Rand 100 999)] eth0: link up"
        "Broadcast message from root@$Hostname`n   The system will reboot in 15 minutes."
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): CRON[$(Rand 1000 9999)]: (root) CMD (test -x /usr/sbin/anacron && run-parts /etc/cron.daily)"
    )
    return $msgs | Get-Random
}
