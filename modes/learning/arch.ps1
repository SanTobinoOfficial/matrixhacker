function Get-LearningContent-arch {
    param([string]$Difficulty = "beginner")

    $fs = @{
        home = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            student = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                info_txt = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                    "Arch Linux — rolling release. Witaj!",
                    "Zarzadzanie pakietami: pacman",
                    "Aktualizacja: sudo pacman -Syu",
                    "Instalacja: sudo pacman -S <pakiet>"
                )}
                build = @{ Type = "dir"; Owner = "student"; Group = "student"; Children = @{
                    PKGBUILD = @{ Type = "file"; Owner = "student"; Group = "student"; Content = @(
                        "# Maintainer: Student Student <student@archlinux.org>",
                        "pkgname=hello-world", "pkgver=1.0", "pkgrel=1",
                        "arch=('x86_64')", "license=('GPL')",
                        "package() { mkdir -p $pkgdir/usr/bin; echo 'hello' > $pkgdir/usr/bin/hello; }"
                    )}
                }}
            }}
        }}
        etc = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            pacman_conf = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "# /etc/pacman.conf", "[options]", "ParallelDownloads = 5",
                "Color", "CheckSpace", "[core]", "[extra]", "[community]"
            )}
            hostname = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @("arch-desktop")}
            locale_gen = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "en_US.UTF-8 UTF-8", "pl_PL.UTF-8 UTF-8", "de_DE.UTF-8 UTF-8"
            )}
        }}
        var = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            log = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                pacman_log = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "[2026-06-01T10:00] [PACMAN] upgraded linux (6.8.0 -> 6.9.0)",
                    "[2026-06-02T14:30] [PACMAN] installed firefox (126.0)",
                    "[2026-06-05T09:15] [PACMAN] removed old-kernel (5.15.0)",
                    "[2026-06-08T08:00] [PACMAN] upgraded systemd (255.0 -> 256.0)"
                )}
            }}
            cache = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                pacman = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
            }}
        }}
        tmp = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Przeczytaj info"; Difficulty = "beginner"; ExpectedCommand = "cat info_txt"
            Description = @("Przeczytaj plik informacyjny o Arch Linux."); Hint = "Uzyj: cat info_txt" }
        @{ Id = 2; Title = "Wyswietl PKGBUILD"; Difficulty = "beginner"; ExpectedCommand = "cat build/PKGBUILD"
            Description = @("W katalogu build/ znajduje sie plik PKGBUILD. Wyswietl go."); Hint = "Uzyj: cat build/PKGBUILD" }
        @{ Id = 3; Title = "Utworz katalog"; Difficulty = "beginner"; ExpectedCommand = "mkdir build/pkg"
            Description = @("W katalogu build utworz podkatalog 'pkg'."); Hint = "Uzyj: mkdir build/pkg" }
        @{ Id = 4; Title = "Sprawdz pacman.conf"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/pacman_conf"
            Description = @("Wyswietl konfiguracje menedzera pakietow pacman."); Hint = "Uzyj: cat /etc/pacman_conf" }
        @{ Id = 5; Title = "Sprawdz locale"; Difficulty = "beginner"; ExpectedCommand = "cat /etc/locale_gen"
            Description = @("Wyswietl dostepne locale w systemie."); Hint = "Uzyj: cat /etc/locale_gen" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Historia pacmana"; Difficulty = "intermediate"; ExpectedCommand = "grep 'upgraded' /var/log/pacman_log"
            Description = @("Znajdz w logu pacmana wszystkie aktualizacje."); Hint = "Uzyj: grep 'upgraded' /var/log/pacman_log" }
        @{ Id = 7; Title = "Kopiuj PKGBUILD"; Difficulty = "intermediate"; ExpectedCommand = "cp build/PKGBUILD ~/PKGBUILD.backup"
            Description = @("Wykonaj kopie zapasowa pliku PKGBUILD."); Hint = "Uzyj: cp build/PKGBUILD ~/PKGBUILD.backup" }
        @{ Id = 8; Title = "Usun tymczasowy"; Difficulty = "intermediate"; ExpectedCommand = "rm ~/PKGBUILD.backup"
            Description = @("Usun plik PKGBUILD.backup z katalogu domowego."); Hint = "Uzyj: rm ~/PKGBUILD.backup" }
        @{ Id = 9; Title = "Sprawdz dysk"; Difficulty = "intermediate"; ExpectedCommand = "df"
            Description = @("Sprawdz uzycie dyskow w systemie."); Hint = "Uzyj: df" }
        @{ Id = 10; Title = "Kto jestem"; Difficulty = "intermediate"; ExpectedCommand = "id"
            Description = @("Sprawdz swoj identyfikator uzytkownika (UID)."); Hint = "Uzyj: id" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Logi pacmana"; Difficulty = "advanced"; ExpectedCommand = "head -3 /var/log/pacman_log"
            Description = @("Wyswietl pierwsze 3 linie logu pacmana."); Hint = "Uzyj: head -3 /var/log/pacman_log" }
        @{ Id = 12; Title = "Znajdz pliki konfiguracyjne"; Difficulty = "advanced"; ExpectedCommand = "find /etc -name '*conf*'"
            Description = @("Znajdz wszystkie pliki z 'conf' w nazwie w /etc."); Hint = "Uzyj: find /etc -name '*conf*'" }
        @{ Id = 13; Title = "Zapisz logi"; Difficulty = "advanced"; ExpectedCommand = "cat /var/log/pacman_log > ~/pacman_history.txt"
            Description = @("Zapisz log pacmana do pliku w katalogu domowym."); Hint = "Uzyj: cat /var/log/pacman_log > ~/pacman_history.txt" }
        @{ Id = 14; Title = "Statystyki katalogu"; Difficulty = "advanced"; ExpectedCommand = "du -sh /var/log"
            Description = @("Sprawdz rozmiar katalogu /var/log."); Hint = "Uzyj: du -sh /var/log" }
        @{ Id = 15; Title = "Wyswietl procesy"; Difficulty = "advanced"; ExpectedCommand = "ps aux | grep systemd"
            Description = @("Znajdz procesy systemd uzywajac ps i grep."); Hint = "Uzyj: ps aux | grep systemd" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Liczenie logow"; Difficulty = "expert"; ExpectedCommand = "wc -l /var/log/pacman_log"
            Description = @("Policz, ile linii ma log pacmana."); Hint = "Uzyj: wc -l /var/log/pacman_log" }
        @{ Id = 17; Title = "Unikalne pakiety"; Difficulty = "expert"; ExpectedCommand = "grep -o 'firefox\|linux\|systemd' /var/log/pacman_log | sort | uniq"
            Description = @("Uzyj grep, sort i uniq aby znalezc unikalne pakiety w logu."); Hint = "To zlozone zadanie. Sprobuj: grep -o 'firefox\|linux\|systemd' /var/log/pacman_log | sort | uniq" }
        @{ Id = 18; Title = "Ktore polecenie"; Difficulty = "expert"; ExpectedCommand = "which pacman"
            Description = @("Sprawdz, gdzie w systemie znajduje sie pacman."); Hint = "Uzyj: which pacman" }
        @{ Id = 19; Title = "Info o uzytkowniku"; Difficulty = "expert"; ExpectedCommand = "whoami"
            Description = @("Sprawdz, jako kto jestes zalogowany."); Hint = "Uzyj: whoami" }
        @{ Id = 20; Title = "Sprawdz kernela"; Difficulty = "expert"; ExpectedCommand = "uname -m"
            Description = @("Sprawdz architekture procesora (uname -m)."); Hint = "Uzyj: uname -m" }
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
