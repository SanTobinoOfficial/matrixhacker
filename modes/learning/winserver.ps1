function Get-LearningContent-winserver {
    param([string]$Difficulty = "beginner")

    $fs = @{
        C = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
            Users = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                Admin = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                    Desktop = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                        admin_readme_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                            "Windows Server 2022 Standard - Domain Controller",
                            "Hostname: SRV-DC01",
                            "Domain: corp.internal",
                            "Roles: AD DS, DNS, DHCP, File Server",
                            "Zarzadzanie: Server Manager, PowerShell, RSAT"
                        )}
                        server_notes_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                            "Zadania administracyjne:",
                            "1. Sprawdz stan replikacji AD",
                            "2. Przejrzyj logi DNS",
                            "3. Wykonaj backup AD",
                            "4. Sprawdz dzierzawe DHCP",
                            "5. Zaktualizuj GPO"
                        )}
                        scripts = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                            deploy_dc_ps1 = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                                '# DC Deployment Script',
                                'Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools',
                                'Install-WindowsFeature -Name DNS -IncludeManagementTools',
                                'Install-WindowsFeature -Name DHCP -IncludeManagementTools',
                                'Install-ADDSForest -DomainName "corp.internal" -DomainNetbiosName "CORP"',
                                'Write-Host "Domain Controller deployment completed."'
                            )}
                            backup_ad_ps1 = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                                '# AD Backup Script',
                                '$backupPath = "C:\Backups\AD_Full_" + (Get-Date -Format "yyyyMMdd")',
                                "ntdsutil.exe 'activate instance ntds' 'ifm' 'create full $backupPath' q q",
                                'Write-Host "AD backup saved to $backupPath"'
                            )}
                        }}
                    }}
                    Documents = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                        domain_config_xml = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                            '<?xml version="1.0"?>',
                            '<domainConfiguration>',
                            '  <domain>corp.internal</domain>',
                            '  <netbios>CORP</netbios>',
                            '  <functionalLevel>2016</functionalLevel>',
                            '  <fsmoRoles>',
                            '    <role name="SchemaMaster">SRV-DC01</role>',
                            '    <role name="DomainNamingMaster">SRV-DC01</role>',
                            '    <role name="PDC">SRV-DC01</role>',
                            '    <role name="RIDMaster">SRV-DC01</role>',
                            '    <role name="InfrastructureMaster">SRV-DC01</role>',
                            '  </fsmoRoles>',
                            '</domainConfiguration>'
                        )}
                        DHCP_backup = @{ Type = "dir"; Owner = "SRV-DC01\Admin"; Group = "None"; Children = @{
                            dhcp_backup_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                                "DHCP Backup - 2026-06-08",
                                "Scope: 10.0.0.100 - 10.0.0.200",
                                "Subnet Mask: 255.255.255.0",
                                "Default Gateway: 10.0.0.1",
                                "DNS Servers: 10.0.0.10, 10.0.0.11",
                                "Domain: corp.internal",
                                "Leases: 24 active, 3 expired"
                            )}
                        }}
                    }}
                }}
            }}
            Windows = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                System32 = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    drivers = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        etc = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                            hosts = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                "# Copyright (c) 1993-2006 Microsoft Corp.",
                                "# Windows Server 2022 - Domain Controller Hosts File",
                                "127.0.0.1       localhost",
                                "::1             localhost",
                                "10.0.0.10       SRV-DC01.corp.internal SRV-DC01",
                                "10.0.0.11       SRV-DC02.corp.internal SRV-DC02",
                                "10.0.0.20       SRV-EXCHANGE.corp.internal SRV-EXCHANGE",
                                "10.0.0.21       SRV-FILE.corp.internal SRV-FILE",
                                "10.0.0.22       SRV-SQL.corp.internal SRV-SQL",
                                "10.0.0.50       SRV-WEB.corp.internal SRV-WEB",
                                "192.168.1.1     corp-gw.corp.internal corp-gw"
                            )}
                        }}
                    }}
                    config = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        sam_save = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                            "[SAM backup - placeholder]"
                        )}
                    }}
                    LogFiles = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        dns_log = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                            "06/08/2026 08:00:01 1234 PACKET  UDP 10.0.0.10  Query  A  dc.corp.internal",
                            "06/08/2026 08:00:02 1234 PACKET  UDP 10.0.0.10  Response  A  10.0.0.10",
                            "06/08/2026 08:05:00 1235 PACKET  UDP 10.0.0.50  Query  A  mail.corp.internal",
                            "06/08/2026 08:05:01 1235 PACKET  UDP 10.0.0.50  Response  A  10.0.0.20",
                            "06/08/2026 08:10:00 1236 PACKET  UDP 192.168.1.100  Query  A  external.com"
                        )}
                    }}
                }}
                NTDS = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    ntds_dit = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                        "[NTDS Database - Active Directory data store - placeholder]"
                    )}
                    edb_log = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                        "[Transaction log for NTDS - placeholder]"
                    )}
                }}
                SYSVOL = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                    domain = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                        scripts = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                            logon_bat = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                '@echo off',
                                'REM Domain logon script - executed at user login',
                                'net time \\SRV-DC01 /set /y',
                                'net use Z: \\SRV-FILE\shared',
                                'echo Network drives mapped successfully.'
                            )}
                            map_drives_ps1 = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                '# Map network drives via PowerShell',
                                'New-PSDrive -Name Z -PSProvider FileSystem -Root "\\SRV-FILE\shared" -Persist',
                                'New-PSDrive -Name X -PSProvider FileSystem -Root "\\SRV-FILE\home\$env:USERNAME" -Persist'
                            )}
                        }}
                        policies = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                            Default_Domain_Policy = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                                gpt_ini = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                    "[General]",
                                    "displayName=Default Domain Policy",
                                    "version=2",
                                    "status=enabled"
                                )}
                            }}
                            Default_Domain_Controller_Policy = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                                gpt_ini = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                                    "[General]",
                                    "displayName=Default Domain Controllers Policy",
                                    "version=1",
                                    "status=enabled"
                                )}
                            }}
                        }}
                    }}
                }}
            }}
            ProgramData = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                logs = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    dcdiag_log_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                        "DC Diagnosis Log - 2026-06-08",
                        "Starting test: Connectivity",
                        "  SRV-DC01: Passed connectivity test",
                        "  SRV-DC02: Passed connectivity test",
                        "Starting test: Replications",
                        "  Replication SRV-DC01 to SRV-DC02: Success",
                        "  Replication SRV-DC02 to SRV-DC01: Success",
                        "Starting test: NetLogons",
                        "  SRV-DC01: Passed NetLogons test",
                        "  SRV-DC02: Passed NetLogons test",
                        "Starting test: Services",
                        "  NTDS: Running",
                        "  DNS: Running",
                        "  KDC: Running",
                        "  NetLogon: Running",
                        "Starting test: FSMO checks",
                        "  SchemaMaster: SRV-DC01 (OK)",
                        "  DomainNamingMaster: SRV-DC01 (OK)",
                        "  PDC: SRV-DC01 (OK)",
                        "  RIDMaster: SRV-DC01 (OK)",
                        "  InfrastructureMaster: SRV-DC01 (OK)",
                        "All tests passed."
                    )}
                    dhcp_log_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                        "DHCP Server Activity Log - 2026-06-08",
                        "08:00:01 DHCP Discover from 00-1A-2B-3C-4D-5E",
                        "08:00:01 DHCP Offer to 00-1A-2B-3C-4D-5E (10.0.0.101)",
                        "08:00:02 DHCP Request from 00-1A-2B-3C-4D-5E",
                        "08:00:02 DHCP Ack to 00-1A-2B-3C-4D-5E (10.0.0.101)",
                        "08:15:00 DHCP Renew from 00-1A-2B-3C-4D-5E (10.0.0.101)",
                        "08:15:00 DHCP Ack to 00-1A-2B-3C-4D-5E (10.0.0.101)",
                        "08:30:00 DHCP Discover from AA-BB-CC-DD-EE-FF",
                        "08:30:01 DHCP Offer to AA-BB-CC-DD-EE-FF (10.0.0.102)",
                        "08:30:02 DHCP Decline - address conflict detected",
                        "08:30:03 DHCP Discover from AA-BB-CC-DD-EE-FF",
                        "08:30:04 DHCP Offer to AA-BB-CC-DD-EE-FF (10.0.0.103)",
                        "08:30:05 DHCP Request from AA-BB-CC-DD-EE-FF",
                        "08:30:05 DHCP Ack to AA-BB-CC-DD-EE-FF (10.0.0.103)",
                        "09:00:00 DHCP Release from 00-1A-2B-3C-4D-5E (10.0.0.101)"
                    )}
                }}
                Microsoft = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    Windows = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{}}
                }}
            }}
            DNS = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                corp_internal_dns = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                    "; DNS zone file for corp.internal",
                    "@ IN SOA SRV-DC01.corp.internal. admin.corp.internal. (",
                    "    2026060801 ; serial",
                    "    3600       ; refresh",
                    "    600        ; retry",
                    "    86400      ; expire",
                    "    3600       ; minimum TTL",
                    ")",
                    "@ IN NS SRV-DC01.corp.internal.",
                    "@ IN NS SRV-DC02.corp.internal.",
                    "@ IN A 10.0.0.10",
                    "SRV-DC01 IN A 10.0.0.10",
                    "SRV-DC02 IN A 10.0.0.11",
                    "SRV-EXCHANGE IN A 10.0.0.20",
                    "SRV-FILE IN A 10.0.0.21",
                    "SRV-SQL IN A 10.0.0.22",
                    "SRV-WEB IN A 10.0.0.50",
                    "_ldap._tcp IN SRV 0 100 389 SRV-DC01.corp.internal.",
                    "_ldap._tcp IN SRV 0 100 389 SRV-DC02.corp.internal.",
                    "_kerberos._tcp IN SRV 0 100 88 SRV-DC01.corp.internal.",
                    "_ldap._tcp.dc._msdcs IN SRV 0 100 389 SRV-DC01.corp.internal."
                )}
                reverse_10_0_0_dns = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                    "; Reverse lookup zone for 10.0.0.x",
                    "@ IN SOA SRV-DC01.corp.internal. admin.corp.internal. (",
                    "    2026060801 ; serial",
                    "    3600       ; refresh",
                    "    600        ; retry",
                    "    86400      ; expire",
                    "    3600       ; minimum TTL",
                    ")",
                    "@ IN NS SRV-DC01.corp.internal.",
                    "10 IN PTR SRV-DC01.corp.internal.",
                    "11 IN PTR SRV-DC02.corp.internal.",
                    "20 IN PTR SRV-EXCHANGE.corp.internal.",
                    "21 IN PTR SRV-FILE.corp.internal.",
                    "22 IN PTR SRV-SQL.corp.internal.",
                    "50 IN PTR SRV-WEB.corp.internal."
                )}
            }}
            DHCP = @{ Type = "dir"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Children = @{
                dhcp_mdb = @{ Type = "file"; Owner = "NT AUTHORITY\SYSTEM"; Group = "SYSTEM"; Content = @(
                    "[DHCP Database - placeholder]"
                )}
            }}
            Temp = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                updates_txt = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                    "Pending updates: KB5048652, KB5048653, KB5048654"
                )}
                patch_log = @{ Type = "file"; Owner = "SRV-DC01\Admin"; Group = "None"; Content = @(
                    "2026-06-07 22:00:00 Installer: KB5048652 installed successfully",
                    "2026-06-07 22:15:00 Installer: KB5048653 - reboot required"
                )}
            }}
            inetpub = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                wwwroot = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    index_html = @{ Type = "file"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Content = @(
                        '<!DOCTYPE html>',
                        '<html>',
                        '<head><title>IIS Default - corp.internal</title></head>',
                        '<body>',
                        '<h1>Windows Server 2022 - IIS</h1>',
                        '<p>Default website for corp.internal intranet.</p>',
                        '<p>Contact IT: it@corp.internal</p>',
                        '</body>',
                        '</html>'
                    )}
                }}
            }}
            Backups = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                AD_Full_20260608 = @{ Type = "dir"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Children = @{
                    ntds_dit = @{ Type = "file"; Owner = "BUILTIN\Administrators"; Group = "SYSTEM"; Content = @(
                        "[AD Backup - NTDS.dit snapshot - placeholder]"
                    )}
                }}
            }}
        }}
    }

    $beginnerTasks = @(
        @{ Id = 1; Title = "Sprawdz pliki Admina"; Difficulty = "beginner"; ExpectedCommand = "Get-ChildItem Users/Admin/Desktop"
            Description = @("W katalogu Desktop Admina sprawdz, jakie sa pliki."); Hint = "Uzyj: Get-ChildItem Users/Admin/Desktop lub ls Users/Admin/Desktop" }
        @{ Id = 2; Title = "Przeczytaj informacje o serwerze"; Difficulty = "beginner"; ExpectedCommand = "Get-Content Users/Admin/Desktop/admin_readme_txt"
            Description = @("Wyswietl plik z informacjami o kontrolerze domeny."); Hint = "Uzyj: Get-Content Users/Admin/Desktop/admin_readme_txt" }
        @{ Id = 3; Title = "Wyswietl skrypt deploy"; Difficulty = "beginner"; ExpectedCommand = "Get-Content Users/Admin/Desktop/scripts/deploy_dc_ps1"
            Description = @("Wyswietl skrypt wdrozeniowy DC."); Hint = "Uzyj: Get-Content Users/Admin/Desktop/scripts/deploy_dc_ps1" }
        @{ Id = 4; Title = "Utworz katalog DNS"; Difficulty = "beginner"; ExpectedCommand = "New-Item -ItemType Directory -Path DNS/zones"
            Description = @("Utworz katalog DNS/zones (mkdir lub New-Item)."); Hint = "Uzyj: mkdir DNS/zones lub New-Item -ItemType Directory -Path DNS/zones" }
        @{ Id = 5; Title = "Sprawdz biezacy katalog"; Difficulty = "beginner"; ExpectedCommand = "Get-Location"
            Description = @("Sprawdz biezacy katalog (pwd lub Get-Location)."); Hint = "Uzyj: Get-Location lub pwd" }
    )

    $intermediateTasks = @(
        @{ Id = 6; Title = "Przegladaj logi DC"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content ProgramData/logs/dcdiag_log_txt"
            Description = @("Wyswietl log diagnozy kontrolera domeny."); Hint = "Uzyj: Get-Content ProgramData/logs/dcdiag_log_txt" }
        @{ Id = 7; Title = "Znajdz bledy DHCP"; Difficulty = "intermediate"; ExpectedCommand = "Select-String -Path ProgramData/logs/dhcp_log_txt -Pattern Decline"
            Description = @("W logach DHCP znajdz zdarzenia Decline."); Hint = "Uzyj: Select-String -Path ProgramData/logs/dhcp_log_txt -Pattern Decline" }
        @{ Id = 8; Title = "Kopiuj backup DHCP"; Difficulty = "intermediate"; ExpectedCommand = "Copy-Item Users/Admin/Documents/DHCP_backup/dhcp_backup_txt Users/Admin/Desktop/dhcp_config_backup.txt"
            Description = @("Skopiuj plik backupu DHCP na Desktop Admina."); Hint = "Uzyj: Copy-Item ... lub cp ..." }
        @{ Id = 9; Title = "Sprawdz hosts DC"; Difficulty = "intermediate"; ExpectedCommand = "Get-Content Windows/System32/drivers/etc/hosts"
            Description = @("Wyswietl plik hosts z wpisami domenowymi."); Hint = "Uzyj: Get-Content Windows/System32/drivers/etc/hosts" }
        @{ Id = 10; Title = "Usun plik aktualizacji"; Difficulty = "intermediate"; ExpectedCommand = "Remove-Item Temp/updates_txt"
            Description = @("Usun plik z lista oczekujacych aktualizacji."); Hint = "Uzyj: Remove-Item Temp/updates_txt" }
    )

    $advancedTasks = @(
        @{ Id = 11; Title = "Szukaj skryptow PS1"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem -Recurse -Filter *.ps1 Users"
            Description = @("Znajdz wszystkie pliki .ps1 w katalogu Users."); Hint = "Uzyj: Get-ChildItem -Recurse -Filter *.ps1 Users" }
        @{ Id = 12; Title = "Zapisz logi DNS"; Difficulty = "advanced"; ExpectedCommand = "Get-Content DNS/corp_internal_dns > Users/Admin/Desktop/dns_zone_export.txt"
            Description = @("Wyeksportuj strefe DNS na Desktop Admina."); Hint = "Uzyj: Get-Content DNS/corp_internal_dns > Users/Admin/Desktop/dns_zone_export.txt" }
        @{ Id = 13; Title = "Konfiguracja domeny"; Difficulty = "advanced"; ExpectedCommand = "Get-Content Users/Admin/Documents/domain_config_xml"
            Description = @("Wyswietl konfiguracje domeny XML."); Hint = "Uzyj: Get-Content Users/Admin/Documents/domain_config_xml" }
        @{ Id = 14; Title = "Data systemowa"; Difficulty = "advanced"; ExpectedCommand = "Get-Date"
            Description = @("Sprawdz biezaca date na serwerze."); Hint = "Uzyj: Get-Date" }
        @{ Id = 15; Title = "Sprawdz skrypty logowania"; Difficulty = "advanced"; ExpectedCommand = "Get-ChildItem Windows/SYSVOL/domain/scripts"
            Description = @("Wyswietl skrypty logowania domenowego w SYSVOL."); Hint = "Uzyj: Get-ChildItem Windows/SYSVOL/domain/scripts" }
    )

    $expertTasks = @(
        @{ Id = 16; Title = "Policz linie w logu DC"; Difficulty = "expert"; ExpectedCommand = "Get-Content ProgramData/logs/dcdiag_log_txt | Measure-Object -Line"
            Description = @("Policz linie w logu dcdiag (Measure-Object)."); Hint = "Uzyj: Get-Content ProgramData/logs/dcdiag_log_txt | Measure-Object -Line" }
        @{ Id = 17; Title = "Sprawdz wolne miejsce na dysku"; Difficulty = "expert"; ExpectedCommand = "Get-PSDrive C"
            Description = @("Sprawdz wolne miejsce na dysku C (Get-PSDrive)."); Hint = "Uzyj: Get-PSDrive C" }
        @{ Id = 18; Title = "Porownaj logi DHCP i DC"; Difficulty = "expert"; ExpectedCommand = "Compare-Object (Get-Content ProgramData/logs/dcdiag_log_txt) (Get-Content ProgramData/logs/dhcp_log_txt)"
            Description = @("Porownaj logi dcdiag i DHCP."); Hint = "Uzyj: Compare-Object (Get-Content ...) (Get-Content ...)" }
        @{ Id = 19; Title = "Znajdz zdarzenia we wszystkich logach"; Difficulty = "expert"; ExpectedCommand = "Select-String -Path ProgramData/logs/* -Pattern Success"
            Description = @("Wyszukaj 'Success' we wszystkich logach w ProgramData/logs."); Hint = "Uzyj: Select-String -Path ProgramData/logs/* -Pattern Success" }
        @{ Id = 20; Title = "Info o systemie serwera"; Difficulty = "expert"; ExpectedCommand = "Get-ComputerInfo"
            Description = @("Wyswietl pelna informacje o serwerze (Get-ComputerInfo)."); Hint = "Uzyj: Get-ComputerInfo" }
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
