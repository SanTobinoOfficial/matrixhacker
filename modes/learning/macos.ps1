function Get-LearningContent-macos {
    $fs = @{
        'Users' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'student' = @{
                    Type = 'dir'
                    Owner = 'student'
                    Group = 'staff'
                    Children = @{
                        'Desktop' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'staff'
                            Children = @{
                                'readme_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Content = @(
                                        'Welcome to macOS 15 Sequoia - Ultra Matrix Terminal',
                                        '================================================',
                                        'Shell: zsh (Z shell) - default since macOS Catalina',
                                        'Package manager: Homebrew (/usr/local/bin/brew)',
                                        'Key differences from Linux:',
                                        '  - ls -G for color output (not --color=auto)',
                                        '  - plist files replace .conf in many cases',
                                        '  - launchd instead of systemd',
                                        '  - Disk Utility instead of fdisk',
                                        '  - sw_vers instead of cat /etc/os-release',
                                        '',
                                        'Type help to see available commands.'
                                    )
                                }
                                'notes_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Content = @(
                                        'macOS CLI Quick Reference',
                                        '=========================',
                                        'open .                  - Open Finder in current dir',
                                        'pbpaste                 - Paste from clipboard',
                                        'pbcopy                  - Copy to clipboard',
                                        'defaults write          - Modify plist settings',
                                        'system_profiler         - Detailed system info',
                                        'diskutil list           - Show disk partitions',
                                        'dscacheutil -q host     - Flush DNS cache',
                                        'brew install            - Install with Homebrew',
                                        'sw_vers                 - Show macOS version',
                                        'plutil -p file.plist    - Pretty-print plist'
                                    )
                                }
                            }
                        }
                        'Documents' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'staff'
                            Children = @{
                                'work' = @{
                                    Type = 'dir'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Children = @{
                                        'project_plan_md' = @{
                                            Type = 'file'
                                            Owner = 'student'
                                            Group = 'staff'
                                            Content = @(
                                                '# Project Plan: Network Infrastructure Upgrade',
                                                '',
                                                '## Timeline',
                                                '- Week 1: Assessment and documentation',
                                                '- Week 2: Hardware procurement',
                                                '- Week 3: Implementation',
                                                '- Week 4: Testing and validation',
                                                '',
                                                '## Resources',
                                                '- 2x Cisco Catalyst switches',
                                                '- Cat6a cabling',
                                                '- Rackmount PDU',
                                                '',
                                                '## Notes',
                                                'Coordinate with facilities for power maintenance.'
                                            )
                                        }
                                        'budget_xlsx' = @{
                                            Type = 'file'
                                            Owner = 'student'
                                            Group = 'staff'
                                            Content = @(
                                                '# Budget Spreadsheet (work/budget.xlsx)',
                                                '# This is a placeholder for an Excel binary file.',
                                                '# Categories: Hardware, Software, Labor, Misc',
                                                '# Total budget: $45,000'
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        'Downloads' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'staff'
                            Children = @{}
                        }
                        'Library' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'staff'
                            Children = @{
                                'Application Support' = @{
                                    Type = 'dir'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Children = @{}
                                }
                                'Preferences' = @{
                                    Type = 'dir'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Children = @{
                                        'com_apple_Terminal_plist' = @{
                                            Type = 'file'
                                            Owner = 'student'
                                            Group = 'staff'
                                            Content = @(
                                                '<?xml version="1.0" encoding="UTF-8"?>',
                                                '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"',
                                                ' "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                                                '<plist version="1.0">',
                                                '<dict>',
                                                '    <key>Default Window Settings</key>',
                                                '    <string>Basic</string>',
                                                '    <key>Startup Window Settings</key>',
                                                '    <string>Basic</string>',
                                                '    <key>ShellExitAction</key>',
                                                '    <integer>2</integer>',
                                                '    <key>TabViewType</key>',
                                                '    <integer>0</integer>',
                                                '    <key>UseFocusFollowsMouse</key>',
                                                '    <false/>',
                                                '    <key>SecureKeyboardEntry</key>',
                                                '    <true/>',
                                                '</dict>',
                                                '</plist>'
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        '_bash_profile' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'staff'
                            Content = @(
                                '# ~/.bash_profile - Bash configuration for macOS Sequoia',
                                '# This file is sourced by bash login shells.',
                                '',
                                'export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"',
                                'export EDITOR=nano',
                                '',
                                'alias ll="ls -lG"',
                                'alias la="ls -laG"',
                                'alias l="ls -CFG"'
                            )
                        }
                        '_zshrc' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'staff'
                            Content = @(
                                '# ~/.zshrc - Zsh configuration for macOS Sequoia',
                                '# This file is sourced by zsh interactive shells.',
                                '',
                                'export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"',
                                'export EDITOR=nano',
                                '',
                                '# Oh My Zsh configuration',
                                'ZSH_THEME="robbyrussell"',
                                'plugins=(git brew macos osx)',
                                '',
                                '# Homebrew settings',
                                'export HOMEBREW_NO_AUTO_UPDATE=1',
                                'export HOMEBREW_NO_INSTALL_CLEANUP=1',
                                '',
                                '# macOS-specific aliases',
                                'alias ll="ls -lG"',
                                'alias la="ls -laG"',
                                'alias l="ls -CFG"',
                                'alias grep="grep --color=auto"',
                                'alias df="df -h"',
                                'alias du="du -h -d 2"',
                                'alias showfiles="defaults write com.apple.finder AppleShowAllFiles TRUE"',
                                'alias hidefiles="defaults write com.apple.finder AppleShowAllFiles FALSE"',
                                '',
                                '# Custom prompt',
                                'PROMPT="%n@%m %1~ %# "'
                            )
                        }
                        '_ssh' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'staff'
                            Children = @{
                                'config' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Content = @(
                                        '# SSH configuration for macOS',
                                        '# Per-host configuration overrides',
                                        '',
                                        'Host *',
                                        '    StrictHostKeyChecking ask',
                                        '    ServerAliveInterval 60',
                                        '    ServerAliveCountMax 3',
                                        '    UseKeychain yes',
                                        '    AddKeysToAgent yes',
                                        '',
                                        'Host server01',
                                        '    HostName 10.0.0.10',
                                        '    User admin',
                                        '    Port 22',
                                        '    IdentityFile ~/.ssh/id_ed25519',
                                        '',
                                        'Host server02',
                                        '    HostName 10.0.0.20',
                                        '    User admin',
                                        '    Port 2222',
                                        '    IdentityFile ~/.ssh/id_ed25519',
                                        '',
                                        'Host github.com',
                                        '    User git',
                                        '    IdentityFile ~/.ssh/id_ed25519'
                                    )
                                }
                                'known_hosts' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'staff'
                                    Content = @(
                                        'server01 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmysteryhash1234567890abcdefghijk',
                                        'server02 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmysteryhash9876543210abcdefghijk',
                                        'github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1xHNGjmPFHY2EGXM7yzMhB6IhM4hGQcGz7VNjDJVk6gm6JZqLKSEiP5AdLjm5bZRl0oh3Tq3sHcA'
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        'Applications' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'Safari' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
                'Terminal' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
                'Xcode' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
                'iTerm2' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
            }
        }
        'System' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'Library' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{
                        'LaunchDaemons' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{
                                'com_apple_ssh_plist' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'wheel'
                                    Content = @(
                                        '<?xml version="1.0" encoding="UTF-8"?>',
                                        '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"',
                                        ' "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                                        '<plist version="1.0">',
                                        '<dict>',
                                        '    <key>Label</key>',
                                        '    <string>com.apple.ssh</string>',
                                        '    <key>ProgramArguments</key>',
                                        '    <array>',
                                        '        <string>/usr/libexec/sshd-keygen-wrapper</string>',
                                        '    </array>',
                                        '    <key>RunAtLoad</key>',
                                        '    <true/>',
                                        '    <key>KeepAlive</key>',
                                        '    <true/>',
                                        '    <key>Disabled</key>',
                                        '    <true/>',
                                        '</dict>',
                                        '</plist>'
                                    )
                                }
                                'com_openssh_sshd_plist' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'wheel'
                                    Content = @(
                                        '<?xml version="1.0" encoding="UTF-8"?>',
                                        '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"',
                                        ' "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                                        '<plist version="1.0">',
                                        '<dict>',
                                        '    <key>Label</key>',
                                        '    <string>com.openssh.sshd</string>',
                                        '    <key>Program</key>',
                                        '    <string>/usr/libexec/sshd-keygen-wrapper</string>',
                                        '    <key>ProgramArguments</key>',
                                        '    <array>',
                                        '        <string>/usr/libexec/sshd-keygen-wrapper</string>',
                                        '        <string>-i</string>',
                                        '    </array>',
                                        '    <key>RunAtLoad</key>',
                                        '    <true/>',
                                        '    <key>KeepAlive</key>',
                                        '    <true/>',
                                        '    <key>Disabled</key>',
                                        '    <false/>',
                                        '    <key>SessionCreate</key>',
                                        '    <true/>',
                                        '</dict>',
                                        '</plist>'
                                    )
                                }
                            }
                        }
                        'LaunchAgents' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{}
                        }
                    }
                }
            }
        }
        'Library' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'Preferences' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{
                        'SystemConfiguration' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{
                                'com_apple_airport_preferences_plist' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'wheel'
                                    Content = @(
                                        '<?xml version="1.0" encoding="UTF-8"?>',
                                        '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"',
                                        ' "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
                                        '<plist version="1.0">',
                                        '<dict>',
                                        '    <key>LastConnected</key>',
                                        '    <date>2026-06-08T08:00:00Z</date>',
                                        '    <key>PreferredNetworks</key>',
                                        '    <array>',
                                        '        <dict>',
                                        '            <key>SSID</key>',
                                        '            <string>Office_WiFi</string>',
                                        '            <key>SecurityType</key>',
                                        '            <string>WPA2</string>',
                                        '            <key>LastConnected</key>',
                                        '            <date>2026-06-08T07:30:00Z</date>',
                                        '        </dict>',
                                        '        <dict>',
                                        '            <key>SSID</key>',
                                        '            <string>Home_Network</string>',
                                        '            <key>SecurityType</key>',
                                        '            <string>WPA3</string>',
                                        '            <key>LastConnected</key>',
                                        '            <date>2026-06-07T22:00:00Z</date>',
                                        '        </dict>',
                                        '    </array>',
                                        '    <key>RememberedNetworks</key>',
                                        '    <integer>2</integer>',
                                        '</dict>',
                                        '</plist>'
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        'etc' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'wheel'
                    Content = @(
                        'macbook-pro'
                    )
                }
                'hosts' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'wheel'
                    Content = @(
                        '127.0.0.1       localhost',
                        '127.0.1.1       macbook-pro.local macbook-pro',
                        '255.255.255.255 broadcasthost',
                        '::1             localhost',
                        'fe80::1%lo0     localhost',
                        '',
                        '# Host aliases for lab environment',
                        '10.0.0.10       server01.lab.local server01',
                        '10.0.0.20       server02.lab.local server02'
                    )
                }
                'sshd_config' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'wheel'
                    Content = @(
                        '# macOS SSH server configuration',
                        '# $OpenBSD: sshd_config,v 1.104 2024/02/03 15:00:00',
                        '',
                        'Port 22',
                        'ListenAddress 0.0.0.0',
                        'HostKey /etc/ssh/ssh_host_ed25519_key',
                        'HostKey /etc/ssh/ssh_host_rsa_key',
                        '',
                        'UsePAM yes',
                        'PasswordAuthentication yes',
                        'ChallengeResponseAuthentication no',
                        'PubkeyAuthentication yes',
                        '',
                        'AcceptEnv LANG LC_*',
                        'Subsystem sftp /usr/libexec/sftp-server',
                        '',
                        'LoginGraceTime 30',
                        'MaxAuthTries 6',
                        'MaxSessions 10',
                        'ClientAliveInterval 300',
                        'ClientAliveCountMax 3'
                    )
                }
                'pam_d' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
                'sw_vers' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'wheel'
                    Content = @(
                        'ProductName:            macOS',
                        'ProductVersion:         15.0',
                        'BuildVersion:           24A232',
                        '',
                        'ProductName:            macOS Sequoia',
                        'SystemVersion:          15.0',
                        'KernelVersion:          24.0.0',
                        'DarwinKernelVersion:    24.0.0'
                    )
                }
            }
        }
        'usr' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'local' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{
                        'bin' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{
                                'brew' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'wheel'
                                    Content = @(
                                        '#!/bin/bash',
                                        '# Homebrew 4.2.0',
                                        '# macOS package manager (unofficial)',
                                        '# Usage: brew install <formula>',
                                        '#        brew search <formula>',
                                        '#        brew update',
                                        '#        brew upgrade',
                                        '',
                                        'HOMEBREW_VERSION="4.2.0"',
                                        'HOMEBREW_PREFIX="/usr/local"',
                                        'HOMEBREW_CELLAR="/usr/local/Cellar"',
                                        'HOMEBREW_REPOSITORY="/usr/local/Homebrew"',
                                        'HOMEBREW_CASKROOM="/usr/local/Caskroom"',
                                        '',
                                        'echo "Homebrew ${HOMEBREW_VERSION}"',
                                        'echo "Run brew --help for usage."'
                                    )
                                }
                            }
                        }
                        'Cellar' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{}
                        }
                        'Caskroom' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'wheel'
                            Children = @{}
                        }
                    }
                }
            }
        }
        'Volumes' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'Data' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
                'Macintosh HD' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
            }
        }
        'private' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'tmp' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
            }
        }
        'tmp' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{}
        }
        'cores' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{}
        }
        'opt' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'homebrew-cask' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{}
                }
            }
        }
        'var' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'wheel'
            Children = @{
                'log' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'wheel'
                    Children = @{
                        'system_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'wheel'
                            Content = @(
                                '2026-06-08 08:00:00.000 kernel[0]: vm_page_bootstrap: 8388608 pages',
                                '2026-06-08 08:00:00.001 kernel[0]: standard timeslicing quantum is 10000 us',
                                '2026-06-08 08:00:00.500 kernel[0]: AppleCredentialManager: starting',
                                '2026-06-08 08:00:01.000 runningboardd[1]: Booting system initiated',
                                '2026-06-08 08:00:02.000 configd[100]: setting hostname to macbook-pro',
                                '2026-06-08 08:00:03.000 mDNSResponder[102]: mDNSResponder-2600.40.3 starting',
                                '2026-06-08 08:00:04.000 opendirectoryd[110]: ODNodeCreateWithNodeType: no nodes',
                                '2026-06-08 08:00:05.000 sshd[150]: Server listening on 0.0.0.0 port 22',
                                '2026-06-08 08:00:06.000 WindowServer[200]: WindowServer started',
                                '2026-06-08 08:05:00.000 syslogd[50]: syslogd started',
                                '2026-06-08 08:10:00.000 mds[300]: (Normal) Volume mount at /System/Volumes/Data',
                                '2026-06-08 08:15:00.000 configd[100]: Network configuration changed',
                                '2026-06-08 08:15:01.000 kernel[0]: en0: Ethernet address 00:1a:2b:3c:4d:5e',
                                '2026-06-08 08:15:02.000 kernel[0]: en0: link up, 1 Gbps, full duplex, lpb',
                                '2026-06-08 08:18:00.000 configd[100]: en0: acquired DHCP lease 192.168.1.50',
                                '2026-06-08 08:20:00.000 mds[300]: (Normal) Volume unmount: /System/Volumes/Data',
                                '2026-06-08 08:22:00.000 sshd[350]: Accepted publickey for student from 10.0.0.10',
                                '2026-06-08 08:22:00.000 sshd[350]: session opened for user student by (uid=0)',
                                '2026-06-08 08:30:00.000 sudo[400]: student : TTY=ttys000 ; USER=root ; COMMAND=brew',
                                '2026-06-08 08:30:05.000 kernel[0]: hibernate image path: /var/vm/sleepimage',
                                '2026-06-08 08:45:00.000 Terminal[420]: Window group 1 created',
                                '2026-06-08 08:45:01.000 Terminal[420]: TTWatcher starting',
                                '2026-06-08 09:00:00.000 mds[300]: (Error) Volume failed to mount on disk3s1',
                                '2026-06-08 09:15:00.000 configd[100]: System configuration updated',
                                '2026-06-08 09:30:00.000 syslogd[50]: syslogd: exiting',
                                '2026-06-08 09:30:01.000 syslogd[55]: syslogd started',
                                '2026-06-08 10:00:00.000 powerd[220]: Sleep transition initiated by user',
                                '2026-06-08 10:00:30.000 kernel[0]: Wake transition initiated',
                                '2026-06-08 10:01:00.000 kernel[0]: hibernate image path: /var/vm/sleepimage',
                                '2026-06-08 10:05:00.000 sshd[450]: Failed password for root from 10.0.0.99',
                                '2026-06-08 10:05:02.000 sshd[452]: Failed password for root from 10.0.0.99',
                                '2026-06-08 10:05:04.000 sshd[454]: error: max auth attempts exceeded for root',
                                '2026-06-08 10:05:04.000 sshd[454]: Disconnecting from 10.0.0.99 port 53422',
                                '2026-06-08 10:05:05.000 kernel[0]: en0: link down',
                                '2026-06-08 10:05:10.000 kernel[0]: en0: link up, 1 Gbps, full duplex, lpb',
                                '2026-06-08 10:30:00.000 configd[100]: Network configuration changed',
                                '2026-06-08 11:00:00.000 analyticsd[500]: Submitted analytics report',
                                '2026-06-08 11:00:00.001 analyticsd[500]: Report ID: 9a8b7c6d-5e4f-3a2b-1c0d-9e8f7a6b5c4d',
                                '2026-06-08 11:15:00.000 mds[300]: (Warning) Low disk space on /System/Volumes/Data',
                                '2026-06-08 11:30:00.000 sudo[550]: student : TTY=ttys001 ; USER=root ; COMMAND=/usr/bin/du'
                            )
                        }
                        'install_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'wheel'
                            Content = @(
                                '2026-06-01 10:00:00+02:00 macbook-pro installer[300]: PackageKit: Installing Homebrew 4.2.0',
                                '2026-06-01 10:05:00+02:00 macbook-pro installer[300]: PackageKit: Install of Homebrew completed',
                                '2026-06-03 14:30:00+02:00 macbook-pro softwareupdated[400]: Downloading macOS Sequoia 15.0 update',
                                '2026-06-03 14:35:00+02:00 macbook-pro softwareupdated[400]: macOS Sequoia 15.0 update downloaded',
                                '2026-06-03 15:00:00+02:00 macbook-pro installer[500]: Installing macOS Sequoia 15.0 (24A232)',
                                '2026-06-03 16:00:00+02:00 macbook-pro installer[500]: macOS Sequoia 15.0 installation completed successfully',
                                '2026-06-05 09:00:00+02:00 macbook-pro brew[600]: Upgrading wget 1.21.4 -> 1.24.5',
                                '2026-06-05 09:01:00+02:00 macbook-pro brew[600]: Upgrading curl 8.4.0 -> 8.7.1',
                                '2026-06-05 09:02:00+02:00 macbook-pro brew[600]: Upgrading git 2.43.0 -> 2.45.0',
                                '2026-06-06 12:00:00+02:00 macbook-pro installer[650]: Installing Visual Studio Code 1.90.0',
                                '2026-06-06 12:05:00+02:00 macbook-pro installer[650]: Visual Studio Code installation completed',
                                '2026-06-07 18:30:00+02:00 macbook-pro installer[700]: Installing Xcode 16.0',
                                '2026-06-07 19:30:00+02:00 macbook-pro installer[700]: Xcode 16.0 installation completed',
                                '2026-06-08 08:00:00+02:00 macbook-pro kernel[0]: Darwin Kernel Version 24.0.0: boot'
                            )
                        }
                    }
                }
            }
        }
    }

    $tasks = @(
        @{
            Id = 'macos-b1'
            Title = 'List files in home directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls -la'
            Description = @(
                'List all files and directories in your home directory.',
                'Include hidden files (starting with .) using the -la flags.'
            )
            Hint = 'Try: ls -la ~'
        }
        @{
            Id = 'macos-b2'
            Title = 'Read the Desktop welcome file'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat Desktop/readme_txt'
            Description = @(
                'Display the contents of the readme file on your Desktop.',
                'This file contains welcome information for macOS Sequoia.'
            )
            Hint = 'Use: cat Desktop/readme_txt'
        }
        @{
            Id = 'macos-b3'
            Title = 'Navigate to Documents'
            Difficulty = 'beginner'
            ExpectedCommand = 'cd Documents'
            Description = @(
                'Change your current directory to Documents.',
                'Use cd to navigate the macOS filesystem.'
            )
            Hint = 'Use: cd Documents'
        }
        @{
            Id = 'macos-b4'
            Title = 'Create a new projects directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'mkdir Projects'
            Description = @(
                'Create a new directory called Projects.',
                'Use mkdir to organize your work into directories.'
            )
            Hint = 'Use: mkdir Projects'
        }
        @{
            Id = 'macos-b5'
            Title = 'Show current working directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'pwd'
            Description = @(
                'Print the full path of your current working directory.',
                'This tells you exactly where you are in the filesystem.'
            )
            Hint = 'Type pwd and press Enter'
        }
        @{
            Id = 'macos-i1'
            Title = 'View zsh shell configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat _zshrc'
            Description = @(
                'Display the zsh configuration file.',
                'macOS uses zsh as the default shell since Catalina.'
            )
            Hint = 'Use: cat _zshrc (from ~)'
        }
        @{
            Id = 'macos-i2'
            Title = 'View SSH client configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat _ssh/config'
            Description = @(
                'Display the SSH client configuration file.',
                'This file defines host aliases and connection parameters.'
            )
            Hint = 'Use: cat _ssh/config (from ~)'
        }
        @{
            Id = 'macos-i3'
            Title = 'Browse installed applications'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ls /Applications'
            Description = @(
                'List all applications in /Applications.',
                'macOS stores GUI applications as .app bundles (directories).'
            )
            Hint = 'Use: ls /Applications'
        }
        @{
            Id = 'macos-i4'
            Title = 'View the hosts file'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/hosts'
            Description = @(
                'Display the BSD-style hosts file.',
                'macOS uses a BSD-style /etc/hosts for local DNS resolution.'
            )
            Hint = 'Use: cat /etc/hosts'
        }
        @{
            Id = 'macos-i5'
            Title = 'Copy the readme file'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cp Desktop/readme_txt Desktop/readme_backup_txt'
            Description = @(
                'Make a backup copy of the Desktop readme file.',
                'The cp command copies files in macOS just like Linux.'
            )
            Hint = 'Use: cp Desktop/readme_txt Desktop/readme_backup_txt'
        }
        @{
            Id = 'macos-a1'
            Title = 'List system launch daemons'
            Difficulty = 'advanced'
            ExpectedCommand = 'ls /System/Library/LaunchDaemons/'
            Description = @(
                'List all launch daemon plist files.',
                'Launch daemons are system services managed by launchd.'
            )
            Hint = 'Use: ls /System/Library/LaunchDaemons/'
        }
        @{
            Id = 'macos-a2'
            Title = 'View SSH daemon launchd plist'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /System/Library/LaunchDaemons/com_openssh_sshd_plist'
            Description = @(
                'Display the SSH daemon launchd property list.',
                'macOS uses launchd plist XML files to configure system services.'
            )
            Hint = 'Use: cat /System/Library/LaunchDaemons/com_openssh_sshd_plist'
        }
        @{
            Id = 'macos-a3'
            Title = 'Find all plist files in home'
            Difficulty = 'advanced'
            ExpectedCommand = 'find /Users -name "*.plist"'
            Description = @(
                'Search for all .plist files under /Users.',
                'Plist files store application and system preferences in macOS.'
            )
            Hint = 'Use: find /Users -name "*.plist"'
        }
        @{
            Id = 'macos-a4'
            Title = 'Check Homebrew version'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /usr/local/bin/brew | grep HOMEBREW_VERSION'
            Description = @(
                'Find the Homebrew version string from the brew script.',
                'Homebrew is the most popular package manager for macOS.'
            )
            Hint = 'Use: cat /usr/local/bin/brew | grep HOMEBREW_VERSION'
        }
        @{
            Id = 'macos-a5'
            Title = 'Search system log for SSH events'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep sshd /var/log/system_log'
            Description = @(
                'Search the system log for all SSH daemon events.',
                'This shows connection attempts, authentication, and errors.'
            )
            Hint = 'Use: grep sshd /var/log/system_log'
        }
        @{
            Id = 'macos-e1'
            Title = 'Unique kernel messages from system log'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /var/log/system_log | grep kernel | sort | uniq'
            Description = @(
                'Extract kernel messages, sort them, and remove duplicates.',
                'This pipeline shows how to filter and deduplicate log entries.'
            )
            Hint = 'Use: cat /var/log/system_log | grep kernel | sort | uniq'
        }
        @{
            Id = 'macos-e2'
            Title = 'Create a compressed backup of Documents'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf documents_backup.tar.gz -C ~ Documents/'
            Description = @(
                'Create a gzipped tar archive of the Documents folder.',
                'Use tar with -czf for compressed backups on macOS.'
            )
            Hint = 'Use: tar -czf documents_backup.tar.gz -C ~ Documents/'
        }
        @{
            Id = 'macos-e3'
            Title = 'Check disk usage of home directories'
            Difficulty = 'expert'
            ExpectedCommand = 'du -sh /Users/*'
            Description = @(
                'Display disk usage for each user home directory.',
                'The -s flag summarizes, -h makes output human-readable.'
            )
            Hint = 'Use: du -sh /Users/*'
        }
        @{
            Id = 'macos-e4'
            Title = 'Display macOS version information'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /etc/sw_vers'
            Description = @(
                'View the macOS system version information.',
                'This is equivalent to running the sw_vers command.'
            )
            Hint = 'Use: cat /etc/sw_vers'
        }
        @{
            Id = 'macos-e5'
            Title = 'Find all files in work project directory'
            Difficulty = 'expert'
            ExpectedCommand = 'find Documents/work -type f -name "*" | sort'
            Description = @(
                'Locate all files in the work project folder and sort them.',
                'This shows how to recursively list files in a project tree.'
            )
            Hint = 'Use: find Documents/work -type f -name "*" | sort'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
