function Get-LearningContent-windows {
    param([string]$Difficulty = "beginner")

    $fs = @{
        C = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
            Users = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                student = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                    Desktop = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                        readme_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "Windows 11 Pro 24H2",
                            "PowerShell to potężne narzedzie automatyzacji.",
                            "Polecenia: Get-ChildItem (ls), Set-Location (cd), Get-Content (cat)",
                            "Aliasy: dir = ls = Get-ChildItem"
                        )}
                        notes_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            "Lista zadan:", "1. Skonfiguruj siec", "2. Zainstaluj aktualizacje", "3. Sprawdz dziennik zdarzen"
                        )}
                    }}
                    Documents = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{
                        config_xml = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                            '<?xml version="1.0"?>', '<configuration>',
                            '  <appSettings>', '    <add key="Theme" value="Dark"/>',
                            '    <add key="Lang" value="pl-PL"/>', '  </appSettings>',
                            '</configuration>'
                        )}
                    }}
                    Downloads = @{ Type = "dir"; Owner = "WIN11-PC\student"; Group = "None"; Children = @{}}
                }}
            }}
            Windows = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                System32 = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    drivers = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        etc = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                            hosts = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                "# Copyright (c) 1993-2006 Microsoft Corp.",
                                "127.0.0.1       localhost",
                                "::1             localhost",
                                "10.0.0.50       dc.corp.internal dc"
                            )}
                        }}
                    }}
                }}
            }}
            ProgramData = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                logs = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    app_log = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @(
                        "[2026-06-08 08:00:01] INFO: Application started",
                        "[2026-06-08 08:00:05] INFO: Loading configuration",
                        "[2026-06-08 08:00:10] WARN: Config key 'Theme' not found, using default",
                        "[2026-06-08 08:01:00] ERROR: Failed to connect to database",
                        "[2026-06-08 08:01:05] INFO: Retrying connection...",
                        "[2026-06-08 08:02:00] ERROR: Database timeout, shutting down"
                    )}
                }}
            }}
            Temp = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                temp_txt = @{ Type = "file"; Owner = "WIN11-PC\student"; Group = "None"; Content = @("temporary file")}
            }}
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
        @{ Id = 6; Title = "Przegladaj logi"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content /ProgramData/logs/app_log"
            Description = @("Wyswietl plik logu aplikacji w /ProgramData/logs/app_log."); Hint = "Uzyj: Get-Content /ProgramData/logs/app_log" }
        @{ Id = 7; Title = "Znajdz bledy"; Difficulty = "intermediate"; ExpectedCommand = "Select-String -Path /ProgramData/logs/app_log -Pattern ERROR"
            Description = @("W pliku app_log znajdz wszystkie linie z 'ERROR'.", "Uzyj Select-String lub grep."); Hint = "Uzyj: Select-String -Path /ProgramData/logs/app_log -Pattern ERROR lub grep 'ERROR' /ProgramData/logs/app_log" }
        @{ Id = 8; Title = "Skopiuj plik"; Difficulty = "intermediate"; ExpectedCommand = "Copy-Item Desktop/notes_txt Desktop/notes_backup.txt"
            Description = @("Skopiuj notes_txt z Desktop do notes_backup.txt w tym samym katalogu.", "Uzyj Copy-Item lub cp."); Hint = "Uzyj: Copy-Item Desktop/notes_txt Desktop/notes_backup.txt lub cp Desktop/notes_txt Desktop/notes_backup.txt" }
        @{ Id = 9; Title = "Sprawdz hosts"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content /Windows/System32/drivers/etc/hosts"
            Description = @("Wyswietl plik hosts Windows."); Hint = "Uzyj: Get-Content /Windows/System32/drivers/etc/hosts" }
        @{ Id = 10; Title = "Usun plik"; Difficulty = "intermediate"; ExpectedCommand = "Remove-Item /Temp/temp_txt"
            Description = @("Usun plik tymczasowy /Temp/temp_txt.", "Uzyj Remove-Item lub rm."); Hint = "Uzyj: Remove-Item /Temp/temp_txt lub rm /Temp/temp_txt" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Sprawdz wersje OS"; Difficulty = "advanced"; ExpectedCommand = "Get-Content /Windows/System32/drivers/etc/hosts"
            Description = @("Wyswietl plik hosts systemowy."); Hint = "Uzyj: Get-Content /Windows/System32/drivers/etc/hosts" }
        @{ Id = 12; Title = "Szukaj plikow"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem -Recurse -Filter *.txt /Users"
            Description = @("Znajdz wszystkie pliki .txt w katalogu Users.", "Uzyj Get-ChildItem -Recurse lub find."); Hint = "Uzyj: Get-ChildItem -Recurse -Filter *.txt /Users lub find /Users -name '*.txt'" }
        @{ Id = 13; Title = "Zapisz output do pliku"; Difficulty = "advanced"; ExpectedCommand = "Get-Process > /Users/student/Desktop/process_list.txt"
            Description = @("Uzyj Get-Process i zapisz wynik do pliku na Desktop.", "Uzyj przekierowania >."); Hint = "Uzyj: Get-Process > /Users/student/Desktop/process_list.txt" }
        @{ Id = 14; Title = "Wyswietl konfig XML"; Difficulty = "advanced"; ExpectedCommand = "Get-Content Documents/config_xml"
            Description = @("Wyswietl plik konfiguracyjny XML w Documents."); Hint = "Uzyj: Get-Content Documents/config_xml" }
        @{ Id = 15; Title = "Czasy systemowe"; Difficulty = "advanced"; ExpectedCommand = "Get-Date"
            Description = @("Sprawdz biezaca date i czas systemowy (Get-Date lub date)."); Hint = "Uzyj: Get-Date lub date" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Logi z Select-String"; Difficulty = "expert"; ExpectedCommand = "Select-String -Path /ProgramData/logs/app_log -Pattern ERROR | Select-Object -First 2"
            Description = @("Znajdz bledy w logu i wyswietl pierwsze 2 wyniki."); Hint = "Uzyj: Select-String -Path /ProgramData/logs/app_log -Pattern ERROR | Select-Object -First 2" }
        @{ Id = 17; Title = "Policz linie w logu"; Difficulty = "expert"; ExpectedCommand = "Get-Content /ProgramData/logs/app_log | Measure-Object -Line"
            Description = @("Policz linie w pliku app_log uzywajac Measure-Object (lub wc)."); Hint = "Uzyj: cat /ProgramData/logs/app_log | wc -l lub Get-Content /ProgramData/logs/app_log | Measure-Object -Line" }
        @{ Id = 18; Title = "Porownaj pliki"; Difficulty = "expert"; ExpectedCommand = "Compare-Object (Get-Content Desktop/readme_txt) (Get-Content Desktop/notes_txt)"
            Description = @("Porownaj zawartosc dwoch plikow na Desktop uzywajac Compare-Object."); Hint = "To zaawansowane. Sprobuj: Compare-Object (Get-Content Desktop/readme_txt) (Get-Content Desktop/notes_txt)" }
        @{ Id = 19; Title = "Sprawdz wolne miejsce"; Difficulty = "expert"; ExpectedCommand = "Get-PSDrive C"
            Description = @("Sprawdz wolne miejsce na dysku C uzywajac Get-PSDrive (lub df)."); Hint = "Uzyj: Get-PSDrive C lub df" }
        @{ Id = 20; Title = "Info o systemie"; Difficulty = "expert"; ExpectedCommand = "Get-ComputerInfo"
            Description = @("Wyswietl pelna informacje o komputerze (Get-ComputerInfo lub uname)."); Hint = "Uzyj: Get-ComputerInfo (moze nie dzialac w symulacji, sprobuj uname -a)" }
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
