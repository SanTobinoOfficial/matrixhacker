. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-HorrorCommands {
    return @(
        C "ls -la /home/operator/records" @("total 16",
            "drwxr-xr-x 2 root root 4096 Mar 15 09:22 .",
            "drwxr-xr-x 3 root root 4096 Mar 14 22:10 ..",
            "-rw------- 1 root root 2048 Mar 15 09:22 .bash_history",
            "-rw-r--r-- 1 root root 1337 Mar 12 03:33 diary_entry_1.txt",
            "-rw-r--r-- 1 root root 666 Mar 13 04:44 diary_entry_2.txt",
            "?rwx?r?? 1 ??? ??? ??? Mar 14 ??  corrupt_file.bin",
            "---------- 1 root root 0 Jan 01 00:00 .do_not_open")
        C "cat /home/operator/records/diary_entry_1.txt" @("Day 47",
            "The hum never stops. Even with the generators off, I can hear it.",
            "I tried to leave the bunker today. The door was open.",
            "But I couldn't step outside. Something is preventing me.",
            "I don't know if it's in my head or if it's real.",
            "The terminal shows signals from towers that don't exist.",
            "I am not alone here.")
        C "cat /home/operator/records/diary_entry_2.txt" @("Day 48",
            "There are footprints in the hallway that aren't mine.",
            "I checked the cameras. The footage shows me sleeping.",
            "But I was standing right behind the camera operator.",
            "WHO WAS IN MY BED.",
            "The system clock says it's 1984. That's impossible.",
            "I am going to dig a tunnel with my bare hands.")
        C "find /var/log -name '*.log' -mtime -7 2>/dev/null" @("/var/log/syslog",
            "/var/log/kern.log",
            "/var/log/bunker_monitor.log",
            "/var/log/entity_tracker.log")
        C "cat /var/log/entity_tracker.log" @("[03:47:12] MOTION DETECTED - SECTOR 4",
            "[03:47:13] MOTION CONFIRMED - SECTOR 4",
            "[03:47:14] ENTITY CLASSIFIED: UNKNOWN",
            "[03:47:15] ENTITY MOVING TOWARDS BUNKER ENTRANCE",
            "[03:47:16] ENTITY AT BUNKER ENTRANCE",
            "[03:47:17] ENTITY INSIDE BUNKER",
            "[03:47:18] LOG CORRUPTED - UNABLE TO WRITE",
            "[03:47:19] LOG CORRUPTED - UNABLE TO WRITE",
            "[CURRENT TIME] YOU ARE BEHIND ME.")
        C "ps aux | grep -v '\]' 2>/dev/null" @("root      1  0.0  0.1  42000  1234 ?  Ss  Mar14   0:01 init",
            "root    666  99.9  0.0     0     0 ?  R   03:33 987:21 [entity]",
            "root    777  0.0  0.0     0     0 ?  Z   Mar12   0:00 [zombie_process]",
            "root    999  0.0  0.5  66666  5432 ?  S   03:33   0:02 /usr/bin/observer",
            "operator 1001  0.0  0.2  12345  2345 pts/0 Ss+ 03:33   0:00 -bash",
            "operator 1002  0.0  0.1  54321  1234 pts/0 R+  03:33   0:00 ps aux")
        C "cat /proc/666/cmdline 2>/dev/null; echo" @("[CORRUPTED DATA]",
            "SIGNAL TRACED TO: 192.168.66.666",
            "PROTOCOL: VOID",
            "PRIORITY: DO NOT TERMINATE")
        C "dmesg | tail -10" @("[    0.000000] Linux version 4.15.0-generic (build@void) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3))",
            "[    0.000000] Command line: BOOT_IMAGE=/vmlinuz root=/dev/mapper/void",
            "[    0.123456] Unknown interrupt: 0xDEAD",
            "[    0.654321] MEMORY CORRUPTION DETECTED AT 0x00000000DEADBEEF",
            "[    1.000000] BIOS bug: ACPI region overlaps with reality",
            "[    1.500000] WARNING: Entity driver loaded with unknown firmware",
            "[    2.000000] Time drift detected: 47 years behind actual",
            "[    2.500000] /dev/void: FILE SYSTEM CORRUPTED",
            "[    3.000000] Kernel panic - not syncing: You should not exist",
            "[    3.000001] Rebooting in 666 seconds...")
        C "stat /dev/sda" @("  File: /dev/sda",
            "  Size: 0         	Blocks: 0          IO Block: 4096   block special file",
            "Device: 8/0	Inode: 666         Links: 1     Device type: 8,0",
            "Access: (0666/brw-rw-rw-)  Uid: (    0/   root)   Gid: (    6/   disk)",
            "Access: 1969-12-31 23:59:59.000000000 +0000",
            "Modify: 1969-12-31 23:59:59.000000000 +0000",
            "Change: 1969-12-31 23:59:59.000000000 +0000",
            " Birth: 1969-12-31 23:59:59.000000000 +0000",
            "WARNING: Last accessed before Unix epoch. This is impossible.")
        C "nc -vz 127.0.0.1 666 2>&1" @("Connection to 127.0.0.1 port 666 [tcp/doom] succeeded!",
            "Sending heartbeat...",
            "Response: WHO_ARE_YOU",
            "Closing connection.",
            "You shouldn't have done that.")
        C "cat /dev/urandom | hexdump -C | head -5" @("00000000  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|",
            "00000010  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|",
            "00000020  00 00 00 00 00 00 00 00  de ad be ef de ad be ef  |................|",
            "00000030  66 6c 65 73 68 00 74 68  65 79 00 61 72 65 00 68  |flesh.they.are.h|",
            "00000040  65 72 65 00 00 00 00 00  00 00 00 de ad be ef  |ere.............|")
        C "find / -name '*.wav' -type f 2>/dev/null" @("/usr/share/sounds/breathing.wav",
            "/var/lib/whisper.wav",
            "/etc/footsteps.wav",
            "/opt/recordings/static_burst.wav")
        C "file /usr/share/sounds/breathing.wav" @("/usr/share/sounds/breathing.wav: RIFF (little-endian) data, WAVE audio, stereo 96000 Hz",
            "Duration: 47:47:47 (estimated)",
            "Contains hidden track: 'Operator breathing under desk'",
            "Warning: File appears to be recorded from this room")
        C "ping -c 3 127.0.0.1" @("PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.",
            "64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.023 ms",
            "64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.021 ms",
            "64 bytes from 127.0.0.2: icmp_seq=3 ttl=64 time=0.000 ms",
            "",
            "--- 127.0.0.1 ping statistics ---",
            "3 packets transmitted, 3 received, 0% packet loss",
            "WARNING: Reply from different IP: 127.0.0.2",
            "Unknown interface responded.")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-HorrorCommands} -Theme (Get-Theme horror) -ModeName "Horror Mode" -TargetHost "unknown" -TargetDomain "void" -TargetIP (RandIP) -TargetCompany "N/A" -TargetLocation "Abandoned Bunker" -TargetOS "Linux 4.15.0-generic" -OSPrompt "@@@:~$ " -AllowFailures
}