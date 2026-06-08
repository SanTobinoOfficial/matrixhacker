. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-ScreensaverCommands {
    return @(
        C "hola" @("mundo")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-ScreensaverCommands} -Theme (Get-Theme screensaver) -ModeName "Matrix Screensaver" -NoMOTD -TimeoutMinutes 60
}