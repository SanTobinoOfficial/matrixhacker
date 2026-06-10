function Get-LearningContent-cisco {
    $fs = @{
        'startup_config' = @{
            Type = 'file'
            Owner = 'root'
            Group = 'root'
            Content = @(
                '! Last configuration change at 08:00:00 UTC Mon Jun 8 2026 by admin',
                '! NVRAM config last updated at 08:00:00 UTC Mon Jun 8 2026',
                '!',
                'version 17.9',
                'service timestamps debug datetime msec localtime',
                'service timestamps log datetime msec localtime',
                'service password-encryption',
                'service tcp-keepalives-in',
                'service tcp-keepalives-out',
                'service pt-vty-logging',
                'hostname Router',
                'boot-start-marker',
                'boot system flash:c2960x-universalk9-mz.SPA.157-3.M3.bin',
                'boot-end-marker',
                '!',
                'enable secret 5 $1$abcdef$ABCDEF1234567890abcdef',
                'enable password 7 0822455D0A16',
                '!',
                'username admin privilege 15 secret 5 $1$ghijkl$GHIJKL1234567890ghijkl',
                'username operator privilege 1 password 7 1234567890ABCDEF',
                '!',
                'aaa new-model',
                'aaa authentication login default local',
                'aaa authorization exec default local',
                'aaa session-id common',
                '!',
                'ip domain-name lab.local',
                'ip name-server 8.8.8.8',
                'ip name-server 8.8.4.4',
                'ip ssh version 2',
                'ip scp server enable',
                '!',
                'interface GigabitEthernet0/0/0',
                ' description WAN Link to ISP',
                ' ip address 192.168.1.1 255.255.255.0',
                ' ip access-group ACL_IN in',
                ' ip access-group ACL_OUT out',
                ' duplex auto',
                ' speed auto',
                ' media-type rj45',
                ' no shutdown',
                '!',
                'interface GigabitEthernet0/0/1',
                ' description Internal LAN',
                ' ip address 10.0.0.1 255.255.255.0',
                ' ip helper-address 10.0.0.10',
                ' duplex auto',
                ' speed auto',
                ' media-type rj45',
                ' no shutdown',
                '!',
                'interface Loopback0',
                ' description OSPF Router-ID',
                ' ip address 1.1.1.1 255.255.255.255',
                '!',
                'interface Vlan1',
                ' description Management VLAN',
                ' ip address 10.0.0.254 255.255.255.0',
                ' no shutdown',
                '!',
                'router ospf 1',
                ' router-id 1.1.1.1',
                ' log-adjacency-changes',
                ' auto-cost reference-bandwidth 100000',
                ' network 10.0.0.0 0.0.0.255 area 0',
                ' network 192.168.1.0 0.0.0.255 area 0',
                ' network 1.1.1.1 0.0.0.0 area 0',
                ' default-information originate',
                '!',
                'ip route 0.0.0.0 0.0.0.0 192.168.1.254',
                'ip route 10.10.10.0 255.255.255.0 192.168.1.200',
                '!',
                'ip access-list extended ACL_IN',
                ' remark Allow established connections from inside',
                ' permit tcp any any established',
                ' remark Allow SSH from management subnet',
                ' permit tcp 10.0.0.0 0.0.0.255 any eq 22',
                ' remark Allow ICMP monitoring probes',
                ' permit icmp any any echo-reply',
                ' permit icmp any any time-exceeded',
                ' permit icmp any any unreachable',
                ' deny ip any any log',
                '!',
                'ip access-list extended ACL_OUT',
                ' remark Allow DNS queries',
                ' permit udp any any eq 53',
                ' remark Allow HTTP and HTTPS',
                ' permit tcp any any eq 80',
                ' permit tcp any any eq 443',
                ' remark Allow NTP sync',
                ' permit udp any any eq 123',
                ' deny ip any any log',
                '!',
                'line con 0',
                ' exec-timeout 15 0',
                ' logging synchronous',
                ' login local',
                '!',
                'line vty 0 4',
                ' exec-timeout 10 0',
                ' logging synchronous',
                ' login local',
                ' transport input ssh',
                '!',
                'snmp-server community public RO',
                'snmp-server community private RW',
                'snmp-server location DataCenter-Rack12-Aisle3',
                'snmp-server contact admin@lab.local',
                'snmp-server enable traps snmp authentication linkdown linkup',
                'snmp-server enable traps syslog',
                'snmp-server host 10.0.0.50 version 2c public',
                '!',
                'ntp server 192.168.1.254 prefer',
                'ntp server 1.pool.ntp.org',
                'ntp update-calendar',
                'clock timezone UTC 0',
                '!',
                'banner motd ^C',
                '**************************************************************************',
                '* WARNING: Unauthorized access to this device is prohibited.             *',
                '* This device is for authorized network operations personnel only.        *',
                '* All access is logged and monitored.                                     *',
                '* Disconnect immediately if you are not an authorized user.               *',
                '**************************************************************************',
                '^C',
                '!',
                'end'
            )
        }
        'running_config' = @{
            Type = 'file'
            Owner = 'root'
            Group = 'root'
            Content = @(
                'Building configuration...',
                '',
                'Current configuration : 4512 bytes',
                '!',
                '! Last configuration change at 08:15:00 UTC Mon Jun 8 2026 by admin',
                '! NVRAM config last updated at 08:00:00 UTC Mon Jun 8 2026',
                '!',
                'version 17.9',
                'service timestamps debug datetime msec localtime',
                'service timestamps log datetime msec localtime',
                'service password-encryption',
                'service tcp-keepalives-in',
                'service tcp-keepalives-out',
                'service pt-vty-logging',
                'hostname Router',
                'boot-start-marker',
                'boot system flash:c2960x-universalk9-mz.SPA.157-3.M3.bin',
                'boot-end-marker',
                '!',
                'enable secret 5 $1$abcdef$ABCDEF1234567890abcdef',
                'enable password 7 0822455D0A16',
                '!',
                'username admin privilege 15 secret 5 $1$ghijkl$GHIJKL1234567890ghijkl',
                'username operator privilege 1 password 7 1234567890ABCDEF',
                '!',
                'aaa new-model',
                'aaa authentication login default local',
                'aaa authorization exec default local',
                'aaa session-id common',
                '!',
                'ip domain-name lab.local',
                'ip name-server 8.8.8.8',
                'ip name-server 8.8.4.4',
                'ip ssh version 2',
                'ip scp server enable',
                '!',
                'interface GigabitEthernet0/0/0',
                ' description WAN Link to ISP',
                ' ip address 192.168.1.1 255.255.255.0',
                ' ip access-group ACL_IN in',
                ' ip access-group ACL_OUT out',
                ' duplex auto',
                ' speed auto',
                ' media-type rj45',
                ' no shutdown',
                '!',
                'interface GigabitEthernet0/0/1',
                ' description Internal LAN',
                ' ip address 10.0.0.1 255.255.255.0',
                ' ip helper-address 10.0.0.10',
                ' duplex auto',
                ' speed auto',
                ' media-type rj45',
                ' no shutdown',
                '!',
                'interface Loopback0',
                ' description OSPF Router-ID',
                ' ip address 1.1.1.1 255.255.255.255',
                '!',
                'interface Vlan1',
                ' description Management VLAN',
                ' ip address 10.0.0.254 255.255.255.0',
                ' no shutdown',
                '!',
                'router ospf 1',
                ' router-id 1.1.1.1',
                ' log-adjacency-changes',
                ' auto-cost reference-bandwidth 100000',
                ' network 10.0.0.0 0.0.0.255 area 0',
                ' network 192.168.1.0 0.0.0.255 area 0',
                ' network 1.1.1.1 0.0.0.0 area 0',
                ' default-information originate',
                '!',
                'ip route 0.0.0.0 0.0.0.0 192.168.1.254',
                'ip route 10.10.10.0 255.255.255.0 192.168.1.200',
                '!',
                'ip access-list extended ACL_IN',
                ' remark Allow established connections from inside',
                ' permit tcp any any established',
                ' remark Allow SSH from management subnet',
                ' permit tcp 10.0.0.0 0.0.0.255 any eq 22',
                ' remark Allow ICMP monitoring probes',
                ' permit icmp any any echo-reply',
                ' permit icmp any any time-exceeded',
                ' permit icmp any any unreachable',
                ' deny ip any any log',
                '!',
                'ip access-list extended ACL_OUT',
                ' remark Allow DNS queries',
                ' permit udp any any eq 53',
                ' remark Allow HTTP and HTTPS',
                ' permit tcp any any eq 80',
                ' permit tcp any any eq 443',
                ' remark Allow NTP sync',
                ' permit udp any any eq 123',
                ' deny ip any any log',
                '!',
                'line con 0',
                ' exec-timeout 15 0',
                ' logging synchronous',
                ' login local',
                '!',
                'line vty 0 4',
                ' exec-timeout 10 0',
                ' logging synchronous',
                ' login local',
                ' transport input ssh',
                '!',
                'snmp-server community public RO',
                'snmp-server community private RW',
                'snmp-server location DataCenter-Rack12-Aisle3',
                'snmp-server contact admin@lab.local',
                'snmp-server enable traps snmp authentication linkdown linkup',
                'snmp-server enable traps syslog',
                'snmp-server host 10.0.0.50 version 2c public',
                '!',
                'ntp server 192.168.1.254 prefer',
                'ntp server 1.pool.ntp.org',
                'ntp update-calendar',
                'clock timezone UTC 0',
                '!',
                'banner motd ^C',
                '**************************************************************************',
                '* WARNING: Unauthorized access to this device is prohibited.             *',
                '* This device is for authorized network operations personnel only.        *',
                '* All access is logged and monitored.                                     *',
                '* Disconnect immediately if you are not an authorized user.               *',
                '**************************************************************************',
                '^C',
                '!',
                'end'
            )
        }
        'version_info' = @{
            Type = 'file'
            Owner = 'root'
            Group = 'root'
            Content = @(
                'Cisco IOS XE Software, Version 17.9.1',
                'Cisco IOS Software [Cupertino], Catalyst L3 Switch Software (c2960x-universalk9-mz), Version 17.9.1, RELEASE SOFTWARE',
                'Copyright (c) 1986-2026 by Cisco Systems, Inc.',
                'Compiled Tue 03-Feb-26 10:22 by prod_rel_team',
                '',
                'ROM: IOS-XE ROM',
                'BOOTLDR: System Bootstrap, Version 17.9.1',
                '',
                'Router uptime is 2 weeks, 3 days, 14 hours, 22 minutes',
                'System returned to ROM by reload at 08:00:00 UTC Mon Jun 8 2026',
                'System image file is "flash:c2960x-universalk9-mz.SPA.157-3.M3.bin"',
                '',
                'This is a Cisco Catalyst 2960-X with 4194304K/8192K bytes of memory.',
                '',
                'Processor board ID FOC1234X5Z6',
                'CPU: Gigabit Ethernet Controller, Version 2.0',
                '2 Gigabit Ethernet interfaces',
                '1 Virtual Ethernet interface',
                '512K bytes of non-volatile configuration memory.',
                '4194304K bytes of USB flash (USB0).',
                '',
                'License Level: LAN Base',
                'License Type: Permanent',
                'Next reload license level: LAN Base'
            )
        }
        'null' = @{
            Type = 'file'
            Owner = 'root'
            Group = 'root'
            Content = @(
                '# Cisco IOS null device (simulated /dev/null)',
                '# Write operations are discarded silently.'
            )
        }
        'flash' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'c2960x-universalk9-mz_SPA_157-3_M3_bin' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# Cisco IOS XE image file',
                        '# File: c2960x-universalk9-mz.SPA.157-3.M3.bin',
                        '# Version: 17.9.1',
                        '# Platform: Catalyst 2960-X',
                        '# Size: 45.8 MB (48005120 bytes)',
                        '# Checksum: 0xA3F8E21B',
                        '# Signed by: Cisco Systems Production CA'
                    )
                }
                'vlan_dat' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'VLAN Name                             Status    Ports',
                        '---- -------------------------------- --------- -------------------------------',
                        '1    default                          active    Gi0/0/0, Gi0/0/1',
                        '10   MANAGEMENT                       active    Gi0/1/0, Gi0/1/1, Gi0/1/2',
                        '20   USERS                            active    Gi0/1/3-Gi0/1/12',
                        '30   SERVERS                          active    Gi0/1/13-Gi0/1/20',
                        '40   VOICE                            active    Gi0/1/21-Gi0/1/24',
                        '100  NATIVE                           active    Gi0/0/0',
                        '',
                        '# VLAN database last saved: Jun 8 2026 08:00:00 UTC'
                    )
                }
                'config_text' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '! Cisco IOS configuration backup',
                        '! Saved by admin on Jun 8 2026 08:00:00 UTC',
                        '! Source: running-config',
                        'version 17.9',
                        'hostname Router',
                        '!',
                        'interface GigabitEthernet0/0/0',
                        ' ip address 192.168.1.1 255.255.255.0',
                        ' no shutdown',
                        '!',
                        'interface GigabitEthernet0/0/1',
                        ' ip address 10.0.0.1 255.255.255.0',
                        ' no shutdown',
                        '!',
                        'end'
                    )
                }
                'sdmprefs' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'sdm prefer lanbase-routing',
                        '! SDM template: lanbase-routing',
                        '! Current SDM template allows for:',
                        '!   VLANs: 1024',
                        '!   Unicast MAC addresses: 8192',
                        '!   IPv4 routes: 4096',
                        '!   IPv4 ACLs: 512',
                        '!   IPv4 QoS ACEs: 512'
                    )
                }
                'c2520' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'config_text' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '! Backup configuration for Cisco 2520 router (remote office)',
                                '! Last change: Jun 7 2026',
                                'version 15.7',
                                'service timestamps log datetime msec',
                                'hostname Branch-Router',
                                '!',
                                'interface Serial0/0/0',
                                ' description WAN link to HQ',
                                ' ip address 10.255.255.2 255.255.255.252',
                                ' encapsulation ppp',
                                ' no shutdown',
                                '!',
                                'interface FastEthernet0/0',
                                ' description Local LAN',
                                ' ip address 192.168.10.1 255.255.255.0',
                                ' no shutdown',
                                '!',
                                'ip route 0.0.0.0 0.0.0.0 10.255.255.1',
                                '!',
                                'end'
                            )
                        }
                    }
                }
                'crypto' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'ca_cert' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '-----BEGIN CERTIFICATE-----',
                                'MIIBqzCCARMCAQEwDQYJKoZIhvcNAQELBQAwADQeFw0yNjA2MDgwODAwMDBa',
                                'Fw0yNzA2MDgwODAwMDBaMAAwXDANBgkqhkiG9w0BAQEFAANLADBIAkEA5vFk',
                                '0gCJc0zRkR5oDhM1ALQJpLBXt3P5RZRArfG5WXZ+TpPJ6fE7PVDM3xKNo5Y',
                                'zLnLJ6vXGgHoN4q4IjQx7HDQIDAQABo0UwQzAMBgNVHRMEBTADAQH/MAsGA1Ud',
                                'DwQEAwICpDAfBgNVHSMEGDAWgBTQx7HDQIDAQABo0UwQzAMBgNVHRMBAf8EBDM2',
                                'WXZ+MA0GCSqGSIb3DQEBCwUAA0EA4m5kQh3aLsdf8HjK2k8L9X7qV0pA6zF4',
                                'sXG/YJmD1QCO',
                                '-----END CERTIFICATE-----'
                            )
                        }
                        'server_key' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# Cisco IOS RSA server key (encrypted)',
                                '# Key size: 2048 bits',
                                '# Generated: Jun 8 2026 08:00:00 UTC',
                                '# Type: RSA encrypted private key',
                                '-----BEGIN ENCRYPTED PRIVATE KEY-----',
                                'MIIBpjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYmxhYmxhYgIB',
                                'ggAAMBAGCyqGSIb3DQEJEAEEIBAcBAAEHgQwZIaR5vFk0gCJc0zRkR5oDhM1',
                                'ALQJpLBXt3P5RZRArfG5WXZ+TpPJ6fE7PVDM3xKNo5YzLnLJ6vXGgHoN4q4',
                                '-----END ENCRYPTED PRIVATE KEY-----'
                            )
                        }
                        'trustpoint_p12' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# PKCS12 Trustpoint Keystore',
                                '# Crypto trustpoint: TP-SELF-SIGNED',
                                '# Subject: CN=Router.lab.local',
                                '# Serial: 0xABCDEF1234567890',
                                '# Created: Jun 8 08:00:00 2026 UTC',
                                '# Expires: Jun 8 2027 08:00:00 UTC',
                                '# Status: active',
                                '** PKCS12 binary keystore - not human readable **'
                            )
                        }
                    }
                }
            }
        }
        'tmp' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{}
        }
    }

    $tasks = @(
        @{
            Id = 'cisco-b1'
            Title = 'List files in flash directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls flash/'
            Description = @(
                'List all files and directories in the flash filesystem.',
                'Cisco IOS uses flash for storing the IOS image, configs, and VLAN data.'
            )
            Hint = 'Use: ls flash/'
        }
        @{
            Id = 'cisco-b2'
            Title = 'View startup configuration'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat startup_config'
            Description = @(
                'Display the startup configuration file.',
                'This configuration is loaded when the router boots.'
            )
            Hint = 'Use: cat startup_config'
        }
        @{
            Id = 'cisco-b3'
            Title = 'View running configuration'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat running_config'
            Description = @(
                'Display the running configuration.',
                'This is the currently active configuration in memory.'
            )
            Hint = 'Use: cat running_config'
        }
        @{
            Id = 'cisco-b4'
            Title = 'Check IOS version'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat version_info'
            Description = @(
                'Display the IOS XE version information.',
                'This simulates the show version command output.'
            )
            Hint = 'Use: cat version_info'
        }
        @{
            Id = 'cisco-b5'
            Title = 'Find the router hostname'
            Difficulty = 'beginner'
            ExpectedCommand = 'grep hostname startup_config'
            Description = @(
                'Search for the hostname in the startup configuration.',
                'The hostname identifies this device on the network.'
            )
            Hint = 'Use: grep hostname startup_config'
        }
        @{
            Id = 'cisco-i1'
            Title = 'Find all interface configurations'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep "interface" running_config'
            Description = @(
                'Search the running configuration for all interface declarations.',
                'This shows every configured interface on the router.'
            )
            Hint = 'Use: grep "interface" running_config'
        }
        @{
            Id = 'cisco-i2'
            Title = 'View ACL rules'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep "access-list" startup_config'
            Description = @(
                'Extract all access-list entries from the startup config.',
                'ACLs control traffic entering and leaving the router.'
            )
            Hint = 'Use: grep "access-list" startup_config'
        }
        @{
            Id = 'cisco-i3'
            Title = 'Check OSPF configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep "ospf" running_config'
            Description = @(
                'Search for OSPF routing protocol configuration.',
                'OSPF is a link-state routing protocol used for internal routing.'
            )
            Hint = 'Use: grep "ospf" running_config'
        }
        @{
            Id = 'cisco-i4'
            Title = 'Find the IOS image file'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ls flash/'
            Description = @(
                'List flash contents to identify the IOS image file.',
                'The .bin file contains the Cisco IOS XE operating system.'
            )
            Hint = 'Use: ls flash/'
        }
        @{
            Id = 'cisco-i5'
            Title = 'View VLAN database'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat flash/vlan_dat'
            Description = @(
                'Display the VLAN database contents.',
                'This file stores VLAN definitions on the switch.'
            )
            Hint = 'Use: cat flash/vlan_dat'
        }
        @{
            Id = 'cisco-a1'
            Title = 'Find all configuration files on flash'
            Difficulty = 'advanced'
            ExpectedCommand = 'find flash -name "*config*"'
            Description = @(
                'Locate all files containing "config" in their name across flash.',
                'This helps identify backup and configuration files.'
            )
            Hint = 'Use: find flash -name "*config*"'
        }
        @{
            Id = 'cisco-a2'
            Title = 'Examine static route configuration'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep "ip route" startup_config'
            Description = @(
                'Find all static route statements in the startup config.',
                'Static routes define fixed paths to destination networks.'
            )
            Hint = 'Use: grep "ip route" startup_config'
        }
        @{
            Id = 'cisco-a3'
            Title = 'Verify enable secret hash'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep "enable secret" startup_config'
            Description = @(
                'Extract the enable secret line to verify the authentication hash.',
                'The enable secret is encrypted with Type 5 MD5 hashing.'
            )
            Hint = 'Use: grep "enable secret" startup_config'
        }
        @{
            Id = 'cisco-a4'
            Title = 'Display the MOTD banner'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep -A 8 "banner motd" running_config'
            Description = @(
                'Show the message-of-the-day banner with context lines.',
                'The MOTD banner displays a warning message on login.'
            )
            Hint = 'Use: grep -A 8 "banner motd" running_config'
        }
        @{
            Id = 'cisco-a5'
            Title = 'Compare running and startup config sizes'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat running_config | grep -c "^!"'
            Description = @(
                'Count the number of configuration sections in running config.',
                'Exclamation marks separate configuration sections in IOS.'
            )
            Hint = 'Use: cat running_config | grep -c "^!"'
        }
        @{
            Id = 'cisco-e1'
            Title = 'Sort interface IP addresses'
            Difficulty = 'expert'
            ExpectedCommand = 'cat running_config | grep "ip address" | sort'
            Description = @(
                'Extract all IP address assignments and sort them.',
                'This uses grep piped through sort to organize interface IPs.'
            )
            Hint = 'Use: cat running_config | grep "ip address" | sort'
        }
        @{
            Id = 'cisco-e2'
            Title = 'Create a compressed flash backup'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf flash_backup.tar.gz flash/'
            Description = @(
                'Create a gzipped tar archive of the entire flash filesystem.',
                'Backing up flash protects the IOS image and all configurations.'
            )
            Hint = 'Use: tar -czf flash_backup.tar.gz flash/'
        }
        @{
            Id = 'cisco-e3'
            Title = 'Review NTP server configuration'
            Difficulty = 'expert'
            ExpectedCommand = 'grep "ntp" startup_config'
            Description = @(
                'Find all NTP-related configuration lines.',
                'NTP synchronizes the router clock with time servers.'
            )
            Hint = 'Use: grep "ntp" startup_config'
        }
        @{
            Id = 'cisco-e4'
            Title = 'Check SNMP configuration'
            Difficulty = 'expert'
            ExpectedCommand = 'grep "snmp-server" startup_config'
            Description = @(
                'Extract all SNMP server configuration statements.',
                'SNMP is used for network monitoring and management.'
            )
            Hint = 'Use: grep "snmp-server" startup_config'
        }
        @{
            Id = 'cisco-e5'
            Title = 'Analyze ACL_IN rule ordering'
            Difficulty = 'expert'
            ExpectedCommand = 'grep -A 12 "ip access-list extended ACL_IN" startup_config'
            Description = @(
                'Display the full ACL_IN access list with all entries.',
                'ACL rules are processed top-to-bottom; order matters for security.'
            )
            Hint = 'Use: grep -A 12 "ip access-list extended ACL_IN" startup_config'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
