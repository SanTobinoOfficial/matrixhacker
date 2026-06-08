function Get-LearningContent-macos {
    param([string]$Difficulty = "beginner")

    $fs = @{
        Users = @{ Type = "dir"; Owner = "root"; Group = "wheel"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{
                Desktop = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{
                    readme_txt = @{ Type = "file"; Owner = "student"; Group = "staff"; Content = @(
                        "macOS Sequoia — witaj w terminalu!",
                        "Shell: zsh (Z shell)",
                        "Zarzadzanie pakietami: brew (Homebrew)",
                        "Roznica: ls -G (kolorowe wyjscie), brak --color"
                    )}
                    info_plist = @{ Type = "file"; Owner = "student"; Group = "staff"; Content = @(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"',
                        ' "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                        '<plist version="1.0"><dict>',
                        '  <key>SystemVersion</key><string>15.0</string>',
                        '  <key>ProductName</key><string>macOS Sequoia</string>',
                        '</dict></plist>'
                    )}
                }}
                Documents = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{
                    notes_md = @{ Type = "file"; Owner = "student"; Group = "staff"; Content = @(
                        "# macOS Notes", "## Useful commands",
                        "- `brew install` - install packages",
                        "- `system_profiler` - system info",
                        "- `plutil` - plist manipulation",
                        "- `dscacheutil` - directory cache"
                    )}
                }}
                Downloads = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{}}
                Applications = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{}}
                Library = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{
                    Logs = @{ Type = "dir"; Owner = "student"; Group = "staff"; Children = @{
                        system_log = @{ Type = "file"; Owner = "student"; Group = "staff"; Content = @(
                            "2026-06-08 08:00:00.000 kernel[0]: vm_page_bootstrap: 4194304 pages",
                            "2026-06-08 08:00:01.000 systemd[1]: Continuing",
                            "2026-06-08 08:05:00.000 mds[100]: (Normal) Volume: volume:0x8000  --- mount at /System/Volumes/Data",
                            "2026-06-08 08:10:00.000 configd[200]: Network configuration changed",
                            "2026-06-08 08:15:00.000 sshd[300]: Accepted publickey for student from 10.0.0.10"
                        )}
                    }}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "wheel"; Children = @{
            hostname = @{ Type = "file"; Owner = "root"; Group = "wheel"; Content = @("macbook-pro")}
            hosts = @{ Type = "file"; Owner = "root"; Group = "wheel"; Content = @(
                "127.0.0.1       localhost",
                "255.255.255.255 broadcasthost",
                "::1             localhost",
                "10.0.0.10       macbook-pro.local macbook-pro"
            )}
            shells = @{ Type = "file"; Owner = "root"; Group = "wheel"; Content = @(
                "/bin/bash", "/bin/zsh", "/bin/sh", "/bin/csh", "/bin/tcsh", "/bin/ksh"
            )}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "wheel"; Children = @{}}
        Volumes = @{ Type = "dir"; Owner = "root"; Group = "wheel"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj readme"; Difficulty = "beginner"; ExpectedCommand = "cat Desktop/readme_txt"
            Description = @("Przeczytaj plik powitalny macOS na Desktop."); Hint = "Uzyj: cat Desktop/readme_txt" }
        @{ Id = 2; Title = "Zobacz co jest na Desktop"; Difficulty = "beginner"; ExpectedCommand = "ls Desktop/"
            Description = @("Wyswietl zawartosc katalogu Desktop."); Hint = "Uzyj: ls Desktop/" }
        @{ Id = 3; Title = "Wyswietl notatki"; Difficulty = "beginner"; ExpectedCommand = "cat Documents/notes_md"
            Description = @("W Documents znajduje sie plik notes_md. Wyswietl go."); Hint = "Uzyj: cat Documents/notes_md" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir Downloads/apps"
            Description = @("Utworz katalog Downloads/apps."); Hint = "Uzyj: mkdir Downloads/apps" }
        @{ Id = 5; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/hostname"
            Description = @("Sprawdz nazwe hosta MacBooka."); Hint = "Uzyj: cat /etc/hostname" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Sprawdz logi systemowe"; Difficulty = "intermediate"; ExpectedCommand = "cat Library/Logs/system_log"
            Description = @("Wyswietl log systemowy macOS."); Hint = "Uzyj: cat Library/Logs/system_log" }
        @{ Id = 7; Title = "Znajdz kernel"; Difficulty = "intermediate"; ExpectedCommand = "grep 'kernel' Library/Logs/system_log"
            Description = @("Znajdz w logu linie dotyczace jadra."); Hint = "Uzyj: grep 'kernel' Library/Logs/system_log" }
        @{ Id = 8; Title = "Kopiuj info.plist"; Difficulty = "intermediate"; ExpectedCommand = "cp Desktop/info_plist ~/info_system_backup.plist"
            Description = @("Skopiuj info_plist z Desktop do katalogu domowego."); Hint = "Uzyj: cp Desktop/info_plist ~/info_system_backup.plist" }
        @{ Id = 9; Title = "Wyswietl hosts"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/hosts"
            Description = @("Wyswietl plik hosts macOS."); Hint = "Uzyj: cat /etc/hosts" }
        @{ Id = 10; Title = "Usun plik"; Difficulty = "intermediate"; ExpectedCommand = "rm ~/info_system_backup.plist"
            Description = @("Usun plik backupu z katalogu domowego."); Hint = "Uzyj: rm ~/info_system_backup.plist" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Znajdz pliki .plist"; Difficulty = "advanced"; ExpectedCommand = "find /Users -name '*.plist'"
            Description = @("Znajdz wszystkie pliki .plist w katalogu Users."); Hint = "Uzyj: find /Users -name '*.plist'" }
        @{ Id = 12; Title = "Sprawdz dostepne shelle"; Difficulty = "advanced"; ExpectedCommand = "cat /etc/shells"
            Description = @("Wyswietl liste dostepnych shelli w /etc/shells."); Hint = "Uzyj: cat /etc/shells" }
        @{ Id = 13; Title = "Logi sshd"; Difficulty = "advanced"; ExpectedCommand = "grep 'sshd' Library/Logs/system_log"
            Description = @("Znajdz w logu zdarzenia zwiazane z sshd."); Hint = "Uzyj: grep 'sshd' Library/Logs/system_log" }
        @{ Id = 14; Title = "Sprawdz date"; Difficulty = "advanced"; ExpectedCommand = "date"
            Description = @("Sprawdz biezaca date na MacBooku."); Hint = "Uzyj: date" }
        @{ Id = 15; Title = "Sprawdz uzytkownika"; Difficulty = "advanced"; ExpectedCommand = "id"
            Description = @("Sprawdz swoje UID i GID."); Hint = "Uzyj: id" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Polacz cat z head"; Difficulty = "expert"; ExpectedCommand = "cat Library/Logs/system_log | head -3"
            Description = @("Wyswietl pierwsze 3 linie logu systemowego uzywajac pipe."); Hint = "Uzyj: cat Library/Logs/system_log | head -3" }
        @{ Id = 17; Title = "Policz linie w logu"; Difficulty = "expert"; ExpectedCommand = "wc -l Library/Logs/system_log"
            Description = @("Policz liczbe linii w logu systemowym."); Hint = "Uzyj: wc -l Library/Logs/system_log" }
        @{ Id = 18; Title = "Sprawdz pamiec"; Difficulty = "expert"; ExpectedCommand = "free -h"
            Description = @("Sprawdz uzycie pamieci RAM."); Hint = "Uzyj: free -h" }
        @{ Id = 19; Title = "Info o systemie"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl pelna informacje o systemie macOS."); Hint = "Uzyj: uname -a" }
        @{ Id = 20; Title = "Posortuj logi"; Difficulty = "expert"; ExpectedCommand = "cat Library/Logs/system_log | sort"
            Description = @("Wyswietl posortowany log systemowy."); Hint = "Uzyj: cat Library/Logs/system_log | sort" }
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
