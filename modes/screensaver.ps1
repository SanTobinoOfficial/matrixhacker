. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-SCREENSAVERCOMMANDS {
    return @()
}

function Start-Screensaver {
    param([hashtable]$Theme)
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    try { [console]::CursorVisible = $false } catch { }
    try { $Host.UI.RawUI.WindowTitle = "Matrix Screensaver - Press Escape to exit" } catch { }
    Matrix-Rain -Infinite -Theme $Theme
    Clear-Host
    try { [console]::CursorVisible = $true } catch { }
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-Screensaver -Theme (Get-Theme screensaver)
}