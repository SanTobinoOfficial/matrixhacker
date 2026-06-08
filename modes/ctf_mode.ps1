. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-Ctf_modeCommands {
    return @(
        C "ls -la" @("total 72",
            "drwxr-xr-x 6 ctf-player ctf-player 4096 Jun  8 00:00 .",
            "drwxr-xr-x 3 root      root      4096 Jun  7 22:00 ..",
            "-rw-r--r-- 1 ctf-player ctf-player  220 Jun  8 00:00 .bash_logout",
            "-rw-r--r-- 1 ctf-player ctf-player 3771 Jun  8 00:00 .bashrc",
            "-rw-r--r-- 1 ctf-player ctf-player  807 Jun  8 00:00 .profile",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:00 challenge_one",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:00 challenge_two",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:00 challenge_three",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:00 .hidden_stash",
            "-rw-r--r-- 1 ctf-player ctf-player   42 Jun  8 00:00 README.md")
        C "cat README.md" @("# CTF Challenge - Cyber Range v1.0",
            "",
            "Welcome, agent. Your mission is to find all flags hidden in this system.",
            "There are 5 flags total. Each flag follows the format: CTF{...}",
            "",
            "Hints:",
            "1. Always check hidden files and directories",
            "2. Environment variables can contain secrets",
            "3. Backup files often contain sensitive data",
            "4. Base64 is not encryption",
            "5. Check what commands you can run as sudo",
            "",
            "Good luck. You will need it.")
        C "ls -la challenge_one/" @("total 20",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:01 .",
            "drwxr-xr-x 6 ctf-player ctf-player 4096 Jun  8 00:00 ..",
            "-rw-r--r-- 1 ctf-player ctf-player  122 Jun  8 00:01 data.txt",
            "-rw-r--r-- 1 ctf-player ctf-player   15 Jun  8 00:01 .hidden.txt")
        C "cat challenge_one/.hidden.txt" @("CTF{n0t_s0_h1dd3n}")
        C "cat challenge_one/data.txt" @("VGhpcyBpcyBub3QgYSBmbGFnLiBUaGUgcmVhbCBmbGFnIGlzIGJlbG93Lg0KDQpDVEZ7YjQ1M182NF8xNV9lNHN5XzI1fQ0KDQpLZWVwIGxvb2tpbmc=",
            "",
            "[HINT: The file above is base64 encoded. Decode it.]")
        C "echo " @("CTF{3nv_v4r14bl3s_4r3_fun}")
        C "ls -la challenge_two/" @("total 16",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:02 .",
            "drwxr-xr-x 6 ctf-player ctf-player 4096 Jun  8 00:00 ..",
            "-rw-r--r-- 1 ctf-player ctf-player  256 Jun  8 00:02 config.bak",
            "-rw-r--r-- 1 ctf-player ctf-player  512 Jun  8 00:02 notes.txt")
        C "cat challenge_two/config.bak" @("# Database Configuration - DO NOT COMMIT",
            "DB_HOST=127.0.0.1",
            "DB_PORT=3306",
            "DB_USER=admin",
            "DB_PASS=CTF{b4ckup_f1l3s_4r3_d4ng3r0us}",
            "DB_NAME=ctf_challenges",
            "FLAG_REFERENCE=flag_three_location: /opt/.flag_3.txt")
        C "cat challenge_two/notes.txt" @("TODO: Remove hardcoded credentials before pushing",
            "TODO: Encrypt config files",
            "TODO: Remove flag from backup",
            "PASSWORD_HINT: MyCatIsFluffy123",
            "SUDO_HINT: Check sudo -l for privilege escalation")
        C "sudo -l" @("Matching Defaults entries for ctf-player on ctf-challenge:",
            "    env_reset, mail_badpass, secure_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
            "",
            "User ctf-player may run the following commands on ctf-challenge:",
            "    (ALL) NOPASSWD: /bin/cat /opt/*.txt",
            "    (ALL) NOPASSWD: /usr/bin/find",
            "    (ALL) NOPASSWD: /usr/bin/base64 *")
        C "sudo cat /opt/.flag_3.txt" @("CTF{pr1v1l3g3_3sc4l4t10n_101}")
        C "ls -la challenge_three/" @("total 12",
            "drwxr-xr-x 2 ctf-player ctf-player 4096 Jun  8 00:03 .",
            "drwxr-xr-x 6 ctf-player ctf-player 4096 Jun  8 00:00 ..",
            "-rw-r--r-- 1 ctf-player ctf-player  177 Jun  8 00:03 encrypted.txt")
        C "cat challenge_three/encrypted.txt" @("FLAG 5: DERF{0ue_p3r5_r3ir0t_4_3un0p}",
            "",
            "Hint: Characters are reversed in this flag.",
            "Hint: The flag format has been scrambled too.",
            "Hint: CTF{...} becomes something else...")
        C "echo 'DERF{0ue_p3r5_r3ir0t_4_3un0p}' | rev" @("CTF{5_p0ur3_3xtr3r5p_5u0}")
        C "find / -name 'flag*' -type f 2>/dev/null" @("/home/ctf-player/challenge_one/.hidden.txt",
            "/home/ctf-player/challenge_two/config.bak",
            "/opt/.flag_3.txt",
            "/home/ctf-player/challenge_three/encrypted.txt",
            "/var/log/flag_ultimate.txt")
        C "cat /var/log/flag_ultimate.txt" @("Congratulations! You found all the flags.",
            "",
            "Submit them to the CTF portal to earn points.",
            "",
            "Final flag: CTF{4ll_fl4gs_f0und_c0ngr4ts}",
            "",
            "Remember: The real challenge was the friends we made along the way.")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-Ctf_modeCommands} -Theme (Get-Theme realistic) -ModeName "CTF Challenge Mode" -TargetHost "ctf-challenge" -TargetDomain "hacklab.local" -TargetIP (RandIP) -TargetCompany "CTF Academy" -TargetLocation "Cyber Range" -TargetOS "Debian 11" -OSPrompt "ctf-player@ctf-challenge:~$ " -AllowFailures
}