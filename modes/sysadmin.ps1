. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-SysadminCommands {
    return @(
        C "whoami" @("admin")
        C "hostname" @("mail-srv")
        C "id" @("uid=1001(admin) gid=1001(admin) groups=1001(admin),10(wheel),997(docker)")
        C "sudo useradd -m -s /bin/bash jkowalski" @("")
        C "sudo passwd jkowalski" @("Changing password for user jkowalski.",
            "New password:",
            "Retype new password:",
            "passwd: all authentication tokens updated successfully.")
        C "df -h" @("Filesystem                   Size  Used Avail Use% Mounted on",
            "/dev/mapper/rl-root         50G   32G   18G  64% /",
            "/dev/sda1                   1G  300M  724M  30% /boot",
            "/dev/mapper/rl-backup      500G  300G  200G  60% /mnt/backup",
            "tmpfs                       8G  2.5G  5.5G  32% /dev/shm")
        C "free -h" @("              total        used        free      shared  buff/cache   available",
            "Mem:           15Gi        8.2Gi        1.1Gi        345Mi        6.7Gi        6.1Gi",
            "Swap:          4.0Gi        1.2Gi        2.8Gi")
        C "top -bn1 | head -15" @("top - 14:23:11 up 45 days,  2:15,  1 user,  load average: 1.20, 0.80, 0.45",
            "Tasks: 123 total,   1 running, 122 sleeping,   0 stopped,   0 zombie",
            "%Cpu(s): 12.5 us,  3.2 sy,  0.0 ni, 84.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st",
            "MiB Mem :  16000.0 total,   1200.0 free,   8200.0 used,   6600.0 buff/cache",
            "MiB Swap:   4096.0 total,   2800.0 free,   1296.0 used.   7200.0 avail Mem",
            "",
            "    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND",
            "   3456 root      20   0  567890  45678   1234 S  12.0   0.3  45:23.12 mysqld",
            "   2345 root      20   0  345678  23456   4567 S   5.0   0.1  12:34.56 nginx",
            "   1234 root      20   0  234567  12345   2345 S   3.0   0.1   8:45.67 httpd",
            "   4567 postfix   20   0  123456  23456   3456 S   1.0   0.1   4:56.78 master",
            "   5678 admin     20   0   45678   5678   2345 R   0.3   0.0   0:01.23 top")
        C "tar -czf /mnt/backup/mail-2026-06-08.tar.gz /var/mail /var/spool" @("tar: Removing leading '/' from member names",
            "/var/mail/",
            "/var/mail/admin",
            "/var/mail/jkowalski",
            "/var/mail/postmaster",
            "/var/spool/",
            "/var/spool/mail/",
            "/var/spool/cron/",
            "/var/spool/postfix/",
            "/var/spool/postfix/active/",
            "/var/spool/postfix/deferred/")
        C "rsync -avz --delete /mnt/backup/ admin@backup-srv:/backup/mail-srv/" @("sending incremental file list",
            "./",
            "mail-2026-06-07.tar.gz",
            "mail-2026-06-08.tar.gz",
            "config-backup-2026-06-08.tar.gz",
            "",
            "sent 1,234,567,890 bytes  received 45,678 bytes  45,678,901.23 bytes/sec",
            "total size is 1,234,567,890  speedup is 1.00")
        C "sudo dnf update -y" @("Last metadata expiration check: 2:34:12 ago on Mon Jun  8 11:49:01 2026.",
            "Dependencies resolved.",
            "==================================================================================",
            " Package                   Arch      Version                   Repository     Size",
            "==================================================================================",
            "Upgrading:",
            " nginx                     x86_64    1:1.24.1-1.el9            appstream     2.5M",
            " openssh                   x86_64    8.7p1-8.el9               baseos        789k",
            " postfix                   x86_64    3.7.4-1.el9               baseos        456k",
            " kernel                    x86_64    5.14.0-362.el9            baseos        123M",
            "",
            "Transaction Summary",
            "==================================================================================",
            "Upgrade  5 Packages",
            "",
            "Total download size: 129M",
            "Downloading:",
            "nginx-1.24.1-1.el9.x86_64.rpm         2.5 MB/s | 2.5 MB     00:01",
            "openssh-8.7p1-8.el9.x86_64.rpm        1.2 MB/s | 789 kB    00:00",
            "Complete!")
        C "sudo crontab -l -u admin" @("0 2 * * * /usr/bin/rsync -avz /var/www/ admin@backup-srv:/backup/www/",
            "30 3 * * * /usr/bin/tar -czf /mnt/backup/db-$(date +\%Y\%m\%d).tar.gz /var/lib/mysql",
            "0 4 * * * /usr/sbin/logrotate /etc/logrotate.d/custom",
            "*/5 * * * * /usr/local/bin/check-mysql-health.sh",
            "@daily /usr/local/bin/cleanup-temp.sh")
        C "sudo logrotate -f /etc/logrotate.d/nginx" @("reading config file /etc/logrotate.d/nginx",
            "Reading state from file: /var/lib/logrotate/logrotate.status",
            "Allocating hash table for state file, size 23456 bytes",
            "Rotating log file: /var/log/nginx/access.log",
            "Rotating log file: /var/log/nginx/error.log",
            "Rotating log file: /var/log/nginx/admin.access.log",
            "Removing old log file /var/log/nginx/access-20260531.log.gz")
        C "sudo mount /dev/sdc1 /mnt/data" @("")
        C "lsblk" @("NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS",
            "sda           8:0    0  100G  0 disk",
            "|-sda1        8:1    0    1G  0 part /boot",
            "|-sda2        8:2    0   99G  0 part",
            "  |-rl-root 253:0    0   50G  0 lvm  /",
            "  |-rl-swap 253:1    0    4G  0 lvm  [SWAP]",
            "  |-rl-home 253:2    0   45G  0 lvm  /home",
            "sdb           8:16   0  500G  0 disk",
            "|-sdb1        8:17   0  500G  0 part /mnt/backup",
            "sdc           8:32   0  250G  0 disk",
            "|-sdc1        8:33   0  250G  0 part /mnt/data",
            "sr0          11:0    1 1024M  0 rom")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-SysadminCommands} -Theme (Get-Theme sysadmin) -ModeName "SysAdmin Simulator" -TargetHost "mail-srv" -TargetDomain "office.local" -TargetIP (RandIP) -TargetCompany "MidSize Corp" -TargetLocation "Berlin Office" -TargetOS "Rocky Linux 9.3" -OSPrompt "admin@mail-srv:~$ "
}