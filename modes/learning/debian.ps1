function Get-LearningContent-debian {
    $fs = @{
        'home' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'student' = @{
                    Type = 'dir'
                    Owner = 'student'
                    Group = 'student'
                    Children = @{
                        'documents' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'student'
                            Children = @{
                                'todo_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        'Debian 12 Bookworm Study Notes',
                                        '- Learn apt-get vs apt differences',
                                        '- Practice dpkg package management',
                                        '- Configure postfix MTA for local delivery',
                                        '- Understand GRUB bootloader config',
                                        '- Review syslog and mail log analysis'
                                    )
                                }
                                'debian_notes_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        'Debian 12 (Bookworm) - Released June 2023',
                                        'Kernel: 6.1 LTS',
                                        'Default filesystem: ext4',
                                        'Init system: systemd v252',
                                        'Python: 3.11',
                                        'GCC: 12.2',
                                        'Desktop: GNOME 43',
                                        'Non-free firmware: separated since Bookworm'
                                    )
                                }
                            }
                        }
                        'configs' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'student'
                            Children = @{
                                'vimrc' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        '" .vimrc - Vim configuration file',
                                        'set number',
                                        'set tabstop=4',
                                        'set shiftwidth=4',
                                        'set expandtab',
                                        'syntax on',
                                        'colorscheme desert'
                                    )
                                }
                            }
                        }
                        '.bashrc' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# ~/.bashrc for Debian 12 Bookworm',
                                'export PS1=''u@h:w$ '''
                                'alias ll=''ls -alF''',
                                'alias la=''ls -A''',
                                'alias l=''ls -CF''',
                                'alias grep=''grep --color=auto''',
                                'alias apt-get=''sudo apt-get''',
                                'export EDITOR=vim'
                            )
                        }
                        '.profile' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# ~/.profile: executed by the command interpreter for login shells.',
                                'if [ "$BASH" ]; then',
                                '  if [ -f ~/.bashrc ]; then',
                                '    . ~/.bashrc',
                                '  fi',
                                'fi',
                                'mesg n 2> /dev/null || true'
                            )
                        }
                        'readme_txt' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                'Ultra Matrix Terminal - Debian 12 (Bookworm) Learning Mode',
                                '',
                                'Debian GNU/Linux 12 - The Universal Operating System.',
                                'Known for stability, freedom, and the APT package system.',
                                '',
                                'Available tools: bash, python3, git, curl, vim',
                                'System services: sshd, postfix, exim4, cron',
                                'Package managers: apt, apt-get, dpkg',
                                '',
                                'This environment follows Debian Stable principles.',
                                'Practice your Debian system administration skills!'
                            )
                        }
                    }
                }
            }
        }
        'etc' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'os-release' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"',
                        'NAME="Debian GNU/Linux"',
                        'VERSION_ID="12"',
                        'VERSION="12 (bookworm)"',
                        'VERSION_CODENAME=bookworm',
                        'ID=debian',
                        'HOME_URL="https://www.debian.org/"',
                        'SUPPORT_URL="https://www.debian.org/support"',
                        'BUG_REPORT_URL="https://bugs.debian.org/"'
                    )
                }
                'debian_version' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '12.0'
                    )
                }
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'debian-bookworm'
                    )
                }
                'hosts' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '127.0.0.1 localhost',
                        '127.0.1.1 debian-bookworm',
                        '',
                        '# The following lines are for IPv6 capable hosts',
                        '::1     localhost ip6-localhost ip6-loopback',
                        'ff02::1 ip6-allnodes',
                        'ff02::2 ip6-allrouters'
                    )
                }
                'apt' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'sources_list' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/apt/sources.list',
                                '# Debian 12 Bookworm - Official Repositories',
                                '',
                                'deb http://deb.debian.org/debian bookworm main non-free-firmware',
                                'deb-src http://deb.debian.org/debian bookworm main non-free-firmware',
                                '',
                                'deb http://deb.debian.org/debian-security bookworm-security main non-free-firmware',
                                'deb-src http://deb.debian.org/debian-security bookworm-security main non-free-firmware',
                                '',
                                'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware',
                                'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware'
                            )
                        }
                    }
                }
                'network' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'interfaces' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/network/interfaces - Debian network config',
                                '# Used by ifup(8) and ifdown(8)',
                                '',
                                'auto lo',
                                'iface lo inet loopback',
                                '',
                                'auto eth0',
                                'iface eth0 inet static',
                                '    address 192.168.1.100',
                                '    netmask 255.255.255.0',
                                '    gateway 192.168.1.1',
                                '    dns-nameservers 8.8.8.8 1.1.1.1'
                            )
                        }
                    }
                }
                'default' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'grub' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/default/grub - GRUB configuration',
                                '# Run update-grub after changing this file',
                                '',
                                'GRUB_DEFAULT=0',
                                'GRUB_TIMEOUT=5',
                                'GRUB_DISTRIBUTOR=`lsb_release -i -s 2>/dev/null || echo Debian`',
                                'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
                                'GRUB_CMDLINE_LINUX=""',
                                '',
                                '# Uncomment to disable graphical terminal',
                                '#GRUB_TERMINAL=console',
                                '',
                                '# The resolution used on graphical terminal',
                                'GRUB_GFXMODE=1024x768',
                                '',
                                '# Uncomment to avoid probing unknown devices',
                                'GRUB_DISABLE_OS_PROBER=false'
                            )
                        }
                    }
                }
                'postfix' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'main_cf' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/postfix/main.cf - Postfix mail transport agent config',
                                'smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)',
                                'biff = no',
                                'append_dot_mydomain = no',
                                'readme_directory = no',
                                'compatibility_level = 3.6',
                                '',
                                'smtpd_tls_security_level = may',
                                'smtp_tls_security_level = may',
                                '',
                                'myhostname = debian-bookworm.localdomain',
                                'alias_maps = hash:/etc/aliases',
                                'alias_database = hash:/etc/aliases',
                                'myorigin = /etc/mailname',
                                'mydestination = $myhostname, localhost.localdomain, localhost',
                                'relayhost =',
                                'mynetworks = 127.0.0.0/8',
                                'mailbox_size_limit = 0',
                                'recipient_delimiter = +',
                                'inet_interfaces = all',
                                'inet_protocols = ipv4'
                            )
                        }
                    }
                }
                'exim4' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'update-exim4_conf_conf' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/exim4/update-exim4.conf.conf',
                                '# Debian exim4 config',
                                '',
                                "dc_eximconfig_configtype='local'",
                                "dc_other_hostnames='debian-bookworm.localdomain'",
                                "dc_local_interfaces='127.0.0.1'",
                                "dc_readhost=''",
                                "dc_relay_domains=''",
                                "dc_minimaldns='false'",
                                "dc_relay_nets=''",
                                "dc_smarthost=''",
                                "CFILEMODE='644'",
                                "dc_use_split_config='false'",
                                "dc_hide_mailname=''",
                                "dc_mailname_in_oh='true'",
                                "dc_localdelivery='mail_spool'"
                            )
                        }
                    }
                }
            }
        }
        'var' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'log' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'syslog' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'Jun  8 10:15:23 debian-bookworm systemd[1]: Started User Login Management.',
                                'Jun  8 10:15:23 debian-bookworm systemd[1]: Started System Logging Service.',
                                'Jun  8 10:15:25 debian-bookworm sshd[856]: Server listening on 0.0.0.0 port 22.',
                                'Jun  8 10:15:30 debian-bookworm kernel: Linux version 6.1.0-21-amd64',
                                'Jun  8 10:16:00 debian-bookworm systemd[1]: Started Network Manager.',
                                'Jun  8 10:16:05 debian-bookworm dhclient[890]: DHCPREQUEST on eth0',
                                'Jun  8 10:16:05 debian-bookworm dhclient[890]: bound to 192.168.1.100',
                                'Jun  8 10:20:00 debian-bookworm cron[920]: (root) CMD (test -x /etc/cron.daily/popularity-contest)',
                                'Jun  8 10:22:14 debian-bookworm sshd[1024]: Accepted publickey for student',
                                'Jun  8 10:30:00 debian-bookworm systemd[1]: Starting apt-daily.service',
                                'Jun  8 10:30:12 debian-bookworm apt[1080]: Starting pkgProblemResolver',
                                'Jun  8 10:30:15 debian-bookworm apt[1080]: Finished pkgsToUpgrade',
                                'Jun  8 10:45:22 debian-bookworm sshd[1150]: Failed password for root from 10.0.0.99',
                                'Jun  8 10:45:28 debian-bookworm sshd[1154]: Failed password for root from 10.0.0.99',
                                'Jun  8 10:45:30 debian-bookworm sshd[1156]: error: max auth attempts exceeded for root',
                                'Jun  8 11:00:00 debian-bookworm systemd[1]: Starting systemd-resolved.service',
                                'Jun  8 11:05:00 debian-bookworm postfix/postfix-script[1300]: starting Postfix mail system',
                                'Jun  8 11:05:01 debian-bookworm postfix/master[1302]: daemon started'
                            )
                        }
                        'auth_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'Jun  8 10:15:22 debian-bookworm sshd[856]: Server listening on 0.0.0.0 port 22.',
                                'Jun  8 10:22:10 debian-bookworm sshd[1020]: Connection from 192.168.1.50 port 45222',
                                'Jun  8 10:22:12 debian-bookworm sshd[1022]: Accepted publickey for student from 192.168.1.50',
                                'Jun  8 10:22:12 debian-bookworm sshd[1022]: session opened for user student',
                                'Jun  8 10:30:00 debian-bookworm sudo[1078]: student : TTY=pts/0 PWD=/home/student USER=root COMMAND=/usr/bin/apt update',
                                'Jun  8 10:45:20 debian-bookworm sshd[1150]: Failed password for root from 10.0.0.99 port 53422 ssh2',
                                'Jun  8 10:45:22 debian-bookworm sshd[1152]: Failed password for root from 10.0.0.99 port 53424 ssh2',
                                'Jun  8 10:45:25 debian-bookworm sshd[1154]: Failed password for root from 10.0.0.99 port 53426 ssh2',
                                'Jun  8 10:45:30 debian-bookworm sshd[1156]: Failed password for root from 10.0.0.99 port 53428 ssh2',
                                'Jun  8 10:45:32 debian-bookworm sshd[1156]: error: maximum authentication attempts exceeded',
                                'Jun  8 10:45:32 debian-bookworm sshd[1156]: Disconnecting from 10.0.0.99',
                                'Jun  8 10:50:00 debian-bookworm sudo[1200]: student : USER=root COMMAND=/usr/bin/systemctl restart sshd',
                                'Jun  8 11:00:00 debian-bookworm sshd[1250]: Accepted publickey for student from 192.168.1.50'
                            )
                        }
                        'mail_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'Jun  8 10:15:24 debian-bookworm exim4[860]: Setting up exim4 configuration',
                                'Jun  8 10:15:25 debian-bookworm exim4[861]: Configuration complete',
                                'Jun  8 11:05:00 debian-bookworm postfix/postfix-script[1300]: starting Postfix',
                                'Jun  8 11:05:01 debian-bookworm postfix/master[1302]: daemon started',
                                'Jun  8 11:05:02 debian-bookworm postfix/smtpd[1304]: connect from localhost[127.0.0.1]',
                                'Jun  8 11:05:03 debian-bookworm postfix/smtpd[1304]: warning: hostname localhost does not resolve',
                                'Jun  8 11:05:05 debian-bookworm postfix/smtpd[1304]: disconnect from localhost[127.0.0.1]',
                                'Jun  8 11:10:00 debian-bookworm postfix/qmgr[1303]: A1B2C3D4: from=<root@debian-bookworm>, size=450',
                                'Jun  8 11:10:00 debian-bookworm postfix/qmgr[1303]: A1B2C3D4: to=<student@debian-bookworm>, relay=local',
                                'Jun  8 11:10:00 debian-bookworm postfix/local[1310]: A1B2C3D4: delivered to mailbox',
                                'Jun  8 11:10:00 debian-bookworm postfix/qmgr[1303]: A1B2C3D4: removed',
                                'Jun  8 11:15:00 debian-bookworm exim4[1350]: Start queue run: pid 1350',
                                'Jun  8 11:15:00 debian-bookworm exim4[1350]: End queue run: pid 1350'
                            )
                        }
                    }
                }
                'spool' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'mail' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'mail'
                            Children = @{}
                        }
                    }
                }
            }
        }
        'usr' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'lib' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'firmware' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'iwlwifi-5000-5_fw' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '# Non-free firmware placeholder',
                                        '# iwlwifi-5000 firmware for Intel WiFi'
                                    )
                                }
                            }
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
            Id = 'debian-b1'
            Title = 'List files in home directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls -la'
            Description = @(
                'List all files and directories in your home folder,',
                'including hidden files with detailed information.'
            )
            Hint = 'Try: ls -la ~'
        }
        @{
            Id = 'debian-b2'
            Title = 'Show current directory path'
            Difficulty = 'beginner'
            ExpectedCommand = 'pwd'
            Description = @(
                'Print the full path of your current working directory.',
                'Verify you are in the expected location.'
            )
            Hint = 'Type pwd and press Enter'
        }
        @{
            Id = 'debian-b3'
            Title = 'Create a new directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'mkdir data'
            Description = @(
                'Create a new directory called "data" in your current location.',
                'Directories help organize files in Linux.'
            )
            Hint = 'Use: mkdir data'
        }
        @{
            Id = 'debian-b4'
            Title = 'Create an empty file'
            Difficulty = 'beginner'
            ExpectedCommand = 'touch newfile.txt'
            Description = @(
                'Create an empty file named "newfile.txt" using the touch command.',
                'Touch creates a file if it does not exist.'
            )
            Hint = 'Use: touch newfile.txt'
        }
        @{
            Id = 'debian-b5'
            Title = 'Copy the hostname file'
            Difficulty = 'beginner'
            ExpectedCommand = 'cp /etc/hostname .'
            Description = @(
                'Copy the system hostname file to your current directory.',
                'The dot represents your current working directory.'
            )
            Hint = 'Use: cp /etc/hostname .'
        }
        @{
            Id = 'debian-i1'
            Title = 'View OS release information'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/os-release'
            Description = @(
                'Display the contents of /etc/os-release to see which',
                'version of Debian is installed on this system.'
            )
            Hint = 'Use: cat /etc/os-release'
        }
        @{
            Id = 'debian-i2'
            Title = 'Search syslog for SSH entries'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep sshd /var/log/syslog'
            Description = @(
                'Search the system log for all lines containing "sshd".',
                'This shows SSH daemon events from the system log.'
            )
            Hint = 'Use: grep sshd /var/log/syslog'
        }
        @{
            Id = 'debian-i3'
            Title = 'Check disk space usage'
            Difficulty = 'intermediate'
            ExpectedCommand = 'df -h'
            Description = @(
                'Show disk space usage in human-readable format.',
                'The -h flag shows sizes in MB and GB.'
            )
            Hint = 'Use: df -h'
        }
        @{
            Id = 'debian-i4'
            Title = 'List all running processes'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ps aux'
            Description = @(
                'Display all running processes on the system.',
                'ps aux shows every process with user, CPU, and memory info.'
            )
            Hint = 'Use: ps aux'
        }
        @{
            Id = 'debian-i5'
            Title = 'View APT sources list'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/apt/sources.list'
            Description = @(
                'Display the apt package repository configuration.',
                'This file defines where the system downloads Debian packages from.'
            )
            Hint = 'Use: cat /etc/apt/sources.list'
        }
        @{
            Id = 'debian-a1'
            Title = 'Check SSH service status'
            Difficulty = 'advanced'
            ExpectedCommand = 'systemctl status sshd'
            Description = @(
                'Check whether the SSH daemon is running and enabled.',
                'Use systemctl to inspect service state on this Debian system.'
            )
            Hint = 'Use: systemctl status sshd'
        }
        @{
            Id = 'debian-a2'
            Title = 'Find configuration files'
            Difficulty = 'advanced'
            ExpectedCommand = 'find /etc -name "*.conf"'
            Description = @(
                'Find all .conf files under /etc/ using the find command.',
                'This is a common way to locate configuration files on Linux.'
            )
            Hint = 'Use: find /etc -name "*.conf"'
        }
        @{
            Id = 'debian-a3'
            Title = 'Display network interfaces config'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/network/interfaces'
            Description = @(
                'Show the Debian network interfaces configuration file.',
                'Debian uses /etc/network/interfaces for traditional network setup.'
            )
            Hint = 'Use: cat /etc/network/interfaces'
        }
        @{
            Id = 'debian-a4'
            Title = 'View GRUB bootloader config'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/default/grub'
            Description = @(
                'Display the GRUB bootloader configuration file.',
                'This file controls boot parameters and timeout settings.'
            )
            Hint = 'Use: cat /etc/default/grub'
        }
        @{
            Id = 'debian-a5'
            Title = 'View recent journal logs'
            Difficulty = 'advanced'
            ExpectedCommand = 'journalctl -n 15'
            Description = @(
                'View the last 15 entries from the systemd journal.',
                'The journal collects logs from all system services.'
            )
            Hint = 'Use: journalctl -n 15'
        }
        @{
            Id = 'debian-e1'
            Title = 'Find failed SSH login attempts'
            Difficulty = 'expert'
            ExpectedCommand = 'grep "Failed password" /var/log/auth.log'
            Description = @(
                'Search the authentication log for failed password attempts.',
                'This is essential for security auditing and detecting brute force attacks.'
            )
            Hint = 'Use: grep "Failed password" /var/log/auth.log'
        }
        @{
            Id = 'debian-e2'
            Title = 'List all installed packages with dpkg'
            Difficulty = 'expert'
            ExpectedCommand = 'dpkg-query -W'
            Description = @(
                'List all installed packages using dpkg-query.',
                'This queries the dpkg database and shows all installed software.'
            )
            Hint = 'Use: dpkg-query -W'
        }
        @{
            Id = 'debian-e3'
            Title = 'Create a compressed archive'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf backup.tar.gz /home/student'
            Description = @(
                'Create a gzip-compressed tar archive of the home directory.',
                'The -czf flags create, compress, and specify the output filename.'
            )
            Hint = 'Use: tar -czf backup.tar.gz /home/student'
        }
        @{
            Id = 'debian-e4'
            Title = 'Check apt package policy'
            Difficulty = 'expert'
            ExpectedCommand = 'apt-cache policy nginx'
            Description = @(
                'Show the package policy for nginx using apt-cache.',
                'This displays version info, priority, and available sources for a package.'
            )
            Hint = 'Use: apt-cache policy nginx'
        }
        @{
            Id = 'debian-e5'
            Title = 'List non-free firmware files'
            Difficulty = 'expert'
            ExpectedCommand = 'find /usr/lib/firmware -type f'
            Description = @(
                'List all firmware files in /usr/lib/firmware.',
                'Debian separates non-free firmware, and this path contains hardware blobs.'
            )
            Hint = 'Use: find /usr/lib/firmware -type f'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
