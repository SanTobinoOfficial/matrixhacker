function Get-LearningContent-kali {
    $fs = @{
        Type = 'dir'; Owner = 'root'; Group = 'root'
        Children = @{
            'home' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'student' = @{
                        Type = 'dir'; Owner = 'student'; Group = 'student'
                        Children = @{
                            'readme_txt' = @{
                                Type = 'file'; Owner = 'student'; Group = 'student'
                                Content = @(
                                    'Kali Linux 2026.1 - Penetration Testing Distribution',
                                    '',
                                    'Welcome to Kali Linux 2026.1 (Rolling Release)',
                                    'Kernel: 6.12.6-amd64',
                                    '',
                                    'Pre-installed tools:',
                                    '  - nmap (network scanner)',
                                    '  - Metasploit Framework (exploitation)',
                                    '  - Burp Suite (web app testing)',
                                    '  - John the Ripper / Hashcat (password cracking)',
                                    '  - Wireshark (packet analysis)',
                                    '  - impacket (SMB/MSRPC tools)',
                                    '  - BloodHound (AD enumeration)',
                                    '',
                                    'Documentation: https://www.kali.org/docs/',
                                    'Community: https://forums.kali.org/',
                                    '',
                                    'REMEMBER: Only use these tools on systems you own',
                                    'or have explicit permission to test.'
                                )
                            }
                            'tools' = @{
                                Type = 'dir'; Owner = 'student'; Group = 'student'
                                Children = @{
                                    'nmap_scan_results_txt' = @{
                                        Type = 'file'; Owner = 'student'; Group = 'student'
                                        Content = @(
                                            'Nmap scan report for 10.10.10.1',
                                            'PORT     STATE    SERVICE     VERSION',
                                            '22/tcp   open     ssh         OpenSSH 8.9p1',
                                            '80/tcp   open     http        Apache httpd 2.4.58',
                                            '443/tcp  open     https       Apache httpd 2.4.58',
                                            '3306/tcp open     mysql       MySQL 8.0.35',
                                            '8080/tcp open     http-proxy  Squid proxy 6.6',
                                            'PORT     STATE    SERVICE',
                                            '135/tcp  filtered msrpc',
                                            '445/tcp  filtered microsoft-ds',
                                            '3389/tcp filtered ms-wbt-server',
                                            'OS: Linux 6.x (88%)',
                                            'MAC: 00:0C:29:AB:CD:EF (VMware)'
                                        )
                                    }
                                    'exploit_notes_txt' = @{
                                        Type = 'file'; Owner = 'student'; Group = 'student'
                                        Content = @(
                                            'Exploit Research Notes - Target: 10.10.10.1',
                                            '',
                                            'Apache 2.4.58 - CVE-2024-? (check sploitdb)',
                                            'OpenSSH 8.9p1 - Check for known vulns',
                                            'MySQL 8.0.35 - Default creds? root:root',
                                            '',
                                            'Potential vectors:',
                                            '1. Web app fuzzing on port 80/443',
                                            '2. SMB enum on filtered ports - try bypass',
                                            '3. Bruteforce SSH with rockyou.txt',
                                            '4. Check Squid proxy for open relay',
                                            '',
                                            'Tools to try: nmap scripts, searchsploit, msfconsole'
                                        )
                                    }
                                }
                            }
                            'loot' = @{
                                Type = 'dir'; Owner = 'student'; Group = 'student'
                                Children = @{}
                            }
                            '.zshrc' = @{
                                Type = 'file'; Owner = 'student'; Group = 'student'
                                Content = @(
                                    '# ZSH configuration for Kali Linux',
                                    'export ZSH=/usr/share/oh-my-zsh',
                                    'ZSH_THEME="kali"',
                                    'plugins=(git nmap sudo python docker)',
                                    'source $ZSH/oh-my-zsh.sh',
                                    'alias ll="ls -alF"',
                                    'alias la="ls -A"',
                                    'alias nmap="nmap --privileged"',
                                    'export EDITOR=nano',
                                    'export PATH=$PATH:$HOME/.local/bin:/usr/share/tools'
                                )
                            }
                            '.bashrc' = @{
                                Type = 'file'; Owner = 'student'; Group = 'student'
                                Content = @(
                                    '# ~/.bashrc for Kali Linux',
                                    'export PS1="\[\e[31m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\w\$ "',
                                    'alias ll="ls -alF"',
                                    'alias la="ls -A"',
                                    'alias grep="grep --color=auto"',
                                    'alias msf="msfconsole -q"',
                                    'alias searchsploit="searchsploit -t"',
                                    'export EDITOR=nano'
                                )
                            }
                        }
                    }
                }
            }
            'usr' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'share' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'wordlists' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'rockyou_txt_gz' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# rockyou.txt.gz - extracted sample',
                                            '123456',
                                            'password',
                                            '12345678',
                                            'qwerty',
                                            '123456789',
                                            '12345',
                                            '1234',
                                            '111111',
                                            '1234567',
                                            'sunshine',
                                            'qwerty123',
                                            'iloveyou',
                                            'princess',
                                            'admin',
                                            'welcome',
                                            'monkey',
                                            'dragon',
                                            'master',
                                            'letmein',
                                            'login',
                                            'admin2024',
                                            'kali2026',
                                            'pentest',
                                            'root1234',
                                            'toor'
                                        )
                                    }
                                    'fasttrack_txt' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# fasttrack.txt - common pentest passwords',
                                            'admin',
                                            'administrator',
                                            'root',
                                            'test',
                                            'guest',
                                            'sa',
                                            '1234567890',
                                            'password123',
                                            'passw0rd',
                                            'P@ssw0rd',
                                            'changeme',
                                            'default',
                                            'backup123',
                                            'admin@123',
                                            'cisco',
                                            'router',
                                            'switch',
                                            'admin1234',
                                            'Password1',
                                            'Welcome1'
                                        )
                                    }
                                }
                            }
                            'nmap' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'scripts' = @{
                                        Type = 'dir'; Owner = 'root'; Group = 'root'
                                        Children = @{
                                            'http_enum_nse' = @{
                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                Content = @(
                                                    '-- http-enum.nse',
                                                    '-- Enumerates directories and files on HTTP servers',
                                                    '-- Category: discovery safe',
                                                    'local http = require "http"',
                                                    'local shortport = require "shortport"',
                                                    'local table = require "table"',
                                                    'description = [[Enumerates common web directories and files]]',
                                                    'author = "Kali Nmap Team"',
                                                    'license = "Same as Nmap"',
                                                    'categories = {"discovery", "safe"}',
                                                    'portrule = shortport.http',
                                                    'action = function(host, port)',
                                                    '  local paths = {"/admin", "/login", "/wp-admin"}',
                                                    '  local results = {}',
                                                    '  for _, path in ipairs(paths) do',
                                                    '    local response = http.get(host, port, path)',
                                                    '    if response.status and response.status < 400 then',
                                                    '      table.insert(results, path .. " - found")',
                                                    '    end',
                                                    '  end',
                                                    '  return #results > 0 and results or nil',
                                                    'end'
                                                )
                                            }
                                            'smb_os_discovery_nse' = @{
                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                Content = @(
                                                    '-- smb-os-discovery.nse',
                                                    '-- Attempts to discover the OS of an SMB server',
                                                    '-- Category: discovery safe',
                                                    'local smb = require "smb"',
                                                    'local stdnse = require "stdnse"',
                                                    'description = [[Determines OS via SMB protocol negotiation]]',
                                                    'author = "Kali Nmap Team"',
                                                    'categories = {"discovery", "safe"}',
                                                    'hostrule = function(host) return smb.get_port(host) end',
                                                    'action = function(host)',
                                                    '  local status, result = smb.get_os(host)',
                                                    '  if status then',
                                                    '    return "OS: " .. result.os .. " | Version: " .. result.version',
                                                    '  end',
                                                    '  return nil',
                                                    'end'
                                                )
                                            }
                                            'vulners_nse' = @{
                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                Content = @(
                                                    '-- vulners.nse',
                                                    '-- Checks service versions against Vulners CVE database',
                                                    '-- Category: discovery intrusive',
                                                    'local http = require "http"',
                                                    'local json = require "json"',
                                                    'description = [[Checks versions against vulners.com API]]',
                                                    'author = "vulners.com"',
                                                    'categories = {"discovery", "intrusive", "vuln"}',
                                                    'portrule = function(host, port)',
                                                    '  return port.version and port.version.product ~= nil',
                                                    'end',
                                                    'action = function(host, port)',
                                                    '  local cpe = port.version.cpe',
                                                    '  local result = {}',
                                                    '  if cpe then',
                                                    '    table.insert(result, "Checking CPE: " .. cpe)',
                                                    '    table.insert(result, "CVE database query required")',
                                                    '  end',
                                                    '  return #result > 0 and result or nil',
                                                    'end'
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            'exploitdb' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'exploits_csv' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# Exploit-DB entries (sample)',
                                            'id,file,description,date,type,platform',
                                            '50120,exploits/linux/webapps/50120.py,WordPress 6.0 RCE,2026-01-15,webapps,linux',
                                            '50121,exploits/linux/remote/50121.c,Apache httpd 2.4.58 DoS,2026-01-20,dos,linux',
                                            '50122,exploits/windows/remote/50122.py,EternalBlue MS17-010,2026-02-01,remote,windows',
                                            '50123,exploits/linux/local/50123.c,Linux Kernel 6.x LPE,2026-02-10,local,linux',
                                            '50124,exploits/multiple/remote/50124.py,Log4j RCE CVE-2021-44228,2026-02-15,remote,multiple',
                                            '50125,exploits/linux/remote/50125.rb,ProFTPD 1.3.5 RCE,2026-03-01,remote,linux',
                                            '50126,exploits/linux/webapps/50126.py,Drupal 10 XSS,2026-03-10,webapps,linux'
                                        )
                                    }
                                    'searchsploit_results_txt' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# searchsploit -t apache 2.4.58',
                                            '# Results: 3 matches',
                                            '',
                                            'Apache httpd 2.4.48 - 2.4.58 | Multiple Vulnerabilities',
                                            '  Path: /usr/share/exploitdb/exploits/linux/webapps/50121',
                                            '  Type: dos',
                                            '  Platform: linux',
                                            '',
                                            'Apache httpd 2.4.58 - Header Injection',
                                            '  Path: /usr/share/exploitdb/exploits/linux/remote/50127',
                                            '  Type: remote',
                                            '  Platform: linux',
                                            '',
                                            'Apache mod_proxy - SSRF Vulnerability',
                                            '  Path: /usr/share/exploitdb/exploits/linux/webapps/50128',
                                            '  Type: webapps',
                                            '  Platform: linux'
                                        )
                                    }
                                    'exploit_files' = @{
                                        Type = 'dir'; Owner = 'root'; Group = 'root'
                                        Children = @{
                                            '50120_py' = @{
                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                Content = @(
                                                    '#!/usr/bin/env python3',
                                                    '# Exploit: WordPress 6.0 RCE',
                                                    '# EDB-ID: 50120',
                                                    'import requests',
                                                    'target = sys.argv[1]',
                                                    'payload = {"cmd": "id"}',
                                                    'r = requests.post(target + "/wp-admin/admin-ajax.php", data=payload)',
                                                    'print(r.text)'
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            'metasploit-framework' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'modules_list_txt' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# Metasploit Framework - Available Modules',
                                            'exploit/multi/handler',
                                            'exploit/multi/script/web_delivery',
                                            'exploit/linux/http/apache_mod_cgi_bash_env',
                                            'exploit/linux/samba/is_known_pipename',
                                            'exploit/windows/smb/ms17_010_eternalblue',
                                            'exploit/multi/http/log4shell_header_inject',
                                            'payload/linux/x64/meterpreter/reverse_tcp',
                                            'payload/windows/x64/meterpreter/reverse_tcp',
                                            'payload/linux/x64/shell/reverse_tcp',
                                            'post/linux/gather/hashdump',
                                            'post/linux/gather/enum_configs',
                                            'post/multi/gather/ssh_creds',
                                            'auxiliary/scanner/portscan/tcp',
                                            'auxiliary/scanner/http/wordpress_login',
                                            'auxiliary/scanner/smb/smb_login'
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            'etc' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'hostname' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @('kali-pentest')
                    }
                    'passwd' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'root:x:0:0:root:/root:/bin/bash',
                            'daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin',
                            'bin:x:2:2:bin:/bin:/usr/sbin/nologin',
                            'kali:x:100:100:Kali Default,,,:/home/kali:/bin/bash',
                            'student:x:1000:1000:Penetration Tester,,,:/home/student:/bin/zsh',
                            'mysql:x:120:130:MySQL Server,,,:/nonexistent:/bin/false',
                            'sshd:x:121:65534::/run/sshd:/usr/sbin/nologin',
                            'postgres:x:122:140:PostgreSQL,,,:/var/lib/postgresql:/bin/bash'
                        )
                    }
                    'os-release' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'PRETTY_NAME="Kali GNU/Linux 2026.1"',
                            'NAME="Kali GNU/Linux"',
                            'VERSION_ID="2026.1"',
                            'VERSION="2026.1 (Rolling)"',
                            'VERSION_CODENAME=kali-rolling',
                            'ID=kali',
                            'ID_LIKE=debian',
                            'HOME_URL="https://www.kali.org/"',
                            'SUPPORT_URL="https://forums.kali.org/"',
                            'BUG_REPORT_URL="https://bugs.kali.org/"',
                            'ANSI_COLOR="1;31"'
                        )
                    }
                    'apt' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'sources_list' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Kali Linux Repositories',
                                    'deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware',
                                    'deb http://http.kali.org/kali kali-last-snapshot main contrib non-free non-free-firmware',
                                    '',
                                    '# Uncomment to add debug packages',
                                    '# deb http://http.kali.org/kali kali-rolling-debug main contrib non-free',
                                    '',
                                    '# Security updates (Kali uses rolling, no separate security repo)',
                                    '# Use: sudo apt update && sudo apt full-upgrade'
                                )
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
                            'kali_setup_log' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '[2026-06-01 10:00:00] INFO: Starting Kali Linux 2026.1 setup',
                                    '[2026-06-01 10:00:02] INFO: Detected: amd64 architecture',
                                    '[2026-06-01 10:00:05] INFO: Configuring apt repositories',
                                    '[2026-06-01 10:00:10] INFO: Installing kali-linux-headless meta-package',
                                    '[2026-06-01 10:05:30] INFO: Package: nmap - installed successfully',
                                    '[2026-06-01 10:06:15] INFO: Package: metasploit-framework - installed successfully',
                                    '[2026-06-01 10:07:00] INFO: Package: burpsuite - installed successfully',
                                    '[2026-06-01 10:08:30] INFO: Package: john - installed successfully',
                                    '[2026-06-01 10:10:00] INFO: Package: hashcat - installed successfully',
                                    '[2026-06-01 10:12:00] INFO: Package: wireshark - installed successfully',
                                    '[2026-06-01 10:15:00] INFO: Package: impacket-scripts - installed successfully',
                                    '[2026-06-01 10:18:00] INFO: Package: bloodhound - installed successfully',
                                    '[2026-06-01 10:20:00] INFO: Downloading rockyou.txt.gz wordlist',
                                    '[2026-06-01 10:25:00] INFO: Extracting common wordlists',
                                    '[2026-06-01 10:30:00] INFO: Configuring ZSH and Oh-My-Zsh',
                                    '[2026-06-01 10:35:00] INFO: Setup complete - Kali Linux 2026.1 ready'
                                )
                            }
                            'live_build_log' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Kali Linux Live Build Log',
                                    '# ISO: kali-linux-2026.1-live-amd64.iso',
                                    'Stage: bootstrap - OK',
                                    'Stage: install-packages - OK',
                                    'Stage: configure-system - OK',
                                    'Stage: install-kernel - OK',
                                    'Stage: create-filesystem - OK',
                                    'Stage: build-initramfs - OK',
                                    'Stage: create-iso - OK',
                                    'Status: BUILD COMPLETE',
                                    'Size: 3.8 GB',
                                    'SHA256: a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b'
                                )
                            }
                        }
                    }
                }
            }
            'opt' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'impacket_readme_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'Impacket - Collection of Python classes for SMB/MSRPC protocols',
                            'Version: 0.12.0',
                            'Location: /opt/impacket',
                            '',
                            'Key tools:',
                            '  impacket-smbclient    - SMB client',
                            '  impacket-psexec       - PSExec-like execution',
                            '  impacket-secretsdump  - Dump SAM secrets',
                            '  impacket-mimikatz     - Mimikatz integration',
                            '  impacket-atexec       - Task scheduler execution',
                            '',
                            'Usage examples:',
                            '  impacket-psexec domain/user:pass@target',
                            '  impacket-secretsdump -sam SAM -system SYSTEM local'
                        )
                    }
                    'bloodhound_readme_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'BloodHound - Active Directory enumeration and graph analysis',
                            'Version: 4.3.0',
                            'Location: /opt/bloodhound',
                            '',
                            'Components:',
                            '  BloodHound GUI - Neo4j-powered graph analysis',
                            '  SharpHound - Ingestor for Windows AD data',
                            '  BloodHound.py - Linux ingestor',
                            '',
                            'Usage:',
                            '  bloodhound-python -d domain.local -u user -p pass -c All',
                            '',
                            'Import results into BloodHound GUI to find attack paths.'
                        )
                    }
                    'chisel_readme_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'Chisel - Fast TCP/UDP tunnel over HTTP',
                            'Version: 1.10.0',
                            'Location: /opt/chisel',
                            '',
                            'Usage:',
                            '  Server: chisel server -p 8080 --reverse',
                            '  Client: chisel client server_ip:8080 R:local_port:target:remote_port',
                            '',
                            'Great for bypassing firewalls and NAT in pentests.'
                        )
                    }
                }
            }
            'root' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    '.bashrc' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '# ~/.bashrc: root user Kali Linux',
                            "export PS1='\[\e[31m\]\u\[\e[0m\]@\h:\w# '",
                            'alias ll="ls -alF"',
                            'alias la="ls -A"',
                            'alias nmap="nmap --privileged"',
                            'alias msf="msfconsole -q"',
                            'umask 022'
                        )
                    }
                    'scripts' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'enum_sh' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '#!/bin/bash',
                                    '# Quick enumeration script',
                                    'echo "=== Hostname ==="',
                                    'hostname',
                                    'echo "=== Users ==="',
                                    'cat /etc/passwd | cut -d: -f1',
                                    'echo "=== Network ==="',
                                    'ip addr | grep inet',
                                    'echo "=== Running Services ==="',
                                    'ss -tlnp',
                                    'echo "=== SUID Binaries ==="',
                                    'find / -perm -4000 -type f 2>/dev/null'
                                )
                            }
                            'privesc_sh' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '#!/bin/bash',
                                    '# Linux privilege escalation checker',
                                    'echo "=== Kernel ==="',
                                    'uname -a',
                                    'echo "=== Sudo Rights ==="',
                                    'sudo -l 2>/dev/null',
                                    'echo "=== Writable Passwd ==="',
                                    'test -w /etc/passwd && echo "VULNERABLE: /etc/passwd is writable"',
                                    'echo "=== Cron Jobs ==="',
                                    'ls -la /etc/cron* 2>/dev/null',
                                    'echo "=== Docker Group ==="',
                                    'groups | grep docker && echo "VULNERABLE: docker group membership"'
                                )
                            }
                        }
                    }
                }
            }
            'tmp' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'payloads' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{}
                    }
                }
            }
        }
    }

    $tasks = @(
        @{
            Id = 'kali-b1'
            Title = 'Read the Kali README'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat readme_txt'
            Description = @(
                'Start by reading the README file in your home directory.',
                'It contains version info and a list of pre-installed tools.'
            )
            Hint = 'Use: cat readme_txt (or: cat /home/student/readme_txt)'
        }
        @{
            Id = 'kali-b2'
            Title = 'List tools directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls tools/'
            Description = @(
                'List the contents of the tools directory to see',
                'what scan results and exploit notes are available.'
            )
            Hint = 'Use: ls tools/'
        }
        @{
            Id = 'kali-b3'
            Title = 'View nmap scan results'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat tools/nmap_scan_results_txt'
            Description = @(
                'Display the nmap scan results file to see open ports',
                'and services on the target machine (10.10.10.1).'
            )
            Hint = 'Use: cat tools/nmap_scan_results_txt'
        }
        @{
            Id = 'kali-b4'
            Title = 'Create loot directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'mkdir loot/exploits'
            Description = @(
                'Create a subdirectory called "exploits" inside your loot folder.',
                'This is where you would store findings from a pentest.'
            )
            Hint = 'Use: mkdir loot/exploits'
        }
        @{
            Id = 'kali-b5'
            Title = 'Check system hostname'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /etc/hostname'
            Description = @(
                'Display the system hostname to confirm you are on',
                'the Kali penetration testing distro.'
            )
            Hint = 'Use: cat /etc/hostname'
        }
        @{
            Id = 'kali-i1'
            Title = 'Search rockyou for passwords'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep "admin" /usr/share/wordlists/rockyou_txt_gz'
            Description = @(
                'Search the rockyou.txt wordlist for passwords containing "admin".',
                'This simulates how you would search for common credentials.'
            )
            Hint = 'Use: grep "admin" /usr/share/wordlists/rockyou_txt_gz'
        }
        @{
            Id = 'kali-i2'
            Title = 'Copy a wordlist to home'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cp /usr/share/wordlists/fasttrack_txt ~/wordlist_copy.txt'
            Description = @(
                'Copy the fasttrack.txt wordlist to your home directory',
                'for offline use during a penetration test.'
            )
            Hint = 'Use: cp /usr/share/wordlists/fasttrack_txt ~/wordlist_copy.txt'
        }
        @{
            Id = 'kali-i3'
            Title = 'List nmap NSE scripts'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ls /usr/share/nmap/scripts/'
            Description = @(
                'List the available nmap NSE (Nmap Scripting Engine) scripts',
                'to see what enumeration and vulnerability scripts are available.'
            )
            Hint = 'Use: ls /usr/share/nmap/scripts/'
        }
        @{
            Id = 'kali-i4'
            Title = 'View passwd file'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/passwd'
            Description = @(
                'Display the /etc/passwd file to see all user accounts',
                'on the Kali system. Look for non-standard users.'
            )
            Hint = 'Use: cat /etc/passwd'
        }
        @{
            Id = 'kali-i5'
            Title = 'Move loot to safe location'
            Difficulty = 'intermediate'
            ExpectedCommand = 'mv ~/wordlist_copy.txt loot/'
            Description = @(
                'Move the wordlist copy you downloaded into the loot directory',
                'to keep your findings organized.'
            )
            Hint = 'Use: mv ~/wordlist_copy.txt loot/'
        }
        @{
            Id = 'kali-a1'
            Title = 'Enumerate with NSE scripts'
            Difficulty = 'advanced'
            ExpectedCommand = 'ls -la /usr/share/nmap/scripts/*.nse'
            Description = @(
                'List all NSE script files with details in the nmap scripts directory.',
                'These scripts automate vulnerability detection and enumeration.'
            )
            Hint = 'Use: ls -la /usr/share/nmap/scripts/http_enum_nse'
        }
        @{
            Id = 'kali-a2'
            Title = 'Query exploit database'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /usr/share/exploitdb/searchsploit_results_txt'
            Description = @(
                'Display searchsploit results to see what exploits are available',
                'for the Apache httpd 2.4.58 service found in the scan.'
            )
            Hint = 'Use: cat /usr/share/exploitdb/searchsploit_results_txt'
        }
        @{
            Id = 'kali-a3'
            Title = 'Check apt sources'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/apt/sources_list'
            Description = @(
                'Display the apt sources.list to see which Kali repositories',
                'are configured for updates and package installation.'
            )
            Hint = 'Use: cat /etc/apt/sources_list'
        }
        @{
            Id = 'kali-a4'
            Title = 'Review setup logs'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /var/log/kali_setup_log'
            Description = @(
                'Read the Kali setup log to verify which packages were installed',
                'and check for any errors during the initial setup.'
            )
            Hint = 'Use: cat /var/log/kali_setup_log'
        }
        @{
            Id = 'kali-a5'
            Title = 'Explore /opt tools'
            Difficulty = 'advanced'
            ExpectedCommand = 'ls /opt/'
            Description = @(
                'List the /opt directory to see what third-party tools',
                'are installed (Impacket, BloodHound, Chisel, etc.)'
            )
            Hint = 'Use: ls /opt/'
        }
        @{
            Id = 'kali-e1'
            Title = 'Advanced wordlist analysis'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /usr/share/wordlists/fasttrack_txt | sort | uniq'
            Description = @(
                'Use a command pipeline to read, sort, and deduplicate',
                'the fasttrack wordlist. This is how you clean wordlists'
                'before using them in password attacks.'
            )
            Hint = 'Use: cat /usr/share/wordlists/fasttrack_txt | sort | uniq'
        }
        @{
            Id = 'kali-e2'
            Title = 'Find NSE scripts recursively'
            Difficulty = 'expert'
            ExpectedCommand = 'find /usr/share/nmap -name "*.nse" -type f'
            Description = @(
                'Use find to locate all .nse script files recursively',
                'under the nmap directory tree.'
            )
            Hint = 'Use: find /usr/share/nmap -name "*.nse" -type f'
        }
        @{
            Id = 'kali-e3'
            Title = 'Backup tools to archive'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf backup_tools.tar.gz -C /home/student tools/'
            Description = @(
                'Create a compressed tar archive of the tools directory',
                'to back up your scanning results and exploit notes.'
            )
            Hint = 'Use: tar -czf backup_tools.tar.gz -C /home/student tools/'
        }
        @{
            Id = 'kali-e4'
            Title = 'Analyze exploit paths'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /usr/share/exploitdb/exploits_csv | grep "5012"'
            Description = @(
                'Search the exploit database CSV for entries matching "5012"',
                'to find the exploit IDs and paths for Apache-related exploits.'
            )
            Hint = 'Use: cat /usr/share/exploitdb/exploits_csv | grep "5012"'
        }
        @{
            Id = 'kali-e5'
            Title = 'Compare passwd entries'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /etc/passwd | cut -d: -f1,3,7'
            Description = @(
                'Extract username, UID, and shell columns from passwd',
                'to analyze which users have login shells vs system accounts.'
            )
            Hint = 'Use: cat /etc/passwd | cut -d: -f1,3,7'
        }
    )
    return @{ Filesystem = $fs; Tasks = $tasks }
}
