. "$PSScriptRoot/../engine/themes.ps1"
. "$PSScriptRoot/../engine/helpers.ps1"
. "$PSScriptRoot/../engine/core.ps1"

function Build-DarkwebCommands {
    return @(
        C "systemctl status tor" @("tor.service - Anonymizing Overlay Network",
            "     Loaded: loaded (/usr/lib/systemd/system/tor.service; enabled; vendor preset: enabled)",
            "     Active: active (running) since Mon 2026-06-08 02:13:37 UTC; 1h 20min ago",
            "   Main PID: 1337 (tor)",
            "      Tasks: 11 (limit: 2234)",
            "     Memory: 42.7M",
            "     CGroup: /system.slice/tor.service",
            "             |tor/1337 /usr/bin/tor --defaults-torrc /etc/tor/torrc")
        C "curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org/api/ip" @("{",
            '  "IsTor": true,',
            '  "IP": "185.220.101.42",',
            '  "Country": "Germany",',
            '  "ExitNode": true,',
            '  "TorVersion": "Tor 0.4.8.12",',
            '  "CircuitEstablished": true,',
            '  "RelayNickname": "AnonymousRelay42"',
            "}")
        C "cat /etc/tor/torrc | grep -v '^#' | grep -v '^$'" @("SOCKSPort 9050",
            "ControlPort 9051",
            "CookieAuthentication 1",
            "ExitNodes {us},{de},{nl},{se}",
            "StrictNodes 1",
            "NewCircuitPeriod 60",
            "MaxCircuitDirtiness 600",
            "NumEntryGuards 3")
        C "curl --socks5-hostname 127.0.0.1:9050 -s http://darkfailn6n7vz7w3j7v7q7q7u7o7j7h7k7n7f7a7b7c7d7.onion/status" @("<pre>",
            "DarkNet Relay Status Checker v3.2",
            "===================================",
            "Active .onion domains: 47,392",
            "Hidden services online: 12,847",
            "Average circuit latency: 847ms",
            "Exit nodes available: 1,234",
            "Bridges operational: 892",
            "Network status: STEALTH OPERATIONAL</pre>")
        C "bitcoin-cli getbalance" @("0.00133700 BTC",
            "Current value: ~.42 USD",
            "Transaction history: anonymized via CoinJoin")
        C "bitcoin-cli listunspent" @("[",
            "  {",
            '    "txid": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1",',
            '    "vout": 0,',
            '    "address": "bc1qanonymous1337xyzdeadbeef",',
            '    "amount": 0.00042000,',
            '    "confirmations": 6,',
            '    "spendable": true',
            "  },",
            "  {",
            '    "txid": "deadbeefcafe1234567890abcdef0987654321fedcba9876543210abcdef",',
            '    "vout": 1,',
            '    "address": "bc1qdarknetwallet42xyz",',
            '    "amount": 0.00091700,',
            '    "confirmations": 3,',
            '    "spendable": true',
            "  }",
            "]")
        C "gpg --list-keys" @("pub   rsa4096 2026-01-15 [SC]",
            "      A1B2C3D4E5F6123456789ABCDEF0123456789AB",
            "      uid   [ultimate] DarkVendor42 <vendor@darknet.onion>",
            "      sub   rsa4096 2026-01-15 [E]",
            "",
            "pub   rsa4096 2025-11-03 [SC]",
            "      1A2B3C4D5E6F7890123456789ABCDEF01234567",
            "      uid   [unknown] Buyer_Anon <anon@torbox.onion>",
            "      sub   rsa4096 2025-11-03 [E]")
        C "cd /home/user/darknet && ls -la markets/" @("total 64",
            "drwx------ 2 user user 4096 Jun  8 02:15 .",
            "drwx------ 4 user user 4096 Jun  6 19:42 ..",
            "-rw------- 1 user user 1337 Jun  8 02:15 alphabay_mirror.txt",
            "-rw------- 1 user user  420 Jun  8 02:16 incognito_url.txt",
            "-rw------- 1 user user 2048 Jun  6 20:00 bohemia_listings.txt",
            "-rw------- 1 user user  666 Jun  7 12:34 archetyp_products.csv",
            "-rw------- 1 user user 4096 Jun  8 02:10 listing_screenshots.tar.gz.enc")
        C "cat /home/user/darknet/markets/alphabay_mirror.txt" @("AlphaBay Market (Mirror v3)",
            "URL: http://alphabay524trz6nq5k3q6v7q7q7u7o7j7h7k7n7f7a7b7c7d7.onion",
            "Status: ONLINE",
            "Listings: 142,847",
            "Categories: Digital Goods, Physical Items, Services, Cards",
            "PGP Fingerprint: DEAD BEEF CAFE 1234 5678 9ABC DEF0 1111 2222 3333",
            "2FA: REQUIRED")
        C "cat /home/user/darknet/markets/archetyp_products.csv | head -8" @("Category,Product,Price(BTC),Vendor,Rating",
            "Digital,Ebook_Hacking_Guide,0.0025,CyberGhost42,4.9",
            "Digital,SQLi_Scanner_Pro,0.0150,ZeroDayLab,4.8",
            "Digital,Exploit_Pack_2026,0.0500,ExploitKing,4.7",
            "Physical,USB_Stealth_Keylogger,0.0080,HardwareHacker,4.5",
            "Cards,Visa_Platinum_Bin,0.0010,CardMaster,4.6",
            "Services,Social_Engineering_Kit,0.0033,PhishExpert,4.4",
            "Services,SMTP_Relay_Access,0.0020,SpamLord,4.3")
        C "curl --socks5-hostname 127.0.0.1:9050 -s http://checkip.amazonaws.com" @("185.220.101.42",
            "",
            "Your IP is masked via Tor exit node.",
            "Geo: Frankfurt, Germany",
            "ISP: Anonymous VPN Services Ltd.",
            "DNS leak: NOT DETECTED")
        C "proxychains nmap -sT -Pn -p 80,443,22,8080 10.0.2.15 2>&1 | tail -10" @("[proxychains] config file found: /etc/proxychains.conf",
            "[proxychains] preloading /usr/lib/libproxychains.so",
            "[proxychains] DLL init",
            "[proxychains] Strict chain  ...  127.0.0.1:9050  ...  10.0.2.15:443",
            "[proxychains] Strict chain  ...  127.0.0.1:9050  ...  10.0.2.15:80",
            "Starting Nmap 7.94 ( https://nmap.org )",
            "Nmap scan report for 10.0.2.15",
            "PORT     STATE  SERVICE",
            "22/tcp   open   ssh",
            "80/tcp   open   http")
        C "openssl enc -aes-256-cbc -d -in message.enc -out /dev/stdout -pass pass:darknet 2>/dev/null" @("BEGIN ENCRYPTED MESSAGE",
            "",
            "Meeting confirmed for 03:33 UTC.",
            "Signal at /dev/shm/.s",
            "Come alone. No electronics.",
            "Verify via PGP signature: DEADBEEF1234",
            "END ENCRYPTED MESSAGE")
        C "tor-resolve -4 5onionwz7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7.onion" @("5onionwz7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7v7.onion resolved to 127.42.42.42",
            "Hidden service .onion address validated",
            "Circuit: 3 hops established",
            "Route: Client -> Relay_DE -> Relay_FR -> Relay_SE -> Destination")
        C "electrum --testnet getaddresshistory bc1qdark 2>/dev/null | head -6" @("History for address bc1qdarknetwallet42xyz",
            "Transaction count: 47",
            "Total received: 4.20000000 BTC",
            "Total sent: 4.19866300 BTC",
            "Current balance: 0.00133700 BTC",
            "Last activity: 2026-06-08 01:33")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-DarkwebCommands} -Theme (Get-Theme darkweb) -ModeName "DarkWeb Mode" -TargetHost "user" -TargetDomain "tor-hidden" -TargetIP (RandIP) -TargetCompany "DarkNet Markets" -TargetLocation "Tor Network" -TargetOS "Tails 6.0" -OSPrompt "user@tor-hidden:~$ " -AllowFailures
}