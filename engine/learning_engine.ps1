# =====================================================================
# LEARNING ENGINE - Virtual FS, command parser, task system
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
$script:learningHistory = [System.Collections.Generic.List[string]]::new()
$script:learningHistoryIdx = -1

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
    # Build display names with / suffix for dirs, padded for alignment
    $displayNames = @()
    foreach ($e in $entries) {
        $epath = "$target/$e"
        $ei = Get-LItem $epath
        $isDir = $ei -and $ei.Type -eq "dir"
        $displayNames += if ($isDir) { "__DIR__$e/" } else { "__FILE__$e" }
    }
    # Calculate max actual display name length (strip prefix)
    $maxName = ($displayNames | ForEach-Object {
        $prefixLen = if ($_ -like "__DIR__*") { 7 } else { 8 }
        $_.Length - $prefixLen
    } | Measure-Object -Maximum).Maximum
    $colWidth = [Math]::Max(10, $maxName + 2)
    $termW = $Host.UI.RawUI.WindowSize.Width
    if ($termW -lt 40) { $termW = 80 }
    $cols = [Math]::Max(1, [Math]::Floor($termW / $colWidth))
    $output = @()
    $row = @()
    foreach ($d in $displayNames) {
        $row += $d
        if ($row.Count -ge $cols) {
            $output += $row -join ""
            $row = @()
        }
    }
    if ($row.Count -gt 0) { $output += $row -join "" }
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
    $recursive = $false; $caseInsensitive = $false; $showLineNum = $false
    $invertMatch = $false; $filesOnly = $false; $countOnly = $false
    $pattern = ""; $targets = @()
    $i = 0
    while ($i -lt $args.Count) {
        $a = $args[$i]
        if ($a -match "^-[a-zA-Z]+$") {
            if ($a -match "r|R") { $recursive = $true }
            if ($a -match "i") { $caseInsensitive = $true }
            if ($a -match "n") { $showLineNum = $true }
            if ($a -match "v") { $invertMatch = $true }
            if ($a -match "l") { $filesOnly = $true }
            if ($a -match "c") { $countOnly = $true }
            $i++
        } elseif ($pattern -eq "") { $pattern = $a; $i++ }
        else { $targets += $a; $i++ }
    }
    if ($pattern -eq "") { return @("grep: missing pattern") }
    if ($targets.Count -eq 0) { $targets = @(".") }
    $results = @()
    $matchFn = if ($caseInsensitive) { { param($l,$p) $l -imatch $p } } else { { param($l,$p) $l -cmatch $p } }
    foreach ($t in $targets) {
        $path = Resolve-LPath $t; $item = Get-LItem $path
        if (-not $item) { $results += "grep: ${t}: No such file or directory"; continue }
        $filesToSearch = @()
        if ($item.Type -eq "file") { $filesToSearch = @($path) }
        elseif ($item.Type -eq "dir") {
            $filesToSearch = if ($recursive) { Get-LDirRecursive $path } else { Get-LDirListing $path }
            $filesToSearch = $filesToSearch | Where-Object { $fi = Get-LItem $_; $fi -and $fi.Type -eq "file" }
        }
        foreach ($fp in $filesToSearch) {
            $fi = Get-LItem $fp
            if (-not $fi -or -not $fi.Content) { continue }
            $lineNum = 0; $matchCount = 0
            foreach ($line in $fi.Content) {
                $lineNum++
                $matched = & $matchFn $line $pattern
                $show = if ($invertMatch) { -not $matched } else { $matched }
                if ($show) {
                    $matchCount++
                    if (-not $filesOnly -and -not $countOnly) {
                        $prefix = if ($targets.Count -gt 1 -or $item.Type -eq "dir") { "${fp}:" } else { "" }
                        $numPrefix = if ($showLineNum) { "${lineNum}:" } else { "" }
                        $results += "$prefix$numPrefix$line"
                    }
                }
            }
            if ($filesOnly -and $matchCount -gt 0) { $results += $fp }
            if ($countOnly) { $results += "${fp}:$matchCount" }
        }
    }
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
    $recursive = $false
    $modeArg = $null; $targetArg = $null
    foreach ($a in $args) { if ($a -eq "-R" -or $a -eq "-r") { $recursive = $true } elseif (-not $modeArg) { $modeArg = $a } else { $targetArg = $a } }
    if (-not $modeArg -or -not $targetArg) { return @("chmod: missing operand") }
    $target = Resolve-LPath $targetArg; $item = Get-LItem $target
    if (-not $item) { return @("chmod: cannot access '$targetArg': No such file or directory") }
    function ConvertOctalToPerms($digit, $isDir) {
        $d = [int][string]$digit
        $r = if ($d -band 4) { "r" } else { "-" }
        $w = if ($d -band 2) { "w" } else { "-" }
        $x = if ($d -band 1) { "x" } else { "-" }
        return "$r$w$x"
    }
    if ($modeArg -match "^(\d)(\d)(\d)$") {
        $prefix = if ($item.Type -eq "dir") { "d" } else { "-" }
        $item.Perms = "$prefix$(ConvertOctalToPerms $Matches[1] $false)$(ConvertOctalToPerms $Matches[2] $false)$(ConvertOctalToPerms $Matches[3] $false)"
    } elseif ($modeArg -match "^([ugoa]*)([+\-=])([rwx]+)$") {
        $who = $Matches[1]; $op = $Matches[2]; $bits = $Matches[3]
        $perms = if ($item.Perms.Length -ge 10) { $item.Perms } else { "-rwxr-xr-x" }
        $uBits = $perms.Substring(1,3).ToCharArray(); $gBits = $perms.Substring(4,3).ToCharArray(); $oBits = $perms.Substring(7,3).ToCharArray()
        $applyBits = { param($sect, $op, $bits)
            $s = $sect -join ""
            foreach ($b in $bits.ToCharArray()) {
                if ($b -eq "r") { if ($op -eq "+") { $s = $s -replace "^.", "r" } elseif ($op -eq "-") { $s = $s -replace "^.", "-" } }
                if ($b -eq "w") { if ($op -eq "+") { $s = $s.Remove(1,1).Insert(1,"w") } elseif ($op -eq "-") { $s = $s.Remove(1,1).Insert(1,"-") } }
                if ($b -eq "x") { if ($op -eq "+") { $s = $s.Remove(2,1).Insert(2,"x") } elseif ($op -eq "-") { $s = $s.Remove(2,1).Insert(2,"-") } }
            }
            return $s
        }
        $prefix = $perms[0]
        if ($who -match "u" -or $who -eq "" -or $who -eq "a") { $uBits = (& $applyBits $uBits $op $bits).ToCharArray() }
        if ($who -match "g" -or $who -eq "" -or $who -eq "a") { $gBits = (& $applyBits $gBits $op $bits).ToCharArray() }
        if ($who -match "o" -or $who -eq "" -or $who -eq "a") { $oBits = (& $applyBits $oBits $op $bits).ToCharArray() }
        $item.Perms = "$prefix$($uBits -join '')$($gBits -join '')$($oBits -join '')"
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
        return @("* ${service}.service - $service server daemon",
            "     Loaded: loaded (/lib/systemd/system/${service}.service; enabled; preset: enabled)",
            "     Active: active (running) since $(Get-Date -Format 'ddd yyyy-MM-dd HH:mm:ss') UTC; 2 days ago",
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

# -- tar (improved) --
Register-LCommand "tar" {
    param($args)
    if ($args.Count -lt 1) { return @("tar: usage: tar [czxvf...] [archive] [files...]") }
    $flags = ""; $archive = $null; $files = @()
    foreach ($a in $args) { if ($a -like "-*") { $flags += $a.TrimStart("-") } elseif (-not $archive) { $archive = $a } else { $files += $a } }
    if ($flags -notmatch "[cxt]") { $flags2 = if ($args.Count -gt 0) { $args[0] }; if ($flags2 -match "^[czxvfjt]+$") { $flags = $flags2 } }
    if ($flags -match "c") {
        $fileList = if ($files.Count -gt 0) { $files } else { @("(files)") }
        $output = @()
        if ($flags -match "v") { foreach ($f in $fileList) { $output += "a $f" } }
        $output += if ($flags -match "z") { "gzip: $archive compressed" } else { "tar: $archive created" }
        return $output
    }
    if ($flags -match "x") {
        $output = @()
        if ($flags -match "v") { $output += "x ./etc/", "x ./etc/hosts", "x ./etc/passwd", "x ./var/log/syslog" }
        $output += "tar: extraction complete"
        return $output
    }
    if ($flags -match "t") {
        return @("./", "./etc/", "./etc/hosts", "./etc/passwd", "./var/", "./var/log/", "./var/log/syslog", "./home/student/")
    }
    return @("tar: unrecognized option. Try: tar czf archive.tar.gz /path")
}

# -- nmap --
Register-LCommand "nmap" {
    param($args)
    $targetHost = "localhost"
    foreach ($a in $args) { if ($a -notlike "-*") { $targetHost = $a } }
    $ip = if ($targetHost -match "^\d+\.\d+\.\d+\.\d+") { $targetHost } else { "10.0.0.$(Rand 1 254)" }
    return @(
        "Starting Nmap 7.94SVN ( https://nmap.org )",
        "Nmap scan report for $targetHost ($ip)",
        "Host is up (0.00$(Rand 1 99)s latency).",
        "",
        "PORT      STATE  SERVICE    VERSION",
        "22/tcp    open   ssh        OpenSSH 9.6p1",
        "80/tcp    open   http       nginx 1.24.0",
        "443/tcp   open   https      nginx 1.24.0",
        "3306/tcp  closed mysql",
        "8080/tcp  closed http-proxy",
        "",
        "Nmap done: 1 IP address (1 host up) scanned in 0.$(Rand 10 99) seconds"
    )
}

# -- top (simple static) --
Register-LCommand "top" {
    $h = Get-Date -Format "HH:mm:ss"; $u = $script:learningUser
    return @(
        "top - $h up $(Rand 1 72)h $(Rand 0 59)m,  1 user,  load avg: 0.$(Rand 10 99), 0.$(Rand 5 50), 0.0$(Rand 1 9)",
        "Tasks: 123 total,   1 running, 122 sleeping,   0 stopped,   0 zombie",
        "%Cpu(s):  $(Rand 1 30).$(Rand 0 9) us,  $(Rand 1 10).$(Rand 0 9) sy,  0.0 ni, $(Rand 60 95).0 id,  0.0 wa",
        "MiB Mem :  16000.0 total,   5000.0 free,   3245.0 used,   7755.0 buff/cache",
        "MiB Swap:   2048.0 total,   2014.0 free,     34.0 used.   12000.0 avail Mem",
        "",
        "  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND",
        "    1 root      20   0   12345   1234    890 S   0.0   0.0   0:03.12 systemd",
        "  892 root      20   0   23456   3456   2234 S   0.0   0.0   0:45.23 sshd",
        " 1245 www-data  20   0   34567   5678   4321 S   0.1   0.0   2:12.34 nginx",
        " 2456 $u         20   0   45678  12345   8765 S   0.3   0.1   1:23.45 bash",
        " 3789 $u         20   0   34567   2345   1234 R   0.0   0.0   0:00.01 top",
        "",
        "(press q or Ctrl+C to quit)"
    )
}

# -- git --
Register-LCommand "git" {
    param($args)
    if ($args.Count -eq 0) { return @("usage: git [options] <command>") }
    $sub = $args[0]
    $rest = if ($args.Count -gt 1) { $args[1..($args.Count-1)] } else { @() }
    switch ($sub) {
        "status"  { return @("On branch main", "Your branch is up to date with 'origin/main'.", "", "nothing to commit, working tree clean") }
        "log"     { return @("commit a1b2c3d4e5f6 (HEAD -> main, origin/main)", "Author: $($script:learningUser) <$($script:learningUser)@example.com>", "Date:   $(Get-Date -Format 'ddd MMM dd HH:mm:ss yyyy') +0000", "", "    Initial commit", "") }
        "add"     { return @() }
        "commit"  { return @("[main a1b2c3d] $($rest -join ' ')", " 1 file changed, 1 insertion(+)") }
        "push"    { return @("Enumerating objects: 3, done.", "Counting objects: 100% (3/3), done.", "Writing objects: 100% (3/3), 256 bytes | 256.00 KiB/s, done.", "Total 3 (delta 0), reused 0 (delta 0)", "To github.com:user/repo.git", "   a1b2c3d..b2c3d4e  main -> main") }
        "pull"    { return @("Already up to date.") }
        "clone"   { $repo = if ($rest.Count -gt 0) { $rest[0] } else { "repo" }; return @("Cloning into '$repo'...", "remote: Enumerating objects: 42, done.", "Receiving objects: 100% (42/42), 1.23 MiB | 2.34 MiB/s, done.") }
        "branch"  { return @("* main", "  develop", "  feature/auth") }
        "checkout" { return @("Switched to branch '$($rest -join ' ')'") }
        "diff"    { return @("diff --git a/file.txt b/file.txt", "index a1b2c3..d4e5f6 100644", "--- a/file.txt", "+++ b/file.txt", "@@ -1,3 +1,4 @@", " line1", "+new line", " line2") }
        "init"    { return @("Initialized empty Git repository in $($script:learningCwd)/.git/") }
        default   { return @("git: '$sub' is not a git command. See 'git help'") }
    }
}

# -- docker --
Register-LCommand "docker" {
    param($args)
    if ($args.Count -eq 0) { return @("Usage: docker [OPTIONS] COMMAND") }
    $sub = $args[0]; $rest = if ($args.Count -gt 1) { $args[1..($args.Count-1)] } else { @() }
    $subCmd = if ($rest.Count -gt 0) { $rest[0] } else { "" }
    switch ($sub) {
        "ps"        { return @("CONTAINER ID   IMAGE          COMMAND                  CREATED       STATUS         PORTS                  NAMES", "a1b2c3d4e5f6   nginx:latest   '/docker-entrypoint...'   2 hours ago   Up 2 hours     0.0.0.0:80->80/tcp   web", "b2c3d4e5f6a7   mysql:8.0      'docker-entrypoint.s...'   2 hours ago   Up 2 hours     3306/tcp               db") }
        "images"    { return @("REPOSITORY   TAG       IMAGE ID       CREATED        SIZE", "nginx        latest    a1b2c3d4e5f6   2 weeks ago    187MB", "mysql        8.0       b2c3d4e5f6a7   3 weeks ago    578MB", "ubuntu       24.04     c3d4e5f6a7b8   4 weeks ago    78.1MB") }
        "run"       { return @("$(([guid]::NewGuid().ToString().Replace('-','').Substring(0,12)))") }
        "stop"      { return @("$($rest -join ' ')") }
        "rm"        { return @("$($rest -join ' ')") }
        "rmi"       { return @("Untagged: $($rest -join ' ')", "Deleted: sha256:a1b2c3d4e5f6") }
        "pull"      { $img = if ($rest.Count -gt 0) { $rest[0] } else { "image" }; return @("Using default tag: latest", "latest: Pulling from library/$img", "Digest: sha256:a1b2c3d4e5f6a7b8c9d0", "Status: Image is up to date for ${img}:latest") }
        "build"     { return @("Step 1/4 : FROM ubuntu:24.04", "Step 2/4 : RUN apt-get update", "Step 3/4 : COPY . /app", "Step 4/4 : CMD ['/app/start.sh']", "Successfully built a1b2c3d4e5f6", "Successfully tagged myapp:latest") }
        "exec"      { return @("") }
        "logs"      { return @("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') container started", "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') service ready") }
        "network"   { return @("NETWORK ID     NAME      DRIVER    SCOPE", "a1b2c3d4e5f6   bridge    bridge    local", "b2c3d4e5f6a7   host      host      local") }
        "volume"    { return @("DRIVER    VOLUME NAME", "local     myapp_data", "local     mysql_data") }
        "compose"   { return @("Starting services...", "Starting db ... done", "Starting web ... done") }
        default     { return @("docker: '$sub' is not a docker command. See 'docker help'") }
    }
}

# -- nano / vi / vim (stub) --
Register-LCommand "nano" {
    param($args)
    $f = if ($args.Count -gt 0) { $args[0] } else { "" }
    return @("  [nano] Simulated editor mode - $f", "  (In a real terminal, nano would open here.)", "  Press Ctrl+X to exit nano." )
}
Register-LCommand "vi"   { return & $script:learningCommands["nano"] $args }
Register-LCommand "vim"  { return & $script:learningCommands["nano"] $args }

# -- chown --
Register-LCommand "chown" {
    param($args)
    if ($args.Count -lt 2) { return @("chown: missing operand") }
    $owner = $args[0]; $target = Resolve-LPath $args[1]; $item = Get-LItem $target
    if (-not $item) { return @("chown: cannot access '$($args[1])': No such file or directory") }
    if ($owner -match "^([^:]+):(.+)$") { $item.Owner = $Matches[1]; $item.Group = $Matches[2] }
    else { $item.Owner = $owner }
    return @()
}

# -- ssh --
Register-LCommand "ssh" {
    param($args)
    $host = if ($args.Count -gt 0 -and $args[0] -notlike "-*") { $args[0] } else { "server" }
    $user = if ($host -match "^(.+)@") { $Matches[1] } else { $script:learningUser }
    $hostOnly = $host -replace "^.+@", ""
    return @("ssh: connect to $hostOnly on port 22: Connection established (simulated)",
        "Welcome to Ubuntu 24.04 LTS - $hostOnly",
        "$user@${hostOnly}:~`$  (ssh session - type 'exit' to disconnect)")
}

# -- scp --
Register-LCommand "scp" {
    param($args)
    $src = if ($args.Count -gt 0) { $args[0] } else { "file" }
    $dst = if ($args.Count -gt 1) { $args[1] } else { "." }
    return @("$src                100% 1024     1.0KB/s   00:00")
}

# -- which --
Register-LCommand "which" {
    param($args)
    if ($args.Count -eq 0) { return @() }
    $known = @("ls","cd","cat","cp","mv","rm","mkdir","touch","pwd","whoami","hostname","id","uname","date","cal","df","du","free","ps","kill","grep","find","chmod","chown","sudo","systemctl","journalctl","ping","nmap","ip","ifconfig","wget","curl","sort","uniq","wc","tar","echo","head","tail","less","more","man","help","clear","exit","git","docker","nano","vi","vim","ssh","scp","top","history","env","alias","uptime","lsblk","ss","netstat","neofetch","who","w")
    $results = @()
    foreach ($c in $args) { if ($known -contains $c -or $script:learningCommands.ContainsKey($c)) { $results += "/usr/bin/$c" } else { $results += "which: no $c in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)" } }
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
    if ($args.Count -eq 0) { return @("What manual page do you want?", "Usage: man <command>") }
    $cmd = $args[0].ToLower()
    $pages = @{
        "ls"         = @("LS(1) - list directory contents", "SYNOPSIS: ls [OPTION]... [FILE]...", "", "  -l    use long listing format", "  -a    do not ignore entries starting with .", "  -h    human-readable sizes (with -l)", "  -R    list subdirectories recursively", "  -t    sort by modification time", "EXAMPLES:", "  ls -la /etc        list all files with permissions", "  ls -lh /var/log    list with human-readable sizes")
        "cd"         = @("CD(1) - change directory", "SYNOPSIS: cd [DIR]", "", "  cd ~       go to home directory", "  cd ..      go up one level", "  cd -       go to previous directory", "  cd /etc    go to absolute path")
        "grep"       = @("GREP(1) - print lines matching a pattern", "SYNOPSIS: grep [OPTIONS] PATTERN [FILE...]", "", "  -r    recursive search", "  -i    case-insensitive", "  -n    show line numbers", "  -v    invert match (show non-matching)", "  -l    show only filenames", "  -c    count matching lines", "EXAMPLES:", "  grep -r 'error' /var/log    search recursively", "  grep -in 'root' /etc/passwd  case-insensitive with line numbers")
        "chmod"      = @("CHMOD(1) - change file permissions", "SYNOPSIS: chmod [OPTIONS] MODE FILE...", "", "  Numeric: chmod 755 file  (rwxr-xr-x)", "  Symbolic: chmod u+x file  (add execute for user)", "", "  4 = read (r), 2 = write (w), 1 = execute (x)", "  u=user, g=group, o=other, a=all", "EXAMPLES:", "  chmod 644 file.conf    rw-r--r--", "  chmod +x script.sh     add execute bit")
        "find"       = @("FIND(1) - search for files in a directory hierarchy", "SYNOPSIS: find [PATH] [EXPRESSION]", "", "  -name PATTERN    match filename", "  -type f/d        file or directory", "  -mtime N         modified N days ago", "  -size +1M        larger than 1MB", "  -exec CMD {} ;   execute command on match", "EXAMPLES:", "  find /etc -name '*.conf'        find config files", "  find /var -mtime -1 -type f     files modified today")
        "tar"        = @("TAR(1) - archive utility", "SYNOPSIS: tar [OPTIONS] [ARCHIVE] [FILES]", "", "  c    create archive", "  x    extract archive", "  z    use gzip compression", "  j    use bzip2 compression", "  v    verbose output", "  f    specify filename", "EXAMPLES:", "  tar -czf backup.tar.gz /etc    create compressed archive", "  tar -xzf backup.tar.gz         extract archive")
        "systemctl"  = @("SYSTEMCTL(1) - control the systemd system and service manager", "SYNOPSIS: systemctl [OPTIONS] COMMAND [UNIT]", "", "  start/stop/restart/reload UNIT    manage service state", "  enable/disable UNIT               control autostart", "  status UNIT                       show service status", "  list-units                        list all units", "  daemon-reload                     reload unit files")
        "apt"        = @("APT(8) - Advanced Package Tool", "SYNOPSIS: apt [OPTIONS] COMMAND", "", "  update              update package index", "  upgrade             upgrade installed packages", "  install PKG         install package", "  remove PKG          remove package", "  search TERM         search packages", "  list --installed    list installed packages", "  show PKG            show package details")
        "ssh"        = @("SSH(1) - OpenSSH remote login client", "SYNOPSIS: ssh [OPTIONS] [USER@]HOST", "", "  -p PORT     connect to specific port", "  -i FILE     identity file (private key)", "  -L PORT     local port forwarding", "  -X          enable X11 forwarding", "EXAMPLES:", "  ssh user@192.168.1.1          basic connection", "  ssh -p 2222 user@server.com   non-standard port")
        "ps"         = @("PS(1) - report a snapshot of current processes", "SYNOPSIS: ps [OPTIONS]", "", "  aux    show all processes (BSD style)", "  -ef    show all processes (UNIX style)", "  -u     show processes for user", "EXAMPLES:", "  ps aux | grep nginx       find nginx processes", "  ps -ef --forest           show process tree")
        "ip"         = @("IP(8) - show/manipulate routing, network devices", "SYNOPSIS: ip [OPTIONS] OBJECT COMMAND", "", "  ip addr show              show addresses", "  ip route show             show routing table", "  ip link set eth0 up/down  manage interface", "  ip addr add 192.168.1.1/24 dev eth0  add address")
    }
    $header = "$($cmd.ToUpper())(1)" + " " * 20 + "User Commands" + " " * 20 + "$($cmd.ToUpper())(1)"
    if ($pages.ContainsKey($cmd)) {
        return @($header, "") + $pages[$cmd] + @("", "(END) - press q or ENTER to continue")
    }
    return @($header, "", "NAME", "       $cmd - $cmd command", "", "SYNOPSIS", "       $cmd [OPTIONS] [ARGUMENTS]", "", "DESCRIPTION", "       Simulated man page. Use .hint for task-specific guidance.", "", "(END)")
}

Register-LCommand "help" {
    param($args)
    return @(
        "  FILESYSTEM     ls, cd, pwd, cat, head, tail, touch, mkdir, rm, cp, mv, find",
        "  SYSTEM         ps, kill, top, df, du, free, uname, uptime, who, w, id",
        "  NETWORK        ping, ip, ifconfig, ss, netstat, lsof, nmap, wget, curl",
        "  TEXT           grep, sort, uniq, wc, echo, less, more, tar, chmod, chown",
        "  INFO           whoami, hostname, date, cal, history, env, alias, neofetch",
        "  SERVICES       systemctl, journalctl, sudo, lsblk",
        "  PACKAGES       apt, dnf, pacman, zypper, apk, brew",
        "  MANUAL         man <cmd>   (try: man ls, man grep, man chmod)",
        "  DEVOPS         docker, kubectl, terraform, mysql",
        "  SECURITY       nmap, searchsploit, hydra, sqlmap, john, hashcat",
        "",
        "  SPECIALS       .hint  .skip  .check  .status  .exit",
        "  TIPS           Tab: path/cmd completion   Up/Down: history   Ctrl+C: cancel"
    )
}

# -- apt (Debian/Ubuntu) --
Register-LCommand "apt" {
    param($args)
    if ($args.Count -eq 0) { return @("apt $($args -join ' ')") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^(install|remove|purge)\s') { return @("Reading package lists... Done", "Building dependency tree... Done", "Reading state information... Done", "$cmd completed successfully.") }
    if ($cmd -match '^update') { return @("Hit:1 http://archive.ubuntu.com/ubuntu jammy InRelease", "Hit:2 http://security.ubuntu.com/ubuntu jammy-security InRelease", "Fetched 0 B in 1s (0 B/s)", "Reading package lists... Done") }
    if ($cmd -match '^upgrade') { return @("Reading package lists... Done", "Building dependency tree... Done", "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.") }
    if ($cmd -match '^(search|list)\s') { return @("Listing... Done") }
    if ($cmd -match '^(show|info)\s') { return @("Package: $($Matches[0])", "Version: 2.0.1", "Priority: optional", "Section: utils", "Maintainer: Ubuntu Developers", "Description: simulated package") }
    return @("apt: $cmd")
}
Register-LCommand "apt-get" { return & $script:learningCommands["apt"] $args }
Register-LCommand "apt-cache" { return @("apt-cache: command simulated") }

# -- dnf (CentOS/Rocky) --
Register-LCommand "dnf" {
    param($args)
    if ($args.Count -eq 0) { return @("dnf $($args -join ' ')") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^(install|remove|erase)\s') { return @("Last metadata expiration check: 0:05:23 ago.", "Package installed successfully.") }
    if ($cmd -match '^update') { return @("Last metadata expiration check: 0:05:23 ago.", "Dependencies resolved.", "Nothing to do.") }
    if ($cmd -match '^list') { return @("Installed Packages: coreutils.x86_64 8.32-30.el9") }
    if ($cmd -match '^(search|info)\s') { return @("Last metadata expiration check: 0:05:23 ago.", "Name: $($Matches[0])") }
    return @("dnf: $cmd")
}
Register-LCommand "yum" { return & $script:learningCommands["dnf"] $args }

# -- pacman (Arch) --
Register-LCommand "pacman" {
    param($args)
    if ($args.Count -eq 0) { return @("usage: pacman <operation> [...]") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^-Syu') { return @(":: Synchronizing package databases...", " core is up to date", " extra is up to date", " community is up to date", ":: Starting full system upgrade...", " there is nothing to do") }
    if ($cmd -match '^-S\s') { return @("resolving dependencies...", "looking for conflicting packages...", "Packages: ($($Matches[0]))", "Total Installed Size:  1.23 MiB", ":: Proceed with installation? [Y/n]", "Y", "(1/1) checking keys in keyring", "(1/1) installing $($Matches[0])") }
    if ($cmd -match '^-R(s|n)?s?\s') { return @("checking dependencies...", "Packages: ($($Matches[0]))", ":: Do you want to remove these packages? [Y/n]", "Y", "(1/1) removing $($Matches[0])") }
    if ($cmd -match '^-Q') { return @("coreutils 9.0-1", "glibc 2.36-2") }
    return @("pacman: $cmd")
}

# -- zypper (openSUSE) --
Register-LCommand "zypper" {
    param($args)
    if ($args.Count -eq 0) { return @("zypper $($args -join ' ')") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^(in|install)\s') { return @("Loading repository data...", "Reading installed packages...", "Resolving package dependencies...", "The following NEW package is going to be installed:", "  $($Matches[0])", "Overall download size: 1.2 MiB", "Continue? [y/n/v/...? shows all options] (y): y") }
    if ($cmd -match '^(up|update)') { return @("Loading repository data...", "Reading installed packages...", "Nothing to do.") }
    if ($cmd -match '^(se|search)\s') { return @("Loading repository data...", "Reading installed packages...", "S | Name | Summary | Type", "--+------+---------+-----", "  | $($Matches[0]) | simulated | package") }
    if ($cmd -match '^(lr|repos)') { return @("# | Alias | Name | Enabled | GPG Check | Refresh", "--+-------+------+---------+-----------+--------", "1 | repo-oss | openSUSE-oss | Yes | p g | Yes") }
    return @("zypper: $cmd")
}

# -- apk (Alpine) --
Register-LCommand "apk" {
    param($args)
    if ($args.Count -eq 0) { return @("apk $($args -join ' ')") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^(add|del)\s') { return @("(1/1) Installing $($Matches[0])", "OK: 42 MiB in 84 packages") }
    if ($cmd -match '^update') { return @("fetch https://dl-cdn.alpinelinux.org/alpine/v3.18/main/x86_64/APKINDEX.tar.gz", "OK: 15848 distinct packages available") }
    if ($cmd -match '^upgrade') { return @("Upgrading... Done.", "OK: 42 MiB in 84 packages") }
    if ($cmd -match '^(search|info)\s') { return @("$($Matches[0])-2.0.1-r0 - simulated package description") }
    return @("apk: $cmd")
}

# -- brew (macOS) --
Register-LCommand "brew" {
    param($args)
    if ($args.Count -eq 0) { return @("Homebrew $('v' + (Get-Random -Max 5).ToString() + '.' + (Get-Random -Max 10).ToString())") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^(install|reinstall)\s') { return @("==> Downloading https://ghcr.io/v2/homebrew/core/$($Matches[0])", "==> Pouring $($Matches[0])-1.0.arm64_ventura.bottle.tar.gz", "  /usr/local/Cellar/$($Matches[0]): 42 files, 1.2MB") }
    if ($cmd -match '^(upgrade|update)') { return @("Already up-to-date.") }
    if ($cmd -match '^(search|info)\s') { return @("$($Matches[0]): stable 1.0 (bottled)", "Simulated package manager for macOS") }
    if ($cmd -match '^list') { return @("coreutils", "findutils", "gnu-sed", "wget", "curl") }
    if ($cmd -match '^doctor') { return @("Your system is ready to brew.") }
    return @("brew: $cmd")
}

# -- nmap --
Register-LCommand "nmap" {
    param($args)
    $target = if ($args[-1] -and $args[-1] -notmatch '^-') { $args[-1] } else { "scanme.org" }
    if ($args -match '-h|--help') { return @("Nmap 7.94SVN ( https://nmap.org )", "Usage: nmap [Scan Type(s)] [Options] {target specification}") }
    if ($args -match '-O') { return @("Starting Nmap 7.94SVN ( https://nmap.org ) at $(Get-Date -Format 'yyyy-MM-dd HH:mm')", "Nmap scan report for $target (192.168.1.1)", "Host is up (0.042s latency).", "Not shown: 995 closed tcp ports (reset)", "PORT     STATE    SERVICE     VERSION", "22/tcp   open     OpenSSH    9.0p1", "80/tcp   open     Apache     httpd 2.4.57", "443/tcp  open     Apache     httpd 2.4.57", "3306/tcp filtered MySQL", "8080/tcp open     Apache     httpd 2.4.57", "Aggressive OS guesses: Linux 5.x (95%), Linux 6.x (90%)", "OS detection performed. Please report any incorrect results.", "Nmap done: 1 IP address (1 host up) scanned in 13.42 seconds") }
    return @("Starting Nmap 7.94SVN ( https://nmap.org ) at $(Get-Date -Format 'yyyy-MM-dd HH:mm')", "Nmap scan report for $target", "Host is up (0.042s latency).", "Not shown: 997 closed tcp ports (reset)", "PORT     STATE    SERVICE", "22/tcp   open     ssh", "80/tcp   open     http", "443/tcp  open     https", "8080/tcp open     http-proxy", "MAC Address: 08:00:27:AB:CD:EF (Oracle VB)", "Nmap done: 1 IP address (1 host up) scanned in 5.67 seconds")
}

# -- searchsploit --
Register-LCommand "searchsploit" {
    param($args)
    if ($args.Count -eq 0) { return @("searchsploit 2.0", "Usage: searchsploit [term1] [term2] ...") }
    $q = "$($args -join ' ')"
    $results = @("Exploit Title | Path", "--------------|------")
    $results += "Linux Kernel 5.x - Privilege Escalation | exploits/linux/local/50922.c"
    $results += "Apache httpd 2.4.49 - Path Traversal | exploits/linux/remote/50581.py"
    $results += "OpenSSH 8.9 - User Enumeration | exploits/linux/remote/50977.sh"
    $results += "MySQL 8.0 - Authentication Bypass | exploits/linux/remote/50859.py"
    $results += "WordPress 6.0 - SQL Injection | exploits/php/webapps/50789.txt"
    $results += "nginx 1.25 - Heap Overflow | exploits/linux/dos/50901.c"
    return $results
}

# -- gobuster --
Register-LCommand "gobuster" {
    param($args)
    $url = if ($args -match '-u\s+(\S+)') { $Matches[1] } else { "http://target.com" }
    $wordlist = if ($args -match '-w\s+(\S+)') { $Matches[1] } else { "/usr/share/wordlists/dirb/common.txt" }
    return @("===============================================================", "Gobuster v3.6 by OJ Reeves (@TheColonial)", "===============================================================", "[+] Url:         $url", "[+] Method:      GET", "[+] Threads:     10", "[+] Wordlist:    $wordlist", "[+] Timeout:     10s", "===============================================================", "$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss') Starting gobuster", "===============================================================", "/admin                (Status: 200) [Size: 8421]", "/backup               (Status: 200) [Size: 14523]", "/config               (Status: 403) [Size: 199]", "/login                (Status: 200) [Size: 5430]", "/uploads              (Status: 200) [Size: 98]", "===============================================================", "$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss') Finished", "===============================================================")
}

# -- hydra --
Register-LCommand "hydra" {
    param($args)
    $target = if ($args[-1] -and $args[-1] -notmatch '^-') { $args[-1] } else { "10.0.0.1" }
    $service = "ssh"
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -match '^-') { if ($args[$i + 1]) { $service = $args[$i + 1] }; break }
    }
    $passwords = @("admin", "root", "password123", "letmein", "12345678", "qwerty")
    $results = @(
        "Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak",
        "Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
        "[DATA] max 16 tasks per 1 server, overall 16 tasks, 6 login tries, ~6 tries per task",
        "[DATA] attacking ${service}://${target}/:22/",
        "[22][$service] host: $target   login: root   password: $($passwords[(Get-Random -Max $passwords.Length)])",
        "1 of 1 target successfully completed, 1 valid password found",
        "Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    )
    return $results
}

# -- msfconsole --
Register-LCommand "msfconsole" {
    param($args)
    return @("", "         =[ metasploit v6.3.36-dev                          ]", "+ -- --=[ 2349 exploits - 1247 auxiliary - 422 post       ]", "+ -- --=[ 1458 payloads - 47 encoders - 11 nops           ]", "+ -- --=[ 9 evasion                                       ]", "", "Metasploit Documentation: https://docs.metasploit.com/", "", "msf6 > ")
}

# -- john / hashcat --
Register-LCommand "john" {
    param($args)
    $hashtype = "raw-sha256"
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -match '^--format=') { $hashtype = $args[$i] -replace '^--format=' }
    }
    return @("Created directory: /home/user/.john", "Using default input encoding: UTF-8", "Loaded 1 password hash ($hashtype, 256 bits)", "Will run 4 OpenMP threads", "Proceeding with single, rules:Single", "Press Ctrl-C to abort, or send SIGUSR1 to john process for status", "p@ssw0rd        (?)", "1g 0:00:00:01 DONE 1/3 (2023-01-01 12:00) 1.000g/s 682.0p/s 682.0c/s 682.0C/s", "Session completed.")
}
Register-LCommand "hashcat" {
    param($args)
    $mode = "1400"
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -match '^-m') { if ($args[$i + 1]) { $mode = $args[$i + 1] } }
    }
    return @("hashcat (v6.2.6) starting in attack mode", "", "OpenCL API (OpenCL 3.0) - Platform #1 [GPU]", "Minimum password length: 8", "Maximum password length: 64", "", "Session..........: hashcat", "Status...........: Running", "Hash.Mode........: $mode (SHA256)", "Speed.#1.........: 14235.0 kH/s", "Progress.........: 1048576/4294967296 (0.02%)", "Candidates.#1....: p@ssw0rd -> 12345678", "Guess.Base.......: /usr/share/wordlists/rockyou.txt")
}

# -- sqlmap --
Register-LCommand "sqlmap" {
    param($args)
    $url = if ($args -match '-u\s+"?([^"\s]+)"?') { $Matches[1] } else { if ($args -match '-u\s+(\S+)') { $Matches[1] } else { "http://test.com?id=1" } }
    return @(
        "        __",
        "       __H__",
        " ___ ___[,]_____ ___ ___  {1.7.8#stable}",
        "|_ -| . [,]     | '| . |",
        "|___|_  [.]_|_|_|__,|  _|",
        "      |_|V...       |_|   https://sqlmap.org",
        "",
        "[!] legal disclaimer: Usage of sqlmap for attacking...",
        "[*] starting @ $(Get-Date -Format 'HH:mm:ss')",
        "",
        "[dd:mm:ss] [INFO] testing connection to the target URL",
        "[dd:mm:ss] [INFO] testing 'Boolean-based blind' parameter 'id' (1)",
        "[dd:mm:ss] [INFO] testing 'Error-based' parameter 'id' (2)",
        "[dd:mm:ss] [INFO] testing 'Stacked queries' parameter 'id' (2)",
        "[dd:mm:ss] [INFO] GET parameter 'id' is 'MySQL >= 5.0.12' injectable",
        "[dd:mm:ss] [INFO] fetching database names",
        "[dd:mm:ss] [INFO] retrieved: information_schema, mysql, wordpress",
        "[dd:mm:ss] [INFO] the back-end DBMS is MySQL",
        "web server operating system: Linux Ubuntu",
        "web application technology: Apache 2.4.57, PHP 8.1",
        "back-end DBMS: MySQL >= 5.0.12",
        "available databases [3]:",
        "[*] information_schema",
        "[*] mysql",
        "[*] wordpress"
    )
}

# -- wpscan --
Register-LCommand "wpscan" {
    param($args)
    $url = if ($args[-1] -and $args[-1] -notmatch '^-') { $args[-1] } else { if ($args -match '-u\s+(\S+)') { $Matches[1] } else { "http://wordpress-site.com" } }
    return @(
        "_______________________________________________________________",
        "       __          _______   _____",
        "      \\ \\        / /  __ \\ / ____|",
        "       \\ \\  /\\  / /| |__) | (___",
        "        \\ \\/  \\/ / |  ___/ \\___ \\",
        "         \\  /\\  /  | |     ____) |",
        "          \\/  \\/   |_|    |_____/",
        "         WordPress Security Scanner",
        "",
        "WPScan v3.8.25 (https://wpscan.com/)",
        "[+] URL: $url",
        "[+] Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
        "",
        "[i] The WordPress version is outdated (6.2.1 -> 6.3.2)",
        "[i] Detected 2 vulnerabilities:",
        "[i]  SQL Injection (CVE-2023-XXXX) - critical",
        "[i]  XSS (CVE-2023-YYYY) - medium",
        "",
        "[+] Enumerating users (via author ID)...",
        "[i] User(s) identified: admin, editor, wp_user",
        "",
        "[+] Enumerating plugins...",
        "[i]  contact-form-7 (5.7.7) - outdated",
        "[i]  woocommerce (7.8.0) - 1 vulnerability identified"
    )
}

# -- nikto --
Register-LCommand "nikto" {
    param($args)
    $host = if ($args -match '-h\s+(\S+)') { $Matches[1] } else { "127.0.0.1" }
    return @(
        "- Nikto v2.5.0",
        "---------------------------------------------------------------------------",
        "+ Target IP:          $host",
        "+ Target Hostname:    $host",
        "---------------------------------------------------------------------------",
        "- Server: Apache/2.4.57",
        "+ /: Server banner: Apache/2.4.57 (Ubuntu).",
        "+ /: The anti-clickjacking X-Frame-Options header is not present.",
        "+ /wp-admin/: WordPress admin login page found.",
        "+ /phpinfo.php: PHP info file found.",
        "+ /server-status: Apache server-status interface found (403 Forbidden).",
        "+ /backup/: Directory listing found (sensitive data?).",
        "+ 5 hosts: 0 new since last scan",
        "+ 2 authenticated hosts",
        "---------------------------------------------------------------------------",
        "1 host(s) tested"
    )
}

# -- kubectl --
Register-LCommand "kubectl" {
    param($args)
    if ($args.Count -eq 0) { return @("kubectl controls the Kubernetes cluster manager.", "", "Basic Commands (Beginner):", "  create        Create a resource", "  expose        Expose a resource", "  run           Run a particular image", "  set           Set specific features on objects", "", "Usage: kubectl [command] [TYPE] [NAME] [flags]") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^get pods') { return @("NAME              READY   STATUS    RESTARTS   AGE", "nginx-deploy-1    1/1     Running   0          42h", "api-server-0      1/1     Running   0          42h", "redis-cache-2     0/1     CrashLoopBackOff  3          5m", "db-stateful-0     1/1     Running   0          42h") }
    if ($cmd -match '^get nodes') { return @("NAME              STATUS   ROLES           AGE   VERSION", "control-plane     Ready    control-plane   42h   v1.28.2", "worker-1          Ready    worker          42h   v1.28.2", "worker-2          Ready    worker          42h   v1.28.2") }
    if ($cmd -match '^get services') { return @("NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE", "kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP        42h", "nginx-service    ClusterIP   10.96.42.1      <none>        80/TCP         42h", "api-service      NodePort    10.96.42.100    <none>        80:30080/TCP   42h") }
    if ($cmd -match '^get (deploy|deployment)') { return @("NAME              READY   UP-TO-DATE   AVAILABLE   AGE", "nginx-deploy      3/3     3            3           42h", "api-server        1/1     1            1           42h") }
    if ($cmd -match '^logs\s+(\S+)') { return @("Starting up on port 8080...", "Connection from 10.1.0.1:54231", "GET /api/status 200 5ms", "Connection from 10.1.0.2:54232", "GET /api/data 200 12ms") }
    if ($cmd -match '^describe\s+pod\s+(\S+)') { return @("Name:             $($Matches[0])", "Namespace:        default", "Node:             worker-1/10.0.0.2", "Status:           Running", "IP:               10.42.0.5", "Containers:", "  Container ID:   docker://abc123", "  Image:          nginx:latest", "  State:          Running (started 42h ago)", "Conditions:", "  Type              Status", "  Initialized       True", "  Ready             True", "  ContainersReady   True", "  PodScheduled      True") }
    if ($cmd -match '^cluster-info') { return @("Kubernetes control plane is running at https://10.0.0.1:6443", "CoreDNS is running at https://10.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy") }
    return @("kubectl $cmd")
}

# -- docker --
Register-LCommand "docker" {
    param($args)
    if ($args.Count -eq 0) { return @("Usage: docker [OPTIONS] COMMAND", "", "Common Commands:", "  run     Create and run a new container", "  exec    Execute a command in a running container", "  ps      List containers", "  images  List Docker images", "  pull    Pull an image from a registry", "  start   Start one or more stopped containers") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^ps') { return @("CONTAINER ID   IMAGE          COMMAND                  CREATED       STATUS       PORTS                  NAMES", 'abc123def456   nginx:latest   "/docker-entrypoint.sh"   2 hours ago   Up 2 hours   0.0.0.0:80->80/tcp    web-server', 'def789abc012   postgres:15    "docker-entrypoint.sh"   3 hours ago   Up 3 hours   0.0.0.0:5432->5432/tcp db', 'ghi345jkl678   redis:7        "docker-entrypoint.sh"   4 hours ago   Up 4 hours   0.0.0.0:6379->6379/tcp cache') }
    if ($cmd -match '^images') { return @("REPOSITORY     TAG       IMAGE ID       CREATED        SIZE", "nginx          latest    abc123456789   2 weeks ago    187MB", "postgres       15        def789012345   3 weeks ago    413MB", "redis          7         ghi345678901   4 weeks ago    117MB", "alpine         latest    123abc456def   2 months ago   7.05MB") }
    if ($cmd -match '^pull\s+(\S+)') { return @("Using default tag: latest", "latest: Pulling from $($Matches[0])", "abc123def456: Pull complete", "def456abc789: Pull complete", "ghi789abc012: Pull complete", "Digest: sha256:abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890", "Status: Downloaded newer image for $($Matches[0]):latest") }
    if ($cmd -match '^run\s+.*') { return @("Unable to find image 'busybox:latest' locally", "busybox:latest: Pulling from library/busybox", "abc123def456: Pull complete", "Digest: sha256:abcdef...", "Status: Downloaded newer image for busybox:latest") }
    if ($cmd -match '^exec\s+.*') { return @("") }
    if ($cmd -match '^logs\s+(\S+)') { return @("2024-01-15 12:00:01 Server started", "2024-01-15 12:00:02 Listening on port 80", "2024-01-15 12:00:03 Connection from 10.0.0.1") }
    if ($cmd -match '^(compose|stack)') { return @("docker compose: simulated") }
    if ($cmd -match '^(network|volume)') { return @("$($Matches[0]): simulated operation completed") }
    return @("docker $cmd")
}

# -- terraform --
Register-LCommand "terraform" {
    param($args)
    if ($args.Count -eq 0) { return @("Usage: terraform [global options] <subcommand> [args]", "", "Common commands:", "  init          Initialize a Terraform working directory", "  plan          Generate and show an execution plan", "  apply         Build or change infrastructure", "  destroy       Destroy Terraform-managed infrastructure") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^init') { return @("Initializing the backend...", "Initializing provider plugins...", '- Finding hashicorp/aws versions matching "~> 5.0"...', "- Installing hashicorp/aws v5.17.0...", "- Installed hashicorp/aws v5.17.0 (signed by HashiCorp)", "", "Terraform has been successfully initialized!") }
    if ($cmd -match '^plan') { return @("Terraform used the selected providers to generate the following execution plan.", "Resource actions are indicated with the following symbols:", "  + create", "", "Terraform will perform the following actions:", "", "# aws_instance.web will be created", '  + resource "aws_instance" "web" {', '      + ami           = "ami-0c55b159cbfafe1f0"', '      + instance_type = "t2.micro"', '      + tags          = {', '          + Name = "web-server"', "        }", "    }", "", "Plan: 1 to add, 0 to change, 0 to destroy.") }
    if ($cmd -match '^apply') { return @("aws_instance.web: Creating...", "aws_instance.web: Still creating... [10s elapsed]", "aws_instance.web: Creation complete after 15s [id=i-0abcd1234efgh5678]", "", "Apply complete! Resources: 1 added, 0 changed, 0 destroyed.") }
    if ($cmd -match '^destroy') { return @("aws_instance.web: Destroying...", "aws_instance.web: Destruction complete after 5s", "", "Destroy complete! Resources: 0 destroyed.") }
    return @("terraform $cmd")
}

# -- mysql --
Register-LCommand "mysql" {
    param($args)
    if ($args.Count -eq 0) { return @("mysql  Ver 8.0.35 for Linux on x86_64 (MySQL Community Server - GPL)", "", "Copyright (c) 2000, 2023, Oracle and/or its affiliates.", "", "Usage: mysql [OPTIONS] [database]") }
    $cmd = "$($args -join ' ')"
    if ($cmd -match '^-u\s') { return @("Welcome to the MySQL monitor.  Commands end with ; or \g.", "Server version: 8.0.35 MySQL Community Server - GPL", "", "mysql>") }
    if ($cmd -match '-(h|host)') { return @("ERROR 2003 (HY000): Can't connect to MySQL server on '$($Matches[0])' (111)") }
    return @("mysql: connection established (simulated)")
}

# -- clear --
Register-LCommand "clear" {
    return @("__CLEAR__")
}

Register-LCommand "history" {
    param($args)
    $hist = $script:learningHistory
    if ($hist.Count -eq 0) { return @("(no commands in history)") }
    $n = if ($args.Count -gt 0 -and $args[0] -match "^\d+$") { [int]$args[0] } else { $hist.Count }
    $start = [Math]::Max(0, $hist.Count - $n)
    $output = @()
    for ($i = $start; $i -lt $hist.Count; $i++) {
        $output += ("  {0,4}  {1}" -f ($i + 1), $hist[$i])
    }
    return $output
}

Register-LCommand "env" {
    return @(
        "HOME=/home/$($script:learningUser)",
        "USER=$($script:learningUser)",
        "SHELL=/bin/bash",
        "TERM=xterm-256color",
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "LANG=en_US.UTF-8",
        "PWD=$($script:learningCwd)",
        "HOSTNAME=$($script:learningHost)",
        "LOGNAME=$($script:learningUser)",
        "EDITOR=nano",
        "PAGER=less"
    )
}

Register-LCommand "alias" {
    return @(
        "alias ll='ls -alF'",
        "alias la='ls -A'",
        "alias l='ls -CF'",
        "alias grep='grep --color=auto'",
        "alias ls='ls --color=auto'",
        "alias ..='cd ..'",
        "alias ...='cd ../..'",
        "alias h='history'"
    )
}

Register-LCommand "printenv" {
    param($args)
    if ($args.Count -gt 0) {
        $env = @{ HOME = "/home/$($script:learningUser)"; USER = $script:learningUser; SHELL = "/bin/bash"; TERM = "xterm-256color"; PATH = "/usr/local/bin:/usr/bin:/bin"; LANG = "en_US.UTF-8"; PWD = $script:learningCwd; HOSTNAME = $script:learningHost }
        $key = $args[0]
        if ($env.ContainsKey($key)) { return @($env[$key]) }
        return @()
    }
    return & $script:learningCommands["env"] @()
}

Register-LCommand "uptime" {
    $h = Get-Random -Minimum 1 -Maximum 72
    $m = Get-Random -Minimum 0 -Maximum 59
    $users = Get-Random -Minimum 1 -Maximum 4
    $l1 = [Math]::Round((Get-Random -Minimum 5 -Maximum 25) / 10.0, 2)
    $l5 = [Math]::Round((Get-Random -Minimum 3 -Maximum 20) / 10.0, 2)
    $l15 = [Math]::Round((Get-Random -Minimum 2 -Maximum 15) / 10.0, 2)
    return @(" $(Get-Date -Format 'HH:mm:ss') up $h`:$($m.ToString('D2')),  $users user$(if($users -gt 1){'s'}),  load average: $l1, $l5, $l15")
}

Register-LCommand "lsblk" {
    return @(
        "NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS",
        "sda      8:0    0   100G  0 disk",
        "|-sda1   8:1    0     1G  0 part /boot",
        "|-sda2   8:2    0    99G  0 part",
        "  `-lvm  253:0  0    99G  0 lvm  /",
        "sdb      8:16   0   500G  0 disk",
        "`-sdb1   8:17   0   500G  0 part /mnt/backup",
        "sr0     11:0    1  1024M  0 rom"
    )
}

Register-LCommand "ss" {
    param($args)
    $header = "Netid  State   Recv-Q  Send-Q  Local Address:Port    Peer Address:Port"
    if ($args -match "-t" -or $args -match "tcp") {
        return @($header,
            "tcp    LISTEN  0       128     0.0.0.0:22           0.0.0.0:*",
            "tcp    LISTEN  0       511     0.0.0.0:80           0.0.0.0:*",
            "tcp    LISTEN  0       511     0.0.0.0:443          0.0.0.0:*",
            "tcp    ESTAB   0       0       192.168.1.10:22      192.168.1.5:54321")
    }
    return @($header,
        "tcp    LISTEN  0       128     0.0.0.0:22           0.0.0.0:*",
        "tcp    LISTEN  0       511     0.0.0.0:80           0.0.0.0:*",
        "udp    UNCONN  0       0       0.0.0.0:68           0.0.0.0:*")
}

Register-LCommand "netstat" {
    param($args)
    return & $script:learningCommands["ss"] $args
}

Register-LCommand "lsof" {
    return @(
        "COMMAND   PID     USER   FD   TYPE DEVICE NODE NAME",
        "systemd     1     root  cwd    DIR    8,1    2 /",
        "sshd      854     root    3u  IPv4  18234    0 *:22",
        "nginx    1203  www-data   6u  IPv4  22411    0 *:80",
        "nginx    1203  www-data   7u  IPv4  22412    0 *:443",
        "mysql    1450    mysql   14u  IPv4  24100    0 *:3306"
    )
}

Register-LCommand "neofetch" {
    $os = $script:learningOsName; $hostN = $script:learningHost; $user = $script:learningUser
    $upH = Rand 1 72; $upM = Rand 0 59; $pkgs = Rand 800 2200
    $cpu = "Intel Core i7-12700K (16) @ 5.000GHz"
    $memUsed = [Math]::Round((Rand 2000 6000)/1000.0, 1)
    $info = @(
        "${user}@$hostN",
        "$(('-') * ($user.Length + $hostN.Length + 1))",
        "OS: $os",
        "Host: VirtualMachine 2.0",
        "Kernel: 6.8.0-45-generic",
        "Uptime: ${upH}h ${upM}m",
        "Packages: $pkgs",
        "Shell: bash 5.2.21",
        "Terminal: xterm-256color",
        "CPU: $cpu",
        "Memory: ${memUsed}GiB / 16.0GiB",
        ""
    )
    $logos = @{
        "ubuntu"  = @("         .--.      ","       .'  . '.    ","      /  .-. -.  \ ","      | (   ) |   ","       \  `-'  /   ","        `---'     ","                   ")
        "debian"  = @("    _____         ","   /  __ \        "," _| /  | |        ","|_  .  -.        ","  | \.  /         ","   \___/          ","                  ")
        "arch"    = @("       /\        ","      /  \       ","     / /\ \      ","    / /  \ \     ","   /_/ /\ \_\    ","  /_/ /  \_\_\   ","                 ")
        "kali"    = @("  .-.            "," (o o)           ","  | |            "," /'-.`-.         ","/    '-'         ","                 ","                 ")
        "alpine"  = @("    /\ /\        ","   /  V  \       ","  / /   \ \      "," /_/  ,   \_\    "," \/  / \  \/     ","   \/   \/       ","                 ")
        "windows" = @("   _______       ","  |       |      ","  |       |      ","  +-------+      ","  |       |      ","  |_______|      ","                 ")
        "default" = @("   +--------+    ","   |        |    ","   | SERVER |    ","   |        |    ","   +--------+    ","                 ","                 ")
    }
    $logoKey = "default"
    foreach ($k in $logos.Keys) { if ($os -ilike "*$k*" -or $hostN -ilike "*$k*") { $logoKey = $k; break } }
    $logo = $logos[$logoKey]
    $output = @()
    for ($i = 0; $i -lt [Math]::Max($logo.Count, $info.Count); $i++) {
        $l = if ($i -lt $logo.Count) { $logo[$i] } else { (" " * 18) }
        $r = if ($i -lt $info.Count) { $info[$i] } else { "" }
        $output += "$l  $r"
    }
    return $output
}

Register-LCommand "w" {
    $user = $script:learningUser
    $h = Get-Random -Minimum 1 -Maximum 24
    $m = Get-Random -Minimum 0 -Maximum 59
    return @(
        " $(Get-Date -Format 'HH:mm:ss') up ${h}:$($m.ToString('D2')),  1 user,  load average: 0.12, 0.08, 0.05",
        "USER     TTY      FROM             LOGIN@   IDLE JCPU   PCPU WHAT",
        "$($user.PadRight(8)) pts/0    192.168.1.5      $(Get-Date -Format 'HH:mm')   0.00s  0.12s  0.01s -bash"
    )
}

Register-LCommand "who" {
    param($args)
    if ($args -match "-b") { return @("         system boot  $(Get-Date (Get-Date).AddDays(-(Get-Random -Min 1 -Max 30)) -Format 'yyyy-MM-dd HH:mm')") }
    return @("$($script:learningUser)   pts/0   $(Get-Date -Format 'yyyy-MM-dd HH:mm') (192.168.1.5)")
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
            if ([string]::IsNullOrEmpty($hint)) { $hint = "Sprobuj uzyc komendy: $($task.ExpectedCommand)" }
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
    $in = $Input.Trim().ToLower() -replace "\s+", " "
    $ex = $Expected.Trim().ToLower() -replace "\s+", " "
    if ($in -eq $ex) { return $true }
    # Allow sudo prefix: "sudo apt install foo" matches "apt install foo"
    if ($in -match "^sudo\s+(.+)$" -and $Matches[1] -eq $ex) { return $true }
    # Allow if input starts with expected (covers pipes like "ls | grep foo" when expected is just "ls")
    if ($in -match "^$([regex]::Escape($ex))(\s|$|\|)") { return $true }
    # Allow extra flags: "ls -la" matches "ls -l" or vice versa
    $inParts = $in -split "\s+"; $exParts = $ex -split "\s+"
    if ($inParts[0] -eq $exParts[0] -and $exParts.Count -le $inParts.Count) {
        $nonFlagEx = $exParts | Where-Object { $_ -notlike "-*" }
        $nonFlagIn = $inParts | Where-Object { $_ -notlike "-*" }
        if (($nonFlagEx | ForEach-Object { $nonFlagIn -contains $_ } | Where-Object { -not $_ }).Count -eq 0 -and $nonFlagEx.Count -gt 0 -and $nonFlagIn.Count -ge $nonFlagEx.Count) { return $true }
    }
    return $false
}

# ===================================================================
# INPUT READER - free typing with backspace support
# ===================================================================

function Get-TabCompletions {
    param([string]$Buffer)
    $knownCmds = @("ls","cd","cat","grep","find","mkdir","rmdir","rm","cp","mv","chmod","chown","pwd","echo","ps","kill","top","df","du","mount","umount","sudo","apt","apt-get","systemctl","service","journalctl","ip","ifconfig","ping","nmap","ssh","scp","curl","wget","tar","zip","unzip","nano","vi","vim","man","which","whoami","uname","hostname","id","groups","useradd","usermod","passwd","docker","kubectl","terraform","aws","git","python","python3","node","npm","mysql","psql","netstat","ss","lsof","iptables","firewall-cmd","sysctl","crontab","pacman","yay","brew","apk","dnf","yum","zypper","history","env","alias","printenv","uptime","lsblk","neofetch","w","who","lsof","free","date","cal","wc","sort","uniq","head","tail","less","more","help","clear","touch","which","tar","alias")
    $specialCmds = @(".hint",".skip",".check",".status",".exit")

    $parts = $Buffer.TrimStart() -split '\s+'
    if ($parts.Count -eq 0) { return @() }

    # Special command completion
    if ($parts.Count -eq 1 -and $parts[0] -like ".*") {
        $partial = $parts[0]
        return $specialCmds | Where-Object { $_ -like "$partial*" } | Sort-Object
    }

    # Command completion (first word)
    if ($parts.Count -eq 1 -and -not $Buffer.EndsWith(" ")) {
        $partial = $parts[0]
        # Also complete from registered commands
        $registered = $script:learningCommands.Keys | Sort-Object
        $all = ($knownCmds + $registered) | Sort-Object -Unique
        return $all | Where-Object { $_ -like "$partial*" } | Sort-Object
    }

    # Path completion (last argument)
    $lastArg = if ($Buffer.EndsWith(" ")) { "" } else { $parts[-1] }
    if ($lastArg -like "-*") { return @() }  # flag, skip

    $dirPart = if ($lastArg -match "^(.*/)") { $Matches[1] } else { "" }
    $filePart = if ($lastArg -match "([^/]*)$") { $Matches[1] } else { $lastArg }

    $targetDir = if ($dirPart) { Resolve-LPath $dirPart } else { $script:learningCwd }
    $entries = Get-LDirListing $targetDir
    $candidates = @()
    foreach ($e in $entries) {
        $name = Split-Path $e -Leaf
        if ($name -like "$filePart*") {
            $ei = Get-LItem $e
            $suffix = if ($ei -and $ei.Type -eq "dir") { "/" } else { "" }
            $candidates += "$dirPart$name$suffix"
        }
    }
    return $candidates | Sort-Object
}

function Read-LearningInput {
    param([string]$PromptLen = "")
    $buffer = ""
    $cursor = 0
    $script:learningHistoryIdx = $script:learningHistory.Count
    $tabCandidates = @()
    $tabIdx = -1

    function Redraw-Line {
        param([string]$newBuf, [int]$promptX)
        $pos = Get-CursorPosition
        Set-CursorPosition -X $promptX -Y $pos.Y
        $padded = $newBuf + (" " * [Math]::Max(0, $buffer.Length - $newBuf.Length))
        Write-Host -NoNewline $padded -ForegroundColor White
        Set-CursorPosition -X ($promptX + $newBuf.Length) -Y $pos.Y
    }

    $promptX = (Get-CursorPosition).X

    while ($true) {
        $k = Read-ConsoleKey
        if (-not $k) { Start-Sleep -Milliseconds 10; continue }

        if ($k.Key -eq "Escape") { return "__ESCAPE__" }
        if ($k.Key -eq "Enter") {
            if ($buffer.Length -gt 0) {
                $script:learningLastCmd = $buffer
                if ($script:learningHistory.Count -eq 0 -or $script:learningHistory[$script:learningHistory.Count - 1] -ne $buffer) {
                    $script:learningHistory.Add($buffer)
                    if ($script:learningHistory.Count -gt 20) { $script:learningHistory.RemoveAt(0) }
                }
            }
            Write-Host ""
            return $buffer
        }
        if ($k.Key -eq "Backspace") {
            if ($cursor -gt 0) {
                $buffer = $buffer.Substring(0, $cursor - 1) + $buffer.Substring($cursor)
                $cursor--
                Redraw-Line $buffer $promptX
                Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            }
            continue
        }
        if ($k.Key -eq "Delete") {
            if ($cursor -lt $buffer.Length) {
                $buffer = $buffer.Substring(0, $cursor) + $buffer.Substring($cursor + 1)
                Redraw-Line $buffer $promptX
                Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            }
            continue
        }
        if ($k.Key -eq "LeftArrow") {
            if ($cursor -gt 0) { $cursor--; Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y }
            continue
        }
        if ($k.Key -eq "RightArrow") {
            if ($cursor -lt $buffer.Length) { $cursor++; Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y }
            continue
        }
        if ($k.Key -eq "Home") {
            $cursor = 0; Set-CursorPosition -X $promptX -Y (Get-CursorPosition).Y
            continue
        }
        if ($k.Key -eq "End") {
            $cursor = $buffer.Length; Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            continue
        }
        if ($k.Key -eq "UpArrow") {
            if ($script:learningHistory.Count -gt 0 -and $script:learningHistoryIdx -gt 0) {
                $script:learningHistoryIdx--
                $buffer = $script:learningHistory[$script:learningHistoryIdx]
                $cursor = $buffer.Length
                Redraw-Line $buffer $promptX
                Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            }
            continue
        }
        if ($k.Key -eq "DownArrow") {
            if ($script:learningHistoryIdx -lt $script:learningHistory.Count - 1) {
                $script:learningHistoryIdx++
                $buffer = $script:learningHistory[$script:learningHistoryIdx]
            } else {
                $script:learningHistoryIdx = $script:learningHistory.Count
                $buffer = ""
            }
            $cursor = $buffer.Length
            Redraw-Line $buffer $promptX
            Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            continue
        }
        if ($k.Key -eq "Tab") {
            # Tab completion
            if ($tabIdx -lt 0 -or $tabCandidates.Count -eq 0) {
                $tabCandidates = @(Get-TabCompletions $buffer)
                $tabIdx = 0
            } else {
                $tabIdx = ($tabIdx + 1) % $tabCandidates.Count
            }
            if ($tabCandidates.Count -gt 0) {
                $completion = $tabCandidates[$tabIdx]
                # Replace last word with completion
                if ($buffer -match "^(.*\s)") { $prefix = $Matches[1] } else { $prefix = "" }
                $buffer = $prefix + $completion
                $cursor = $buffer.Length
                Redraw-Line $buffer $promptX
                Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
            }
            continue
        }
        # Any other key resets tab state
        $tabIdx = -1; $tabCandidates = @()
        if ($k.KeyChar -and $k.KeyChar -ne "`0") {
            $ch = $k.KeyChar
            $buffer = $buffer.Substring(0, $cursor) + $ch + $buffer.Substring($cursor)
            $cursor++
            Redraw-Line $buffer $promptX
            Set-CursorPosition -X ($promptX + $cursor) -Y (Get-CursorPosition).Y
        }
        Start-Sleep -Milliseconds 5
    }
}

# ===================================================================
# LEARNING SESSION - interactive loop
# ===================================================================

function Start-LearningSession {
    param(
        [string]$SystemName = "Ubuntu",
        [string]$Hostname = "ubuntu",
        [string]$Username = "student",
        [string]$OsName = "Ubuntu 24.04 LTS",
        [string]$PromptString = "student@ubuntu:~`$",
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
    $script:learningHistory = [System.Collections.Generic.List[string]]::new()
    $script:learningHistoryIdx = -1

    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    try { [console]::CursorVisible = $false } catch { }
    try { $Host.UI.RawUI.WindowTitle = "Learning Mode - $SystemName" } catch { }

    # Matrix intro
    Matrix-Rain -DurationSeconds 3 -Theme $Theme
    Clear-Host

    # Welcome screen
    $w = 57
    $border = [char]0x2550
    $tl = [char]0x2554; $tr = [char]0x2557; $bl = [char]0x255A; $br = [char]0x255D
    $vb = [char]0x2551; $lm = [char]0x2560; $rm = [char]0x2563; $hm = [char]0x2550
    $diffLabel = ""
    if ($Tasks.Count -le 5) { $diffLabel = "[*   ] Beginner" }
    elseif ($Tasks.Count -le 10) { $diffLabel = "[**  ] Intermediate" }
    elseif ($Tasks.Count -le 15) { $diffLabel = "[*** ] Advanced" }
    else { $diffLabel = "[****] Expert/All" }
    Write-Host ""
    Write-Host "  $tl$([string]$border * $w)$tr" -ForegroundColor $Theme.accent
    Write-Host "  $vb$("  ULTRA MATRIX TERMINAL  -  TRYB NAUKI".PadRight($w))$vb" -ForegroundColor Cyan
    Write-Host "  $lm$([string]$hm * $w)$rm" -ForegroundColor $Theme.accent
    Write-Host "  $vb$("  System:   $SystemName".PadRight($w))$vb" -ForegroundColor Green
    Write-Host "  $vb$("  OS:       $OsName".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $vb$("  Zadania:  $($Tasks.Count)  Poziom: $diffLabel".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $lm$([string]$hm * $w)$rm" -ForegroundColor $Theme.accent
    Write-Host "  $vb$("  .hint   [H]  Podpowiedz do biezacego zadania".PadRight($w))$vb" -ForegroundColor DarkYellow
    Write-Host "  $vb$("  .skip   [S]  Pomin i przejdz do nastepnego".PadRight($w))$vb" -ForegroundColor DarkYellow
    Write-Host "  $vb$("  .status [P]  Pokaz postep sesji".PadRight($w))$vb" -ForegroundColor DarkYellow
    Write-Host "  $vb$("  .exit   [Q]  Zakoncz sesje nauki".PadRight($w))$vb" -ForegroundColor DarkYellow
    Write-Host "  $lm$([string]$hm * $w)$rm" -ForegroundColor $Theme.accent
    Write-Host "  $vb$("  Tab: dopelnianie komend i sciezek".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $vb$("  Strzalki gora/dol: historia komend".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $vb$("  help: lista dostepnych komend  man <cmd>: manpage".PadRight($w))$vb" -ForegroundColor DarkGray
    Write-Host "  $bl$([string]$border * $w)$br" -ForegroundColor $Theme.accent
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

            $total = $script:learningTasks.Count
            $done = $script:learningCompletedTasks.Keys.Count
            $barFilled = [Math]::Floor(($done / [Math]::Max(1, $total)) * 20)
            $progressBar = ([string][char]0x2588 * $barFilled) + ([string][char]0x2591 * (20 - $barFilled))
            $pct = [Math]::Floor(($done / [Math]::Max(1, $total)) * 100)

            Write-Host ""
            Write-Host "  $([char]0x250C)$([char]0x2500 * 47)$([char]0x2510)" -ForegroundColor $Theme.accent
            Write-Host ("  $([char]0x2502) Zadanie {0}/{1}  [{2}] {3,3}% $([char]0x2502)" -f ($script:learningCurrentTask + 1), $total, $progressBar, $pct) -ForegroundColor Cyan
            Write-Host ("  $([char]0x2502) $($task.Title.PadRight(45))$([char]0x2502)") -ForegroundColor White
            Write-Host ("  $([char]0x2502) Poziom: $($difficultyLabel.PadRight(40))$([char]0x2502)") -ForegroundColor $Theme.accent
            Write-Host "  $([char]0x2514)$([char]0x2500 * 47)$([char]0x2518)" -ForegroundColor $Theme.accent
            Write-Host ""
            foreach ($td in $task.Description) {
                Write-Host "    $td" -ForegroundColor Gray
            }
            Write-Host ""
            Write-Host "  [.hint] podpowiedz  [.skip] pomin  [.status] postep  [.exit] wyjdz" -ForegroundColor DarkGray
            Write-Host ""
            Start-Sleep -Milliseconds 300
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
            $displayCwd = $script:learningCwd -replace "^/home/$Username", "~"
            if ($displayCwd -eq "/home") { $displayCwd = "/home" }
            Write-Host -NoNewline "$Username@$Hostname`:$displayCwd$rootChar " -ForegroundColor $Theme.promptColor

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
                Write-Host ""
                Write-Host "  $([char]0x250C)$([char]0x2500 * 50)$([char]0x2510)" -ForegroundColor Yellow
                Write-Host "  $([char]0x2502) PODPOWIEDZ: $($hint.PadRight(38))$([char]0x2502)" -ForegroundColor Yellow
                Write-Host "  $([char]0x2514)$([char]0x2500 * 50)$([char]0x2518)" -ForegroundColor Yellow
                Write-Host ""
                continue
            }
            if ($trimmed -eq ".status") {
                $total = $script:learningTasks.Count
                $done = $script:learningCompletedTasks.Keys.Count
                $skipped = $script:learningSkippedTasks.Keys.Count
                $hints = $script:learningHintUsed.Keys.Count
                $barFilled = [Math]::Floor(($done / [Math]::Max(1, $total)) * 30)
                $bar = ([string][char]0x2588 * $barFilled) + ([string][char]0x2591 * (30 - $barFilled))
                $pct = [Math]::Floor(($done / [Math]::Max(1, $total)) * 100)
                $barColor = if ($pct -ge 80) { "Green" } elseif ($pct -ge 40) { "Yellow" } else { "Cyan" }
                Write-Host ""
                Write-Host "  $([char]0x250C)$([char]0x2500 * 40)$([char]0x2510)" -ForegroundColor DarkGray
                Write-Host ("  $([char]0x2502) POSTEP  [{0}] {1,3}% $([char]0x2502)" -f $bar, $pct) -ForegroundColor $barColor
                Write-Host ("  $([char]0x2502) Wykonane:    {0}/{1}  {2}$([char]0x2502)" -f $done, $total, " " * (26 - "$done/$total".Length)) -ForegroundColor Cyan
                Write-Host ("  $([char]0x2502) Pominiete:   {0}     {1}$([char]0x2502)" -f $skipped, " " * 27) -ForegroundColor Yellow
                Write-Host ("  $([char]0x2502) Podpowiedzi: {0}     {1}$([char]0x2502)" -f $hints, " " * 27) -ForegroundColor DarkGray
                Write-Host ("  $([char]0x2502) Biezace:     {0}/{1}  {2}$([char]0x2502)" -f ($script:learningCurrentTask + 1), $total, " " * (26 - "$($script:learningCurrentTask + 1)/$total".Length)) -ForegroundColor Gray
                Write-Host "  $([char]0x2514)$([char]0x2500 * 40)$([char]0x2518)" -ForegroundColor DarkGray
                Write-Host ""
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
                    # Colored ls output
                    if ($line -match "__DIR__|__FILE__") {
                        $tokens = [regex]::Matches($line, "(__DIR__|__FILE__)(.*?)(?=__DIR__|__FILE__|$)")
                        foreach ($tok in $tokens) {
                            $isDir = $tok.Groups[1].Value -eq "__DIR__"
                            $name = $tok.Groups[2].Value.TrimEnd()
                            $pad = [Math]::Max(14, $name.Length + 2)
                            if ($isDir) {
                                Write-Host -NoNewline $name.PadRight($pad) -ForegroundColor Cyan
                            } else {
                                $fc = if ($name -match "\.(sh|py|pl|rb|exe|bin|run)$") { "Green" } elseif ($name -match "\.(conf|cfg|ini|json|yaml|yml|toml)$") { "Yellow" } else { "White" }
                                Write-Host -NoNewline $name.PadRight($pad) -ForegroundColor $fc
                            }
                        }
                        Write-Host ""
                        continue
                    }
                    $color = "Gray"
                    if ($line -match "^  \[(HINT|SKIP|CHECK|POSTEP)") { $color = "Yellow" }
                    elseif ($line -match "(error|failed|denied|No such file|not found|permission denied|cannot|invalid)" -and $line -notmatch "^\s*#") { $color = "Red" }
                    elseif ($line -match "^drwxr|^drwx") { $color = "Cyan" }
                    elseif ($line -match "^-rwx|-r-x") { $color = "Green" }
                    elseif ($line -match "^-rw") { $color = "White" }
                    elseif ($line -match "^total ") { $color = "DarkGray" }
                    elseif ($line -match "^\s*#|^;|^//") { $color = "DarkGreen" }
                    elseif ($line -match "^\[.*\]$") { $color = "Yellow" }
                    elseif ($line -match "^(Active|Loaded|Main PID|Tasks|Memory|CGroup|   CPU)") { $color = "Cyan" }
                    elseif ($line -match "running|active|enabled|online| UP " -and $line -notmatch "not ") { $color = "Green" }
                    elseif ($line -match "stopped|inactive|disabled| DOWN|dead") { $color = "Red" }
                    elseif ($line -match "^(top|Tasks|%Cpu|MiB)") { $color = "Cyan" }
                    elseif ($line -match "^(commit|Author|Date|Branch|On branch|HEAD)") { $color = "Yellow" }
                    elseif ($line -match "^\+") { $color = "Green" }
                    elseif ($line -match "^-" -and $line -notmatch "^---") { $color = "Red" }
                    elseif ($line -match "^CONTAINER|^IMAGE|^NETWORK|^VOLUME|^DRIVER|^REPOSITORY") { $color = "Cyan" }
                    elseif ($line -match "^Step \d+") { $color = "DarkYellow" }
                    elseif ($line -match "^(NAME|PORT|STATE|PID|USER)") { $color = "DarkGray" }
                    elseif ($line -match "Nmap scan report|Host is up|Starting Nmap") { $color = "Green" }
                    elseif ($line -match "^(\d+/tcp|udp)") { $color = "Cyan" }
                    elseif ($line -match "open\s") { $color = "Green" }
                    elseif ($line -match "closed|filtered") { $color = "DarkGray" }
                    elseif ($line -match "@.*---") { $color = "White" }
                    elseif ($line -match "@") { $color = "Cyan" }
                    Write-Host $line -ForegroundColor $color
                }
                Write-Host ""
            }

            # Check if command matches expected
            if ($task.ExpectedCommand) {
                if (Check-CommandMatches $trimmed $task.ExpectedCommand) {
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    $doneNow = $script:learningCompletedTasks.Keys.Count
                    $totalTasks = $script:learningTasks.Count
                    Write-Host ""
                    Write-Host "  $([char]0x250C)$([char]0x2500 * 35)$([char]0x2510)" -ForegroundColor Green
                    Write-Host "  $([char]0x2502)  $([char]0x2714) POPRAWNIE!  Zadanie $($script:learningCurrentTask + 1)/$totalTasks $(' ' * 12)$([char]0x2502)" -ForegroundColor Green
                    if (-not $script:learningHintUsed.ContainsKey($script:learningCurrentTask)) {
                        Write-Host "  $([char]0x2502)  Bez podpowiedzi - doskonale!$(' ' * 7)$([char]0x2502)" -ForegroundColor Cyan
                    }
                    Write-Host "  $([char]0x2514)$([char]0x2500 * 35)$([char]0x2518)" -ForegroundColor Green
                    Write-Host ""
                    $script:learningCurrentTask++
                    Start-Sleep -Milliseconds 600
                    Clear-Host
                    break
                }
            }

            # Also check the custom Check scriptblock
            if ($task.ContainsKey("Check") -and $task.Check) {
                $result = & $task.Check
                if ($result -eq $true) {
                    $script:learningCompletedTasks[$script:learningCurrentTask] = $true
                    $doneNow = $script:learningCompletedTasks.Keys.Count
                    $totalTasks = $script:learningTasks.Count
                    Write-Host ""
                    Write-Host "  $([char]0x250C)$([char]0x2500 * 35)$([char]0x2510)" -ForegroundColor Green
                    Write-Host "  $([char]0x2502)  $([char]0x2714) POPRAWNIE!  Zadanie $($script:learningCurrentTask + 1)/$totalTasks $(' ' * 12)$([char]0x2502)" -ForegroundColor Green
                    Write-Host "  $([char]0x2514)$([char]0x2500 * 35)$([char]0x2518)" -ForegroundColor Green
                    Write-Host ""
                    $script:learningCurrentTask++
                    Start-Sleep -Milliseconds 600
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
    $hints = $script:learningHintUsed.Keys.Count

    $scoreRaw = if ($total -gt 0) { ($done / $total) * 100 - ($hints * 5) - ($skipped * 10) } else { 0 }
    $score = [Math]::Max(0, [Math]::Min(100, [Math]::Round($scoreRaw)))
    $grade = switch ($true) {
        { $score -ge 95 } { "S  (Mistrz!)" }
        { $score -ge 80 } { "A  (Swietnie!)" }
        { $score -ge 65 } { "B  (Dobrze)" }
        { $score -ge 50 } { "C  (Srednia)" }
        { $score -ge 30 } { "D  (Cwicz wiecej)" }
        default            { "F  (Sprobuj jeszcze raz)" }
    }
    $gradeColor = switch ($true) {
        { $score -ge 80 } { "Green" }
        { $score -ge 50 } { "Yellow" }
        default            { "Red" }
    }
    $barFilled = [Math]::Floor($score / 5)
    $bar = ([string][char]0x2588 * $barFilled) + ([string][char]0x2591 * (20 - $barFilled))

    Write-Host ""
    Write-Host "  $([char]0x250C)$([char]0x2500 * 47)$([char]0x2510)" -ForegroundColor Cyan
    $header = "  SESJA ZAKONCZONA - $SystemName"
    Write-Host "  $([char]0x2502)$($header.PadRight(47))$([char]0x2502)" -ForegroundColor Green
    Write-Host "  $([char]0x2514)$([char]0x2500 * 47)$([char]0x2518)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host ("  Wynik:        [$bar] {0}%" -f $score) -ForegroundColor $gradeColor
    Write-Host "  Ocena:        $grade" -ForegroundColor $gradeColor
    Write-Host ""
    Write-Host "  Wykonane:     $done/$total" -ForegroundColor Cyan
    Write-Host "  Pominiete:    $skipped/$total" -ForegroundColor Yellow
    Write-Host "  Podpowiedzi:  $hints" -ForegroundColor DarkGray
    Write-Host ""

    if ($done -eq $total -and $hints -eq 0 -and $skipped -eq 0) {
        Write-Host "  Idealne wykonanie! Gratulacje!" -ForegroundColor Green
    }
    Write-Host "  Nacisnij ENTER aby wrocic do menu." -ForegroundColor DarkGray
    while ($true) { $k = Read-ConsoleKey; if ($k -and ($k.Key -eq "Enter" -or $k.Key -eq "Escape")) { break }; Start-Sleep -Milliseconds 50 }

    Clear-Host
    Matrix-Rain -DurationSeconds 3 -Theme $Theme
    Start-Sleep -Milliseconds 500
    try { [console]::CursorVisible = $true } catch { }
}
