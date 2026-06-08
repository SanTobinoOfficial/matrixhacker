function Get-LearningContent-kali {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                readme_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "Kali Linux 2026.1 — pentesting distribution",
                    "Narzedzia: nmap, metasploit, burpsuite, john, hashcat",
                    "Dokumentacja: kali.org/docs"
                )}
                tools = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    scan_results = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "Nmap scan report for 10.10.10.1", "PORT    STATE  SERVICE",
                        "22/tcp  open   ssh", "80/tcp  open   http", "443/tcp open  https",
                        "3306/tcp open  mysql", "8080/tcp open  http-proxy"
                    )}
                }}
                loot = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{}}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("kali-pentest")}
            passwd = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "root:x:0:0:root:/root:/bin/bash",
                "student:x:1000:1000:Student,,,:/home/student:/bin/zsh",
                "mysql:x:120:130:MySQL Server,,,:/nonexistent:/bin/false"
            )}
            shadow = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "root:\$y\$j9T\$abcdef1234567890:19876:0:99999:7:::",
                "student:\$y\$j9T\$0987654321fedcba:19876:0:99999:7:::"
            )}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                kali_setup_log = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "[INFO] Starting Kali Linux setup", "[INFO] Configuring repositories",
                    "[INFO] Installing kali-linux-headless", "[INFO] Setup complete"
                )}
            }}
        }}
        usr = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            share = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                wordlists = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                    rockyou_txt = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                        "password123", "123456789", "qwerty123", "letmein", "admin2024"
                    )}
                }}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj readme Kali"; Difficulty = "beginner"; ExpectedCommand = "cat readme_txt"
            Description = @("Przeczytaj plik powitalny Kali Linux."); Hint = "Uzyj: cat readme_txt" }
        @{ Id = 2; Title = "Listuj narzedzia"; Difficulty = "beginner"; ExpectedCommand = "ls tools/"
            Description = @("Wyswietl zawartosc katalogu tools."); Hint = "Uzyj: ls tools/" }
        @{ Id = 3; Title = "Wyswietl wyniki skanu"; Difficulty = "beginner"; ExpectedCommand = "cat tools/scan_results"
            Description = @("W katalogu tools/ znajduje sie plik scan_results. Wyswietl go."); Hint = "Uzyj: cat tools/scan_results" }
        @{ Id = 4; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir loot/exploits"
            Description = @("W katalogu loot utworz podkatalog 'exploits'."); Hint = "Uzyj: mkdir loot/exploits" }
        @{ Id = 5; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/hostname"
            Description = @("Sprawdz nazwe hosta Kali."); Hint = "Uzyj: cat /etc/hostname" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Znajdz w wordlist"; Difficulty = "intermediate"; ExpectedCommand = "grep 'admin' /usr/share/wordlists/rockyou_txt"
            Description = @("Wyszukaj haslo 'admin' w wordliscie rockyou."); Hint = "Uzyj: grep 'admin' /usr/share/wordlists/rockyou_txt" }
        @{ Id = 7; Title = "Skopiuj wordliste"; Difficulty = "intermediate"; ExpectedCommand = "cp /usr/share/wordlists/rockyou_txt ~/wordlist_copy.txt"
            Description = @("Skopiuj wordliste do katalogu domowego."); Hint = "Uzyj: cp /usr/share/wordlists/rockyou_txt ~/wordlist_copy.txt" }
        @{ Id = 8; Title = "Sprawdz shadow"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/shadow"
            Description = @("Wyswietl plik /etc/shadow (hashe haseł)."); Hint = "Uzyj: cat /etc/shadow" }
        @{ Id = 9; Title = "Sprawdz paswd"; Difficulty = "intermediate"; ExpectedCommand = "cat /etc/passwd"
            Description = @("Wyswietl plik /etc/passwd z lista uzytkownikow."); Hint = "Uzyj: cat /etc/passwd" }
        @{ Id = 10; Title = "Przenies plik"; Difficulty = "intermediate"; ExpectedCommand = "mv ~/wordlist_copy.txt loot/"
            Description = @("Przenies plik wordlist_copy.txt do katalogu loot/."); Hint = "Uzyj: mv ~/wordlist_copy.txt loot/" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Logi instalacji"; Difficulty = "advanced"; ExpectedCommand = "cat /var/log/kali_setup_log"
            Description = @("Wyswietl log instalacji Kali Linux."); Hint = "Uzyj: cat /var/log/kali_setup_log" }
        @{ Id = 12; Title = "Znajdz pliki txt"; Difficulty = "advanced"; ExpectedCommand = "find /home -name '*.txt'"
            Description = @("Znajdz wszystkie pliki .txt w /home."); Hint = "Uzyj: find /home -name '*.txt'" }
        @{ Id = 13; Title = "Ostatnie logowania"; Difficulty = "advanced"; ExpectedCommand = "journalctl -n 5"
            Description = @("Wyswietl 5 ostatnich wpisow z journalctl."); Hint = "Uzyj: journalctl -n 5" }
        @{ Id = 14; Title = "Porty HTTP"; Difficulty = "advanced"; ExpectedCommand = "grep 'http' tools/scan_results"
            Description = @("W pliku scan_results znajdz linie z 'http'."); Hint = "Uzyj: grep 'http' tools/scan_results" }
        @{ Id = 15; Title = "Sprawdz interfejs"; Difficulty = "advanced"; ExpectedCommand = "ip a"
            Description = @("Wyswietl adresy IP interfejsow sieciowych."); Hint = "Uzyj: ip a" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Polacz komendy"; Difficulty = "expert"; ExpectedCommand = "ps aux | grep root"
            Description = @("Znajdz procesy uruchomione przez roota uzywajac ps i grep."); Hint = "Uzyj: ps aux | grep root" }
        @{ Id = 17; Title = "Sortuj i uniq"; Difficulty = "expert"; ExpectedCommand = "sort /etc/passwd | uniq"
            Description = @("Wyswietl posortowany /etc/passwd bez duplikatow."); Hint = "Uzyj: sort /etc/passwd | uniq" }
        @{ Id = 18; Title = "Sprawdz pamiec"; Difficulty = "expert"; ExpectedCommand = "free -h"
            Description = @("Sprawdz uzycie pamieci RAM."); Hint = "Uzyj: free -h" }
        @{ Id = 19; Title = "Testuj polaczenie"; Difficulty = "expert"; ExpectedCommand = "ping -c 2 localhost"
            Description = @("Wyslij 2 pingi do localhost."); Hint = "Uzyj: ping -c 2 localhost" }
        @{ Id = 20; Title = "Wersja jadra"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl pelna informacje o wersji jadra."); Hint = "Uzyj: uname -a" }
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
