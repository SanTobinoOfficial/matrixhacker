function Get-LearningContent-winserver {
    param([string]$Difficulty = "beginner")

    $fs = @{
        C = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
            Users = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                Admin = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                    Desktop = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                        server_deploy_ps1 = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                            "# Server deployment script",
                            "# Configure AD DS, DNS, DHCP",
                            "Install-WindowsFeature -Name AD-Domain-Services",
                            "Install-WindowsFeature -Name DNS",
                            "Install-WindowsFeature -Name DHCP"
                        )}
                        dc_info_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                            "Windows Server 2022 Standard",
                            "Domain Controller: corp.internal",
                            "Roles: AD DS, DNS, DHCP",
                            "IP: 10.0.0.10/24"
                        )}
                    }}
                    Documents = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                        GPO_backup = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                            default_policy = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                                "GPO: Default Domain Policy", "Settings:",
                                "Password Policy: Enabled", "Account Lockout: 5 attempts",
                                "Audit Policy: Success/Failure"
                            )}
                        }}
                    }}
                }}
            }}
            Windows = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                System32 = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    LogFiles = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        DNS_Log = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                            "06/08/2026 08:00:01 1234 PACKET  UDP 10.0.0.10  Query  A  dc.corp.internal",
                            "06/08/2026 08:00:02 1234 PACKET  UDP 10.0.0.10  Response  A  10.0.0.10",
                            "06/08/2026 08:05:00 1235 PACKET  UDP 10.0.0.50  Query  A  mail.corp.internal",
                            "06/08/2026 08:05:01 1235 PACKET  UDP 10.0.0.50  Response  A  10.0.0.20",
                            "06/08/2026 08:10:00 1236 PACKET  UDP 192.168.1.100  Query  A  external.com"
                        )}
                    }}
                }}
            }}
            DNS = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{}}
            Temp = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                updates_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @("Pending updates: KB5048652, KB5048653")}
            }}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Sprawdz info o DC"; Difficulty = "beginner"; ExpectedCommand = "Get-ChildItem Desktop/"
            Description = @("W katalogu Desktop Admina sprawdz, jakie sa pliki."); Hint = "Uzyj: Get-ChildItem Desktop/ lub ls Desktop/" }
        @{ Id = 2; Title = "Przeczytaj dc_info"; Difficulty = "beginner"; ExpectedCommand = "Get-Content Desktop/dc_info_txt"
            Description = @("Wyswietl plik z informacjami o kontrolerze domeny."); Hint = "Uzyj: Get-Content Desktop/dc_info_txt lub cat Desktop/dc_info_txt" }
        @{ Id = 3; Title = "Wyswietl skrypt deploy"; Difficulty = "beginner"; ExpectedCommand = "Get-Content Desktop/server_deploy_ps1"
            Description = @("Wyswietl skrypt wdrozeniowy serwera."); Hint = "Uzyj: Get-Content Desktop/server_deploy_ps1" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "New-Item -ItemType Directory -Path DNS/zones"
            Description = @("Utworz katalog C:\DNS\zones (mkdir lub New-Item)."); Hint = "Uzyj: mkdir DNS/zones lub New-Item -ItemType Directory -Path DNS/zones" }
        @{ Id = 5; Title = "Sprawdz biezacy katalog"; Difficulty = "beginner"; ExpectedCommand = "pwd"
            Description = @("Sprawdz biezacy katalog (pwd lub Get-Location)."); Hint = "Uzyj: pwd lub Get-Location" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Przegladaj logi DNS"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content /Windows/System32/LogFiles/DNS_Log"
            Description = @("Wyswietl logi serwera DNS."); Hint = "Uzyj: Get-Content /Windows/System32/LogFiles/DNS_Log" }
        @{ Id = 7; Title = "Znajdz zapytania A"; Difficulty = "intermediate"; ExpectedCommand = "Select-String -Path /Windows/System32/LogFiles/DNS_Log -Pattern 'Query  A'"
            Description = @("W logach DNS znajdz wszystkie zapytania typu A."); Hint = "Uzyj: Select-String lub grep: grep 'Query  A' /Windows/System32/LogFiles/DNS_Log" }
        @{ Id = 8; Title = "Kopiuj GPO"; Difficulty = "intermediate"; ExpectedCommand = "Copy-Item Documents/GPO_backup/default_policy Desktop/gpo_backup.txt"
            Description = @("Skopiuj plik default_policy z GPO_backup na Desktop."); Hint = "Uzyj: Copy-Item Documents/GPO_backup/default_policy Desktop/gpo_backup.txt" }
        @{ Id = 9; Title = "Sprawdz aktualizacje"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content /Temp/updates_txt"
            Description = @("Wyswietl liste oczekujacych aktualizacji."); Hint = "Uzyj: Get-Content /Temp/updates_txt" }
        @{ Id = 10; Title = "Usun plik tymczasowy"; Difficulty = "intermediate"; ExpectedCommand = "Remove-Item /Temp/updates_txt"
            Description = @("Usun plik z lista aktualizacji."); Hint = "Uzyj: Remove-Item /Temp/updates_txt lub rm /Temp/updates_txt" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Szukaj plikow PS1"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem -Recurse -Filter *.ps1 /Users"
            Description = @("Znajdz wszystkie pliki .ps1 w katalogu Users."); Hint = "Uzyj: Get-ChildItem -Recurse -Filter *.ps1 /Users lub find /Users -name '*.ps1'" }
        @{ Id = 12; Title = "Logi DNS z ip"; Difficulty = "advanced"; ExpectedCommand = "Get-Content /Windows/System32/LogFiles/DNS_Log | Select-String '10.0.0'"
            Description = @("W logach DNS znajdz linie zawierajace '10.0.0'."); Hint = "Uzyj pipe: cat /Windows/System32/LogFiles/DNS_Log | grep '10.0.0'" }
        @{ Id = 13; Title = "Sprawdz konfiguracje"; Difficulty = "advanced"; ExpectedCommand = "Get-Content Documents/GPO_backup/default_policy"
            Description = @("Wyswietl domyslna polityke grupy GPO."); Hint = "Uzyj: Get-Content Documents/GPO_backup/default_policy" }
        @{ Id = 14; Title = "Zapisz logi do pliku"; Difficulty = "advanced"; ExpectedCommand = "Get-Content /Windows/System32/LogFiles/DNS_Log > Desktop/dns_export.txt"
            Description = @("Wyeksportuj logi DNS na Desktop."); Hint = "Uzyj: cat /Windows/System32/LogFiles/DNS_Log > Desktop/dns_export.txt" }
        @{ Id = 15; Title = "Data systemowa"; Difficulty = "advanced"; ExpectedCommand = "Get-Date"
            Description = @("Sprawdz biezaca date na serwerze."); Hint = "Uzyj: Get-Date lub date" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Policz linie w logu"; Difficulty = "expert"; ExpectedCommand = "Get-Content /Windows/System32/LogFiles/DNS_Log | Measure-Object -Line"
            Description = @("Policz linie w logach DNS (Measure-Object lub wc -l)."); Hint = "Uzyj: cat /Windows/System32/LogFiles/DNS_Log | wc -l" }
        @{ Id = 17; Title = "Wersja OS"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl informacje o systemie (uname -a)."); Hint = "Uzyj: uname -a" }
        @{ Id = 18; Title = "Sortuj logi"; Difficulty = "expert"; ExpectedCommand = "Get-Content /Windows/System32/LogFiles/DNS_Log | Sort-Object"
            Description = @("Wyswietl posortowane logi DNS."); Hint = "Uzyj: cat /Windows/System32/LogFiles/DNS_Log | sort" }
        @{ Id = 19; Title = "Sprawdz pamiec"; Difficulty = "expert"; ExpectedCommand = "free"
            Description = @("Sprawdz uzycie pamieci serwera."); Hint = "Uzyj: free" }
        @{ Id = 20; Title = "Sprawdz wolne miejsce"; Difficulty = "expert"; ExpectedCommand = "df"
            Description = @("Sprawdz miejsce na dyskach."); Hint = "Uzyj: df" }
    )

    $tasks = @()
    switch ($Difficulty) {
        "beginner" { $tasks = $beginnerTasks }
        "intermediate" { $tasks = $intermediateTasks }
        "advanced" { $tasks = $advancedTasks }
        "expert" { $tasks = $expertTasks }
        default { $tasks = $beginnerTasks }
    }
    return @{ Filesystem = $fs; Tasks = $tasks }
}
