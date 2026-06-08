function Get-LearningContent-ubuntu {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                welcome = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "Witaj w Ubuntu 24.04 LTS!",
                    "",
                    "Ten plik pomoze Ci poznac podstawy terminala.",
                    "Sprobuj uzyc: ls, cd, cat, mkdir, touch"
                )}
                Documents = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    notes_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "Notatki z lekcji:", "1. ls - lista plikow", "2. cd - zmiana katalogu", "3. cat - wyswietl plik"
                    )}
                }}
                Projects = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{}}
                'bashrc' = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "# ~/.bashrc", "alias ll='ls -la'", "alias gs='git status'",
                    "export PS1='\u@\h:\w\$ '", "export EDITOR=nano"
                )}
            }}
            other = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            nginx = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                nginx_conf = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "user www-data;", "worker_processes auto;", "pid /run/nginx.pid;",
                    "events { worker_connections 768; multi_accept on; }",
                    "http { sendfile on; tcp_nopush on;",
                    "    include /etc/nginx/mime.types;",
                    "    server { listen 80; root /var/www/html; } }"
                )}
            }}
            passwd = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "root:x:0:0:root:/root:/bin/bash",
                "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin",
                "student:x:1000:1000:Student,,,:/home/student:/bin/bash",
                "admin:x:1001:1001:Administrator,,,:/home/admin:/bin/bash",
                "mysql:x:120:130:MySQL Server,,,:/nonexistent:/bin/false"
            )}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("ubuntu-server")}
            os_release = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                'PRETTY_NAME="Ubuntu 24.04 LTS"', 'NAME="Ubuntu"',
                "VERSION_ID=24.04", "VERSION_CODENAME=noble", "ID=ubuntu"
            )}
        }}
        'var' = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                syslog = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "Jun  8 08:00:01 ubuntu CRON[1234]: pam_unix(cron:session): session opened",
                    "Jun  8 08:01:22 ubuntu sshd[2345]: Accepted publickey for student",
                    "Jun  8 08:05:00 ubuntu nginx[3456]: 10.0.0.1 GET /index.html 200",
                    "Jun  8 08:10:15 ubuntu kernel: [12345.678] eth0: link up",
                    "Jun  8 08:15:30 ubuntu systemd[1]: Started Cleanup of Temporary Directories",
                    "Jun  8 08:20:00 ubuntu sshd[4567]: Failed password for root from 192.168.1.100",
                    "Jun  8 08:25:45 ubuntu nginx[3456]: 10.0.0.2 GET /api/data 404",
                    "Jun  8 08:30:01 ubuntu CRON[5678]: (root) CMD (test -x /usr/sbin/anacron)"
                )}
                auth_log = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "Jun  8 08:00:01 ubuntu sshd[2345]: Accepted publickey for student from 10.0.0.10",
                    "Jun  8 08:10:00 ubuntu sudo: student : TTY=pts/0 ; USER=root ; COMMAND=/bin/systemctl restart nginx",
                    'Jun  8 08:20:00 ubuntu sshd[4567]: Failed password for root from 192.168.1.100 port 54321 ssh2',
                    'Jun  8 08:20:05 ubuntu sshd[4567]: Failed password for root from 192.168.1.100 port 54322 ssh2',
                    'Jun  8 08:20:10 ubuntu sshd[4567]: Failed password for root from 192.168.1.100 port 54323 ssh2'
                )}
            }}
            www = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                html = @{ Type = "dir"; Owner = "www-data"; Group = "www-data"; Children = @{
                    index_html = @{ Type = "file"; Owner = "www-data"; Group = "www-data"; Content = @(
                        "<html><head><title>Ubuntu Server</title></head>",
                        "<body><h1>Welcome to Ubuntu 24.04 LTS!</h1>",
                        "<p>This server is running Nginx on Ubuntu.</p></body></html>"
                    )}
                }}
            }}
        }}
        usr = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{} }
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            temp_data = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @("temp data file")}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Znajdz plik welcome.txt"; Difficulty = "beginner"; ExpectedCommand = "ls -la"
            Description = @("Katalog domowy zawiera plik powitalny. Wyswietl jego zawartosc,", "aby dowiedziec sie wiecej o systemie Ubuntu.")
            Hint = "Uzyj ls -la aby wyswietlic wszystkie pliki w biezacym katalogu." }
        @{ Id = 2; Title = "Przejdz do katalogu Documents"; Difficulty = "beginner"; ExpectedCommand = "cd Documents"
            Description = @("Przejdz do katalogu 'Documents' (dokumenty) i sprawdz,", "co sie w nim znajduje.")
            Hint = "Uzyj cd Documents, a nastepnie ls." }
        @{ Id = 3; Title = "Wyswietl plik notatek"; Difficulty = "beginner"; ExpectedCommand = "cat Documents/notes_txt"
            Description = @("W katalogu Documents znajduje sie plik z notatkami.", "Wyswietl jego zawartosc komenda cat.")
            Hint = "Uzyj: cat Documents/notes_txt" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir Projects/linux-lessons"
            Description = @("W katalogu Projects utworz podkatalog o nazwie 'linux-lessons'.", "Nastepnie sprawdz, czy zostal utworzony.")
            Hint = "Uzyj: mkdir Projects/linux-lessons" }
        @{ Id = 5; Title = "Sprawdz biezacy katalog"; Difficulty = "beginner"; ExpectedCommand = "pwd"
            Description = @("Sprawdz, w ktorym katalogu sie znajdujesz, uzywajac", "komendy pwd (print working directory).")
            Hint = "Po prostu wpisz: pwd" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Wyszukaj w logach"; Difficulty = "intermediate"; ExpectedCommand = "grep 'Failed password' /var/log/auth_log"
            Description = @("Ktos probuje sie wlamac na serwer. W logach /var/log/auth_log", "znajdz wszystkie linie z 'Failed password'.")
            Hint = "Uzyj grep z wzorcem 'Failed password': grep 'Failed password' /var/log/auth_log" }
        @{ Id = 7; Title = "Sprawdz procesy"; Difficulty = "intermediate"; ExpectedCommand = "ps aux"
            Description = @("Wyswietl wszystkie dzialajace procesy w systemie,", "aby zobaczyc co jest uruchomione.")
            Hint = "Uzyj: ps aux" }
        @{ Id = 8; Title = "Kopiuj plik"; Difficulty = "intermediate"; ExpectedCommand = "cp /var/www/html/index_html ~/index_html.backup"
            Description = @("Wykonaj kopie zapasowa pliku index_html z /var/www/html/", "do katalogu domowego z nazwa index_html.backup.")
            Hint = "Uzyj cp: cp /var/www/html/index_html ~/index_html.backup" }
        @{ Id = 9; Title = "Zmien uprawnienia"; Difficulty = "intermediate"; ExpectedCommand = "chmod 755 ~/index_html.backup"
            Description = @("Zmien uprawnienia pliku index_html.backup w katalogu domowym", "na 755 (rwxr-xr-x).")
            Hint = "Uzyj: chmod 755 ~/index_html.backup" }
        @{ Id = 10; Title = "Sprawdz miejsce na dysku"; Difficulty = "intermediate"; ExpectedCommand = "df -h"
            Description = @("Sprawdz, ile miejsca jest dostepne na dyskach w systemie.", "Uzyj opcji -h dla czytelnego formatu.")
            Hint = "Uzyj: df -h" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Restart uslugi"; Difficulty = "advanced"; ExpectedCommand = "sudo systemctl restart nginx"
            Description = @("Usluga nginx wymaga restartu. Uzyj systemctl,", "aby zrestartowac ja z uprawnieniami roota.")
            Hint = "Uzyj: sudo systemctl restart nginx" }
        @{ Id = 12; Title = "Znajdz pliki .conf"; Difficulty = "advanced"; ExpectedCommand = "find /etc -name '*.conf'"
            Description = @("Znajdz wszystkie pliki konfiguracyjne (*.conf) w katalogu /etc", "i jego podkatalogach.")
            Hint = "Uzyj find z opcja -name: find /etc -name '*.conf'" }
        @{ Id = 13; Title = "Logi bledow"; Difficulty = "advanced"; ExpectedCommand = "journalctl -n 20"
            Description = @("Wyswietl ostatnie 20 wpisow z logow systemowych", "za pomoca journalctl.")
            Hint = "Uzyj: journalctl -n 20" }
        @{ Id = 14; Title = "Statystyki pamieci"; Difficulty = "advanced"; ExpectedCommand = "free -h"
            Description = @("Sprawdz, ile pamieci RAM jest uzywane, a ile dostepne.", "Uzyj opcji -h dla czytelnego formatu.")
            Hint = "Uzyj: free -h" }
        @{ Id = 15; Title = "Sprawdz interfejs sieciowy"; Difficulty = "advanced"; ExpectedCommand = "ip a"
            Description = @("Wyswietl wszystkie interfejsy sieciowe i ich adresy IP", "za pomoca komendy ip.")
            Hint = "Uzyj: ip a" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Kto jest zalogowany"; Difficulty = "expert"; ExpectedCommand = "grep 'student' /etc/passwd"
            Description = @("Sprawdz w pliku /etc/passwd informacje o uzytkowniku 'student'.", "Uzyj grep aby znalezc odpowiednia linie.")
            Hint = "Uzyj: grep 'student' /etc/passwd" }
        @{ Id = 17; Title = "Polacz komendy"; Difficulty = "expert"; ExpectedCommand = "ps aux | grep nginx"
            Description = @("Uzyj pipe (|) aby polaczyc ps aux z grep i znalezc", "tylko procesy zwiazane z nginx.")
            Hint = "Uzyj: ps aux | grep nginx" }
        @{ Id = 18; Title = "Spakuj katalog"; Difficulty = "expert"; ExpectedCommand = "tar -czf backup.tar.gz /var/www"
            Description = @("Spakuj katalog /var/www do archiwum tar.gz", "o nazwie backup.tar.gz.")
            Hint = "Uzyj: tar -czf backup.tar.gz /var/www" }
        @{ Id = 19; Title = "Sortuj unikalne"; Difficulty = "expert"; ExpectedCommand = "sort /var/log/auth_log | uniq"
            Description = @("Wyswietl zawartosc /var/log/auth_log, posortuj ja,", "a nastepnie wyswietl tylko unikalne linie.")
            Hint = "Uzyj pipe: sort /var/log/auth_log | uniq" }
        @{ Id = 20; Title = "Sprawdz wersje systemu"; Difficulty = "expert"; ExpectedCommand = "cat /etc/os_release"
            Description = @("Sprawdz dokladna wersje systemu Ubuntu, wyswietlajac", "plik /etc/os-release.")
            Hint = "Uzyj: cat /etc/os_release" }
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
