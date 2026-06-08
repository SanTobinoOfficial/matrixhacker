function Get-LearningContent-centos {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                welcome_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "Rocky Linux 9.4 — enterprise-grade Linux",
                    "Zastapil on CentOS 9 jako stabilna wersja RHEL.",
                    "Zarzadzanie pakietami: dnf"
                )}
                httpd_config = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{}}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            yum_repos_d = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                rocky_repo = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "[rocky]", "name=Rocky Linux 9.4", "baseurl=https://download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/",
                    "enabled=1", "gpgcheck=1"
                )}
            }}
            selinux = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                config = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "# SELinux configuration", "SELINUX=enforcing", "SELINUXTYPE=targeted"
                )}
            }}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("rocky-server")}
            resolv_conf = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "nameserver 8.8.8.8", "nameserver 8.8.4.4", "search corp.internal"
            )}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                messages = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "Jun  8 09:00:01 rocky kernel: Linux version 5.14.0-427.el9.x86_64",
                    "Jun  8 09:00:05 rocky systemd[1]: Starting DNF automatic updates",
                    "Jun  8 09:05:00 rocky sshd[1234]: Accepted publickey for student",
                    "Jun  8 09:10:00 rocky sudo[2345]: student : TTY=pts/0 ; USER=root ; COMMAND=/bin/systemctl start httpd",
                    "Jun  8 09:15:00 rocky kernel: SELinux: policy loaded"
                )}
            }}
            www = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                html = @{ Type = "dir"; Owner = "apache"; Group = "apache"; Children = @{
                    index_html = @{ Type = "file"; Owner = "apache"; Group = "apache"; Content = @(
                        "<html><body><h1>Rocky Linux Server</h1><p>Enterprise Linux.</p></body></html>"
                    )}
                }}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj powitanie"; Difficulty = "beginner"; ExpectedCommand = "cat welcome_txt"
            Description = @("Przeczytaj plik powitalny w katalogu domowym."); Hint = "Uzyj: cat welcome_txt" }
        @{ Id = 2; Title = "Stworz katalog httpd"; Difficulty = "beginner"; ExpectedCommand = "mkdir httpd_config/sites"
            Description = @("W katalogu httpd_config utworz podkatalog 'sites'."); Hint = "Uzyj: mkdir httpd_config/sites" }
        @{ Id = 3; Title = "Listuj katalog etc"; Difficulty = "beginner"; ExpectedCommand = "ls /etc"
            Description = @("Wyswietl zawartosc katalogu /etc."); Hint = "Uzyj: ls /etc" }
        @{ Id = 4; Title = "Wyswietl hostname"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/hostname"
            Description = @("Sprawdz nazwe hosta w pliku /etc/hostname."); Hint = "Uzyj: cat /etc/hostname" }
        @{ Id = 5; Title = "Sprawdz uzytkownika"; Difficulty = "beginner"; ExpectedCommand = "whoami"
            Description = @("Sprawdz, jako ktory uzytkownik jestes zalogowany."); Hint = "Wpisz: whoami" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Logi kernela"; Difficulty = "intermediate"; ExpectedCommand = "grep 'kernel' /var/log/messages"
            Description = @("Znajdz w /var/log/messages wszystkie linie dotyczace jadra."); Hint = "Uzyj: grep 'kernel' /var/log/messages" }
        @{ Id = 7; Title = "Skopiuj index.html"; Difficulty = "intermediate"; ExpectedCommand = "cp /var/www/html/index_html ~/index_backup.html"
            Description = @("Skopiuj index_html z /var/www/html/ do katalogu domowego."); Hint = "Uzyj: cp /var/www/html/index_html ~/index_backup.html" }
        @{ Id = 8; Title = "Sprawdz DNS"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/resolv_conf"
            Description = @("Wyswietl konfiguracje DNS w /etc/resolv.conf."); Hint = "Uzyj: cat /etc/resolv_conf" }
        @{ Id = 9; Title = "Zmien uprawnienia"; Difficulty = "intermediate"; ExpectedCommand = "chmod +x ~/index_backup.html"
            Description = @("Dodaj uprawnienia execute do pliku index_backup.html."); Hint = "Uzyj: chmod +x ~/index_backup.html" }
        @{ Id = 10; Title = "Sprawdz pamiec swap"; Difficulty = "intermediate"; ExpectedCommand = "free"
            Description = @("Sprawdz uzycie pamieci RAM i swap."); Hint = "Uzyj: free" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Sprawdz SELinux"; Difficulty = "advanced"; ExpectedCommand = "cat /etc/selinux/config"
            Description = @("Wyswietl konfiguracje SELinux."); Hint = "Uzyj: cat /etc/selinux/config" }
        @{ Id = 12; Title = "Restart httpd"; Difficulty = "advanced"; ExpectedCommand = "sudo systemctl restart httpd"
            Description = @("Zrestartuj usluge httpd (Apache) przez systemctl."); Hint = "Uzyj: sudo systemctl restart httpd" }
        @{ Id = 13; Title = "Wyszukaj w logach sudo"; Difficulty = "advanced"; ExpectedCommand = "find /var/log -name '*log*'"
            Description = @("Znajdz wszystkie pliki logow w /var/log."); Hint = "Uzyj: find /var/log -name '*log*'" }
        @{ Id = 14; Title = "Interfejsy sieciowe"; Difficulty = "advanced"; ExpectedCommand = "ifconfig"
            Description = @("Wyswietl interfejsy sieciowe za pomoca ifconfig."); Hint = "Uzyj: ifconfig" }
        @{ Id = 15; Title = "Czas pracy systemu"; Difficulty = "advanced"; ExpectedCommand = "uptime"
            Description = @("Sprawdz, jak dlugo dziala system."); Hint = "Uzyj: uptime" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Sprawdz status SEL"; Difficulty = "expert"; ExpectedCommand = "getenforce"
            Description = @("Sprawdz tryb SELinux (getenforce)."); Hint = "SELinux: getenforce niestety nie istnieje w symulacji. Sprobuj: cat /etc/selinux/config" }
        @{ Id = 17; Title = "Polacz komendy grep"; Difficulty = "expert"; ExpectedCommand = "cat /var/log/messages | grep sshd"
            Description = @("Uzyj pipe aby znalezc logi sshd w /var/log/messages."); Hint = "Uzyj: cat /var/log/messages | grep sshd" }
        @{ Id = 18; Title = "Sprawdz wersje"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl pelna informacje o systemie (uname -a)."); Hint = "Uzyj: uname -a" }
        @{ Id = 19; Title = "Listuj repozytoria"; Difficulty = "expert"; ExpectedCommand = "ls /etc/yum_repos_d/"
            Description = @("Wyswietl pliki repozytoriow DNF/YUM."); Hint = "Uzyj: ls /etc/yum_repos_d/" }
        @{ Id = 20; Title = "Sprawdz resolv"; Difficulty = "expert"; ExpectedCommand = "cat /etc/resolv_conf | grep nameserver"
            Description = @("Uzyj pipe z grep aby wyswietlic tylko serwery DNS."); Hint = "Uzyj: cat /etc/resolv_conf | grep nameserver" }
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
