function Get-LearningContent-windows {
    param([string]$Difficulty = "beginner")

    $fs = @{
        C = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
            Users = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                student = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                    Desktop = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                        readme_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "Windows 11 Pro 24H2",
                            "PowerShell to potężne narzędzie automatyzacji.",
                            "Polecenia: Get-ChildItem (ls), Set-Location (cd), Get-Content (cat)",
                            "Aliasy: dir = ls = Get-ChildItem"
                        )}
                        notes_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "Lista zadan:",
                            "1. Skonfiguruj siec",
                            "2. Zainstaluj aktualizacje",
                            "3. Sprawdz dziennik zdarzen",
                            "4. Przetestuj polaczenie DNS",
                            "5. Utworz kopia zapasowa"
                        )}
                        system_shortcut_lnk = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "LINK: C:\Windows\System32\cmd.exe",
                            "LINK: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
                        )}
                    }}
                    Documents = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                        config_xml = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            '<?xml version="1.0"?>', '<configuration>',
                            '  <appSettings>', '    <add key="Theme" value="Dark"/>',
                            '    <add key="Lang" value="pl-PL"/>',
                            '    <add key="AutoSave" value="true"/>',
                            '    <add key="BackupInterval" value="3600"/>',
                            '  </appSettings>',
                            '</configuration>'
                        )}
                        scripts = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                            backup_ps1 = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                                '# Backup script',
                                '$source = "C:\Users\student\Documents"',
                                '$dest = "C:\Backup\Documents"',
                                'Copy-Item -Path $source -Destination $dest -Recurse',
                                'Write-Host "Backup completed."'
                            )}
                            cleanup_ps1 = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                                '# Cleanup script',
                                'Remove-Item -Path "C:\Temp\*" -Force',
                                'Write-Host "Cleanup completed."'
                            )}
                        }}
                    }}
                    Downloads = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{}}
                    Pictures = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                        wallpaper_jpg = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "[wallpaper.jpg - Windows 11 default wallpaper]"
                        )}
                    }}
                    Music = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{}}
                }}
            }}
            Windows = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                System32 = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    drivers = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        etc = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                            hosts = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                "# Copyright (c) 1993-2006 Microsoft Corp.",
                                "# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.",
                                "127.0.0.1       localhost",
                                "::1             localhost",
                                "10.0.0.50       dc.corp.internal dc",
                                "10.0.0.51       fileserver.corp.internal fileserver",
                                "10.0.0.52       mail.corp.internal mail",
                                "192.168.1.10    corp-ws-01.corp.internal corp-ws-01",
                                "192.168.1.11    corp-ws-02.corp.internal corp-ws-02"
                            )}
                        }}
                    }}
                    config = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        SAM = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                            "[SAM Registry Hive - placeholder]"
                        )}
                        SOFTWARE = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                            "[SOFTWARE Registry Hive - placeholder]"
                        )}
                    }}
                    LogFiles = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{}}
                }}
            }}
            "Program Files" = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                "7-Zip" = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
                Python311 = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
                Git = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
            }}
            ProgramData = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                logs = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    app_log_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                        "[2026-06-08 08:00:01] INFO: Application started",
                        "[2026-06-08 08:00:05] INFO: Loading configuration",
                        "[2026-06-08 08:00:10] WARN: Config key 'Theme' not found, using default",
                        "[2026-06-08 08:00:15] INFO: User session started: student",
                        "[2026-06-08 08:01:00] ERROR: Failed to connect to database",
                        "[2026-06-08 08:01:05] INFO: Retrying connection...",
                        "[2026-06-08 08:01:30] INFO: Connection established after retry",
                        "[2026-06-08 08:02:00] ERROR: Database timeout, shutting down",
                        "[2026-06-08 08:02:05] INFO: Cleanup initiated",
                        "[2026-06-08 08:02:10] INFO: Application terminated"
                    )}
                }}
                Microsoft = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    Windows = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                        "Start Menu" = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
                        Templates = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
                    }}
                }}
            }}
            Temp = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                temp_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @("temporary file")}
                install_log = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                    "2026-06-07 14:30:00 Installer: Starting 7-Zip setup",
                    "2026-06-07 14:30:15 Installer: 7-Zip installed successfully",
                    "2026-06-07 14:35:00 Installer: Starting Git setup",
                    "2026-06-07 14:35:30 Installer: Git installed successfully"
                )}
            }}
            Public = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                Desktop = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    public_readme_txt = @{ Type = "file"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Content = @(
                        "Public Desktop - shared shortcuts for all users.",
                        "Shortcuts available to all users on this machine."
                    )}
                }}
            }}
            Recovery = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{}}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj readme"; Difficulty = "beginner"; ExpectedCommand = "Get-ChildItem"
            Description = @("W katalogu domowym (C:\Users\student) znajduja sie pliki.", "Wyswietl ich liste za pomoca Get-ChildItem (lub ls, dir)."); Hint = "Uzyj: Get-ChildItem lub ls lub dir" }
        @{ Id = 2; Title = "Wyswietl zawartosc pliku"; Difficulty = "beginner"; ExpectedCommand = "Get-Content Desktop/readme_txt"
            Description = @("W katalogu Desktop znajduje sie plik readme_txt.", "Wyswietl jego zawartosc (Get-Content lub cat)."); Hint = "Uzyj: Get-Content Desktop/readme_txt lub cat Desktop/readme_txt" }
        @{ Id = 3; Title = "Przejdz do Documents"; Difficulty = "beginner"; ExpectedCommand = "Set-Location Documents"
            Description = @("Przejdz do katalogu Documents (Set-Location lub cd).", "Nastepnie listuj pliki."); Hint = "Uzyj: Set-Location Documents lub cd Documents" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "New-Item -ItemType Directory -Path Downloads/backup"
            Description = @("W katalogu Downloads utworz podkatalog 'backup'.", "Uzyj mkdir lub New-Item."); Hint = "Uzyj: mkdir Downloads/backup lub New-Item -ItemType Directory -Path Downloads/backup" }
        @{ Id = 5; Title = "Sprawdz biezacy katalog"; Difficulty = "beginner"; ExpectedCommand = "Get-Location"
            Description = @("Sprawdz, w ktorym katalogu aktualnie jestes.", "Uzyj Get-Location lub pwd."); Hint = "Uzyj: Get-Location lub pwd" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Przegladaj logi"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content ProgramData/logs/app_log_txt"
            Description = @("Wyswietl plik logu aplikacji w ProgramData/logs/app_log_txt."); Hint = "Uzyj: Get-Content ProgramData/logs/app_log_txt" }
        @{ Id = 7; Title = "Znajdz bledy"; Difficulty = "intermediate"; ExpectedCommand = "Select-String -Path ProgramData/logs/app_log_txt -Pattern ERROR"
            Description = @("W pliku app_log_txt znajdz wszystkie linie z 'ERROR'.", "Uzyj Select-String."); Hint = "Uzyj: Select-String -Path ProgramData/logs/app_log_txt -Pattern ERROR" }
        @{ Id = 8; Title = "Skopiuj plik"; Difficulty = "intermediate"; ExpectedCommand = "Copy-Item Desktop/notes_txt Desktop/notes_backup.txt"
            Description = @("Skopiuj notes_txt z Desktop do notes_backup.txt w tym samym katalogu.", "Uzyj Copy-Item."); Hint = "Uzyj: Copy-Item Desktop/notes_txt Desktop/notes_backup.txt" }
        @{ Id = 9; Title = "Sprawdz hosts"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content Windows/System32/drivers/etc/hosts"
            Description = @("Wyswietl plik hosts Windows."); Hint = "Uzyj: Get-Content Windows/System32/drivers/etc/hosts" }
        @{ Id = 10; Title = "Przenies plik"; Difficulty = "intermediate"; ExpectedCommand = "Move-Item Temp/temp_txt Temp/archive_temp.txt"
            Description = @("Przenies plik Temp/temp_txt do Temp/archive_temp.txt.", "Uzyj Move-Item."); Hint = "Uzyj: Move-Item Temp/temp_txt Temp/archive_temp.txt" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Szukaj plikow .txt"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem -Recurse -Filter *.txt Users"
            Description = @("Znajdz wszystkie pliki .txt w katalogu Users.", "Uzyj Get-ChildItem -Recurse."); Hint = "Uzyj: Get-ChildItem -Recurse -Filter *.txt Users" }
        @{ Id = 12; Title = "Sprawdz procesy"; Difficulty = "advanced"; ExpectedCommand = "Get-Process > Desktop/process_list.txt"
            Description = @("Uzyj Get-Process i zapisz wynik do pliku na Desktop."); Hint = "Uzyj: Get-Process > Desktop/process_list.txt" }
        @{ Id = 13; Title = "Wyswietl konfiguracje XML"; Difficulty = "advanced"; ExpectedCommand = "Get-Content Documents/config_xml"
            Description = @("Wyswietl plik konfiguracyjny XML w Documents."); Hint = "Uzyj: Get-Content Documents/config_xml" }
        @{ Id = 14; Title = "Czasy systemowe"; Difficulty = "advanced"; ExpectedCommand = "Get-Date"
            Description = @("Sprawdz biezaca date i czas systemowy (Get-Date)."); Hint = "Uzyj: Get-Date" }
        @{ Id = 15; Title = "Zapisz liste programow"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem 'Program Files' > Desktop/programs.txt"
            Description = @("Wylistuj zawartosc Program Files i zapisz do pliku."); Hint = "Uzyj: Get-ChildItem 'Program Files' > Desktop/programs.txt" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Logi z Select-String"; Difficulty = "expert"; ExpectedCommand = "Select-String -Path ProgramData/logs/app_log_txt -Pattern ERROR | Select-Object -First 2"
            Description = @("Znajdz bledy w logu i wyswietl pierwsze 2 wyniki."); Hint = "Uzyj: Select-String -Path ProgramData/logs/app_log_txt -Pattern ERROR | Select-Object -First 2" }
        @{ Id = 17; Title = "Policz linie w logu"; Difficulty = "expert"; ExpectedCommand = "Get-Content ProgramData/logs/app_log_txt | Measure-Object -Line"
            Description = @("Policz linie w pliku app_log_txt uzywajac Measure-Object."); Hint = "Uzyj: Get-Content ProgramData/logs/app_log_txt | Measure-Object -Line" }
        @{ Id = 18; Title = "Porownaj pliki"; Difficulty = "expert"; ExpectedCommand = "Compare-Object (Get-Content Desktop/readme_txt) (Get-Content Desktop/notes_txt)"
            Description = @("Porownaj zawartosc dwoch plikow na Desktop uzywajac Compare-Object."); Hint = "Uzyj: Compare-Object (Get-Content Desktop/readme_txt) (Get-Content Desktop/notes_txt)" }
        @{ Id = 19; Title = "Sprawdz wolne miejsce"; Difficulty = "expert"; ExpectedCommand = "Get-PSDrive C"
            Description = @("Sprawdz wolne miejsce na dysku C uzywajac Get-PSDrive."); Hint = "Uzyj: Get-PSDrive C" }
        @{ Id = 20; Title = "Info o systemie"; Difficulty = "expert"; ExpectedCommand = "Get-ComputerInfo"
            Description = @("Wyswietl pelna informacje o komputerze (Get-ComputerInfo)."); Hint = "Uzyj: Get-ComputerInfo" }
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
