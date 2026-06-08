function Get-LearningContent-alpine {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                about_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    'Alpine Linux 3.20 - lekki i bezpieczny',
                    'Zarzadzanie pakietami: apk',
                    'Init system: OpenRC (nie systemd!)',
                    'Menedzer plikow: busybox'
                )}
                configs = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    network_cfg = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "auto lo", "iface lo inet loopback",
                        "auto eth0", "iface eth0 inet static",
                        "    address 10.0.0.50", "    netmask 255.255.255.0", "    gateway 10.0.0.1"
                    )}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            apk = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                repositories = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "https://dl-cdn.alpinelinux.org/alpine/v3.20/main",
                    "https://dl-cdn.alpinelinux.org/alpine/v3.20/community"
                )}
            }}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("alpine-box")}
            inittab = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "# /etc/inittab", "::sysinit:/sbin/openrc sysinit",
                "::wait:/sbin/openrc boot", "::ctrlaltdel:/sbin/reboot"
            )}
        }}
        'var' = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                messages = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "Jun  8 07:00:00 alpine-box kernel: Linux version 6.7.0-0.alpine",
                    "Jun  8 07:00:05 alpine-box openrc: Starting syslogd",
                    "Jun  8 07:00:10 alpine-box openrc: Starting sshd",
                    "Jun  8 07:05:00 alpine-box sshd[1234]: Server listening on 0.0.0.0 port 22"
                )}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj o Alpine"; Difficulty = "beginner"; ExpectedCommand = "cat about_txt"
            Description = @("Przeczytaj plik informacyjny o Alpine Linux."); Hint = "Uzyj: cat about_txt" }
        @{ Id = 2; Title = "Listuj configs"; Difficulty = "beginner"; ExpectedCommand = "ls configs/"
            Description = @("Wyswietl zawartosc katalogu configs."); Hint = "Uzyj: ls configs/" }
        @{ Id = 3; Title = "Wyswietl konfiguracje sieci"; Difficulty = "beginner"; ExpectedCommand = "cat configs/network_cfg"
            Description = @("Wyswietl konfiguracje sieci w configs/network_cfg."); Hint = "Uzyj: cat configs/network_cfg" }
        @{ Id = 4; Title = "Stworz podkatalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir configs/backup"
            Description = @("Utworz katalog configs/backup."); Hint = "Uzyj: mkdir configs/backup" }
        @{ Id = 5; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/hostname"
            Description = @("Sprawdz nazwe tego hosta."); Hint = "Uzyj: cat /etc/hostname" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Znajdz wzmianki o openrc"; Difficulty = "intermediate"; ExpectedCommand = "grep 'openrc' /var/log/messages"
            Description = @("W logu /var/log/messages znajdz linie z 'openrc'."); Hint = "Uzyj: grep 'openrc' /var/log/messages" }
        @{ Id = 7; Title = "Skopiuj konfiguracje"; Difficulty = "intermediate"; ExpectedCommand = "cp configs/network_cfg ~/network.backup"
            Description = @("Skopiuj konfiguracje sieci do katalogu domowego."); Hint = "Uzyj: cp configs/network_cfg ~/network.backup" }
        @{ Id = 8; Title = "Sprawdz repozytoria"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/apk/repositories"
            Description = @("Wyswietl repozytoria APK Alpine."); Hint = "Uzyj: cat /etc/apk/repositories" }
        @{ Id = 9; Title = "Sprawdz uptime"; Difficulty = "intermediate"; ExpectedCommand = "uptime"
            Description = @("Sprawdz, jak dlugo dziala system."); Hint = "Uzyj: uptime" }
        @{ Id = 10; Title = "Sprawdz uzytkownika"; Difficulty = "intermediate"; ExpectedCommand = "whoami"
            Description = @("Sprawdz, jako kto jestes zalogowany."); Hint = "Wpisz: whoami" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Logi jadra"; Difficulty = "advanced"; ExpectedCommand = "grep 'kernel' /var/log/messages"
            Description = @("Znajdz linie dotyczace jadra w /var/log/messages."); Hint = "Uzyj: grep 'kernel' /var/log/messages" }
        @{ Id = 12; Title = "Znajdz backup"; Difficulty = "advanced"; ExpectedCommand = "find /home -name '*.backup'"
            Description = @("Znajdz wszystkie pliki .backup w /home."); Hint = "Uzyj: find /home -name '*.backup'" }
        @{ Id = 13; Title = "Ostatnie logi"; Difficulty = "advanced"; ExpectedCommand = "tail -3 /var/log/messages"
            Description = @("Wyswietl ostatnie 3 linie logu /var/log/messages."); Hint = "Uzyj: tail -3 /var/log/messages" }
        @{ Id = 14; Title = "Statystyki dysku"; Difficulty = "advanced"; ExpectedCommand = "df -h"
            Description = @("Sprawdz wolne miejsce na dysku."); Hint = "Uzyj: df -h" }
        @{ Id = 15; Title = "Wyswietl procesy"; Difficulty = "advanced"; ExpectedCommand = "ps"
            Description = @("Wyswietl liste procesow."); Hint = "Uzyj: ps" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Zapisz logi do pliku"; Difficulty = "expert"; ExpectedCommand = "cat /var/log/messages > ~/system_log.txt"
            Description = @("Zapisz caly log systemowy do pliku w katalogu domowym."); Hint = 'Uzyj: cat /var/log/messages > ~/system_log.txt' }
        @{ Id = 17; Title = "Polacz ps z grep"; Difficulty = "expert"; ExpectedCommand = "ps | grep sshd"
            Description = @("Uzyj pipe aby znalezc proces sshd."); Hint = "Uzyj: ps | grep sshd" }
        @{ Id = 18; Title = "Sprawdz pamiec w MB"; Difficulty = "expert"; ExpectedCommand = "free -m"
            Description = @("Sprawdz uzycie pamieci w megabajtach."); Hint = "Uzyj: free -m" }
        @{ Id = 19; Title = "Wersja jadra"; Difficulty = "expert"; ExpectedCommand = "uname -r"
            Description = @("Sprawdz wersje jadra Linux."); Hint = "Uzyj: uname -r" }
        @{ Id = 20; Title = "Policz linie w logu"; Difficulty = "expert"; ExpectedCommand = "wc -l /var/log/messages"
            Description = @("Policz liczbe linii w /var/log/messages."); Hint = "Uzyj: wc -l /var/log/messages" }
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
