. "$PSScriptRoot\..\engine\themes.ps1"
. "$PSScriptRoot\..\engine\helpers.ps1"
. "$PSScriptRoot\..\engine\core.ps1"

function Build-OutageCommands {
    return @(
        C "whoami" @("root")
        C "hostname" @("srv-db-01")
        C "id" @("uid=0(root) gid=0(root) groups=0(root)")
        C "df -h" @("Filesystem      Size  Used Avail Use% Mounted on",
            "/dev/sda1       200G  187G   13G  94% /",
            "/dev/sdb1       500G  498G  2.0G 100% /var/lib/mysql",
            "tmpfs           7.8G  7.5G  300M  97% /dev/shm")
        C "free -m" @("              total        used        free      shared  buff/cache   available",
            "Mem:          16000      15123        120        345        757         478",
            "Swap:          4096       4000         96")
        C "systemctl status mysql" @("* mysql.service - MySQL Community Server",
            "   Loaded: loaded (/lib/systemd/system/mysql.service; enabled; vendor preset: enabled)",
            "   Active: failed (Result: exit-code) since Mon 2026-06-08 03:17:22 UTC",
            "  Process: 4521 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid (code=exited, status=1/FAILURE)",
            " Main PID: 4521 (code=exited, status=1/FAILURE)",
            "   Status: `"Server shutdown in progress`"",
            "    Error: 28 (No space left on device)")
        C "systemctl status nginx" @("* nginx.service - A high performance web server and a reverse proxy server",
            "   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)",
            "   Active: active (running) since Mon 2026-06-08 03:22:45 UTC",
            "  Process: 4893 ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;' (code=exited, status=0/SUCCESS)",
            " Main PID: 4897 (nginx)",
            "   Tasks: 2 (limit: 23456)",
            "   Memory: 12.4M",
            "   CPU: 234ms")
        C "systemctl status sshd" @("* ssh.service - OpenSSH server",
            "   Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)",
            "   Active: active (running) since Sun 2026-06-07 14:02:11 UTC",
            "   Docs: man:sshd(8)",
            " Main PID: 2341 (sshd)",
            "   Tasks: 3 (limit: 23456)",
            "   Memory: 8.2M")
        C "journalctl -p err -n 20" @("Jun 08 03:15:01 srv-db-01 kernel: [ 3456.789] EXT4-fs error: journal checksum mismatch",
            "Jun 08 03:15:02 srv-db-01 kernel: [ 3456.891] Buffer I/O error on device sda1, logical block 23456",
            "Jun 08 03:15:03 srv-db-01 mysqld[4521]: [ERROR] InnoDB: Database page corruption detected",
            "Jun 08 03:15:03 srv-db-01 mysqld[4521]: [ERROR] InnoDB: Unable to open file: ib_logfile0",
            "Jun 08 03:15:04 srv-db-01 mysqld[4521]: [ERROR] Aborting",
            "Jun 08 03:16:00 srv-db-01 systemd[1]: mysql.service: Failed with result 'exit-code'.",
            "Jun 08 03:17:22 srv-db-01 systemd[1]: mysql.service: Scheduled restart job, restart counter 5.",
            "Jun 08 03:17:22 srv-db-01 systemd[1]: mysql.service: Start request repeated too quickly.",
            "Jun 08 03:17:22 srv-db-01 systemd[1]: mysql.service: Failed with result 'exit-code'.",
            "Jun 08 03:17:22 srv-db-01 systemd[1]: mysql.service: Unit entered failed state.")
        C "dmesg | tail -10" @("[ 3456.234] sda: sda1 sda2",
            "[ 3456.235] sd 0:0:0:0: [sda] Attached SCSI disk",
            "[ 3456.890] EXT4-fs (sda1): mounted filesystem with ordered data mode",
            "[ 3457.123] systemd[1]: Starting MySQL Community Server...",
            "[ 3457.456] oom_reaper: reaped process 4521 (mysqld), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB",
            "[ 3458.001] Out of memory: Killed process 4521 (mysqld) total-vm:1456789kB, anon-rss:1234567kB, file-rss:23456kB, shmem-rss:34567kB",
            "[ 3458.002] oom_reaper: reaped process 4521 (mysqld), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB",
            "[ 3459.000] systemd[1]: mysql.service: Main process exited, code=killed, status=9/OOM",
            "[ 3459.001] systemd[1]: mysql.service: Failed with result 'exit-code'.")
        C "tail -50 /var/log/mysql/error.log" @("2026-06-08 03:14:55 0 [ERROR] InnoDB: Database page corruption on disk or a failed",
            "2026-06-08 03:14:55 0 [ERROR] InnoDB: file read of page 3456 failed",
            "2026-06-08 03:14:56 0 [ERROR] InnoDB: Page [page id: space=0, page number=3456] log sequence number 123456789 is in the future!",
            "2026-06-08 03:14:56 0 [ERROR] InnoDB: Operating system error number 28 in a file operation.",
            "2026-06-08 03:14:56 0 [ERROR] InnoDB: Error number 28 means 'No space left on device'",
            "2026-06-08 03:14:57 0 [ERROR] InnoDB: Could not open or create system tablespace. If you tried to add new data files to the system tablespace, and it failed here,",
            "2026-06-08 03:14:57 0 [ERROR] InnoDB: you can now edit innodb_data_file_path parameter in my.cnf and try again.",
            "2026-06-08 03:14:58 1 [ERROR] [FATAL] InnoDB: Space id and page no stored in the page are invalid.")
        C "systemctl restart mysql" @("Job for mysql.service failed because the control process exited with error code.",
            "See `"systemctl status mysql.service`" and `"journalctl -xeu mysql.service`" for details.")
        C "du -sh /var/log/*" @("4.0K    /var/log/alternatives.log",
            "2.5G    /var/log/mysql",
            "1.2G    /var/log/nginx",
            "4.0K    /var/log/private",
            "890M    /var/log/journal",
            "12M     /var/log/syslog",
            "4.0K    /var/log/wtmp",
            "6.5G    /var/log/")
        C "systemctl list-units --state=failed" @("  UNIT                    LOAD   ACTIVE SUB    DESCRIPTION",
            "  mysql.service          loaded failed failed MySQL Community Server",
            "  cron.service           loaded failed failed Regular background program processing daemon",
            "  ufw.service            loaded failed failed Uncomplicated firewall",
            "",
            "LOAD   = Reflects whether the unit definition was properly loaded.",
            "ACTIVE = The high-level unit activation state, i.e. generalization of SUB.",
            "SUB    = The low-level unit activation state, values depend on unit type.",
            "",
            "3 loaded units listed.")
        C "df -i" @("Filesystem      Inodes  IUsed   IFree IUse% Mounted on",
            "/dev/sda1      1310720 1189234  121486   91% /",
            "/dev/sdb1      3276800 2983456  293344   91% /var/lib/mysql")
        C "ping -c 3 10.0.0.1" @("PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.",
            "64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.345 ms",
            "64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.289 ms",
            "64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.312 ms",
            "",
            "--- 10.0.0.1 ping statistics ---",
            "3 packets transmitted, 3 received, 0% packet loss, time 2345ms",
            "rtt min/avg/max/mdev = 0.289/0.315/0.345/0.023 ms")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-OutageCommands} -Theme (Get-Theme outage) -ModeName "Production Outage" -TargetHost "srv-db-01" -TargetDomain "prod.internal" -TargetIP (RandIP) -TargetCompany "CloudScale Inc" -TargetLocation "Frankfurt DC" -TargetOS "Ubuntu 22.04 LTS" -OSPrompt "root@srv-db-01:~#" -AllowFailures
}