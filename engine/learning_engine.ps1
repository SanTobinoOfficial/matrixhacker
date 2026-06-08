# =====================================================================
# LEARNING ENGINE — Virtual FS, command parser, task system
# =====================================================================

$script:learningVfs = @{}
$script:learningCwd = "/"
$script:learningUser = "student"
$script:learningHost = "host"
$script:learningOsName = "Linux"
$script:learningPrompt = "student@host:~$"
$script:learningTasks = @()
$script:learningCurrentTask = 0
$script:learningCompletedTasks = @{}
$script:learningSudo = $false
$script:learningHintUsed = @{}
$script:learningSkippedTasks = @{}

# ===================================================================
# FILESYSTEM CORE
# ===================================================================

function New-LearningFS {
    param([hashtable]$Template)
    $script:learningVfs = @{}
    function Build-Flat($node, $prefix) {
        foreach ($entry in $node.Keys) {
            $path = if ($prefix -eq "/") { "/$entry" } else { "$prefix/$entry" }
            $item = $node[$entry]
            $script:learningVfs[$path] = @{
                Type = $item.Type
                Content = if ($item.ContainsKey("Content")) { $item.Content } else { $null }
                Perms = if ($item.ContainsKey("Perms")) { $item.Perms } else { if ($item.Type -eq "dir") { "drwxr-xr-x" } else { "-rw-r--r--" } }
                Owner = if ($item.ContainsKey("Owner")) { $item.Owner } else { "root" }
                Group = if ($item.ContainsKey("Group")) { $item.Group } else { "root" }
            }
            if ($item.Type -eq "dir" -and $item.ContainsKey("Children") -and $item.Children) {
                Build-Flat $item.Children $path
            }
        }
    }
    Build-Flat $Template "/"
    $script:learningCwd = "/home/student"
    if (-not $script:learningVfs.ContainsKey($script:learningCwd)) {
        $script:learningCwd = "/"
    }
}

function Resolve-LPath {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or $Path -eq "~") { return "/home/student" }
    if ($Path.StartsWith("~/")) { $Path = "/home/student" + $Path.Substring(1) }
    elseif ($Path -eq "~") { $Path = "/home/student" }
    elseif ($Path -eq ".") { return $script:learningCwd }
    elseif ($Path -eq "..") { return (Split-LPath $script:learningCwd) }
    elseif (-not $Path.StartsWith("/")) { $Path = "$($script:learningCwd)/$Path" }
    $parts = $Path.Split("/", [StringSplitOptions]::RemoveEmptyEntries)
    $resolved = @()
    foreach ($p in $parts) {
        if ($p -eq ".") { continue }
        elseif ($p -eq "..") { if ($resolved.Count -gt 0) { $resolved = $resolved[0..($resolved.Count-2)] } }
        else { $resolved += $p }
    }
    return "/" + ($resolved -join "/")
}

function Split-LPath {
    param([string]$Path)
    $normalized = Resolve-LPath $Path
    $parts = $normalized.TrimEnd("/").Split("/")
    if ($parts.Count -le 1) { return "/" }
    return "/" + ($parts[0..($parts.Count-2)] -join "/")
}

function Get-LItem {
    param([string]$Path)
    $normalized = Resolve-LPath $Path
    if ($script:learningVfs.ContainsKey($normalized)) {
        return $script:learningVfs[$normalized]
    }
    return $null
}

function Set-LItem {
    param([string]$Path, [hashtable]$Item)
    $normalized = Resolve-LPath $Path
    $script:learningVfs[$normalized] = $Item
}

function Remove-LItem {
    param([string]$Path)
    $normalized = Resolve-LPath $Path
    $script:learningVfs.Remove($normalized)
}

function Get-LDirListing {
    param([string]$Path)
    $dir = Resolve-LPath $Path
    $parentPrefix = if ($dir -eq "/") { "/" } else { "$dir/" }
    return $script:learningVfs.Keys | Where-Object {
        $_ -ne $dir -and $_.StartsWith($parentPrefix) -and
        $_.Substring($parentPrefix.Length) -notmatch "/"
    }
}

function Get-LDirRecursive {
    param([string]$Path)
    $dir = Resolve-LPath $Path
    return $script:learningVfs.Keys | Where-Object { $_ -ne $dir -and $_.StartsWith($dir) } | Sort-Object
}

# ===================================================================
# COMMAND HANDLERS
# ===================================================================

$script:learningCommands = @{}

function Register-LCommand {
    param([string]$Name, [scriptblock]$Handler)
    $script:learningCommands[$Name] = $Handler
}

function Get-CommandSuffix {
    param([string]$Path)
    if ($Path -match '\.(py|sh|pl)$') { return $Matches[1] }
    return $null
}

# -- ls --
Register-LCommand "ls" {
    param($args)
    $path = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "." }
    $long = ($args -match "^-l" -or $args -match "^-la" -or $args -match "^-al" -or $args -match "^-l.*" -or $args -match "^-a.*l")
    $all = ($args -match "^-a" -or $args -match "^-la" -or $args -match "^-al")
    $human = ($args -match "^-h")
    $target = Resolve-LPath $path
    $item = Get-LItem $target
    if (-not $item) { return @("ls: cannot access '$path': No such file or directory") }
    if ($item.Type -ne "dir") {
        if ($long) { return @("$($item.Perms) 1 $($item.Owner) $($item.Group) 0 $(Get-Date -Format 'MMM dd HH:mm') $(Split-Path $target -Leaf)") }
        return @(Split-Path $target -Leaf)
    }
    $entries = Get-LDirListing $target | ForEach-Object { Split-Path $_ -Leaf } | Sort-Object
    if (-not $all) { $entries = $entries | Where-Object { $_ -notlike ".*" } }
    $total = $entries.Count
    if ($long) {
        $output = @("total $total")
        foreach ($e in $entries) {
            $epath = "$target/$e"
            $ei = Get-LItem $epath
            if ($ei) { $output += "$($ei.Perms) 1 $($ei.Owner) $($ei.Group) 0 $(Get-Date -Format 'MMM dd HH:mm') $e" }
            else { $output += "-rw-r--r-- 1 root root 0 $(Get-Date -Format 'MMM dd HH:mm') $e" }
        }
        return $output
    }
    if ($entries.Count -eq 0) { return @("") }
    $line = ""
    $output = @()
    foreach ($e in $entries) {
        if (($line + "  $e").Length -gt 80) { $output += $line.TrimStart(); $line = "" }
        $line += "  $e"
    }
    if ($line) { $output += $line.TrimStart() }
    if ($output.Count -eq 0) { return @("") }
    return $output
}

# -- cd --
Register-LCommand "cd" {
    param($args)
    $path = if ($args.Count -gt 0) { $args[0] } else { "~" }
    $target = Resolve-LPath $path
    $item = Get-LItem $target
    if (-not $item) { return @("cd: ${path}: No such file or directory") }
    if ($item.Type -ne "dir") { return @("cd: ${path}: Not a directory") }
    $script:learningCwd = $target
    return @()
}

# -- pwd --
Register-LCommand "pwd" {
    return @($script:learningCwd)
}

# -- cat --
Register-LCommand "cat" {
    param($args)
    if ($args.Count -eq 0) { return @() }
    $output = @()
    foreach ($f in $args) {
        $target = Resolve-LPath $f
        $item = Get-LItem $target
        if (-not $item) { $output += "cat: ${f}: No such file or directory"; continue }
        if ($item.Type -eq "dir") { $output += "cat: ${f}: Is a directory"; continue }
        if ($item.Content) { $output += $item.Content }
    }
    return $output
}

# -- head --
Register-LCommand "head" {
    param($args)
    $n = 10
    $files = @()
    $i = 0
    while ($i -lt $args.Count) {
        if ($args[$i] -eq "-n" -and $i + 1 -lt $args.Count) { $n = [int]$args[$i+1]; $i += 2 }
        elseif ($args[$i] -match "^-(\d+)$") { $n = [int]$Matches[1]; $i++ }
        else { $files += $args[$i]; $i++ }
    }
    if ($files.Count -eq 0) { return @() }
    $output = @()
    foreach ($f in $files) {
        $target = Resolve-LPath $f; $item = Get-LItem $target
        if (-not $item) { $output += "head: ${f}: No such file or directory"; continue }
        if ($item.Type -eq "dir") { $output += "head: ${f}: Is a directory"; continue }
        if ($item.Content) {
            $lines = $item.Content
            if ($files.Count -gt 1) { $output += "==> $f <==" }
            $output += $lines | Select-Object -First $n
        }
    }
    return $output
}

# -- tail --
Register-LCommand "tail" {
    param($args)
    $n = 10
    $files = @()
    $i = 0
    while ($i -lt $args.Count) {
        if ($args[$i] -eq "-n" -and $i + 1 -lt $args.Count) { $n = [int]$args[$i+1]; $i += 2 }
        elseif ($args[$i] -match "^-(\d+)$") { $n = [int]$Matches[1]; $i++ }
        else { $files += $args[$i]; $i++ }
    }
    if ($files.Count -eq 0) { return @() }
    $output = @()
    foreach ($f in $files) {
        $target = Resolve-LPath $f; $item = Get-LItem $target
        if (-not $item) { $output += "tail: ${f}: No such file or directory"; continue }
        if ($item.Type -eq "dir") { $output += "tail: ${f}: Is a directory"; continue }
        if ($item.Content) {
            $lines = $item.Content
            if ($files.Count -gt 1) { $output += "==> $f <==" }
            $output += $lines | Select-Object -Last $n
        }
    }
    return $output
}

# -- touch --
Register-LCommand "touch" {
    param($args)
    if ($args.Count -eq 0) { return @() }
    foreach ($f in $args) {
        $target = Resolve-LPath $f
        if (Get-LItem $target) { continue }
        $parent = Split-LPath $target
        if (-not (Get-LItem $parent)) { return @("touch: cannot touch '$f': No such file or directory") }
        Set-LItem $target @{ Type = "file"; Content = @(); Perms = "-rw-r--r--"; Owner = $script:learningUser; Group = $script:learningUser }
    }
    return @()
}

# -- mkdir --
Register-LCommand "mkdir" {
    param($args)
    $parent = $false
    $dirs = @()
    $i = 0
    while ($i -lt $args.Count) {
        if ($args[$i] -eq "-p") { $parent = $true; $i++ }
        else { $dirs += $args[$i]; $i++ }
    }
    if ($dirs.Count -eq 0) { return @("mkdir: missing operand") }
    $output = @()
    foreach ($d in $dirs) {
        $target = Resolve-LPath $d
        if (Get-LItem $target) { if (-not $parent) { $output += "mkdir: cannot create directory '$d': File exists" }; continue }
        $parentPath = Split-LPath $target
        if (-not (Get-LItem $parentPath)) {
            if ($parent) {
                $parts = $target.TrimEnd("/").Split("/", [StringSplitOptions]::RemoveEmptyEntries)
                $acc = ""
                foreach ($p in $parts) {
                    $acc = "$acc/$p"; $acc = $acc -replace "^/+", "/"
                    if (-not (Get-LItem $acc)) { Set-LItem $acc @{ Type = "dir"; Content = $null; Perms = "drwxr-xr-x"; Owner = $script:learningUser; Group = $script:learningUser } }
                }
            } else { $output += "mkdir: cannot create directory '$d': No such file or directory" }
        } else {
            Set-LItem $target @{ Type = "dir"; Content = $null; Perms = "drwxr-xr-x"; Owner = $script:learningUser; Group = $script:learningUser }
        }
    }
    return $output
}

# -- rm --
Register-LCommand "rm" {
    param($args)
    $recursive = $false; $force = $false
    $targets = @()
    foreach ($a in $args) {
        if ($a -eq "-r" -or $a -eq "-rf" -or $a -eq "-fr" -or $a -eq "-R") { $recursive = $true }
        elseif ($a -eq "-f") { $force = $true }
        else { $targets += $a }
    }
    if ($targets.Count -eq 0) { return @("rm: missing operand") }
    $output = @()
    foreach ($t in $targets) {
        $target = Resolve-LPath $t; $item = Get-LItem $target
        if (-not $item) { if (-not $force) { $output += "rm: cannot remove '$t': No such file or directory" }; continue }
        if ($item.Type -eq "dir" -and -not $recursive) { $output += "rm: cannot remove '$t': Is a directory"; continue }
        $children = Get-LDirListing $target
        if ($children.Count -gt 0 -and $recursive) { foreach ($c in $children) { Remove-LItem $c } }
        Remove-LItem $target
    }
    return $output
}

# -- cp --
Register-LCommand "cp" {
    param($args)
    $recursive = $false
    $sources = @(); $dest = $null
    $i = 0
    while ($i -lt $args.Count) {
        if ($args[$i] -eq "-r" -or $args[$i] -eq "-R") { $recursive = $true; $i++ }
        else { $sources += $args[$i]; $i++ }
    }
    if ($sources.Count -lt 2) { return @("cp: missing file operand") }
    $dest = $sources[-1]; $sources = $sources[0..($sources.Count-2)]
    $destPath = Resolve-LPath $dest
    $destIsDir = (Get-LItem $destPath) -and (Get-LItem $destPath).Type -eq "dir"
    foreach ($s in $sources) {
        $srcPath = Resolve-LPath $s; $item = Get-LItem $srcPath
        if (-not $item) { return @("cp: cannot stat '$s': No such file or directory") }
        $targetPath = if ($destIsDir) { "$destPath/$(Split-Path $s -Leaf)" } else { $destPath }
        if ($item.Type -eq "dir" -and -not $recursive) { return @("cp: -r not specified; omitting directory '$s'") }
        if ($item.Type -eq "dir") {
            $script:learningVfs.Keys | Where-Object { $_.StartsWith("$srcPath/") } | ForEach-Object {
                $rel = $_.Substring($srcPath.Length)
                $newPath = "$targetPath$rel"
                Set-LItem $newPath $script:learningVfs[$_]
            }
        }
        Set-LItem $targetPath @{ Type = $item.Type; Content = $item.Content; Perms = $item.Perms; Owner = $script:learningUser; Group = $script:learningUser }
    }
    return @()
}

# -- mv --
Register-LCommand "mv" {
    param($args)
    $sources = @(); $dest = $null
    $i = 0
    while ($i -lt $args.Count) { $sources += $args[$i]; $i++ }
    if ($sources.Count -lt 2) { return @("mv: missing file operand") }
    $dest = $sources[-1]; $sources = $sources[0..($sources.Count-2)]
    $destPath = Resolve-LPath $dest
    $destIsDir = (Get-LItem $destPath) -and (Get-LItem $destPath).Type -eq "dir"
    foreach ($s in $sources) {
        $srcPath = Resolve-LPath $s; $item = Get-LItem $srcPath
        if (-not $item) { return @("mv: cannot stat '$s': No such file or directory") }
        $targetPath = if ($destIsDir) { "$destPath/$(Split-Path $s -Leaf)" } else { $destPath }
        Set-LItem $targetPath @{ Type = $item.Type; Content = $item.Content; Perms = $item.Perms; Owner = $script:learningUser; Group = $script:learningUser }
        Remove-LItem $srcPath
    }
    return @()
}

# -- echo --
Register-LCommand "echo" {
    param($args)
    if ($args.Count -eq 0) { return @("") }
    return @(($args -join " "))
}

# -- whoami --
Register-LCommand "whoami" {
    return @($script:learningUser)
}

# -- hostname --
Register-LCommand "hostname" {
    return @($script:learningHost)
}

# -- id --
Register-LCommand "id" {
    param($args)
    $u = if ($args.Count -gt 0) { $args[0] } else { $script:learningUser }
    return @("uid=1000($u) gid=1000($u) groups=1000($u),27(sudo)")
}

# -- uname --
Register-LCommand "uname" {
    param($args)
    $a = if ($args.Count -gt 0) { $args[0] } else { "" }
    if ($a -eq "-a" -or $a -eq "--all") { return @("Linux $($script:learningHost) 6.8.0-45-generic #46-Ubuntu SMP PREEMPT_DYNAMIC x86_64 x86_64 x86_64 GNU/Linux") }
    if ($a -eq "-r") { return @("6.8.0-45-generic") }
    if ($a -eq "-m") { return @("x86_64") }
    return @("Linux")
}

# -- date --
Register-LCommand "date" {
    return @((Get-Date).ToString("ddd MMM dd HH:mm:ss UTC 2026"))
}

# -- cal --
Register-LCommand "cal" {
    $now = Get-Date
    $m = $now.Month; $y = $now.Year
    $firstDay = [DateTime]::new($y, $m, 1)
    $daysInMonth = [DateTime]::DaysInMonth($y, $m)
    $startDow = [int]$firstDay.DayOfWeek
    $line = "    " + $now.ToString("MMMM yyyy")
    $cal = @($line, "Su Mo Tu We Th Fr Sa")
    $week = " " * ($startDow * 3)
    for ($d = 1; $d -le $daysInMonth; $d++) {
        $week += $d.ToString().PadLeft(3)
        if (($startDow + $d) % 7 -eq 0 -or $d -eq $daysInMonth) { $cal += $week; $week = "" }
    }
    return $cal
}

# -- df --
Register-LCommand "df" {
    param($args)
    $human = ($args -match "^-h")
    $h = if ($human) { "G" } else { "" }
    return @("Filesystem      Size  Used Avail Use% Mounted on",
        "/dev/sda1        98${h}  42${h}   51${h}  46% /",
        "/dev/sdb1       500${h} 210${h}  290${h}  42% /mnt/backup",
        "tmpfs           3.9${h}     0  3.9${h}   0% /dev/shm")
}

# -- du --
Register-LCommand "du" {
    param($args)
    $human = ($args -match "^-h")
    $target = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "." }
    $path = Resolve-LPath $target
    $suffix = if ($human) { "K" } else { "" }
    return @("12${suffix}	$path")
}

# -- free --
Register-LCommand "free" {
    param($args)
    $human = ($args -match "^-h")
    $u = if ($human) { "Mi" } else { "" }
    return @("               total        used        free      shared  buff/cache   available",
        "Mem:           7869${u}      3245${u}      2102${u}       234${u}      2522${u}      4123${u}",
        "Swap:          2048${u}        34${u}      2014${u}")
}

# -- ps --
Register-LCommand "ps" {
    param($args)
    $aux = ($args -match "aux" -or $args -match "ax" -or $args -match "-ef")
    if (-not $aux) { return @("  PID TTY          TIME CMD", "    1 ?        00:00:03 systemd", "  892 ?        00:00:45 sshd", " 1245 ?        00:02:12 nginx") }
    return @("USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND",
        "root           1  0.0  0.1 12345  1234 ?        Ss   Jun01   0:03 systemd",
        "root         892  0.0  0.3 23456  3456 ?        Ss   Jun01   0:45 sshd",
        "root        1245  0.1  0.5 34567  5678 ?        S    Jun01   2:12 nginx",
        "$($script:learningUser)        2456  0.3  1.2 45678 12345 ?        Ssl  Jun01   1:23 bash",
        "$($script:learningUser)        3789  0.0  0.2 34567  2345 pts/0    R+   12:00   0:00 ps aux")
}

# -- kill --
Register-LCommand "kill" {
    param($args)
    if ($args.Count -eq 0) { return @("kill: usage: kill [-s sigspec] [-n signum] pid") }
    return @()
}

# -- grep --
Register-LCommand "grep" {
    param($args)
    $recursive = $false; $pattern = ""; $targets = @()
    $i = 0
    while ($i -lt $args.Count) {
        if ($args[$i] -eq "-r" -or $args[$i] -eq "-R") { $recursive = $true; $i++ }
        elseif ($args[$i] -eq "-i") { $i++ }
        elseif ($pattern -eq "" -and $args[$i] -notlike "-*") { $pattern = $args[$i]; $i++ }
        else { $targets += $args[$i]; $i++ }
    }
    if ($pattern -eq "") { return @() }
    if ($targets.Count -eq 0) { $targets = "." }
    $results = @()
    foreach ($t in $targets) {
        $path = Resolve-LPath $t; $item = Get-LItem $path
        if (-not $item) { continue }
        if ($item.Type -eq "file" -and $item.Content) {
            foreach ($line in $item.Content) { if ($line -match $pattern) { $results += "$($t):$line" } }
        } elseif ($item.Type -eq "dir") {
            $files = if ($recursive) { Get-LDirRecursive $path } else { Get-LDirListing $path }
            foreach ($f in $files) { $fi = Get-LItem $f; if ($fi -and $fi.Type -eq "file" -and $fi.Content) { foreach ($line in $fi.Content) { if ($line -match $pattern) { $results += "$($f):$line" } } } }
        }
    }
    if ($results.Count -eq 0) { return @() }
    return $results
}

# -- find --
Register-LCommand "find" {
    param($args)
    $target = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "." }
    $path = Resolve-LPath $target
    $name = $null; $type = $null
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -eq "-name" -and $i+1 -lt $args.Count) { $name = $args[$i+1]; $i++ }
        if ($args[$i] -eq "-type" -and $i+1 -lt $args.Count) { $type = $args[$i+1]; $i++ }
    }
    $results = @()
    $allPaths = Get-LDirRecursive $path
    foreach ($p in $allPaths) {
        $leaf = Split-Path $p -Leaf; $item = Get-LItem $p
        if ($name -and $leaf -notlike $name) { continue }
        if ($type -and $item -and $item.Type -ne $type) { continue }
        $results += $p
    }
    if ($results.Count -eq 0) { return @() }
    return $results
}

# -- chmod --
Register-LCommand "chmod" {
    param($args)
    if ($args.Count -lt 2) { return @("chmod: missing operand") }
    $mode = $args[0]; $target = Resolve-LPath $args[1]; $item = Get-LItem $target
    if (-not $item) { return @("chmod: cannot access '$($args[1])': No such file or directory") }
    if ($mode -match "^\d{3}$") {
        $r = if ([int]$mode[0] -band 4) { "r" } else { "-" }
        $w = if ([int]$mode[0] -band 2) { "w" } else { "-" }
        $x = if ([int]$mode[0] -band 1 -or $mode -eq "755" -or $mode -eq "777") { "x" } else { "-" }
        $prefix = if ($item.Type -eq "dir") { "d" } else { "-" }
        $item.Perms = "$prefix$r$w$x" + $item.Perms.Substring(3)
    }
    return @()
}

# -- sudo --
Register-LCommand "sudo" {
    param($args)
    if ($args.Count -eq 0) { return @("sudo: usage: sudo <command>") }
    $cmd = $args[0]; $cmdArgs = $args[1..($args.Count-1)]
    $script:learningSudo = $true
    $handler = $script:learningCommands[$cmd]
    if ($handler) { return & $handler $cmdArgs }
    return @("sudo: ${cmd}: command not found")
}

# -- systemctl --
Register-LCommand "systemctl" {
    param($args)
    if ($args.Count -lt 2) { return @("systemctl: missing argument") }
    $action = $args[0]; $service = $args[1]
    if ($action -eq "status") {
        return @("● ${service}.service - $service server daemon",
            "     Loaded: loaded (/lib/systemd/system/${service}.service; enabled; preset: enabled)",
            "     Active: active (running) since $(Get-Date -Format 'ddd YYYY-MM-dd HH:mm:ss') UTC; 2 days ago",
            "   Main PID: 1245 (${service})",
            "      Tasks: 5 (limit: 2231)",
            "     Memory: 12.3M",
            "        CPU: 2.345s")
    }
    if ($action -eq "start" -or $action -eq "restart" -or $action -eq "reload") {
        return @("Job for ${service}.service succeeded.")
    }
    if ($action -eq "stop") { return @("Job for ${service}.service stopped.") }
    if ($action -eq "enable" -or $action -eq "disable") { return @("Created symlink /etc/systemd/system/multi-user.target.wants/${service}.service.") }
    return @()
}

# -- journalctl --
Register-LCommand "journalctl" {
    param($args)
    $n = 10
    for ($i = 0; $i -lt $args.Count; $i++) { if ($args[$i] -eq "-n" -and $i+1 -lt $args.Count) { $n = [int]$args[$i+1] } }
    $logs = @()
    $pids = (Get-Random -Minimum 1000 -Maximum 9999), (Get-Random -Minimum 1000 -Maximum 9999)
    for ($j = 0; $j -lt [Math]::Min($n, 10); $j++) {
        $logs += "$(Get-Date -Format 'MMM dd HH:mm:ss') $($script:learningHost) systemd[1]: Started service unit $j."
    }
    return $logs
}

# -- ping --
Register-LCommand "ping" {
    param($args)
    $targetHost = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "localhost" }
    return @("PING $targetHost (10.0.0.1) 56(84) bytes of data.",
        "64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.345 ms",
        "64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.289 ms",
        "64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.312 ms",
        "64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.301 ms",
        "",
        "--- $targetHost ping statistics ---",
        "4 packets transmitted, 4 received, 0% packet loss, time 3004ms",
        "rtt min/avg/max/mdev = 0.289/0.312/0.345/0.020 ms")
}

# -- ip / ifconfig --
Register-LCommand "ip" {
    param($args)
    if ($args.Count -gt 0 -and $args[0] -eq "a") {
        return @("1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN",
            "    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00",
            "    inet 127.0.0.1/8 scope host lo",
            "       valid_lft forever preferred_lft forever",
            "2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP",
            "    link/ether 00:1a:2b:3c:4d:5e brd ff:ff:ff:ff:ff:ff",
            "    inet 10.0.0.$(Rand 10 50)/24 brd 10.0.0.255 scope global eth0",
            "       valid_lft forever preferred_lft forever")
    }
    return @("Usage: ip [OPTIONS] OBJECT {COMMAND}")
}

Register-LCommand "ifconfig" {
    return @("eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500",
        "        inet 10.0.0.$(Rand 10 50)  netmask 255.255.255.0  broadcast 10.0.0.255",
        "        inet6 fe80::21a:2bff:fe3c:4d5e  prefixlen 64  scopeid 0x20<link>",
        "        ether 00:1a:2b:3c:4d:5e  txqueuelen 1000  (Ethernet)",
        "        RX packets 12345  bytes 6789012 (6.4 MiB)",
        "        TX packets 6789  bytes 1234567 (1.1 MiB)",
        "",
        "lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536",
        "        inet 127.0.0.1  netmask 255.0.0.0",
        "        inet6 ::1  prefixlen 128  scopeid 0x10<host>",
        "        loop  txqueuelen 1000  (Local Loopback)")
}

# -- wget / curl --
Register-LCommand "wget" {
    param($args)
    $url = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "http://example.com" }
    $file = if ($args.Count -gt 1 -and $args[0] -eq "-O") { $args[1] } else { "index.html" }
    return @("--$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')--  $url",
        "Resolving $(([System.Uri]$url).Host)... 93.184.216.34",
        "Connecting to $(([System.Uri]$url).Host)|93.184.216.34|:443... connected.",
        "HTTP request sent, awaiting response... 200 OK",
        "Length: 1256 (1.2K) [text/html]",
        "Saving to: '$file'",
        "",
        "$file            100%[===================>]   1.22K  --.-KB/s    in 0s",
        "",
        "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') (1.22 MB/s) - '$file' saved [1256/1256]")
}

Register-LCommand "curl" {
    param($args)
    $url = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "http://example.com" }
    $opts = @(); foreach ($a in $args) { if ($a -like "-*") { $opts += $a } }
    if ($opts -contains "-s" -or $opts -contains "--silent") { return @("<!doctype html><html><head><title>Example Domain</title>...</html>") }
    return @("  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current",
        "                                 Dload  Upload   Total   Spent    Left  Speed",
        "100  1256  100  1256    0     0   1256      0  0:00:01  0:00:01 --:--:--  1256",
        "<!doctype html><html><head><title>Example Domain</title>...</html>")
}

# -- sort --
Register-LCommand "sort" {
    param($args)
    $files = @(); forEach ($a in $args) { if ($a -notlike "-*") { $files += $a } }
    if ($files.Count -eq 0) { return @() }
    $lines = @()
    foreach ($f in $files) { $target = Resolve-LPath $f; $item = Get-LItem $target; if ($item -and $item.Content) { $lines += $item.Content } }
    return ($lines | Sort-Object)
}

# -- uniq --
Register-LCommand "uniq" {
    param($args)
    $lines = @()
    foreach ($a in $args) {
        if ($a -notlike "-*") { $target = Resolve-LPath $a; $item = Get-LItem $target; if ($item -and $item.Content) { $lines += $item.Content } }
    }
    $result = @(); $prev = $null
    foreach ($l in $lines) { if ($l -ne $prev) { $result += $l }; $prev = $l }
    return $result
}

# -- wc --
Register-LCommand "wc" {
    param($args)
    $files = @(); forEach ($a in $args) { if ($a -notlike "-*") { $files += $a } }
    if ($files.Count -eq 0) { return @("0 0 0") }
    $totalL = 0; $totalW = 0; $totalC = 0
    $results = @()
    foreach ($f in $files) {
        $target = Resolve-LPath $f; $item = Get-LItem $target
        if (-not $item) { $results += "wc: ${f}: No such file or directory"; continue }
        $content = $item.Content -join "`n"
        $l = $item.Content.Count; $w = ($content -split "\s+" | Where-Object { $_ }).Count; $c = $content.Length
        $totalL += $l; $totalW += $w; $totalC += $c
        $results += "  $l  $w  $c $f"
    }
    if ($files.Count -gt 1) { $results += "  $totalL  $totalW  $totalC total" }
    return $results
}

# -- tar --
Register-LCommand "tar" {
    param($args)
    if ($args.Count -lt 2) { return @("tar: usage: tar [options] <file>") }
    return @("")
}

# -- which --
Register-LCommand "which" {
    param($args)
    if ($args.Count -eq 0) { return @() }
    $known = @("ls","cd","cat","cp","mv","rm","mkdir","touch","pwd","whoami","hostname","id","uname","date","cal","df","du","free","ps","kill","grep","find","chmod","sudo","systemctl","journalctl","ping","ip","ifconfig","wget","curl","sort","uniq","wc","tar","echo","head","tail","less","more","man","help","clear","exit")
    $results = @()
    foreach ($c in $args) { if ($known -contains $c) { $results += "/usr/bin/$c" } else { $results += "$c not found" } }
    return $results
}

# -- less / more --
Register-LCommand "less" {
    param($args)
    if ($args.Count -eq 0) { return @() }
    $target = Resolve-LPath $args[0]; $item = Get-LItem $target
    if (-not $item) { return @("less: $($args[0]): No such file or directory") }
    if ($item.Content) { return $item.Content }
    return @()
}
Register-LCommand "more" { return & $script:learningCommands["less"] $args }

# -- man / help --
Register-LCommand "man" {
    param($args)
    if ($args.Count -eq 0) { return @("What manual page do you want?") }
    return @("MAN(1)                          User Commands                          MAN(1)",
        "",
        "NAME",
        "       $($args[0]) - simulated $($args[0]) command",
        "",
        "SYNOPSIS",
        "       $($args[0]) [OPTIONS] [ARGUMENTS]",
        "",
        "DESCRIPTION",
        "       This is a simulated man page for '$($args[0])'.",
        "       In this learning environment, the command behaves",
        "       as a realistic simulation.",
        "",
        "SEE ALSO",
        "       .hint, .skip, .check, .status")
}

Register-LCommand "help" {
    param($args)
    return @("Available commands: ls, cd, cat, head, tail, touch, mkdir, rm, cp, mv,",
        "echo, whoami, hostname, id, uname, date, cal, df, du, free, ps, kill,",
        "grep, find, chmod, sudo, systemctl, journalctl, ping, ip, ifconfig,",
        "wget, curl, sort, uniq, wc, tar, which, less, more, man, help, clear, pwd",
        "",
        "Special commands: .hint, .skip, .check, .status, .exit")
}

# -- clear --
Register-LCommand "clear" {
    return @("__CLEAR__")
}

# ===================================================================
# COMMAND PARSER
# ===================================================================

function Invoke-LearningCommand {
    param([string]$RawInput)

    $RawInput = $RawInput.Trim()
    if ([string]::IsNullOrEmpty($RawInput)) { return @() }

    # Handle redirects
    $append = $false; $redirectFile = $null
    if ($RawInput -match ">>\s*(.+)$") { $append = $true; $redirectFile = $Matches[1].Trim(); $RawInput = $RawInput -replace ">>\s*.+$", "" }
    elseif ($RawInput -match ">\s*(.+)$") { $redirectFile = $Matches[1].Trim(); $RawInput = $RawInput -replace ">\s*.+$", "" }

    # Handle pipes
    $parts = $RawInput.Split("|")
    $output = @()
    $first = $true

    foreach ($segment in $parts) {
        $segment = $segment.Trim()
        if ([string]::IsNullOrEmpty($segment)) { continue }

        # Parse command and args
        $tokens = @()
        $current = ""; $inQuote = $false; $quoteChar = ""
        foreach ($ch in $segment.ToCharArray()) {
            if ($inQuote) { if ($ch -eq $quoteChar) { $inQuote = $false } else { $current += $ch } }
            elseif ($ch -eq "'" -or $ch -eq '"') { $inQuote = $true; $quoteChar = $ch }
            elseif ($ch -eq ' ') { if ($current) { $tokens += $current; $current = "" } }
            else { $current += $ch }
        }
        if ($current) { $tokens += $current }

        if ($tokens.Count -eq 0) { continue }

        $cmdName = $tokens[0].ToLower()
        $cmdArgs = $tokens[1..($tokens.Count-1)]

        if ($first) {
            $output = @()
            $first = $false
        }

        # Handle special commands
        if ($cmdName -eq ".hint" -or $cmdName -eq ".skip" -or $cmdName -eq ".check" -or $cmdName -eq ".status" -or $cmdName -eq ".exit") {
            $output = Process-LSpecialCommand $cmdName
            continue
        }

        if ($cmdName -eq "clear") { return @("__CLEAR__") }
        if ($cmdName -eq "exit") { return @("__EXIT__") }

        # Check for command in registered handlers
        $handler = $script:learningCommands[$cmdName]
        if (-not $handler) {
            # Check if it exists as a file in vfs (script execution)
            $scriptPath = Resolve-LPath $cmdName
            $scriptItem = Get-LItem $scriptPath
            if ($scriptItem -and $scriptItem.Type -eq "file") {
                $output = @("Running script...", "[done]")
                continue
            }
            # Try common paths
            $commonPaths = @("/usr/bin/$cmdName", "/bin/$cmdName", "/usr/local/bin/$cmdName")
            $found = $false
            foreach ($cp in $commonPaths) { if (Get-LItem $cp) { $found = $true; break } }
            if ($found) { $output = @(); continue }

            if ($first) { $output = @("${cmdName}: command not found") }
            else { $output = @() }
            continue
        }

        $output = & $handler $cmdArgs
        if ($first) { $first = $false }
    }

    # Handle redirect
    if ($redirectFile) {
        $target = Resolve-LPath $redirectFile
        if ($append) {
            $existing = Get-LItem $target
            if ($existing -and $existing.Content) { $existing.Content = $existing.Content + $output }
            elseif ($existing) { $existing.Content = $output }
            else { Set-LItem $target @{ Type = "file"; Content = $output; Perms = "-rw-r--r--"; Owner = $script:learningUser; Group = $script:learningUser } }
        } else {
            Set-LItem $target @{ Type = "file"; Content = $output; Perms = "-rw-r--r--"; Owner = $script:learningUser; Group = $script:learningUser }
        }
        return @()
    }

    return $output
}

# ===================================================================
# SPECIAL COMMANDS (.hint, .skip, .check, .status)
# ===================================================================

function Process-LSpecialCommand {
    param([string]$Command)

    $task = $script:learningTasks[$script:learningCurrentTask]
    if (-not $task) { return @("No active task.") }

    switch ($Command) {
        ".hint" {
            $script:learningHintUsed[$script:learningCurrentTask] = $true
            $hint = $task.Hint
            if ([string]::IsNullOrEmpty($hint)) { $hint = "Spróbuj użyć komendy: $($task.ExpectedCommand)" }
            return @("", "  [HINT] $hint", "")
        }
        ".skip" {
            $script:learningSkippedTasks[$script:learningCurrentTask] = $true
            $solution = $task.ExpectedCommand
            return @("", "  [SKIP] Rozwiazanie: $solution", "  [SKIP] Przechodze do nastepnego zadania.", "")
        }
        ".check" {
            if ($task.ContainsKey("Check") -and $task.Check) {
                $result = & $task.Check
                if ($result -eq $true) {
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    return @("", "  [CHECK] Zadanie $($script:learningCurrentTask + 1)/$($script:learningTasks.Count) wykonane!", "  [CHECK] Gratulacje!", "")
                }
                return @("", "  [CHECK] Jeszcze nie gotowe. Wskazowka: .hint", "")
            }
            # Fallback: check if expected command was used
            if ($script:learningCompletedTasks.ContainsKey($script:learningCurrentTask)) {
                return @("", "  [CHECK] Zadanie $($script:learningCurrentTask + 1) juz wykonane!", "")
            }
            return @("", "  [CHECK] Jeszcze nie gotowe.", "")
        }
        ".status" {
            $total = $script:learningTasks.Count
            $done = $script:learningCompletedTasks.Keys.Count
            $skipped = $script:learningSkippedTasks.Keys.Count
            $current = $script:learningCurrentTask + 1
            $progress = [Math]::Floor(($done / [Math]::Max(1, $total)) * 100)
            $bar = "[" + ("#" * $done) + ("-" * ($total - $done)) + "]"
            return @("", "  Postep: $bar $progress%", "  Wykonane: $done/$total | Pominiete: $skipped | Aktualne: $current/$total", "")
        }
        ".exit" {
            return @("__EXIT__")
        }
    }
    return @()
}

function Check-CommandMatches {
    param([string]$Input, [string]$Expected)
    $in = $Input.Trim().ToLower().Replace("  ", " ")
    $ex = $Expected.Trim().ToLower().Replace("  ", " ")
    if ($in -eq $ex) { return $true }
    # Also match if the command starts the same (covers pipes)
    if ($in -match "^$([regex]::Escape($ex))") { return $true }
    return $false
}

# ===================================================================
# INPUT READER — free typing with backspace support
# ===================================================================

function Read-LearningInput {
    $buffer = ""
    $cursor = 0
    while ($true) {
        $k = Read-ConsoleKey
        if (-not $k) { Start-Sleep -Milliseconds 10; continue }

        if ($k.Key -eq "Escape") { return "__ESCAPE__" }
        if ($k.Key -eq "Enter") {
            if ($buffer.Length -gt 0) { $script:learningLastCmd = $buffer }
            Write-Host ""
            return $buffer
        }
        if ($k.Key -eq "Backspace") {
            if ($cursor -gt 0) {
                $buffer = $buffer.Substring(0, $cursor - 1) + $buffer.Substring($cursor)
                $cursor--
                # Redraw line
                $pos = Get-CursorPosition
                Set-CursorPosition -X 0 -Y $pos.Y
                Write-Host (" " * ($buffer.Length + 2)) -NoNewline
                Set-CursorPosition -X 0 -Y $pos.Y
                if ($buffer.Length -gt 0) { Write-Host -NoNewline $buffer -ForegroundColor White }
                Write-Host -NoNewline ""
            }
            continue
        }
        if ($k.Key -eq "UpArrow") {
            if ($script:learningLastCmd) {
                $pos = Get-CursorPosition
                Set-CursorPosition -X 0 -Y $pos.Y
                Write-Host (" " * [Math]::Max($buffer.Length + 2, 40)) -NoNewline
                Set-CursorPosition -X 0 -Y $pos.Y
                $buffer = $script:learningLastCmd
                $cursor = $buffer.Length
                Write-Host -NoNewline $buffer -ForegroundColor White
            }
            continue
        }
        if ($k.KeyChar -and $k.KeyChar -ne "`0") {
            $ch = $k.KeyChar
            $buffer = $buffer.Substring(0, $cursor) + $ch + $buffer.Substring($cursor)
            $cursor++
            Write-Host -NoNewline $ch -ForegroundColor White
        }
        Start-Sleep -Milliseconds 5
    }
}

# ===================================================================
# LEARNING SESSION — interactive loop
# ===================================================================

function Start-LearningSession {
    param(
        [string]$SystemName = "Ubuntu",
        [string]$Hostname = "ubuntu",
        [string]$Username = "student",
        [string]$OsName = "Ubuntu 24.04 LTS",
        [string]$PromptString = "student@ubuntu:~$",
        [hashtable]$Filesystem,
        [array]$Tasks,
        [hashtable]$Theme
    )

    $script:learningUser = $Username
    $script:learningHost = $Hostname
    $script:learningOsName = $OsName
    $script:learningPrompt = $PromptString
    $script:learningTasks = $Tasks
    $script:learningCurrentTask = 0
    $script:learningCompletedTasks = @{}
    $script:learningHintUsed = @{}
    $script:learningSkippedTasks = @{}
    $script:learningLastCmd = ""

    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    try { [console]::CursorVisible = $false } catch { }
    try { $Host.UI.RawUI.WindowTitle = "Learning Mode - $SystemName" } catch { }

    # Matrix intro
    Matrix-Rain -DurationSeconds 3 -Theme $Theme
    Clear-Host

    # Welcome
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "     TRYB NAUKI — $SystemName" -ForegroundColor Green
    Write-Host "     Tryb: interaktywny symulator terminala" -ForegroundColor DarkGray
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Witaj w trybie nauki! Symulujesz sesje terminala" -ForegroundColor Gray
    Write-Host "  systemu $OsName." -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Polecenia specjalne:" -ForegroundColor Yellow
    Write-Host "    .hint    - podpowiedz" -ForegroundColor DarkYellow
    Write-Host "    .skip    - pomin zadanie" -ForegroundColor DarkYellow
    Write-Host "    .check   - sprawdz zadanie" -ForegroundColor DarkYellow
    Write-Host "    .status  - postep" -ForegroundColor DarkYellow
    Write-Host "    .exit    - zakoncz" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "  Masz do wykonania $($Tasks.Count) zadan dla tego systemu." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Nacisnij ENTER aby rozpoczac..." -ForegroundColor DarkGray

    while ($true) {
        $k = Read-ConsoleKey; if ($k -and ($k.Key -eq "Enter" -or $k.Key -eq "Escape")) { break }
        Start-Sleep -Milliseconds 50
    }
    Clear-Host

    # Main loop
    while ($script:learningCurrentTask -lt $script:learningTasks.Count) {
        $task = $script:learningTasks[$script:learningCurrentTask]

        # Show task briefing (only if not already completed or visited)
        if (-not $script:learningCompletedTasks.ContainsKey($script:learningCurrentTask) -and
            -not $script:learningSkippedTasks.ContainsKey($script:learningCurrentTask)) {

            $difficultyLabel = switch ($task.Difficulty) {
                "beginner" { "POCZATKUJACY" }
                "intermediate" { "SREDNIOZAAWANSOWANY" }
                "advanced" { "ZAAWANSOWANY" }
                "expert" { "EKSPERT" }
                default { $task.Difficulty }
            }

            Write-Host ""
            Write-Host "  $("=" * 45)" -ForegroundColor $Theme.accent
            Write-Host "  Zadanie $($script:learningCurrentTask + 1)/$($script:learningTasks.Count)" -ForegroundColor Cyan
            Write-Host "  Poziom: $difficultyLabel" -ForegroundColor $Theme.accent
            Write-Host "  $("=" * 45)" -ForegroundColor $Theme.accent
            Write-Host ""
            foreach ($td in $task.Description) {
                Write-Host "    $td" -ForegroundColor Gray
            }
            Write-Host ""
            Write-Host "  Wpisz .hint po podpowiedz, .skip aby pominac." -ForegroundColor DarkGray
            Write-Host ""
            Start-Sleep -Milliseconds 500
        }

        # Command loop for this task
        $taskDone = $false
        while (-not $taskDone) {
            if (($script:learningCompletedTasks.ContainsKey($script:learningCurrentTask)) -or
                ($script:learningSkippedTasks.ContainsKey($script:learningCurrentTask))) {
                $taskDone = $true; break
            }

            # Prompt
            $rootChar = if ($script:learningSudo -or $script:learningUser -eq "root") { "#" } else { "$" }
            Write-Host -NoNewline "$Username@$Hostname`:$($script:learningCwd)$rootChar " -ForegroundColor $Theme.promptColor

            # Read user input
            $input = Read-LearningInput
            if ($input -eq "__ESCAPE__") { return }
            if ([string]::IsNullOrWhiteSpace($input)) { continue }

            # Check for special commands
            $trimmed = $input.Trim()
            if ($trimmed -eq ".exit" -or $trimmed -eq "exit") {
                Write-Host "Koniec sesji." -ForegroundColor DarkGray
                Start-Sleep -Milliseconds 300
                return
            }
            if ($trimmed -eq ".skip") {
                $solution = $task.ExpectedCommand
                Write-Host ""; Write-Host "  [SKIP] Rozwiazanie: $solution" -ForegroundColor Yellow
                Write-Host "  [SKIP] Przechodze dalej." -ForegroundColor Yellow
                $script:learningSkippedTasks[$script:learningCurrentTask] = $true
                $script:learningCurrentTask++
                Start-Sleep -Milliseconds 500
                Clear-Host
                break
            }
            if ($trimmed -eq ".check") {
                $completed = $false
                if ($task.ContainsKey("Check") -and $task.Check) {
                    $result = & $task.Check
                    if ($result -eq $true) { $completed = $true }
                }
                if ($completed) {
                    Write-Host ""; Write-Host "  [CHECK] Zadanie $($script:learningCurrentTask + 1) wykonane!" -ForegroundColor Green; Write-Host ""
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    $script:learningCurrentTask++
                    Start-Sleep -Milliseconds 500
                    Clear-Host
                    break
                } else {
                    Write-Host ""; Write-Host "  [CHECK] Jeszcze nie gotowe. Sprobuj .hint" -ForegroundColor Yellow; Write-Host ""
                }
                continue
            }
            if ($trimmed -eq ".hint") {
                $hint = $task.Hint
                if ([string]::IsNullOrEmpty($hint)) { $hint = "Sprobuj: $($task.ExpectedCommand)" }
                $script:learningHintUsed[$script:learningCurrentTask] = $true
                Write-Host ""; Write-Host "  [HINT] $hint" -ForegroundColor Yellow; Write-Host ""
                continue
            }
            if ($trimmed -eq ".status") {
                $total = $script:learningTasks.Count
                $done = $script:learningCompletedTasks.Keys.Count
                $skipped = $script:learningSkippedTasks.Keys.Count
                Write-Host ""; Write-Host "  Wykonane: $done/$total | Pominiete: $skipped | Biezace: $($script:learningCurrentTask + 1)/$total" -ForegroundColor Cyan; Write-Host ""
                continue
            }

            # Process command
            $output = Invoke-LearningCommand $trimmed

            # Handle clear
            if ($output.Count -eq 1 -and $output[0] -eq "__CLEAR__") { Clear-Host; continue }
            if ($output.Count -eq 1 -and $output[0] -eq "__EXIT__") { Write-Host "Koniec sesji." -ForegroundColor DarkGray; return }

            # Show output
            if ($output.Count -gt 0) {
                foreach ($line in $output) {
                    $color = "Gray"
                    if ($line -match "^  \[(HINT|SKIP|CHECK|POSTEP)") { $color = "Yellow" }
                    elseif ($line -match "error|denied|No such file|not found") { $color = "Red" }
                    elseif ($line -match "drwxr|^-rw") { $color = "Cyan" }
                    elseif ($line -match "^total ") { $color = "DarkGray" }
                    Write-Host $line -ForegroundColor $color
                }
                Write-Host ""
            }

            # Check if command matches expected
            if ($task.ExpectedCommand) {
                if (Check-CommandMatches $trimmed $task.ExpectedCommand) {
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    Write-Host "  + Zadanie $($script:learningCurrentTask + 1) wykonane!" -ForegroundColor Green
                    Write-Host ""
                    $script:learningCurrentTask++
                    Start-Sleep -Milliseconds 400
                    Clear-Host
                    break
                }
            }

            # Also check the custom Check scriptblock
            if ($task.ContainsKey("Check") -and $task.Check) {
                $result = & $task.Check
                if ($result -eq $true) {
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    Write-Host "  + Zadanie $($script:learningCurrentTask + 1) wykonane!" -ForegroundColor Green
                    Write-Host ""
                    $script:learningCurrentTask++
                    Start-Sleep -Milliseconds 400
                    Clear-Host
                    break
                }
            }

            Start-Sleep -Milliseconds 50
        }

        if ($script:learningCurrentTask -ge $script:learningTasks.Count) { break }
    }

    # Completion
    $total = $script:learningTasks.Count
    $done = $script:learningCompletedTasks.Keys.Count
    $skipped = $script:learningSkippedTasks.Keys.Count

    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host "     KONIEC — Tryb nauki: $SystemName" -ForegroundColor Green
    Write-Host "  ========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Wyniki:" -ForegroundColor Gray
    Write-Host "  Wykonane:  $done/$total" -ForegroundColor Cyan
    Write-Host "  Pominiete: $skipped/$total" -ForegroundColor Yellow
    Write-Host "  Podpowiedzi uzyto: $($script:learningHintUsed.Keys.Count)" -ForegroundColor DarkGray
    Write-Host ""

    if ($done -eq $total) {
        Write-Host "  Wszystkie zadania wykonane! Gratulacje!" -ForegroundColor Green
    } else {
        Write-Host "  Nacisnij ENTER aby wrocic do menu." -ForegroundColor DarkGray
        while ($true) { $k = Read-ConsoleKey; if ($k -and ($k.Key -eq "Enter" -or $k.Key -eq "Escape")) { break }; Start-Sleep -Milliseconds 50 }
    }

    Clear-Host
    Matrix-Rain -Infinite -Theme $Theme
    Start-Sleep -Milliseconds 500
    try { [console]::CursorVisible = $true } catch { }
}
