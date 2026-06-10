function Get-LearningContent-opensuse {
    $fs = @{
        Type = 'dir'
        Owner = 'root'
        Group = 'root'
        Children = @{
            'etc' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'os_release' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'NAME="openSUSE Tumbleweed"',
                            '# VERSION="20250528"',
                            'ID="opensuse-tumbleweed"',
                            'ID_LIKE="opensuse suse"',
                            'VERSION_ID="20250528"',
                            'PRETTY_NAME="openSUSE Tumbleweed"',
                            'ANSI_COLOR="0;32"',
                            'CPE_NAME="cpe:/o:opensuse:tumbleweed:20250528"',
                            'HOME_URL="https://www.opensuse.org/"',
                            'DOCUMENTATION_URL="https://doc.opensuse.org/"',
                            'LOGO="distribution-logo"'
                        )
                    }
                    'hostname' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @('tumbleweed-box')
                    }
                    'zypp' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'zypper_conf' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/zypp/zypper.conf',
                                    '[main]',
                                    'gpgcheck = 1',
                                    'repo.refresh = true',
                                    'parallel.downloads = 5',
                                    'download.background = true',
                                    'commit.downloadOnly = false',
                                    'solv.cache = /var/cache/zypp/solv'
                                )
                            }
                            'repos_d' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'repo-oss_repo' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '[openSUSE:OSS]',
                                            'name=openSUSE Tumbleweed OSS',
                                            'enabled=1',
                                            'autorefresh=1',
                                            'baseurl=https://download.opensuse.org/tumbleweed/repo/oss/',
                                            'type=rpm-md',
                                            'keeppackages=0',
                                            'gpgcheck=1',
                                            'gpgkey=https://download.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml.key'
                                        )
                                    }
                                    'repo-nonoss_repo' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '[openSUSE:NonOSS]',
                                            'name=openSUSE Tumbleweed Non-OSS',
                                            'enabled=1',
                                            'autorefresh=1',
                                            'baseurl=https://download.opensuse.org/tumbleweed/repo/non-oss/',
                                            'type=rpm-md',
                                            'gpgcheck=1',
                                            'gpgkey=https://download.opensuse.org/tumbleweed/repo/non-oss/repodata/repomd.xml.key'
                                        )
                                    }
                                    'repo-update_repo' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '[openSUSE:Update]',
                                            'name=openSUSE Tumbleweed Update',
                                            'enabled=1',
                                            'autorefresh=1',
                                            'baseurl=https://download.opensuse.org/tumbleweed/repo/update/',
                                            'type=rpm-md',
                                            'gpgcheck=1',
                                            'gpgkey=https://download.opensuse.org/tumbleweed/repo/update/repodata/repomd.xml.key'
                                        )
                                    }
                                }
                            }
                        }
                    }
                    'sysconfig' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'SuSEfirewall2' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# SuSEfirewall2 configuration',
                                    '# Path: Network/Firewall',
                                    'FW_DEV_EXT="eth0"',
                                    'FW_SERVICES_EXT_TCP="ssh 22"',
                                    'FW_SERVICES_EXT_UDP=""',
                                    'FW_CONFIGURATIONS_EXT=""',
                                    'FW_MASQUERADE="no"',
                                    'FW_FORWARD="no"',
                                    'FW_IGNORE_FW_BROADCAST="yes"',
                                    'FW_LOG_DENIED="yes"',
                                    'FW_ALLOW_FW_SOURCE_ROUTE="no"'
                                )
                            }
                            'network' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'ifcfg-eth0' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# /etc/sysconfig/network/ifcfg-eth0',
                                            'BOOTPROTO="dhcp"',
                                            'STARTMODE="auto"',
                                            'DHCLIENT_SET_HOSTNAME="yes"',
                                            'NAME="Ethernet Card 0"',
                                            'MTU=""'
                                        )
                                    }
                                    'config' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# /etc/sysconfig/network/config',
                                            'NETWORKMANAGER="yes"',
                                            'DHCLIENT_USE_HOSTNAME="yes"',
                                            'NETCONFIG_DNS_POLICY="auto"'
                                        )
                                    }
                                    'routes' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# /etc/sysconfig/network/routes',
                                            '# Destination   Gateway         Netmask         Device'
                                        )
                                    }
                                }
                            }
                            'clock' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/sysconfig/clock',
                                    'TIMEZONE="Europe/Warsaw"',
                                    'HWCLOCK="-u"'
                                )
                            }
                            'keyboard' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/sysconfig/keyboard',
                                    'KEYTABLE="us"',
                                    'KEYMAP="us"'
                                )
                            }
                            'language' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/sysconfig/language',
                                    'RC_LANG="en_US.UTF-8"',
                                    'RC_LC_ALL=""'
                                )
                            }
                        }
                    }
                    'snapper' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'configs' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'root' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# /etc/snapper/configs/root',
                                            'SUBVOLUME="/"',
                                            'FSTYPE="btrfs"',
                                            'TIMELINE_CREATE="yes"',
                                            'TIMELINE_CLEANUP="yes"',
                                            'TIMELINE_LIMIT_DAILY="7"',
                                            'TIMELINE_LIMIT_WEEKLY="4"',
                                            'TIMELINE_LIMIT_MONTHLY="6"',
                                            'NUMBER_LIMIT="50"',
                                            'NUMBER_LIMIT_IMPORTANT="10"',
                                            'ALLOW_USERS=""',
                                            'ALLOW_GROUPS=""'
                                        )
                                    }
                                }
                            }
                        }
                    }
                    'pam_d' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'common-auth' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/pam.d/common-auth',
                                    'auth        required      pam_env.so',
                                    'auth        sufficient    pam_unix.so try_first_pass nullok',
                                    'auth        required      pam_deny.so'
                                )
                            }
                            'common-account' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/pam.d/common-account',
                                    'account     sufficient    pam_unix.so',
                                    'account     required      pam_deny.so'
                                )
                            }
                            'common-password' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/pam.d/common-password',
                                    'password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok',
                                    'password    required      pam_deny.so'
                                )
                            }
                            'common-session' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# /etc/pam.d/common-session',
                                    'session     required      pam_limits.so',
                                    'session     required      pam_unix.so',
                                    'session     optional      pam_systemd.so'
                                )
                            }
                        }
                    }
                    'alternatives' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'README' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Alternatives system for openSUSE',
                                    'Managed by update-alternatives',
                                    'Use: update-alternatives --config <name>'
                                )
                            }
                            'vi' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('link currently points to /usr/bin/vim')
                            }
                            'editor' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('link currently points to /usr/bin/nvim')
                            }
                            'java' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('link currently points to /usr/lib64/jvm/java-21-openjdk')
                            }
                        }
                    }
                }
            }
            'var' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'log' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'messages' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'Jun  1 08:15:01 tumbleweed-box rsyslogd: [origin software="rsyslogd"] start',
                                    'Jun  1 08:15:02 tumbleweed-box kernel: Linux version 6.10.2-1-default',
                                    'Jun  1 08:15:03 tumbleweed-box systemd[1]: Starting Snapper Daemon...',
                                    'Jun  1 08:15:03 tumbleweed-box systemd[1]: Started Snapper Daemon.',
                                    'Jun  1 08:15:04 tumbleweed-box systemd[1]: Starting SuSEfirewall2...',
                                    'Jun  1 08:15:05 tumbleweed-box SuSEfirewall2: Firewall rules applied',
                                    'Jun  1 08:15:06 tumbleweed-box sshd[1120]: Server listening on 0.0.0.0 port 22.',
                                    'Jun  1 08:15:07 tumbleweed-box snapperd[1080]: Snapshot #1 created',
                                    'Jun  1 08:30:01 tumbleweed-box CROND[1201]: (root) CMD (test -x /usr/lib/sa/sa1)',
                                    'Jun  1 08:45:22 tumbleweed-box sshd[1250]: Accepted publickey for student',
                                    'Jun  1 09:00:01 tumbleweed-box snapperd[1300]: Cleanup triggered: removing 0 snapshots'
                                )
                            }
                        }
                    }
                    'lib' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'snapper' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'snapshots' = @{
                                        Type = 'dir'; Owner = 'root'; Group = 'root'
                                        Children = @{
                                            '1' = @{
                                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                                Children = @{
                                                    'snapshot' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @(
                                                            '# Snapshot 1',
                                                            'Date: 2025-06-01 08:15:07',
                                                            'Type: timeline',
                                                            'Description: first root filesystem snapshot'
                                                        )
                                                    }
                                                    'info_xml' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @(
                                                            '<?xml version="1.0"?>',
                                                            '<snapshot>',
                                                            '  <num>1</num>',
                                                            '  <type>timeline</type>',
                                                            '  <date>2025-06-01 08:15:07</date>',
                                                            '</snapshot>'
                                                        )
                                                    }
                                                }
                                            }
                                            '2' = @{
                                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                                Children = @{
                                                    'snapshot' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @(
                                                            '# Snapshot 2',
                                                            'Date: 2025-06-01 08:30:01',
                                                            'Type: pre',
                                                            'Description: before zypper install'
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            'home' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'student' = @{
                        Type = 'dir'; Owner = 'student'; Group = 'student'
                        Children = @{
                            'opensuse-lab' = @{
                                Type = 'dir'; Owner = 'student'; Group = 'student'
                                Children = @{
                                    'notes_txt' = @{
                                        Type = 'file'; Owner = 'student'; Group = 'student'
                                        Content = @(
                                            '# openSUSE Tumbleweed Notes',
                                            'Zypper is the package manager (frontend to rpm)',
                                            'YaST configs live in /etc/sysconfig/',
                                            'Snapper manages Btrfs snapshots',
                                            'SuSEfirewall2 is the traditional firewall',
                                            'Use "zypper ps" to check process using deleted files after update'
                                        )
                                    }
                                }
                            }
                            'bashrc' = @{
                                Type = 'file'; Owner = 'student'; Group = 'student'
                                Content = @(
                                    '# .bashrc - openSUSE',
                                    'alias ll="ls -la"',
                                    'alias zypper="sudo zypper"',
                                    'alias zup="sudo zypper dup"',
                                    'alias zref="sudo zypper ref"',
                                    'alias zlog="sudo zypper history"',
                                    'alias snapper="sudo snapper"',
                                    'export EDITOR=nano',
                                    'export VISUAL=nano'
                                )
                            }
                        }
                    }
                }
            }
        }
    }
    $tasks = @(
        @{ Id = 1; Title = 'Explore home directory'; Difficulty = 'beginner'
            ExpectedCommand = 'ls -la /home/student'
            Description = @('List all files in /home/student including hidden dotfiles.')
            Hint = 'ls -la /home/student' }
        @{ Id = 2; Title = 'Navigate to lab folder'; Difficulty = 'beginner'
            ExpectedCommand = 'cd /home/student/opensuse-lab'
            Description = @('Change to the opensuse-lab directory under your home.')
            Hint = 'cd <path>' }
        @{ Id = 3; Title = 'Check openSUSE version'; Difficulty = 'beginner'
            ExpectedCommand = 'cat /etc/os-release'
            Description = @('Display /etc/os-release to confirm this is openSUSE Tumbleweed.')
            Hint = 'cat /etc/os-release' }
        @{ Id = 4; Title = 'Read the hostname'; Difficulty = 'beginner'
            ExpectedCommand = 'cat /etc/hostname'
            Description = @('Check the system hostname in /etc/hostname.')
            Hint = 'cat /etc/hostname' }
        @{ Id = 5; Title = 'Create a lab subdirectory'; Difficulty = 'beginner'
            ExpectedCommand = 'mkdir /home/student/opensuse-lab/zypper'
            Description = @('Create a "zypper" subdirectory inside opensuse-lab.')
            Hint = 'mkdir <path>' }
        @{ Id = 6; Title = 'Read OS release info'; Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/os-release'
            Description = @('Display OS information to verify distro and version.')
            Hint = 'cat /etc/os-release' }
        @{ Id = 7; Title = 'Check Zypper repositories'; Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/zypp/repos.d/repo-oss.repo'
            Description = @('Read the OSS repository configuration for Zypper.')
            Hint = 'cat /etc/zypp/repos.d/repo-oss.repo' }
        @{ Id = 8; Title = 'Check network config'; Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/sysconfig/network/ifcfg-eth0'
            Description = @('Read the SUSE-style network interface configuration.')
            Hint = 'cat /etc/sysconfig/network/ifcfg-eth0' }
        @{ Id = 9; Title = 'Search logs for SSH'; Difficulty = 'intermediate'
            ExpectedCommand = 'grep sshd /var/log/messages'
            Description = @('Search /var/log/messages for lines containing sshd.')
            Hint = 'grep sshd /var/log/messages' }
        @{ Id = 10; Title = 'Check disk usage'; Difficulty = 'intermediate'
            ExpectedCommand = 'df -h'
            Description = @('Display disk usage in human-readable format.')
            Hint = 'df -h' }
        @{ Id = 11; Title = 'Read snapper config'; Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/snapper/configs/root'
            Description = @('Display the snapper configuration for the root subvolume.')
            Hint = 'cat /etc/snapper/configs/root' }
        @{ Id = 12; Title = 'Check firewall config'; Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/sysconfig/SuSEfirewall2'
            Description = @('Read the SuSEfirewall2 configuration file.')
            Hint = 'cat /etc/sysconfig/SuSEfirewall2' }
        @{ Id = 13; Title = 'View journal logs'; Difficulty = 'advanced'
            ExpectedCommand = 'journalctl --no-pager -n 15'
            Description = @('View the 15 most recent systemd journal entries.')
            Hint = 'journalctl --no-pager -n 15' }
        @{ Id = 14; Title = 'Find config files'; Difficulty = 'advanced'
            ExpectedCommand = 'find /etc -name "*.conf" -type f 2>/dev/null | head -15'
            Description = @('Find .conf files under /etc, limit to 15 results.')
            Hint = 'find /etc -name "*.conf" -type f 2>/dev/null | head -15' }
        @{ Id = 15; Title = 'Check memory usage'; Difficulty = 'advanced'
            ExpectedCommand = 'free -h'
            Description = @('Display memory usage in human-readable format.')
            Hint = 'free -h' }
        @{ Id = 16; Title = 'Analyze YaST configs'; Difficulty = 'expert'
            ExpectedCommand = 'ls -la /etc/sysconfig/ | grep -v "^d" | head -20'
            Description = @('List files in /etc/sysconfig/ excluding directories to see YaST-managed configs.')
            Hint = 'ls -la /etc/sysconfig/ | grep -v "^d" | head -20' }
        @{ Id = 17; Title = 'Check alternatives'; Difficulty = 'expert'
            ExpectedCommand = 'ls -la /etc/alternatives/ | head -15'
            Description = @('List alternatives managed by update-alternatives.')
            Hint = 'ls -la /etc/alternatives/ | head -15' }
        @{ Id = 18; Title = 'Analyze log patterns'; Difficulty = 'expert'
            ExpectedCommand = 'grep -oP "systemd\[.*?\]" /var/log/messages | sort | uniq -c | sort -rn'
            Description = @('Extract systemd process tags from messages, count and sort by frequency.')
            Hint = 'grep -oP "systemd\[.*?\]" /var/log/messages | sort | uniq -c | sort -rn' }
        @{ Id = 19; Title = 'Backup with tar'; Difficulty = 'expert'
            ExpectedCommand = 'tar czvf /tmp/opensuse-home-backup.tar.gz /home/student'
            Description = @('Create a compressed tar archive of /home/student in /tmp.')
            Hint = 'tar czvf /tmp/backup.tar.gz /home/student' }
        @{ Id = 20; Title = 'Explore snapper snapshots'; Difficulty = 'expert'
            ExpectedCommand = 'ls -la /var/lib/snapper/snapshots/ 2>/dev/null'
            Description = @('List existing snapper snapshots stored on disk.')
            Hint = 'ls -la /var/lib/snapper/snapshots/' }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
