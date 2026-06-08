function Get-LearningContent-cisco {
    param([string]$Difficulty = "beginner")

    $fs = @{
        flash = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
            ios_image_bin = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "Cisco IOS XE 17.9 image"
            )}
            startup_config = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "! Startup configuration",
                "version 17.9",
                "service timestamps debug datetime msec",
                "service timestamps log datetime msec",
                "hostname Router",
                "!",
                "interface GigabitEthernet0/0",
                " ip address 10.0.0.1 255.255.255.0",
                " no shutdown",
                "!",
                "interface GigabitEthernet0/1",
                " ip address 192.168.1.1 255.255.255.0",
                " no shutdown",
                "!",
                "router ospf 1",
                " network 10.0.0.0 0.0.0.255 area 0",
                "!",
                "line vty 0 4",
                " password cisco",
                " login",
                "!",
                "end"
            )}
            vlan_dat = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "VLAN Name                             Status    Ports",
                "1    default                          active    Gi0/0, Gi0/1",
                "10   MANAGEMENT                       active    Gi0/2",
                "20   USERS                            active    Gi0/3-Gi0/10",
                "30   SERVERS                          active    Gi0/11-Gi0/20"
            )}
            running_config = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                "Building configuration...",
                "Current configuration : 2345 bytes",
                "version 17.9", "hostname Router",
                "interface GigabitEthernet0/0", " ip address 10.0.0.1 255.255.255.0",
                "interface GigabitEthernet0/1", " ip address 192.168.1.1 255.255.255.0",
                "router ospf 1", " network 10.0.0.0 0.0.0.255 area 0",
                "end"
            )}
            logs = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{
                syslog = @{ Type = "file"; Owner = "root"; Group = "root"; Content = @(
                    "*Jun  8 08:00:00: %SYS-5-CONFIG_I: Configured from console by console",
                    "*Jun  8 08:05:00: %LINK-3-UPDOWN: Interface GigabitEthernet0/0, changed state to up",
                    "*Jun  8 08:05:01: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0, changed state to up",
                    "*Jun  8 08:10:00: %OSPF-5-ADJCHG: Process 1, Nbr 10.0.0.2 on GigabitEthernet0/0 from LOADING to FULL",
                    "*Jun  8 08:15:00: %SEC-6-IPACCESSLOGP: list ACL_IN allowed 10.0.0.50 -> 10.0.0.10"
                )}
            }}
            config_backup = @{ Type = "dir"; Owner = "root"; Group = "root"; Children = @{}}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Wyswietl konfiguracje"; Difficulty = "beginner"; ExpectedCommand = "cat flash/running_config"
            Description = @("Router Cisco IOS przechowuje konfiguracje na flash.", "Wyswietl plik running_config."); Hint = "Uzyj: cat flash/running_config" }
        @{ Id = 2; Title = "Sprawdz interfejsy"; Difficulty = "beginner"; ExpectedCommand = "cat flash/startup_config"
            Description = @("W pliku startup_config znajdz konfiguracje startowa.", "Wyswietl caly plik."); Hint = "Uzyj: cat flash/startup_config" }
        @{ Id = 3; Title = "Wyswietl VLANy"; Difficulty = "beginner"; ExpectedCommand = "cat flash/vlan_dat"
            Description = @("Wyswietl plik z konfiguracja VLANow (vlan.dat)."); Hint = "Uzyj: cat flash/vlan_dat" }
        @{ Id = 4; Title = "Przejdz do logow"; Difficulty = "beginner"; ExpectedCommand = "ls flash/logs/"
            Description = @("Sprawdz, jakie pliki sa w katalogu flash/logs/."); Hint = "Uzyj: ls flash/logs/" }
        @{ Id = 5; Title = "Sprawdz hostname"; Difficulty = "beginner"; ExpectedCommand = "hostname"
            Description = @("Sprawdz nazwe routera."); Hint = "Wpisz: hostname" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Przegladaj syslog"; Difficulty = "intermediate"; ExpectedCommand = "cat flash/logs/syslog"
            Description = @("Wyswietl logi systemowe routera."); Hint = "Uzyj: cat flash/logs/syslog" }
        @{ Id = 7; Title = "Znajdz OSPF"; Difficulty = "intermediate"; ExpectedCommand = "grep 'OSPF' flash/logs/syslog"
            Description = @("W logach syslog znajdz linie dotyczace protokolu OSPF."); Hint = "Uzyj: grep 'OSPF' flash/logs/syslog" }
        @{ Id = 8; Title = "Zrob backup konfiguracji"; Difficulty = "intermediate"; ExpectedCommand = "cp flash/running_config flash/config_backup/running_config_bak"
            Description = @("Skopiuj running_config do katalogu config_backup."); Hint = "Uzyj: cp flash/running_config flash/config_backup/running_config_bak" }
        @{ Id = 9; Title = "Sprawdz adresy IP"; Difficulty = "intermediate"; ExpectedCommand = "grep 'ip address' flash/startup_config"
            Description = @("Znajdz wszystkie adresy IP w konfiguracji startowej."); Hint = "Uzyj: grep 'ip address' flash/startup_config" }
        @{ Id = 10; Title = "Sprawdz wersje IOS"; Difficulty = "intermediate"; ExpectedCommand = "grep 'version' flash/startup_config"
            Description = @("Sprawdz, jaka wersja IOS jest uruchomiona."); Hint = "Uzyj: grep 'version' flash/startup_config" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Szukaj w konfiguracji"; Difficulty = "advanced"; ExpectedCommand = "grep -r 'Gigabit' flash/"
            Description = @("Znajdz wszystkie wzmianki o GigabitEthernet w katalogu flash."); Hint = "Uzyj: grep -r 'Gigabit' flash/" }
        @{ Id = 12; Title = "Logi interfejsow"; Difficulty = "advanced"; ExpectedCommand = "grep 'Interface' flash/logs/syslog"
            Description = @("Znajdz w syslogu zdarzenia zwiazane z interfejsami."); Hint = "Uzyj: grep 'Interface' flash/logs/syslog" }
        @{ Id = 13; Title = "Policz linie konfiguracji"; Difficulty = "advanced"; ExpectedCommand = "wc -l flash/running_config"
            Description = @("Policz, ile linii ma running_config."); Hint = "Uzyj: wc -l flash/running_config" }
        @{ Id = 14; Title = "Ostatnie logi"; Difficulty = "advanced"; ExpectedCommand = "tail -3 flash/logs/syslog"
            Description = @("Wyswietl ostatnie 3 wpisy sysloga."); Hint = "Uzyj: tail -3 flash/logs/syslog" }
        @{ Id = 15; Title = "Sprawdz date"; Difficulty = "advanced"; ExpectedCommand = "date"
            Description = @("Sprawdz date na routerze."); Hint = "Uzyj: date" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Polacz grep z sort"; Difficulty = "expert"; ExpectedCommand = "grep 'ip address' flash/startup_config | sort"
            Description = @("Znajdz linie z 'ip address' w konfiguracji i posortuj je."); Hint = "Uzyj: grep 'ip address' flash/startup_config | sort" }
        @{ Id = 17; Title = "Szukaj przez find"; Difficulty = "expert"; ExpectedCommand = "find flash -name '*config*'"
            Description = @("Znajdz wszystkie pliki z 'config' w nazwie na flash."); Hint = "Uzyj: find flash -name '*config*'" }
        @{ Id = 18; Title = "Zapisz konfig do backupu"; Difficulty = "expert"; ExpectedCommand = "cat flash/running_config > flash/config_backup/run_last.txt"
            Description = @("Zapisz running_config do pliku run_last.txt w backupie."); Hint = "Uzyj: cat flash/running_config > flash/config_backup/run_last.txt" }
        @{ Id = 19; Title = "Sprawdz wolne miejsce"; Difficulty = "expert"; ExpectedCommand = "df"
            Description = @("Sprawdz miejsce na dysku flash."); Hint = "Uzyj: df" }
        @{ Id = 20; Title = "Info o systemie"; Difficulty = "expert"; ExpectedCommand = "uname -a"
            Description = @("Wyswietl informacje o systemie IOS."); Hint = "Uzyj: uname -a" }
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
