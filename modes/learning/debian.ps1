function Get-LearningContent-debian {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                readme = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "Debian 12 (Bookworm) — witaj!",
                    "Debian slynie ze stabilnosci.",
                    "Aktualna wersja: 12.5", "Kod: Bookworm"
                )}
                backup = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{}}
                scripts = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    deploy_sh = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "#!/bin/bash", "# Deployment script", "echo 'Deploying...'"
                    )}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            apt = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                sources_list = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "deb http://deb.debian.org/debian bookworm main contrib non-free",
                    "deb-src http://deb.debian.org/debian bookworm main contrib non-free",
                    "deb http://security.debian.org/debian-security bookworm-security main"
                )}
            }}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("debian-server")}
            fstab = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "# /etc/fstab", "UUID=1234-5678 / ext4 defaults 0 1",
                "UUID=8765-4321 /mnt/backup ext4 defaults 0 2"
            )}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                daemon_log = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "Jun  8 10:00:00 debian systemd[1]: Starting PostgreSQL",
                    "Jun  8 10:00:05 debian postgres[1234]: database system was shut down",
                    "Jun  8 10:00:10 debian systemd[1]: Started PostgreSQL Cluster",
                    "Jun  8 10:05:00 debian apt[2345]: update completed successfully",
                    "Jun  8 10:10:00 debian systemd[1]: Stopped PostgreSQL Cluster"
                )}
            }}
            backups = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            temp_conf = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @("temporary config")}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Wyswietl plik readme"; Difficulty = "beginner"; ExpectedCommand = "cat readme"
            Description = @("W katalogu domowym znajduje sie plik readme.", "Wyswietl jego zawartosc."); Hint = "Uzyj: cat readme" }
        @{ Id = 2; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir backup/old"
            Description = @("W katalogu backup utworz podkatalog o nazwie 'old'."); Hint = "Uzyj: mkdir backup/old" }
        @{ Id = 3; Title = "Listowanie plikow"; Difficulty = "beginner"; ExpectedCommand = "ls -la scripts/"
            Description = @("Wyswietl szczegolowa liste plikow w katalogu scripts."); Hint = "Uzyj: ls -la scripts/" }
        @{ Id = 4; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "hostname"
            Description = @("Sprawdz, jaka jest nazwa tego hosta."); Hint = "Wpisz: hostname" }
        @{ Id = 5; Title = "Zobacz kalendarz"; Difficulty = "beginner"; ExpectedCommand = "cal"
            Description = @("Wyswietl kalendarz na biezacy miesiac."); Hint = "Uzyj: cal" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Znajdz wpisy PostgreSQL"; Difficulty = "intermediate"; ExpectedCommand = "grep -r 'PostgreSQL' /var/log/"
            Description = @("Przeszukaj logi w /var/log/ w poszukiwaniu wzmianek o PostgreSQL."); Hint = "Uzyj: grep -r 'PostgreSQL' /var/log/" }
        @{ Id = 7; Title = "Skopiuj skrypt deploy"; Difficulty = "intermediate"; ExpectedCommand = "cp scripts/deploy_sh backup/deploy.sh"
            Description = @("Skopiuj skrypt deploy.sh z scripts/ do katalogu backup/."); Hint = "Uzyj: cp scripts/deploy_sh backup/deploy.sh" }
        @{ Id = 8; Title = "Sprawdz pamiec"; Difficulty = "intermediate"; ExpectedCommand = "free -m"
            Description = @("Sprawdz uzycie pamieci RAM w megabajtach."); Hint = "Uzyj: free -m" }
        @{ Id = 9; Title = "Usun plik tymczasowy"; Difficulty = "intermediate"; ExpectedCommand = "rm /tmp/temp_conf"
            Description = @("Usun plik tymczasowy /tmp/temp_conf."); Hint = "Uzyj: rm /tmp/temp_conf" }
        @{ Id = 10; Title = "Wyswietl fstab"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/fstab"
            Description = @("Wyswietl plik konfiguracyjny /etc/fstab."); Hint = "Uzyj: cat /etc/fstab" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Logi systemd"; Difficulty = "advanced"; ExpectedCommand = "journalctl -u postgresql"
            Description = @("Wyswietl logi systemd dla uslugi postgresql."); Hint = "Uzyj: journalctl -u postgresql" }
        @{ Id = 12; Title = "Znajdz skrypty sh"; Difficulty = "advanced"; ExpectedCommand = "find /home -name '*.sh'"
            Description = @("Znajdz wszystkie pliki .sh w katalogu /home."); Hint = "Uzyj: find /home -name '*.sh'" }
        @{ Id = 13; Title = "Pinguj localhost"; Difficulty = "advanced"; ExpectedCommand = "ping -c 4 localhost"
            Description = @("Wyslij 4 pingi do localhost, aby sprawdzic stos TCP/IP."); Hint = "Uzyj: ping -c 4 localhost" }
        @{ Id = 14; Title = "Wyswietl liste procesow"; Difficulty = "advanced"; ExpectedCommand = "ps -ef"
            Description = @("Wyswietl wszystkie procesy w formacie full."); Hint = "Uzyj: ps -ef" }
        @{ Id = 15; Title = "Sprawdz date systemowa"; Difficulty = "advanced"; ExpectedCommand = "date"
            Description = @("Sprawdz biezaca date i czas systemowy."); Hint = "Wpisz: date" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Sprawdz open ports"; Difficulty = "expert"; ExpectedCommand = "ss -tulpn"
            Description = @("Wyswietl wszystkie nasluchujace porty TCP/UDP."); Hint = "Uzyj: ss -tulpn" }
        @{ Id = 17; Title = "Zapisz wynik do pliku"; Difficulty = "expert"; ExpectedCommand = "ps aux > ~/process_list.txt"
            Description = @("Zapisz liste procesow do pliku ~/process_list.txt uzywajac przekierowania."); Hint = "Uzyj: ps aux > ~/process_list.txt" }
        @{ Id = 18; Title = "Statystyki dysku"; Difficulty = "expert"; ExpectedCommand = "du -sh /home"
            Description = @("Sprawdz, ile miejsca zajmuje katalog /home."); Hint = "Uzyj: du -sh /home" }
        @{ Id = 19; Title = "Testuj polaczenie"; Difficulty = "expert"; ExpectedCommand = "curl -s http://localhost"
            Description = @("Wykonaj ciche zapytanie HTTP do localhost uzywajac curl."); Hint = "Uzyj: curl -s http://localhost" }
        @{ Id = 20; Title = "Wyswietl wersje jadra"; Difficulty = "expert"; ExpectedCommand = "uname -r"
            Description = @("Sprawdz, jaka wersje jadra Linux ma ten system."); Hint = "Uzyj: uname -r" }
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
