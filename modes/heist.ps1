. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-HeistCommands {
    return @(
        C "whoami" @("ghost")
        C "hostname" @("infiltrator")
        C "id" @("uid=0(root) gid=0(root) groups=0(root)")
        C "./disable-alarm --vault zurich --override 0xDEADBEEF" @("[*] Initializing alarm bypass module...",
            "[*] Handshake with vault security panel: ESTABLISHED",
            "[+] Sending override token: 0xDEADBEEF",
            "[+] Alarm panel firmware: v3.2.1 - VULNERABLE",
            "[+] Override accepted. Alarm system: DISABLED",
            "[*] Perimeter sensors: OFFLINE",
            "[*] Vault door sensors: OFFLINE",
            "[*] Camera feed: LOOPING (30 min buffer)",
            "[!] You have 29:47 before silent alarm triggers")
        C "./clone-db --source vault.secure:3306 --output /tmp/exfil/vault_dump.sql --user sa --hash 4a7d1ed8a4e3b2c1f9d0e8f7a6b5c4d3" @("[*] Connecting to vault.secure:3306 with elevated privileges...",
            "[+] Connection established. Detected: MySQL 8.0.35",
            "[*] Resolving schema: vault_main (12 tables, 987,654 rows)",
            "[*] Dumping table: account_holders (345,678 rows)... DONE",
            "[*] Dumping table: account_balances (987,654 rows)... DONE",
            "[*] Dumping table: transaction_log (1,234,567 rows)... DONE",
            "[*] Dumping table: safe_combinations (42 rows)... DONE",
            "[+] Database clone complete: 2.3 GB written to /tmp/exfil/vault_dump.sql",
            "[*] Checksum: a1b2c3d4e5f67890a1b2c3d4e5f67890")
        C "./wire-transfer --account 48302947 --routing 11000029 --amount 999999.99 --to offshore://bank.seychelles/swift/SECYSCSC --currency USD" @("[*] Establishing SWIFT connection: bank.seychelles (SECYSCSC)...",
            "[+] SWIFT gateway: CONNECTED",
            "[*] Authenticating as wire operator #8472 (credentials from dump)...",
            "[+] Authentication: GRANTED",
            "[*] Initiating wire transfer...",
            "[+] Sending: $999,999.99 USD",
            "[+] From Account: 48302947 (Zurich Vault - First National Bank)",
            "[+] To Account: 74839201 (Seychelles International Trust)",
            "[+] SWIFT Ref: BNKZCHZZXXXX",
            "[*] Processing... 25%... 50%... 75%...",
            "[+] Transfer COMPLETE. Confirmation: TX-9A8B-7C6D-5E4F",
            "[!] Remaining balance on account 48302947: $1.23")
        C "./cover-tracks --scrub /var/log/ --pattern *bank*" @("[*] Scanning /var/log/ for traces...",
            "[*] Found 12 files matching pattern '*bank*'",
            "[*] Scrubbing file: /var/log/auth.log (3 entries removed)",
            "[*] Scrubbing file: /var/log/secure (7 entries removed)",
            "[*] Scrubbing file: /var/log/messages (2 entries removed)",
            "[*] Scrubbing file: /var/log/syslog (4 entries removed)",
            "[*] Scrubbing file: /var/log/audit/audit.log (12 entries removed)",
            "[+] Secure wipe complete: 28 entries overwritten",
            "[+] Journal entries: NULLIFIED")
        C "./wipe-logs --all --secure" @("[WARNING] This will permanently delete all system logs!",
            "Are you sure? (y/N): y",
            "[*] Secure wiping /var/log/*.log...",
            "[*] Overwriting with zeros: PASS 1/3",
            "[*] Overwriting with random data: PASS 2/3",
            "[*] Overwriting with zeros: PASS 3/3",
            "[+] /var/log/auth.log: WIPED",
            "[+] /var/log/syslog: WIPED",
            "[+] /var/log/kern.log: WIPED",
            "[+] /var/log/audit/audit.log: WIPED",
            "[+] Log rotation backups: REMOVED",
            "[*] Securing free space (overwriting deleted inodes)...",
            "[+] All traces removed. 256 MB of free space sanitized.")
        C "./decrypt-safe --vault-door 4 --hash a1b2c3d4e5f67890a1b2c3d4e5f67890 --wordlist /tmp/words.txt" @("[*] Initializing safe decryption module...",
            "[*] Vault Door #4 detected: Chubb DSG-3 electronic lock",
            "[*] Extracted hash: a1b2c3d4e5f67890a1b2c3d4e5f67890",
            "[*] Running dictionary attack with 1,234,567 entries...",
            "[*] Trying combinations... 0.5% complete",
            "[*] Match found! Code: 74-28-39 (left 3 turns, right 2 turns, left 1 turn)",
            "[+] Decryption successful! Vault door #4: OPEN",
            "[+] Contents: Safety deposit boxes #4101-#4150",
            "[*] Extracting physical key from deposit box #4124...")
        C "nc vault.secure 443" @("Trying 10.10.10.10...",
            "Connected to vault.secure.",
            "Escape character is '^]'.",
            "220 Vault Secure Gateway v2.1.4",
            "EHOST SPOOFING...",
            "250 Hello ghost@infiltrator.local",
            "MAIL FROM:<ceo@firstnational.bank>",
            "250 2.1.0 Sender OK",
            "RCPT TO:<internal.audit@firstnational.bank>",
            "250 2.1.5 Recipient OK",
            "DATA",
            "354 Start mail input; end with <CRLF>.<CRLF>",
            "Subject: Urgent: Wire Transfer Authorization",
            "",
            "Please authorize immediate wire of $999,999.99 to account 74839201.",
            "Approved by CEO.",
            ".",
            "250 2.0.0 Message accepted for delivery")
        C "./bypass-firewall --target vault.secure --method icmp_tunnel" @("[*] ICMP tunnel module v1.4 loaded",
            "[*] Target: vault.secure (10.10.10.10)",
            "[*] Firewall detection: Palo Alto PA-5250 (firmware 10.2.5)",
            "[*] ICMP tunnel handshake: ESTABLISHED",
            "[+] Covert channel opened on ICMP echo-request packets",
            "[*] Data rate: 2.4 Mbps (limited by ICMP size restrictions)",
            "[*] Encrypted payload: AES-256-GCM",
            "[*] Uploading /tmp/exfil/vault_dump.sql...",
            "[+] 2.3 GB / 2.3 GB - 100% complete",
            "[+] Exfiltration complete via ICMP tunnel")
        C "strings /tmp/exfil/vault_dump.sql | grep 'safe_code' | head -5" @("safe_code,4101,74-28-39",
            "safe_code,4102,18-56-92",
            "safe_code,4103,33-41-07",
            "safe_code,4104,62-15-88",
            "safe_code,4105,91-03-44")
        C "dd if=/dev/urandom of=/var/log/auth.log bs=1024 count=100" @("100+0 records in",
            "100+0 records out",
            "102400 bytes (102 kB, 100 KiB) copied, 0.0456789 s, 2.2 MB/s")
        C "echo 'Connection closed.' >> /var/log/messages; shutdown -h now" @("")
        C "cat /tmp/exfil/summary.txt" @("=== OPERATION NIGHTSHADE - COMPLETE ===",
            "",
            "Target:     First National Bank - Zurich Vault",
            "Vault Door: #4 (Chubb DSG-3 / code: 74-28-39)",
            "Accounts:   12 high-value accounts identified",
            "Transferred: $999,999.99 to Seychelles International Trust",
            "Data:       2.3 GB exfiltrated (account records, safe codes, client list)",
            "Logs:       All system logs wiped and overwritten",
            "Status:     COVERED - No traces remaining",
            "",
            "Next window: 72 hours for Phase 2.")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-HeistCommands} -Theme (Get-Theme heist) -ModeName "Data Heist" -TargetHost "infiltrator" -TargetDomain "vault.secure" -TargetIP (RandIP) -TargetCompany "First National Bank" -TargetLocation "Zurich Vault" -TargetOS "CipherOS 3.0" -OSPrompt "ghost@infiltrator:~$ " -AllowFailures
}