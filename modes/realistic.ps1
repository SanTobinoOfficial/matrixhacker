. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-REALISTICCOMMANDS {
    return @(
        C "whoami" @("jdoe")
        C "hostname" @("debian-node-01")
        C "id" @("uid=1000(jdoe) gid=1000(jdoe) groups=1000(jdoe),27(sudo)")
        C "ls -la /etc/nginx/" @("total 28",
            "drwxr-xr-x  2 root root 4096 Mar 15 09:22 .",
            "drwxr-xr-x 76 root root 4096 Mar 15 09:20 ..",
            "-rw-r--r--  1 root root 1077 Mar 15 09:20 fastcgi.conf",
            "-rw-r--r--  1 root root 1041 Mar 15 09:20 nginx.conf",
            "-rw-r--r--  1 root root 1009 Mar 15 09:20 sites-enabled/default")
        C "cat /etc/nginx/nginx.conf" @("user www-data;",
            "worker_processes auto;",
            "pid /run/nginx.pid;",
            "events {",
            "    worker_connections 768;",
            "    multi_accept on;",
            "}",
            "http {",
            "    sendfile on;",
            "    tcp_nopush on;",
            "    types_hash_max_size 2048;",
            "    include /etc/nginx/mime.types;",
            "}")
        C "systemctl status sshd --no-pager" @("● sshd.service - OpenSSH server daemon",
            "     Loaded: loaded (/lib/systemd/system/sshd.service; enabled; preset: enabled)",
            "     Active: active (running) since Sat 2026-03-14 22:15:33 CET; 2 days ago",
            "       Docs: man:sshd(8)",
            "   Main PID: 892 (sshd)",
            "      Tasks: 1 (limit: 2231)",
            "     Memory: 5.3M",
            "        CPU: 2.345s",
            "     CGroup /system.slice/sshd.service",
            "             └─892 ""sshd: /usr/sbin/sshd -D""")
        C "journalctl -u nginx --no-pager -n 8" @("Mar 16 08:12:01 debian-node-01 nginx[1245]: 10.0.0.23 - - [16/Mar/2026:08:12:01 +0100] ""GET /index.html HTTP/1.1"" 200 1234",
            "Mar 16 08:12:05 debian-node-01 nginx[1245]: 10.0.0.23 - - [16/Mar/2026:08:12:05 +0100] ""GET /styles.css HTTP/1.1"" 304 0",
            "Mar 16 08:15:22 debian-node-01 nginx[1245]: 10.0.0.45 - - [16/Mar/2026:08:15:22 +0100] ""POST /api/login HTTP/1.1"" 401 52",
            "Mar 16 08:15:23 debian-node-01 nginx[1245]: 10.0.0.45 - - [16/Mar/2026:08:15:23 +0100] ""POST /api/login HTTP/1.1"" 200 1240",
            "Mar 16 08:20:00 debian-node-01 nginx[1245]: [warn] 1024 worker_connections exceed limit",
            "Mar 16 08:21:00 debian-node-01 nginx[1245]: 10.0.0.88 - - [16/Mar/2026:08:21:00 +0100] ""GET /admin HTTP/1.1"" 403 48",
            "Mar 16 08:22:00 debian-node-01 nginx[1245]: 10.0.0.88 - - [16/Mar/2026:08:22:00 +0100] ""GET /wp-admin HTTP/1.1"" 404 162",
            "Mar 16 08:25:01 debian-node-01 CRON[3412]: pam_unix(cron:session): session opened for user root(uid=0)")
        C "df -h" @("Filesystem      Size  Used Avail Use% Mounted on",
            "udev            3.9G     0  3.9G   0% /dev",
            "tmpfs           787M  1.2M  786M   1% /run",
            "/dev/sda1        98G   42G   51G  46% /",
            "tmpfs           3.9G     0  3.9G   0% /dev/shm",
            "tmpfs           5.0M     0  5.0M   0% /run/lock",
            "/dev/sdb1       500G  210G  290G  42% /mnt/backup")
        Cprog "free -m" @("               total        used        free      shared  buff/cache   available",
            "Mem:            7869        3245        2102         234        2522        4123",
            "Swap:           2048          34        2014")
        C "ps aux --sort=-%mem | head -8" @("USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND",
            "jdoe       2456  0.3  4.2 452168 34512 ?        Ssl  Mar15   1:23 /usr/bin/gnome-shell",
            "mysql       889  0.1  3.8 1.2G 30245 ?        Ssl  Mar14  12:45 /usr/sbin/mysqld",
            "www-data   1245  0.2  2.1 34512 17200 ?        S    Mar15   5:12 nginx -g daemon off;",
            "root        678  0.0  1.8 123456 14500 ?        Ss   Mar14   0:45 /lib/systemd/systemd-journald",
            "postgres   1023  0.1  1.5 456789 12300 ?        Ss   Mar14   3:34 /usr/lib/postgresql/15/bin/postgres",
            "root        892  0.0  0.8 12345  6500 ?        Ss   Mar14   2:34 sshd: /usr/sbin/sshd -D",
            "redis       777  0.0  0.5 56789  4200 ?        Ssl  Mar14   0:12 /usr/bin/redis-server 0.0.0.0:6379")
        C "tail -6 /var/log/syslog" @("Mar 16 08:30:01 debian-node-01 systemd[1]: Starting Cleanup of Temporary Directories...",
            "Mar 16 08:30:01 debian-node-01 systemd[1]: run-rW5x3kdj43V3sdTtI8.mount: Deactivated successfully.",
            "Mar 16 08:30:01 debian-node-01 systemd[1]: tmp-cleanup.service: Deactivated successfully.",
            "Mar 16 08:30:02 debian-node-01 systemd[1]: Started Cleanup of Temporary Directories.",
            "Mar 16 08:31:22 debian-node-01 sshd[4521]: Accepted publickey for jdoe from 10.0.0.14 port 54221",
            "Mar 16 08:31:22 debian-node-01 sshd[4521]: session opened for user jdoe by (pam_unix)")
        C "netstat -tulpn" @("Active Internet connections (only servers)",
            "Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name",
            "tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      892/sshd",
            "tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1056/master",
            "tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1245/nginx",
            "tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      1245/nginx",
            "tcp6       0      0 :::22                   :::*                    LISTEN      892/sshd",
            "tcp6       0      0 :::3306                 :::*                    LISTEN      889/mysqld",
            "udp        0      0 0.0.0.0:68              0.0.0.0:*                           678/dhclient")
        C "uptime" @(" 08:45:12 up 2 days, 10:29,  3 users,  load average: 0.45, 0.32, 0.28")
        C "cat /etc/os-release" @("PRETTY_NAME=""Debian GNU/Linux 12 (bookworm)""",
            "NAME=""Debian GNU/Linux""",
            "VERSION_ID=""12""",
            "VERSION=""12 (bookworm)""",
            "VERSION_CODENAME=bookworm",
            "ID=debian",
            "HOME_URL=""https://www.debian.org/""",
            "SUPPORT_URL=""https://www.debian.org/support""",
            "BUG_REPORT_URL=""https://bugs.debian.org/""")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-REALISTICCOMMANDS} -Theme (Get-Theme realistic) -ModeName "Realistic" -TargetHost "debian-node-01" -TargetDomain "corp.internal" -TargetIP (RandIP) -TargetCompany "OmniCorp International" -TargetLocation "Warsaw DC" -TargetOS "Debian GNU/Linux 12 (bookworm)" -OSPrompt "jdoe@debian-node-01:~$ " -AllowFailures
}