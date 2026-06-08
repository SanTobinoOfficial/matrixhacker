function Get-LearningContent-opensuse {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                readme_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "openSUSE Tumbleweed — rolling release",
                    "Zarzadzanie pakietami: zypper",
                    "Konfiguracja: YaST (Yast Another Setup Tool)",
                    "Aktualizacja: sudo zypper update"
                )}
                projects = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    app_conf = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "# Application config", "APP_NAME=myapp", "APP_ENV=production",
                        "APP_PORT=3000", "DB_HOST=localhost", "DB_NAME=myapp_db"
                    )}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            zypper = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                repos_d = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                    repo_tumbleweed = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                        "[tumbleweed]", "name=Tumbleweed", "enabled=1",
                        "baseurl=https://download.opensuse.org/tumbleweed/repo/oss/",
                        "gpgcheck=1"
                    )}
                }}
            }}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("opensuse-box")}
            sysconfig = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                network = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                    ifcfg_eth0 = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                        "BOOTPROTO='dhcp'", "STARTMODE='auto'", "ZONE='public'"
                    )}
                }}
            }}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                zypper_log = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "2026-06-01 10:00:00 | install | firefox-126.0.x86_64",
                    "2026-06-03 14:30:00 | remove | old-package-1.0.x86_64",
                    "2026-06-05 09:00:00 | update | systemd-256.0.x86_64",
                    "2026-06-08 08:00:00 | install | nginx-1.26.x86_64"
                )}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj readme"; Difficulty = "beginner"; ExpectedCommand = "cat readme_txt"
            Description = @("Przeczytaj plik readme o openSUSE."); Hint = "Uzyj: cat readme_txt" }
        @{ Id = 2; Title = "Sprawdz projekty"; Difficulty = "beginner"; ExpectedCommand = "ls projects/"
            Description = @("Wyswietl zawartosc katalogu projects."); Hint = "Uzyj: ls projects/" }
        @{ Id = 3; Title = "Wyswietl app config"; Difficulty = "beginner"; ExpectedCommand = "cat projects/app_conf"
            Description = @("Wyswietl konfiguracje aplikacji z pliku app_conf."); Hint = "Uzyj: cat projects/app_conf" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir projects/logs"
            Description = @("W katalogu projects utworz podkatalog 'logs'."); Hint = "Uzyj: mkdir projects/logs" }
        @{ Id = 5; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/hostname"
            Description = @("Sprawdz nazwe hosta."); Hint = "Uzyj: cat /etc/hostname" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Logi zyppera"; Difficulty = "intermediate"; ExpectedCommand = "cat /var/log/zypper_log"
            Description = @("Wyswietl log menedzera pakietow zypper."); Hint = "Uzyj: cat /var/log/zypper_log" }
        @{ Id = 7; Title = "Kopiuj config"; Difficulty = "intermediate"; ExpectedCommand = "cp projects/app_conf ~/app_conf.backup"
            Description = @("Zrob kopie pliku konfiguracyjnego app_conf."); Hint = "Uzyj: cp projects/app_conf ~/app_conf.backup" }
        @{ Id = 8; Title = "Wyszukaj w logach"; Difficulty = "intermediate"; ExpectedCommand = "grep 'install' /var/log/zypper_log"
            Description = @("Znajdz w logu zyppera linie z 'install'."); Hint = "Uzyj: grep 'install' /var/log/zypper_log" }
        @{ Id = 9; Title = "Konfiguracja sieci"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/sysconfig/network/ifcfg_eth0"
            Description = @("Wyswietl konfiguracje interfejsu sieciowego."); Hint = "Uzyj: cat /etc/sysconfig/network/ifcfg_eth0" }
        @{ Id = 10; Title = "Sprawdz uzytkownika"; Difficulty = "intermediate"; ExpectedCommand = "id"
            Description = @("Sprawdz swoj identyfikator uzytkownika."); Hint = "Uzyj: id" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Restart serwera"; Difficulty = "advanced"; ExpectedCommand = "sudo systemctl restart sshd"
            Description = @("Zrestartuj usluge SSH przez systemctl."); Hint = "Uzyj: sudo systemctl restart sshd" }
        @{ Id = 12; Title = "Znajdz pliki .conf w /etc"; Difficulty = "advanced"; ExpectedCommand = "find /etc -name '*.conf'"
            Description = @("Znajdz wszystkie pliki .conf w /etc."); Hint = "Uzyj: find /etc -name '*.conf'" }
        @{ Id = 13; Title = "Ostatnie instalacje"; Difficulty = "advanced"; ExpectedCommand = "tail -5 /var/log/zypper_log"
            Description = @("Wyswietl ostatnie 5 wpisow z logu zyppera."); Hint = "Uzyj: tail -5 /var/log/zypper_log" }
        @{ Id = 14; Title = "Sprawdz interfejsy"; Difficulty = "advanced"; ExpectedCommand = "ip a"
            Description = @("Wyswietl adresy IP interfejsow sieciowych."); Hint = "Uzyj: ip a" }
        @{ Id = 15; Title = "Wyswietl kalendarz"; Difficulty = "advanced"; ExpectedCommand = "cal"
            Description = @("Wyswietl kalendarz."); Hint = "Uzyj: cal" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Polacz z grep"; Difficulty = "expert"; ExpectedCommand = "ps aux | grep systemd"
            Description = @("Znajdz procesy systemd uzywajac ps i grep."); Hint = "Uzyj: ps aux | grep systemd" }
        @{ Id = 17; Title = "Sortuj logi"; Difficulty = "expert"; ExpectedCommand = "sort /var/log/zypper_log"
            Description = @("Wyswietl posortowany log zyppera."); Hint = "Uzyj: sort /var/log/zypper_log" }
        @{ Id = 18; Title = "Sprawdz pamiec"; Difficulty = "expert"; ExpectedCommand = "free"
            Description = @("Sprawdz uzycie pamieci."); Hint = "Uzyj: free" }
        @{ Id = 19; Title = "Testuj ping"; Difficulty = "expert"; ExpectedCommand = "ping -c 3 localhost"
            Description = @("Wyslij 3 pingi do localhost."); Hint = "Uzyj: ping -c 3 localhost" }
        @{ Id = 20; Title = "Info o systemie"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl pelna informacje o systemie."); Hint = "Uzyj: uname -a" }
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
