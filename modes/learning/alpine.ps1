function Get-LearningContent-alpine {
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
                        'docs' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'student'
                            Children = @{
                                'alpine_notes_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        'Alpine Linux 3.20 - Lightweight Linux',
                                        'Init system: OpenRC (not systemd)',
                                        'Package manager: apk',
                                        'C library: musl (not glibc)',
                                        'Shell: ash (not bash by default)',
                                        'Coreutils: Busybox (multi-call binary)',
                                        'Size: ~5MB base install',
                                        'Kernel: 6.6 LTS'
                                    )
                                }
                                'todo_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        'Alpine Learning Tasks',
                                        '- Understand OpenRC service management (rc-service, rc-update)',
                                        '- Practice apk package management',
                                        '- Learn ash shell basics',
                                        '- Explore Busybox applets',
                                        '- Configure network on Alpine'
                                    )
                                }
                            }
                        }
                        '.profile' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# Alpine Linux /home/student/.profile',
                                '# Ash shell profile',
                                '',
                                'export ENV=$HOME/.shinit',
                                'export PATH=$PATH:/usr/local/bin',
                                '',
                                'if [ -f "$HOME/.shinit" ]; then',
                                '    . "$HOME/.shinit"',
                                'fi'
                            )
                        }
                        '.shinit' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# Alpine /home/student/.shinit',
                                '# Ash shell init (equivalent to .bashrc)',
                                '',
                                'alias ll="ls -alF"',
                                'alias la="ls -A"',
                                'alias l="ls -CF"',
                                'alias grep="grep --color=auto"'
                            )
                        }
                        'readme_txt' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                'Ultra Matrix Terminal - Alpine Linux 3.20 Learning Mode',
                                '',
                                'Alpine Linux is a security-oriented, lightweight Linux distribution',
                                'based on musl libc and busybox.',
                                '',
                                'Key differences from Debian/Ubuntu:',
                                '- OpenRC init system (not systemd)',
                                '- apk package manager (not apt)',
                                '- ash shell (not bash)',
                                '- musl libc (not glibc)',
                                '- Busybox provides standard Unix utilities',
                                '',
                                'Learn the Alpine way!'
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
                        'NAME="Alpine Linux"',
                        'ID=alpine',
                        'VERSION_ID=3.20.0',
                        'PRETTY_NAME="Alpine Linux 3.20.0"',
                        'HOME_URL="https://alpinelinux.org/"',
                        'BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"'
                    )
                }
                'alpine-release' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '3.20.0'
                    )
                }
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'alpine-box'
                    )
                }
                'hosts' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '127.0.0.1 localhost',
                        '127.0.1.1 alpine-box',
                        '',
                        '::1     localhost ip6-localhost ip6-loopback'
                    )
                }
                'motd' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'Welcome to Alpine Linux 3.20',
                        'Kernel 6.6.x on x86_64',
                        '',
                        'You are in Ultra Matrix Terminal - Learning Mode',
                        'Type "help" to see available commands.'
                    )
                }
                'apk' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'repositories' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/apk/repositories',
                                '# Alpine Linux 3.20 repositories',
                                '',
                                'https://dl-cdn.alpinelinux.org/alpine/v3.20/main',
                                'https://dl-cdn.alpinelinux.org/alpine/v3.20/community',
                                '',
                                '# Testing repository (unstable)',
                                '#https://dl-cdn.alpinelinux.org/alpine/v3.20/testing'
                            )
                        }
                    }
                }
                'inittab' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# /etc/inittab - Alpine Linux init configuration',
                        '',
                        '::sysinit:/sbin/openrc sysinit',
                        '::sysinit:/sbin/openrc boot',
                        '::wait:/sbin/openrc default',
                        '',
                        '# Set up a Getty on each virtual console',
                        'tty1::respawn:/sbin/getty 38400 tty1',
                        'tty2::respawn:/sbin/getty 38400 tty2',
                        'tty3::respawn:/sbin/getty 38400 tty3',
                        'tty4::respawn:/sbin/getty 38400 tty4',
                        'tty5::respawn:/sbin/getty 38400 tty5',
                        'tty6::respawn:/sbin/getty 38400 tty6',
                        '',
                        '# CTRL-ALT-DELETE handling',
                        '::ctrlaltdel:/sbin/reboot',
                        '',
                        '# Shutdown',
                        '::shutdown:/sbin/openrc shutdown'
                    )
                }
                'init_d' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'sshd' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/sbin/openrc-run',
                                '# OpenRC service for OpenSSH SSH daemon',
                                '',
                                'description="OpenSSH SSH daemon"',
                                '',
                                'command="/usr/sbin/sshd"',
                                'command_args=""',
                                'pidfile="/run/sshd.pid"',
                                'command_background=true',
                                '',
                                'depend() {',
                                '    need net',
                                '    use dns logger',
                                '}'
                            )
                        }
                        'networking' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/sbin/openrc-run',
                                '# OpenRC service for network interfaces',
                                '',
                                'description="Network interfaces"',
                                '',
                                'depend() {',
                                '    need localmount',
                                '    after bootmisc',
                                '}'
                            )
                        }
                        'syslogd' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/sbin/openrc-run',
                                '# OpenRC service for syslog daemon',
                                '',
                                'description="System logger"',
                                'supervisor="supervise-daemon"',
                                'command="/sbin/syslogd"',
                                'command_args="-s 2048"',
                                '',
                                'depend() {',
                                '    need net',
                                '}'
                            )
                        }
                    }
                }
                'conf_d' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'hostname' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/conf.d/hostname',
                                '# Hostname configuration for OpenRC',
                                '',
                                'hostname="alpine-box"'
                            )
                        }
                        'syslog' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '# /etc/conf.d/syslog',
                                '# Syslog daemon configuration',
                                '',
                                'SYSLOGD_OPTS="-s 2048 -b 10"',
                                'KLOGD_OPTS=""'
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
                                '# /etc/network/interfaces - Alpine network config',
                                '',
                                'auto lo',
                                'iface lo inet loopback',
                                '',
                                'auto eth0',
                                'iface eth0 inet dhcp'
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
                        'messages' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                'Jun  8 10:15:20 alpine-box kern.info kernel: Linux version 6.6.32-0-alpine',
                                'Jun  8 10:15:20 alpine-box kern.info kernel: Mounting root filesystem',
                                'Jun  8 10:15:21 alpine-box user.info syslogd: starting',
                                'Jun  8 10:15:22 alpine-box user.info openrc: starting sysinit',
                                'Jun  8 10:15:23 alpine-box user.info openrc: starting boot',
                                'Jun  8 10:15:24 alpine-box user.info openrc: starting networking',
                                'Jun  8 10:15:25 alpine-box daemon.info sshd[98]: Server listening on 0.0.0.0 port 22',
                                'Jun  8 10:15:25 alpine-box user.info openrc: starting sshd',
                                'Jun  8 10:15:26 alpine-box user.info openrc: starting syslogd',
                                'Jun  8 10:15:30 alpine-box auth.info sshd[102]: Accepted publickey for student from 192.168.1.50',
                                'Jun  8 10:16:00 alpine-box kern.info kernel: eth0: link up, 1000Mbps, full duplex',
                                'Jun  8 10:16:05 alpine-box user.info dhcp: eth0: leased 192.168.1.100 for 86400 seconds',
                                'Jun  8 10:20:00 alpine-box cron.info crond[135]: crond: started',
                                'Jun  8 10:30:00 alpine-box user.info apk[200]: upgrading openssl: 3.3.0-r0 -> 3.3.1-r0',
                                'Jun  8 10:30:05 alpine-box user.info apk[200]: upgrading busybox: 1.36.1-r0 -> 1.36.1-r1',
                                'Jun  8 10:45:22 alpine-box auth.err sshd[250]: Failed password for root from 10.0.0.99',
                                'Jun  8 10:45:25 alpine-box auth.err sshd[252]: Failed password for root from 10.0.0.99',
                                'Jun  8 10:45:28 alpine-box auth.err sshd[254]: error: max auth attempts exceeded for root',
                                'Jun  8 11:00:00 alpine-box user.info crond[300]: (root) CMD (run-parts /etc/periodic/hourly)'
                            )
                        }
                        'dmesg' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '[    0.000000] Linux version 6.6.32-0-alpine',
                                '[    0.000000] Available memory: 2048MB',
                                '[    0.000000] Kernel command line: console=tty0 root=/dev/sda1',
                                '[    0.010000] DMI: QEMU Standard PC (i440FX + PIIX, 1996)',
                                '[    0.020000] smpboot: CPU0: Intel QEMU Virtual CPU',
                                '[    0.030000] PCI: Using configuration type 1',
                                '[    0.040000] usbcore: registered new interface driver usbfs',
                                '[    0.050000] ACPI: Interpreter enabled',
                                '[    0.500000] SCSI subsystem initialized',
                                '[    1.000000] random: crng init done',
                                '[    1.200000] EXT4-fs (sda1): mounted filesystem with ordered data mode',
                                '[    1.500000] eth0: link up, 1000Mbps, full duplex'
                            )
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
        }
        'bin' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'busybox' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# Busybox multi-call binary placeholder',
                        '# This file represents /bin/busybox on Alpine',
                        '# Busybox provides: sh, ls, cp, mv, cat, grep, etc.'
                    )
                }
                'sh' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# /bin/sh -> /bin/busybox',
                        '# On Alpine, /bin/sh is a symlink to busybox (ash shell)'
                    )
                }
            }
        }
        'sbin' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'openrc' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# /sbin/openrc - OpenRC init system',
                        '# Manages services on Alpine Linux'
                    )
                }
                'rc-update' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# /sbin/rc-update - OpenRC service manager',
                        '# Used to add/remove services from runlevels'
                    )
                }
                'rc-service' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '# /sbin/rc-service - OpenRC service control',
                        '# Used to start/stop/restart services'
                    )
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
            Id = 'alpine-b1'
            Title = 'List files in home directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls -la'
            Description = @(
                'List all files in your home directory with details.',
                'Alpine uses Busybox ls, which supports standard flags.'
            )
            Hint = 'Try: ls -la ~'
        }
        @{
            Id = 'alpine-b2'
            Title = 'Show current directory path'
            Difficulty = 'beginner'
            ExpectedCommand = 'pwd'
            Description = @(
                'Print the working directory path.',
                'This shows your current location in the filesystem.'
            )
            Hint = 'Type pwd and press Enter'
        }
        @{
            Id = 'alpine-b3'
            Title = 'Create a directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'mkdir myproject'
            Description = @(
                'Create a new directory called "myproject".',
                'Busybox mkdir works the same as GNU mkdir for basic usage.'
            )
            Hint = 'Use: mkdir myproject'
        }
        @{
            Id = 'alpine-b4'
            Title = 'Create an empty file'
            Difficulty = 'beginner'
            ExpectedCommand = 'touch readme.md'
            Description = @(
                'Create an empty file named "readme.md" using touch.',
                'Busybox touch is a minimal implementation but works for file creation.'
            )
            Hint = 'Use: touch readme.md'
        }
        @{
            Id = 'alpine-b5'
            Title = 'Display the hostname'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /etc/hostname'
            Description = @(
                'Display the system hostname from /etc/hostname.',
                'Confirm you are on the Alpine system named alpine-box.'
            )
            Hint = 'Use: cat /etc/hostname'
        }
        @{
            Id = 'alpine-i1'
            Title = 'View Alpine OS release info'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/os-release'
            Description = @(
                'Display the Alpine Linux version information.',
                'Alpine 3.20 uses musl libc and Busybox utilities.'
            )
            Hint = 'Use: cat /etc/os-release'
        }
        @{
            Id = 'alpine-i2'
            Title = 'Check package repositories'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/apk/repositories'
            Description = @(
                'Show the Alpine package repository configuration.',
                'Alpine uses apk and repositories are defined in /etc/apk/repositories.'
            )
            Hint = 'Use: cat /etc/apk/repositories'
        }
        @{
            Id = 'alpine-i3'
            Title = 'View system messages log'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /var/log/messages'
            Description = @(
                'Display the system log messages.',
                'Alpine uses traditional syslogd, not systemd-journald.'
            )
            Hint = 'Use: cat /var/log/messages'
        }
        @{
            Id = 'alpine-i4'
            Title = 'Check disk space'
            Difficulty = 'intermediate'
            ExpectedCommand = 'df -h'
            Description = @(
                'Show disk space usage in human-readable format.',
                'Busybox df supports -h for human-readable output.'
            )
            Hint = 'Use: df -h'
        }
        @{
            Id = 'alpine-i5'
            Title = 'List running processes'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ps aux'
            Description = @(
                'Show all running processes on the system.',
                'Busybox ps supports the aux flags for full process listing.'
            )
            Hint = 'Use: ps aux'
        }
        @{
            Id = 'alpine-a1'
            Title = 'Check SSH daemon status with OpenRC'
            Difficulty = 'advanced'
            ExpectedCommand = 'rc-service sshd status'
            Description = @(
                'Check the status of the SSH daemon using OpenRC.',
                'Alpine does not use systemctl; rc-service is the equivalent.'
            )
            Hint = 'Use: rc-service sshd status'
        }
        @{
            Id = 'alpine-a2'
            Title = 'List enabled OpenRC services'
            Difficulty = 'advanced'
            ExpectedCommand = 'rc-update show'
            Description = @(
                'Show all services registered with OpenRC and their runlevels.',
                'rc-update manages which services start at boot.'
            )
            Hint = 'Use: rc-update show'
        }
        @{
            Id = 'alpine-a3'
            Title = 'Update Alpine package index'
            Difficulty = 'advanced'
            ExpectedCommand = 'apk update'
            Description = @(
                'Update the apk package repository index.',
                'This fetches the latest package list from Alpine repositories.'
            )
            Hint = 'Use: apk update'
        }
        @{
            Id = 'alpine-a4'
            Title = 'View init system configuration'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/inittab'
            Description = @(
                'Display the /etc/inittab file that configures the init system.',
                'Alpine uses a traditional inittab-based init with OpenRC.'
            )
            Hint = 'Use: cat /etc/inittab'
        }
        @{
            Id = 'alpine-a5'
            Title = 'Search for packages'
            Difficulty = 'advanced'
            ExpectedCommand = 'apk search openssh'
            Description = @(
                'Search for packages matching "openssh" using apk.',
                'This shows available SSH-related packages in Alpine repositories.'
            )
            Hint = 'Use: apk search openssh'
        }
        @{
            Id = 'alpine-e1'
            Title = 'Show hostname configuration'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /etc/conf.d/hostname'
            Description = @(
                'Display the OpenRC hostname configuration.',
                'Alpine stores service configuration in /etc/conf.d/ rather than /etc/default/.'
            )
            Hint = 'Use: cat /etc/conf.d/hostname'
        }
        @{
            Id = 'alpine-e2'
            Title = 'List all OpenRC services with details'
            Difficulty = 'expert'
            ExpectedCommand = 'rc-update -v show'
            Description = @(
                'Show all services managed by OpenRC with verbose output.',
                'The -v flag shows additional details about each service.'
            )
            Hint = 'Use: rc-update -v show'
        }
        @{
            Id = 'alpine-e3'
            Title = 'List Busybox applets'
            Difficulty = 'expert'
            ExpectedCommand = 'busybox --list'
            Description = @(
                'List all available Busybox applets (built-in commands).',
                'Busybox combines many Unix utilities into a single binary.'
            )
            Hint = 'Use: busybox --list'
        }
        @{
            Id = 'alpine-e4'
            Title = 'Filter kernel messages from syslog'
            Difficulty = 'expert'
            ExpectedCommand = 'grep kernel /var/log/messages'
            Description = @(
                'Search for kernel-related messages in the system log.',
                'This shows boot messages and kernel events on Alpine.'
            )
            Hint = 'Use: grep kernel /var/log/messages'
        }
        @{
            Id = 'alpine-e5'
            Title = 'Show installed package info'
            Difficulty = 'expert'
            ExpectedCommand = 'apk info -vv busybox'
            Description = @(
                'Display detailed information about the busybox package.',
                'The -vv flag shows the full package description and dependencies.'
            )
            Hint = 'Use: apk info -vv busybox'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
