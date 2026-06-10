# =====================================================================
# SETTINGS - user preferences, config persist
# =====================================================================

$script:AppSettings = @{}

function ConvertJsonToHashtable {
    param($JsonString)
    $obj = $JsonString | ConvertFrom-Json
    $ht = @{}
    $obj.PSObject.Properties | ForEach-Object { $ht[$_.Name] = $_.Value }
    return $ht
}

function Get-SettingsPath {
    $dir = Get-InstallDir
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    return "$dir/settings.json"
}

function Get-DefaultSettings {
    $localPath = "$PSScriptRoot/../config/settings.json"
    if (Test-Path -LiteralPath $localPath) {
        try { return ConvertJsonToHashtable (Get-Content -Raw -LiteralPath $localPath) } catch { }
    }
    return @{
        theme = "learning"
        lastMode = $null
        lastDifficulty = "beginner"
        language = "pl"
    }
}

function Get-UserSettings {
    $path = Get-SettingsPath
    if (Test-Path -LiteralPath $path) {
        try { return ConvertJsonToHashtable (Get-Content -Raw -LiteralPath $path) } catch { }
    }
    return @{}
}

function Save-UserSettings {
    param([hashtable]$Settings)
    $path = Get-SettingsPath
    $Settings | ConvertTo-Json | Out-File -LiteralPath $path -Encoding utf8
}

function Get-Settings {
    $defaults = Get-DefaultSettings
    $user = Get-UserSettings
    $merged = @{}
    foreach ($k in $defaults.Keys) { $merged[$k] = $defaults[$k] }
    foreach ($k in $user.Keys) { if ($user.ContainsKey($k)) { $merged[$k] = $user[$k] } }
    $script:AppSettings = $merged
    return $merged
}

function Set-Setting {
    param([string]$Key, $Value)
    $user = Get-UserSettings
    $user[$Key] = $Value
    Save-UserSettings $user
    $script:AppSettings[$Key] = $Value
}

function Reset-Settings {
    $path = Get-SettingsPath
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
    $script:AppSettings = Get-DefaultSettings
    return $script:AppSettings
}
