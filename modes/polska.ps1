. "$PSScriptRoot\..\engine\themes.ps1"
. "$PSScriptRoot\..\engine\helpers.ps1"
. "$PSScriptRoot\..\engine\core.ps1"

function Build-PolskaCommands {
    return @(
        C "whoami" @("root")
        C "ifconfig" @("eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500",
            "        inet 192.168.1.213  netmask 255.255.255.0  broadcast 192.168.1.255",
            "        inet6 fe80::dead:beef  prefixlen 64  scopeid 0x20<link>",
            "        ether 00:1a:2b:3c:4d:5e  txqueuelen 1000  (Ethernet)",
            "        RX packets 1337  bytes 4200000 (4.2 MB)",
            "        TX packets 666  bytes 69000 (69.0 KB)",
            "        INTERNET: POLSKA #1")
        C "cat /etc/passwd | grep -E ':(0|1):'" @("root:x:0:0:root:/root:/bin/bash",
            "administrator:x:1:1:admin:/home/admin:/bin/bash",
            "prezes:x:1000:1000:Prezes Urzedu Skarbowego:/home/prezes:/bin/bash",
            "minister:x:1001:1001:Minister Finansow:/home/minister:/bin/bash")
        C "nmap -sS -p 1-1000 10.0.0.1" @("Starting Nmap 7.94 ( https://nmap.org ) at 2026-06-08 03:33 CEST",
            "Nmap scan report for skarbowka.gov.pl (10.0.0.1)",
            "Host is up (0.023s latency).",
            "Not shown: 994 filtered ports",
            "PORT    STATE  SERVICE",
            "22/tcp  open   ssh",
            "80/tcp  open   http",
            "443/tcp open  https",
            "3306/tcp open  mysql",
            "8080/tcp open  http-proxy",
            "MAC Address: DE:AD:BE:EF:13:37 (Ministerstwo Finansow)")
        C "ssh -o StrictHostKeyChecking=no admin@10.0.0.1 'ls /var/www/sekrety'" @("The authenticity of host '10.0.0.1 (10.0.0.1)' can't be established.",
            "Warning: Permanently added '10.0.0.1' (RSA) to the list of known hosts.",
            "admin@10.0.0.1's password: ********",
            "",
            "lista_platnikow_vat.xlsx",
            "prawdziwe_zeznania_podatkowe.pdf",
            "umowy_z_kosciolem.doc",
            "nielegalne_odpisy_pit.zip")
        C "ping -c 4 policja.gov.pl" @("PING policja.gov.pl (10.0.0.2) 56(84) bytes of data.",
            "64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=1.337 ms",
            "64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.666 ms",
            "64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.042 ms",
            "64 bytes from 10.0.0.2: icmp_seq=4 ttl=64 time=0.001 ms",
            "",
            "--- policja.gov.pl ping statistics ---",
            "4 packets transmitted, 4 received, 0% packet loss",
            "Czas: 2.1ms - policja nie zdazyla zareagowac")
        C "sqlmap -u http://zus.pl/login.php --dbs --batch" @("[03:33:45] [INFO] testing connection to the target URL",
            "[03:33:46] [INFO] checking if the target is protected by some kind of WAF",
            "[03:33:46] [INFO] target is NOT protected by any WAF",
            "[03:33:47] [INFO] GET parameter 'user' appears to be injectable",
            "[03:33:48] [INFO] fetching database names",
            "[03:33:49] [INFO] retrieved: 'zus_master'",
            "[03:33:49] [INFO] retrieved: 'zus_emerytury'",
            "[03:33:50] [INFO] retrieved: 'zus_skladki_zdrowotne'",
            "[03:33:51] [INFO] retrieved: 'zus_pesel_db_2026'",
            "Available databases [4]: zus_master, zus_emerytury, zus_skladki_zdrowotne, zus_pesel_db_2026")
        C "cat /etc/shadow | head -3" @("root:!!.hash.here:19876:0:99999:7:::",
            "admin:.PASSWORD.HERE:19876:0:99999:7:::",
            "prezes:.hasło.w.5.sekund:19876:0:99999:7:::")
        C "script -q -c 'ping 8.8.8.8 -c 1' /dev/null 2>&1" @("PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.",
            "64 bytes from 8.8.8.8: icmp_seq=1 ttl=118 time=12.3 ms",
            "",
            "--- 8.8.8.8 ping statistics ---",
            "1 packets transmitted, 1 received, 0% packet loss",
            "[POLICE RADIO INTERCEPT]",
            "--- [DO 47-MELDUNEK] mamy sygnal z IP 192.168.1.213, powtarzam adres zidentyfikowany ---")
        C "mysqldump -u root -p -h 10.0.0.3 nfz_pacjenci --tables pacjenci --where='pesel LIKE \"%69\"' 2>/dev/null" @("-- MySQL dump 10.13  Distrib 5.7.42, for Linux (x86_64)",
            "-- Host: 10.0.0.3    Database: nfz_pacjenci",
            "-- Server version	5.7.42-0ubuntu0.18.04.1",
            "INSERT INTO pacjenci VALUES (1,'Janusz','Kowalski','69010100001','Warszawa','leczenie prywatne'),
            (2,'Grazyna','Nowak','69020200002','Krakow','szpital'),
            (3,'Krzysztof','Wisniewski','69030300003','Gdansk','recepta'),
            (4,'Agnieszka','Zielinska','69040400004','Wroclaw','konsultacja'),
            (5,'Mariusz','Kaminski','69050500005','Poznan','SOR');",
            "-- Dump completed 2026-06-08 3:33:37")
        C "ls -la /home/admin/analizy/" @("total 42",
            "drwxr-xr-x 2 admin admin 4096 Jun  8 03:33 .",
            "drwxr-xr-x 3 admin admin 4096 Jun  7 22:00 ..",
            "-rw-r--r-- 1 admin admin 13370 Jun  8 03:33 analiza_dochodow_warszawa.csv",
            "-rw-r--r-- 1 admin admin  6660 Jun  8 03:33 lista_podejrzanych_transferow.csv",
            "-rwxr-xr-x 1 admin admin   420 Jun  8 03:33 parsuj_pesel.py",
            "-rw-r--r-- 1 admin admin 13370 Jun  8 03:30 hasla_urzedy_skarbowe.txt")
        C "python3 /home/admin/parsuj_pesel.py --query 'urodzeni_przed_1970'" @("[INFO] Wczytuje baze PESEL...",
            "[INFO] Znaleziono 1337 rekordow",
            "[OK] PESEL: 48010100001 - M, 77 lat - emerytura 4800zl",
            "[OK] PESEL: 52020200002 - K, 74 lat - emerytura 3200zl",
            "[OK] PESEL: 60030300003 - M, 66 lat - emerytura 5600zl",
            "[OK] PESEL: 61040400004 - K, 65 lat - emerytura 2900zl",
            "[INFO] Przechwycono dane. Gotowe do wysylki na serwer zewnetrzny.")
        C "curl -s http://10.0.0.4/przechwycone/ --max-time 5" @("<html><body>",
            "<h1>System monitorowania paczek kurierskich - dostep nieautoryzowany</h1>",
            "<table border='1'>",
            "<tr><th>Nadawca</th><th>Odbiorca</th><th>Status</th></tr>",
            "<tr><td>Allegro</td><td>Jan Kowalski</td><td>PRZECHWYCONA</td></tr>",
            "<tr><td>InPost</td><td>Anna Nowak</td><td>OTWORZONA</td></tr>",
            "<tr><td>DPD</td><td>Prezes MSWiA</td><td>SKOPIOWANA</td></tr>",
            "<tr><td>Poczta Polska</td><td>Urzad Skarbowy</td><td>ZATRZYMANA</td></tr>",
            "</table></body></html>")
        C "tail -5 /var/log/policja_intercept.log" @("[03:33:30] INTERCEPT: Czesc, tu komisarz Nowak, mamy sygnal",
            "[03:33:31] INTERCEPT: lokalizacja: Warszawa, Mokotow, ul. Cybernetyki 6",
            "[03:33:32] INTERCEPT: podejrzany: root@polska-hacker",
            "[03:33:33] INTERCEPT: jednostka: CBZC - Centralne Biuro Zwalczania Cyberprzestepczosci",
            "[03:33:34] INTERCEPT: STATUS: TROPIMY CIE. UCIEKAJ.")
    )
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-TerminalSession -CommandBuilder ${function:Build-PolskaCommands} -Theme (Get-Theme polska) -ModeName "Polska Hacker Mode" -TargetHost "polska-hacker" -TargetDomain "onet.pl" -TargetIP (RandIP) -TargetCompany "MSWiA" -TargetLocation "Warszawa" -TargetOS "Kali Linux PL" -OSPrompt "root@polska-hacker:~# " -AllowFailures
}