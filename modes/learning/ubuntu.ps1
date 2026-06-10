function Get-LearningContent-ubuntu {
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
                                        'Ubuntu Server LTS Study Plan',
                                        '- Review systemd service management (systemctl)',
                                        '- Practice log analysis with grep and journalctl',
                                        '- Configure nginx virtual hosts',
                                        '- Set up netplan network bonding',
                                        '- Schedule cron jobs for log rotation'
                                    )
                                }
                                'notes_txt' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        'Ubuntu 24.04 LTS (Noble Numbat)',
                                        'Kernel: 6.8-generic',
                                        'Default filesystem: ext4',
                                        'Init system: systemd v255',
                                        'Python: 3.12',
                                        'Snapd: pre-installed',
                                        'Netplan: default network configurator',
                                        'Firewall: ufw (Uncomplicated Firewall)'
                                    )
                                }
                            }
                        }
                        'projects' = @{
                            Type = 'dir'
                            Owner = 'student'
                            Group = 'student'
                            Children = @{
                                'hello_py' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        '#!/usr/bin/env python3',
                                        'print("Hello from Ubuntu 24.04 LTS!")',
                                        '',
                                        'import os, sys',
                                        'print(f"Python {sys.version}")',
                                        'print(f"Running on {os.uname().sysname} {os.uname().release}")'
                                    )
                                }
                                'setup_sh' = @{
                                    Type = 'file'
                                    Owner = 'student'
                                    Group = 'student'
                                    Content = @(
                                        '#!/bin/bash',
                                        '# Setup script for web dev environment',
                                        'echo "Updating package lists..."',
                                        'sudo apt update',
                                        'echo "Installing nginx..."',
                                        'sudo apt install -y nginx',
                                        'echo "Starting nginx..."',
                                        'sudo systemctl start nginx',
                                        'echo "Done."'
                                    )
                                }
                            }
                        }
                        '.bashrc' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# ~/.bashrc: executed by bash for non-login shells.',
                                'export PS1=''u@h:w$ '''
                                'alias ll=''ls -alF''',
                                'alias la=''ls -A''',
                                'alias l=''ls -CF''',
                                'alias grep=''grep --color=auto''',
                                'export EDITOR=nano',
                                'export PATH=$PATH:$HOME/.local/bin'
                            )
                        }
                        '.profile' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# ~/.profile: executed by Bourne-compatible login shells.',
                                'if [ "$BASH" ]; then',
                                '  if [ -f ~/.bashrc ]; then',
                                '    . ~/.bashrc',
                                '  fi',
                                'fi',
                                'mesg n 2> /dev/null || true'
                            )
                        }
                        '.bash_logout' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                '# ~/.bash_logout: executed by bash when login shell exits.',
                                'if [ -f /usr/bin/clear_console ]; then',
                                '    /usr/bin/clear_console -q',
                                'fi'
                            )
                        }
                        'readme_txt' = @{
                            Type = 'file'
                            Owner = 'student'
                            Group = 'student'
                            Content = @(
                                'Ultra Matrix Terminal - Ubuntu 24.04 LTS Learning Mode',
                                '',
                                'This environment simulates a real Ubuntu Server 24.04 system.',
                                '',
                                'Available tools: bash, python3, git, curl, vim, nano',
                                'System services: nginx, sshd, systemd-journald, cron',
                                'Package manager: apt',
                                '',
                                'Student user has full sudo privileges.',
                                'Practice your Linux system administration skills!'
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
                        'PRETTY_NAME="Ubuntu 24.04 LTS"',
                        'NAME="Ubuntu"',
                        'VERSION_ID="24.04"',
                        'VERSION="24.04 LTS (Noble Numbat)"',
                        'VERSION_CODENAME=noble',
                        'ID=ubuntu',
                        'ID_LIKE=debian',
                        'HOME_URL="https://www.ubuntu.com/"',
                        'SUPPORT_URL="https://help.ubuntu.com/"',
                        'BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"',
                        'PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"',
                        'UBUNTU_CODENAME=noble',
                        'LOGO=ubuntu-logo'
                    )
                }
                'lsb-release' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'DISTRIB_ID=Ubuntu',
                        'DISTRIB_RELEASE=24.04',
                        'DISTRIB_CODENAME=noble',
                        'DISTRIB_DESCRIPTION="Ubuntu 24.04 LTS"'
                    )
                }
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'ubuntu-noble'
                    )
                }
                'hosts' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        '127.0.0.1 localhost',
                        '127.0.1.1 ubuntu-noble',
                        '',
                        '# The following lines are for IPv6 capable hosts',
                        '::1     ip6-localhost ip6-loopback',
                        'fe00::0 ip6-localnet',
                        'ff02::1 ip6-allnodes',
                        'ff02::2 ip6-allrouters'
                    )
                }
                'apt' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'sources.list.d' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'ubuntu_sources' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        'Types: deb',
                                        'URIs: http://archive.ubuntu.com/ubuntu/',
                                        'Suites: noble noble-updates noble-backports',
                                        'Components: main restricted universe multiverse',
                                        'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg',
                                        '',
                                        'Types: deb',
                                        'URIs: http://security.ubuntu.com/ubuntu/',
                                        'Suites: noble-security',
                                        'Components: main restricted universe multiverse',
                                        'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg'
                                    )
                                }
                            }
                        }
                    }
                }
                'netplan' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        '01-netcfg_yaml' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                'network:',
                                '  version: 2',
                                '  renderer: networkd',
                                '  ethernets:',
                                '    eth0:',
                                '      dhcp4: true',
                                '      dhcp6: false',
                                '      addresses:',
                                '        - 192.168.1.100/24',
                                '      routes:',
                                '        - to: default',
                                '          via: 192.168.1.1',
                                '      nameservers:',
                                '        addresses:',
                                '          - 8.8.8.8',
                                '          - 1.1.1.1'
                            )
                        }
                    }
                }
                'nginx' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'nginx_conf' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                'user www-data;',
                                'worker_processes auto;',
                                'pid /run/nginx.pid;',
                                'include /etc/nginx/modules-enabled/*.conf;',
                                '',
                                'events {',
                                '    worker_connections 768;',
                                '    multi_accept on;',
                                '}',
                                '',
                                'http {',
                                '    sendfile on;',
                                '    tcp_nopush on;',
                                '    tcp_nodelay on;',
                                '    keepalive_timeout 65;',
                                '    types_hash_max_size 2048;',
                                '    include /etc/nginx/mime.types;',
                                '    default_type application/octet-stream;',
                                '',
                                '    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;',
                                '    ssl_prefer_server_ciphers on;',
                                '    access_log /var/log/nginx/access.log;',
                                '    error_log /var/log/nginx/error.log;',
                                '',
                                '    gzip on;',
                                '    gzip_vary on;',
                                '',
                                '    include /etc/nginx/conf.d/*.conf;',
                                '    include /etc/nginx/sites-enabled/*;',
                                '}'
                            )
                        }
                        'sites-available' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'default' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        'server {',
                                        '    listen 80 default_server;',
                                        '    listen [::]:80 default_server;',
                                        '    root /var/www/html;',
                                        '    index index.html index.htm index.nginx-debian.html;',
                                        '    server_name _;',
                                        '    location / {',
                                        '        try_files $uri $uri/ =404;',
                                        '    }',
                                        '}'
                                    )
                                }
                            }
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
                                '# If you change this file, run update-grub to rebuild',
                                'GRUB_DEFAULT=0',
                                'GRUB_TIMEOUT=5',
                                'GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`',
                                'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"',
                                'GRUB_CMDLINE_LINUX=""',
                                'GRUB_GFXMODE=1920x1080',
                                'GRUB_DISABLE_OS_PROBER=false'
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
                                'Jun  8 10:15:23 ubuntu-noble systemd[1]: Started User Login Management.',
                                'Jun  8 10:15:23 ubuntu-noble systemd[1]: Started System Logging Service.',
                                'Jun  8 10:15:25 ubuntu-noble nginx[856]: Starting nginx: OK.',
                                'Jun  8 10:15:25 ubuntu-noble sshd[857]: Server listening on 0.0.0.0 port 22.',
                                'Jun  8 10:15:30 ubuntu-noble kernel: Linux version 6.8.0-22-generic',
                                'Jun  8 10:16:00 ubuntu-noble systemd[1]: Started Network Manager.',
                                'Jun  8 10:16:05 ubuntu-noble dhclient[890]: DHCPREQUEST on eth0 to 192.168.1.1',
                                'Jun  8 10:16:05 ubuntu-noble dhclient[890]: DHCPACK from 192.168.1.1',
                                'Jun  8 10:16:05 ubuntu-noble dhclient[890]: bound to 192.168.1.100',
                                'Jun  8 10:20:00 ubuntu-noble cron[920]: (root) CMD (test -x /etc/cron.daily/popularity-contest)',
                                'Jun  8 10:22:14 ubuntu-noble sshd[1024]: Accepted publickey for student from 192.168.1.50',
                                'Jun  8 10:25:30 ubuntu-noble nginx[1050]: 192.168.1.50 GET / HTTP/1.1 200 612',
                                'Jun  8 10:30:00 ubuntu-noble systemd[1]: Starting apt-daily.service',
                                'Jun  8 10:30:12 ubuntu-noble apt[1080]: Starting pkgProblemResolver',
                                'Jun  8 10:30:15 ubuntu-noble apt[1080]: Finished pkgsToUpgrade',
                                'Jun  8 10:45:22 ubuntu-noble sshd[1150]: Failed password for root from 10.0.0.99 port 53422',
                                'Jun  8 10:45:25 ubuntu-noble sshd[1152]: Failed password for root from 10.0.0.99 port 53424',
                                'Jun  8 10:45:28 ubuntu-noble sshd[1154]: Failed password for root from 10.0.0.99 port 53426',
                                'Jun  8 10:45:30 ubuntu-noble sshd[1156]: error: maximum authentication attempts exceeded',
                                'Jun  8 11:00:00 ubuntu-noble systemd[1]: Starting systemd-resolved.service'
                            )
                        }
                        'auth_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'Jun  8 10:15:22 ubuntu-noble sshd[856]: Server listening on 0.0.0.0 port 22.',
                                'Jun  8 10:22:10 ubuntu-noble sshd[1020]: Connection from 192.168.1.50 port 45222',
                                'Jun  8 10:22:12 ubuntu-noble sshd[1022]: Accepted publickey for student from 192.168.1.50 port 45222',
                                'Jun  8 10:22:12 ubuntu-noble sshd[1022]: session opened for user student by (uid=0)',
                                'Jun  8 10:30:00 ubuntu-noble sudo[1078]: student : TTY=pts/0 PWD=/home/student USER=root COMMAND=/usr/bin/apt update',
                                'Jun  8 10:30:00 ubuntu-noble sudo[1078]: pam_unix(sudo:session): session opened for user root',
                                'Jun  8 10:45:20 ubuntu-noble sshd[1150]: Failed password for root from 10.0.0.99 port 53422 ssh2',
                                'Jun  8 10:45:22 ubuntu-noble sshd[1152]: Failed password for root from 10.0.0.99 port 53424 ssh2',
                                'Jun  8 10:45:25 ubuntu-noble sshd[1154]: Failed password for root from 10.0.0.99 port 53426 ssh2',
                                'Jun  8 10:45:28 ubuntu-noble sshd[1156]: Connection from 10.0.0.99 port 53428',
                                'Jun  8 10:45:30 ubuntu-noble sshd[1156]: Failed password for root from 10.0.0.99 port 53428 ssh2',
                                'Jun  8 10:45:32 ubuntu-noble sshd[1156]: error: maximum authentication attempts exceeded for root',
                                'Jun  8 10:45:32 ubuntu-noble sshd[1156]: Disconnecting from 10.0.0.99 port 53428',
                                'Jun  8 10:50:00 ubuntu-noble sudo[1200]: student : TTY=pts/0 PWD=/home/student USER=root COMMAND=/usr/bin/systemctl restart nginx',
                                'Jun  8 10:50:05 ubuntu-noble sudo[1200]: pam_unix(sudo:session): session closed for user root',
                                'Jun  8 11:00:00 ubuntu-noble sshd[1250]: Accepted publickey for student from 192.168.1.50 port 45300',
                                'Jun  8 11:00:00 ubuntu-noble sshd[1250]: session opened for user student by (uid=0)'
                            )
                        }
                        'dpkg_log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                '2026-06-05 14:30:00 install nginx-core:amd64 1.24.0-2ubuntu7',
                                '2026-06-05 14:30:01 status installed nginx-core:amd64 1.24.0-2ubuntu7',
                                '2026-06-05 14:30:02 configure nginx-common:amd64 1.24.0-2ubuntu7',
                                '2026-06-05 14:30:03 status installed nginx:amd64 1.24.0-2ubuntu7',
                                '2026-06-05 14:35:00 install openssh-server:amd64 9.6p1-3ubuntu13',
                                '2026-06-05 14:35:01 status installed openssh-server:amd64 9.6p1-3ubuntu13',
                                '2026-06-06 09:00:00 upgrade python3:amd64 3.12.0-1 3.12.3-1ubuntu2',
                                '2026-06-06 09:00:01 status half-configured python3:amd64 3.12.0-1',
                                '2026-06-06 09:00:02 status installed python3:amd64 3.12.3-1ubuntu2',
                                '2026-06-07 16:20:00 install curl:amd64 8.5.0-2ubuntu6',
                                '2026-06-07 16:20:01 status half-installed curl:amd64 8.5.0-2ubuntu6',
                                '2026-06-07 16:20:02 status installed curl:amd64 8.5.0-2ubuntu6'
                            )
                        }
                    }
                }
                'www' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'html' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'index_html' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '<!DOCTYPE html>',
                                        '<html>',
                                        '<head>',
                                        '<title>Welcome to nginx on Ubuntu!</title>',
                                        '</head>',
                                        '<body>',
                                        '<h1>Welcome to nginx!</h1>',
                                        '<p>This is the default welcome page for nginx on Ubuntu 24.04 LTS.</p>',
                                        '<p>The web server is running.</p>',
                                        '</body>',
                                        '</html>'
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        'snap' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'bin' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{}
                }
            }
        }
        'usr' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'share' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'doc' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{}
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
            Id = 'ubuntu-b1'
            Title = 'List files in home directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls -la'
            Description = @(
                'List all files and directories in your home folder,',
                'including hidden files (those starting with a dot).',
                'Use the -la flags for detailed listing.'
            )
            Hint = 'Try: ls -la ~ or just ls -la from your home directory'
        }
        @{
            Id = 'ubuntu-b2'
            Title = 'Show current directory path'
            Difficulty = 'beginner'
            ExpectedCommand = 'pwd'
            Description = @(
                'Print the full path of your current working directory.',
                'This helps you understand where you are in the filesystem.'
            )
            Hint = 'Type pwd and press Enter'
        }
        @{
            Id = 'ubuntu-b3'
            Title = 'Create a new directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'mkdir mydata'
            Description = @(
                'Create a new directory called "mydata" in your current location.',
                'Directories are used to organize files into a hierarchy.'
            )
            Hint = 'Use: mkdir mydata'
        }
        @{
            Id = 'ubuntu-b4'
            Title = 'Create an empty file'
            Difficulty = 'beginner'
            ExpectedCommand = 'touch testfile.txt'
            Description = @(
                'Create an empty file named "testfile.txt" using the touch command.',
                'Touch is commonly used to create empty files or update timestamps.'
            )
            Hint = 'Use: touch testfile.txt'
        }
        @{
            Id = 'ubuntu-b5'
            Title = 'Copy the hostname file'
            Difficulty = 'beginner'
            ExpectedCommand = 'cp /etc/hostname .'
            Description = @(
                'Copy the system hostname file to your current directory.',
                'The dot (.) represents the current directory in Linux.'
            )
            Hint = 'Use: cp /etc/hostname .'
        }
        @{
            Id = 'ubuntu-i1'
            Title = 'View OS release information'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/os-release'
            Description = @(
                'Display the contents of /etc/os-release to see which',
                'version of Ubuntu is installed on this system.'
            )
            Hint = 'Use: cat /etc/os-release'
        }
        @{
            Id = 'ubuntu-i2'
            Title = 'Search for SSH entries in auth log'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep sshd /var/log/auth.log'
            Description = @(
                'Search the authentication log for all lines containing "sshd".',
                'This shows SSH login attempts and connections.'
            )
            Hint = 'Use: grep sshd /var/log/auth.log'
        }
        @{
            Id = 'ubuntu-i3'
            Title = 'Check disk space usage'
            Difficulty = 'intermediate'
            ExpectedCommand = 'df -h'
            Description = @(
                'Show disk space usage for all mounted filesystems.',
                'The -h flag makes the output human-readable (MB, GB).'
            )
            Hint = 'Use: df -h'
        }
        @{
            Id = 'ubuntu-i4'
            Title = 'List running processes'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ps aux'
            Description = @(
                'Show all running processes on the system.',
                'Use ps aux to see every process with detailed information.'
            )
            Hint = 'Use: ps aux'
        }
        @{
            Id = 'ubuntu-i5'
            Title = 'Check memory usage'
            Difficulty = 'intermediate'
            ExpectedCommand = 'free -h'
            Description = @(
                'Display the amount of free and used memory in the system.',
                'The -h flag shows values in human-readable format.'
            )
            Hint = 'Use: free -h'
        }
        @{
            Id = 'ubuntu-a1'
            Title = 'Check nginx service status'
            Difficulty = 'advanced'
            ExpectedCommand = 'systemctl status nginx'
            Description = @(
                'Check the status of the nginx web server using systemctl.',
                'This shows whether the service is active, enabled, and its recent logs.'
            )
            Hint = 'Use: systemctl status nginx'
        }
        @{
            Id = 'ubuntu-a2'
            Title = 'Find nginx configuration files'
            Difficulty = 'advanced'
            ExpectedCommand = 'find /etc/nginx -name "*.conf"'
            Description = @(
                'Use the find command to locate all .conf files under /etc/nginx/.',
                'This is useful for discovering configuration files in a directory tree.'
            )
            Hint = 'Use: find /etc/nginx -name "*.conf"'
        }
        @{
            Id = 'ubuntu-a3'
            Title = 'View recent journal logs'
            Difficulty = 'advanced'
            ExpectedCommand = 'journalctl -n 20'
            Description = @(
                'View the last 20 entries from the systemd journal.',
                'The journal contains system logs collected by journald.'
            )
            Hint = 'Use: journalctl -n 20'
        }
        @{
            Id = 'ubuntu-a4'
            Title = 'Display network configuration'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/netplan/01-netcfg.yaml'
            Description = @(
                'Show the netplan network configuration file.',
                'Ubuntu uses netplan for network setup instead of /etc/network/interfaces.'
            )
            Hint = 'Use: cat /etc/netplan/01-netcfg.yaml'
        }
        @{
            Id = 'ubuntu-a5'
            Title = 'View apt repository sources'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/apt/sources.list.d/ubuntu.sources'
            Description = @(
                'Show the apt software repository configuration.',
                'This file defines where the system downloads packages from.'
            )
            Hint = 'Use: cat /etc/apt/sources.list.d/ubuntu.sources'
        }
        @{
            Id = 'ubuntu-e1'
            Title = 'Check SSH service logs from today'
            Difficulty = 'expert'
            ExpectedCommand = 'journalctl -u sshd --since today'
            Description = @(
                'Use journalctl to filter logs for the sshd service since midnight.',
                'This is how you troubleshoot SSH issues on a systemd-based system.'
            )
            Hint = 'Use: journalctl -u sshd --since today'
        }
        @{
            Id = 'ubuntu-e2'
            Title = 'Find failed login attempts in auth log'
            Difficulty = 'expert'
            ExpectedCommand = 'grep "Failed password" /var/log/auth.log'
            Description = @(
                'Search the authentication log for failed password attempts.',
                'This is a common security audit technique to detect brute force attacks.'
            )
            Hint = 'Use: grep "Failed password" /var/log/auth.log'
        }
        @{
            Id = 'ubuntu-e3'
            Title = 'Create a compressed backup'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf backup.tar.gz -C /home/student .'
            Description = @(
                'Create a gzipped tar archive of your home directory contents.',
                'The -c flag creates an archive, -z compresses with gzip, -f specifies the filename.'
            )
            Hint = 'Use: tar -czf backup.tar.gz -C /home/student .'
        }
        @{
            Id = 'ubuntu-e4'
            Title = 'Find and display large log files'
            Difficulty = 'expert'
            ExpectedCommand = 'find /var/log -type f -name "*.log" -exec ls -lh {} \;'
            Description = @(
                'Find all .log files in /var/log and display their sizes.',
                'This uses find with -exec to run ls on each result, showing file sizes.'
            )
            Hint = 'Use: find /var/log -type f -name "*.log" -exec ls -lh {} \;'
        }
        @{
            Id = 'ubuntu-e5'
            Title = 'Analyze sudo command history'
            Difficulty = 'expert'
            ExpectedCommand = 'grep sudo /var/log/auth.log | grep COMMAND'
            Description = @(
                'Extract all sudo command executions from the auth log.',
                'This shows which commands were run with elevated privileges and by whom.'
            )
            Hint = 'Use: grep sudo /var/log/auth.log | grep COMMAND'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
