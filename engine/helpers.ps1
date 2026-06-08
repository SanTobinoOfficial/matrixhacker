# =====================================================================
# HELPERS — shared utility functions for all modes
# =====================================================================

function Rand { param($a,$b) Get-Random -Minimum $a -Maximum $b }

function RandIP { "$(Rand 10 255).$(Rand 10 255).$(Rand 10 255).$(Rand 10 255)" }

function RandDate {
    $d = (Get-Date).AddDays(-(Rand 0 14)).AddHours(-(Rand 0 23)).AddMinutes(-(Rand 0 59))
    $d.ToString("MMM dd HH:mm:ss")
}

function RandHex($len=8) {
    -join ((1..$len) | ForEach-Object { '{0:x}' -f (Rand 0 15) })
}

function C($c, $o) { @{ Command = $c; Output = $o } }

function Cp($c, $o) { @{ Command = $c; Output = $o; Progress = $true } }

# Dynamic prompt with directory tracking
function Get-DynamicPrompt {
    param([string]$PromptBase, [string]$SimDir, [bool]$IsRoot)
    $dir = if ($SimDir -eq "~") { "~" } else { $SimDir }
    $userHost = $PromptBase -replace '[:~\$#>].*', ''
    $suffix = if ($IsRoot) { '#' } else { '$' }
    return "$userHost`:$dir$suffix "
}

# System noise generator (evaluated at call time)
function Get-SystemNoise {
    param([string]$Hostname)
    $msgs = @(
        "You have mail in /var/mail/$(Split-Path $script:OS.prompt -Leaf)"
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): sshd[$(Rand 1000 9999)]: Failed password for root from $(RandIP) port $(Rand 40000 60000) ssh2"
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): kernel: [$(Rand 1000000 9999999).$(Rand 100 999)] eth0: link up"
        "Broadcast message from root@$Hostname`n   The system will reboot in 15 minutes."
        "Message from syslogd@$Hostname at $(Get-Date -Format 'HH:mm'): CRON[$(Rand 1000 9999)]: (root) CMD (test -x /usr/sbin/anacron && run-parts /etc/cron.daily)"
    )
    return $msgs | Get-Random
}
