# Ultra Matrix Terminal

**Lokalizacja:** `C:\Users\Tobiasz\Desktop\skrypty\ultra-matrix-terminal`
**Uruchomienie:** `.\launcher.ps1` (GUI na Windows, CLI na其它)

Interaktywny symulator terminala z 32 motywami, 17 systemami do nauki i 15 trybami rozrywkowymi "press-to-reveal".

---

## Architektura

```
ultra-matrix-terminal/
├── launcher.ps1            # Entry point: GUI (WinForms) lub CLI launcher
├── install.ps1             # Instalator (skróty, PATH)
├── CLAUDE.md               # Ten plik
│
├── engine/                 # Silnik
│   ├── core.ps1            # Matrix-Rain, Type-Command, Start-TerminalSession, Show-Output
│   ├── helpers.ps1         # Read-ConsoleKey, Rand, RandIP, Get-SystemNoise, Get-DynamicPrompt
│   ├── themes.ps1          # 32 motywy kolorystyczne (Get-Theme, Get-AllThemes, $script:Themes)
│   ├── learning_engine.ps1 # Virtual FS, rejestracja komend, system zadań, Start-LearningSession
│   ├── settings.ps1        # Persystencja ustawień (theme, lastMode, language)
│   └── platform.ps1        # Detekcja OS (Windows/Linux/macOS)
│
├── config/
│   └── settings.json       # Domyślne ustawienia
│
├── modes/                  # Tryby press-to-reveal (15 sztuk)
│   ├── realistic.ps1       # Realistyczna sesja Linux
│   ├── hollywood.ps1       # Hollywoodzki hacker
│   ├── cyberpunk.ps1       # Netrunner w Night City
│   ├── matrix.ps1          # Matrix - wake up Neo
│   ├── mrrobot.ps1         # Fsociety
│   ├── outage.ps1          # Produkcyjny awaria SEV-1
│   ├── tutorial.ps1        # Linux tutorial dla początkujących
│   ├── pentest.ps1         # Pentest report symulacja
│   ├── sysadmin.ps1        # SysAdmin symulator
│   ├── heist.ps1           # Data Heist
│   ├── horror.ps1          # Horror terminal
│   ├── polska.ps1          # Polski hacker
│   ├── darkweb.ps1         # Dark web nawigacja
│   ├── ctf_mode.ps1        # CTF Challenge
│   ├── screensaver.ps1     # Nieskończony Matrix rain
│   └── learning.ps1        # Tryb Nauki - selektor + Start-LearningMode
│
└── modes/learning/         # Scenariusze nauki (17 systemów, po 20 zadań)
    ├── ubuntu.ps1          # Ubuntu 24.04 LTS - apt, netplan, snap, systemd, nginx
    ├── debian.ps1          # Debian 12 - apt, ifupdown, postfix, GRUB
    ├── centos.ps1          # Rocky/CentOS 9 - dnf, SELinux, firewalld
    ├── arch.ps1            # Arch Linux - pacman, mkinitcpio, systemd-boot
    ├── kali.ps1            # Kali Linux - nmap, exploit-db, metasploit, wordlists
    ├── alpine.ps1          # Alpine Linux 3.20 - apk, OpenRC, busybox
    ├── opensuse.ps1        # openSUSE Tumbleweed - zypper, YaST, snapper
    ├── windows.ps1         # Windows 11 - PowerShell, NTFS, Event Log
    ├── winserver.ps1       # Windows Server 2022 - AD DS, DNS, DHCP, GPO, IIS
    ├── cisco.ps1           # Cisco IOS - startup-config, VLAN, OSPF, ACL
    ├── macos.ps1           # macOS Sequoia - brew, launchd, plist, Zsh
    ├── docker.ps1          # Docker Admin - containers, volumes, compose, swarm
    ├── cloud.ps1           # Cloud DevOps - kubectl, terraform, AWS, K8s
    ├── webdev.ps1          # Web Developer - React, Webpack, nginx, npm
    ├── sql.ps1             # SQL DBA - MySQL 8.0, PostgreSQL 16
    ├── iot.ps1             # IoT Hacker - OpenWrt, U-Boot, firmware
    └── ctf_mode.ps1        # CTF Challenge Lab - flags, reverse engineering
```

## Jak to działa

### Przepływ uruchomienia (launcher.ps1)
1. Ładuje wszystkie `engine/*.ps1` (core, helpers, themes, settings, platform, learning_engine)
2. Ładuje wszystkie `modes/*.ps1` (BEZ -Recurse - learning subdirectory ładowany przez learning.ps1)
3. Na Windows: pokazuje GUI (WinForms z przyciskami)
4. GUI przycisk zapisuje wybrany tryb do `$script:selectedMode` i zamyka formularz
5. Po zamknięciu GUI: `Start-Mode` uruchamia wybrany tryb w konsoli

### Tryby press-to-reveal
Każdy plik w `modes/*.ps1` (oprócz learning.ps1) definiuje `Build-XXXCOMMANDS` która zwraca tablicę komend. `Start-TerminalSession` w `core.ps1`:
1. Matrix-Rain intro (4s)
2. Briefing/connection header
3. Pętla: prompt → Invoke-PressToReveal (klawisz po klawiszu) → Show-Output
4. Po wyczerpaniu komend lub timeout: nieskończony Matrix-Rain

### Tryb Nauki (learning mode)
`learning.ps1` ładuje wszystkie `modes/learning/*.ps1` które definiują `Get-LearningContent-XXX`.
Przepływ:
1. Show-LearningSelector → wybór systemu
2. Show-DifficultySelector → wybór poziomu (beginner/intermediate/advanced/expert = 5 zadań każdy)
3. Start-LearningMode → `New-LearningFS` + `Start-LearningSession`
4. `Start-LearningSession` w `learning_engine.ps1`:
   - Matrix-Rain 3s → Clear-Host → Welcome → czeka na Enter
   - Pętla zadań: pokazuje opis → user wpisuje komendę → `Check-CommandMatches` → podpowiedź/skip/check/status
   - Virtual FS: `New-LearningFS` buduje płaską tablicę ścieżek z zagnieżdżonego hasha

### Learning Engine (learning_engine.ps1)
- **Virtual FS**: `$script:learningVfs` - hashtable path→{Type,Content,Perms,Owner,Group}
- **Komendy**: Register-LCommand rejestruje handler (ls, cd, cat, grep, find, apt, docker, kubectl, nmap, mysql, terraform, brew, hydra, sqlmap, itd.)
- **Zadania**: każdy system ma 20 zadań (5 per difficulty), każde z `Id, Title, Difficulty, ExpectedCommand, Description, Hint`
- **Sprawdzanie**: `Check-CommandMatches` porównuje wpisaną komendę z oczekiwaną (trim + lowercase)

### System ustawień (settings.ps1)
- `Get-Settings` → merguje domyślne z `config/settings.json` z userowskimi z `$env:LOCALAPPDATA/UltraMatrix/settings.json`
- `Set-Setting` → zapisuje pojedyńcze ustawienie
- `Reset-Settings` → kasuje userowskie, przywraca domyślne

## Znane problemy / uwagi

- **GUI + Read-Host**: Formularz WinForms musi być zamknięty przed użyciem Read-Host w konsoli (naprawione przez `$script:selectedMode` + `$form.Close()` w click handlerze)
- **Double-loading**: learning/*.ps1 ładowane tylko przez learning.ps1, NIE przez -Recurse w launcherze
- **Press-to-reveal auto-start**: Każdy tryb ma blok `if ($MyInvocation.InvocationName -ne '.')` - przy dot-source (z launcher.ps1) NIE startuje automatycznie
- **Wszystkie scenariusze**: Funkcja `Get-LearningContent-XXX` zwraca `@{ Filesystem = $fs; Tasks = $tasks }` gdzie Filesystem to zagnieżdżony hash drzewa katalogów, Tasks to tablica zadań

## Dodawanie nowego systemu learning

1. Stwórz `modes/learning/<id>.ps1` z funkcją `function Get-LearningContent-<id>`
2. Dodaj wpis do `$learningSystems` w `modes/learning.ps1`
3. Funkcja zwraca `@{ Filesystem = <hash>; Tasks = <array> }`
4. 20 zadań: 5 beginner, 5 intermediate, 5 advanced, 5 expert
5. Filesystem: zagnieżdżony hash z Type=dir/file, Owner, Group, Content (array stringów), Children (dla dir)
