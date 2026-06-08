# =====================================================================
# THEMES â€” color palettes, matrix char sets, mode metadata
# =====================================================================

$script:Themes = @{
    realistic = @{
        name = "Realistic Terminal"
        id = "realistic"
        matrixStyle = "matrix"
        promptColor = "Yellow"
        matrixHead = "White"
        matrixBright = "Green"
        matrixBody = "Green"
        matrixTail = "DarkGreen"
        accent = "Cyan"
        errorColor = "Red"
        briefColor = "DarkGray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+="
        overlayMsgs = @(
            "ACCESS GRANTED", "SSH handshake complete", "session opened",
            "SYS: loading kernel module", "eth0: link up"
        )
    }
    hollywood = @{
        name = "Hollywood Hacker"
        id = "hollywood"
        matrixStyle = "cyberpunk"
        promptColor = "Cyan"
        matrixHead = "White"
        matrixBright = "Cyan"
        matrixBody = "Blue"
        matrixTail = "DarkBlue"
        accent = "Red"
        errorColor = "Yellow"
        briefColor = "DarkYellow"
        chars = "0123456789ABCDEF<>-+*/=%#&|_~"
        overlayMsgs = @(
            "ENHANCE!", "ACCESSING MAINFRAME...", "FIREWALL BYPASSED",
            "ROUTING THROUGH 12 PROXIES", "SATELLITE UPLINK ESTABLISHED",
            "DECRYPTING 4096-bit RSA...", "IP TRACED: 85.23.14.77"
        )
    }
    cyberpunk = @{
        name = "Cyberpunk 2077"
        id = "cyberpunk"
        matrixStyle = "neon"
        promptColor = "Magenta"
        matrixHead = "White"
        matrixBright = "Cyan"
        matrixBody = "Magenta"
        matrixTail = "DarkMagenta"
        accent = "Yellow"
        errorColor = "Red"
        briefColor = "DarkCyan"
        chars = "ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅ0123456789"
        overlayMsgs = @(
            "NETRUNNER ACTIVE", "ICE BREACHED", "CORTICAL LINK ESTABLISHED",
            "BLACKWALL PROTOCOL INITIATED", "DATA FORGE: ACTIVE"
        )
    }
    matrix = @{
        name = "The Matrix"
        id = "matrix"
        matrixStyle = "matrix"
        promptColor = "Green"
        matrixHead = "White"
        matrixBright = "Green"
        matrixBody = "Green"
        matrixTail = "DarkGreen"
        accent = "DarkYellow"
        errorColor = "Red"
        briefColor = "DarkGreen"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+="
        overlayMsgs = @(
            "WAKE UP, NEO...", "THE MATRIX HAS YOU...", "FOLLOW THE WHITE RABBIT",
            "KNOCK KNOCK, NEO", "THERE IS NO SPOON", "RED PILL / BLUE PILL"
        )
    }
    mrrobot = @{
        name = "Mr. Robot"
        id = "mrrobot"
        matrixStyle = "matrix"
        promptColor = "DarkRed"
        matrixHead = "White"
        matrixBright = "Red"
        matrixBody = "DarkRed"
        matrixTail = "DarkGray"
        accent = "Green"
        errorColor = "Yellow"
        briefColor = "DarkGray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_[]{}<>"
        overlayMsgs = @(
            "HELLO FRIEND", "FSOCIETY", "EVIL CORP COMPROMISED",
            "MASK ON", "REBELLION STARTS NOW", "DELETE ALL RECORDS"
        )
    }
    outage = @{
        name = "Production Outage"
        id = "outage"
        matrixStyle = "cyberpunk"
        promptColor = "Red"
        matrixHead = "White"
        matrixBright = "Red"
        matrixBody = "Yellow"
        matrixTail = "DarkYellow"
        accent = "Cyan"
        errorColor = "Red"
        briefColor = "Yellow"
        chars = "0123456789ABCDEF<>-+*/=%#&|_~"
        overlayMsgs = @(
            "SEV-1 INCIDENT", "PAGE RECEIVED 03:00 AM", "DATABASE REPLICATION FAILURE",
            "MEMORY AT 97%", "ALERT: CASCADE FAILURE IMMINENT"
        )
    }
    tutorial = @{
        name = "Linux Tutorial"
        id = "tutorial"
        matrixStyle = "matrix"
        promptColor = "Yellow"
        matrixHead = "White"
        matrixBright = "Green"
        matrixBody = "Green"
        matrixTail = "DarkGreen"
        accent = "Cyan"
        errorColor = "Red"
        briefColor = "DarkGray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+="
        overlayMsgs = @(
            "TIP: try 'ls -la'", "TIP: use tab completion",
            "TIP: man is your friend", "TIP: pipes are powerful"
        )
    }
    pentest = @{
        name = "Pentest Report"
        id = "pentest"
        matrixStyle = "matrix"
        promptColor = "DarkYellow"
        matrixHead = "White"
        matrixBright = "DarkYellow"
        matrixBody = "DarkYellow"
        matrixTail = "DarkGray"
        accent = "Gray"
        errorColor = "Red"
        briefColor = "DarkYellow"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_<>:"
        overlayMsgs = @(
            "CVE-2024-XXXX: LOADING...", "VULNERABILITY SCANNING",
            "CRITICAL: 5 FINDINGS", "EXPLOIT AVAILABLE"
        )
    }
    sysadmin = @{
        name = "SysAdmin Simulator"
        id = "sysadmin"
        matrixStyle = "matrix"
        promptColor = "Blue"
        matrixHead = "White"
        matrixBright = "Cyan"
        matrixBody = "Blue"
        matrixTail = "DarkBlue"
        accent = "Yellow"
        errorColor = "Red"
        briefColor = "Gray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        overlayMsgs = @(
            "BACKUP COMPLETE", "CRON JOB TRIGGERED", "USER LOGIN DETECTED",
            "DISK SPACE WARNING", "CERTIFICATE EXPIRES IN 30 DAYS"
        )
    }
    heist = @{
        name = "Data Heist"
        id = "heist"
        matrixStyle = "cyberpunk"
        promptColor = "Cyan"
        matrixHead = "White"
        matrixBright = "Red"
        matrixBody = "Cyan"
        matrixTail = "DarkCyan"
        accent = "Yellow"
        errorColor = "Red"
        briefColor = "DarkGray"
        chars = "0123456789ABCDEF<>-+*/=%#&|_~"
        overlayMsgs = @(
            "DOWNLOADING... 47%", "EXFILTRATING DATABASE...",
            "38 GB TRANSFERRED", "ALERT: INTRUSION DETECTED",
            "COVERING TRACKS..."
        )
    }
    horror = @{
        name = "Horror Terminal"
        id = "horror"
        matrixStyle = "matrix"
        promptColor = "DarkRed"
        matrixHead = "Red"
        matrixBright = "DarkRed"
        matrixBody = "Gray"
        matrixTail = "DarkGray"
        accent = "Red"
        errorColor = "Red"
        briefColor = "DarkGray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&"
        overlayMsgs = @(
            "I CAN SEE YOU", "DONT TURN AROUND", "IT'S BEHIND YOU",
            "YOU SHOULDN'T BE HERE", "THERE ARE THINGS IN THE DARK",
            "RUN"
        )
    }
    polska = @{
        name = "Polska Hacker"
        id = "polska"
        matrixStyle = "cyberpunk"
        promptColor = "Yellow"
        matrixHead = "White"
        matrixBright = "Red"
        matrixBody = "White"
        matrixTail = "DarkGray"
        accent = "Cyan"
        errorColor = "Red"
        briefColor = "DarkYellow"
        chars = "0123456789ABCDEF<>-+*/=%#&|_~"
        overlayMsgs = @(
            "POLACZENIE NAWIAZANE", "URZAD SKARBOWY: DOSTEP ZABRONIONY",
            "PESEL DB: 45MB POBRANE", "MSWiA: BACKDOOR ZAINSTALOWANY",
            "POLSKA GUROM", "BAZA PESEL: SCIAGANIE..."
        )
    }
    darkweb = @{
        name = "Dark Web"
        id = "darkweb"
        matrixStyle = "matrix"
        promptColor = "DarkRed"
        matrixHead = "Red"
        matrixBright = "DarkRed"
        matrixBody = "DarkGray"
        matrixTail = "Black"
        accent = "Green"
        errorColor = "Red"
        briefColor = "DarkGray"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_."
        overlayMsgs = @(
            "CONNECTING TO TOR...", "CIRCUIT ESTABLISHED: 3 HOPS",
            ".ONION RESOLVED", "HIDDEN SERVICE FOUND",
            "ANONYMOUS CONNECTION ACTIVE"
        )
    }
    screensaver = @{
        name = "Matrix Screensaver"
        id = "screensaver"
        matrixStyle = "matrix"
        promptColor = "Green"
        matrixHead = "White"
        matrixBright = "Green"
        matrixBody = "Green"
        matrixTail = "DarkGreen"
        accent = "Green"
        errorColor = "Green"
        briefColor = "DarkGreen"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+="
        overlayMsgs = @()
    }
    learning = @{
        name = "Tryb Nauki"
        id = "learning"
        matrixStyle = "matrix"
        promptColor = "Cyan"
        matrixHead = "White"
        matrixBright = "Cyan"
        matrixBody = "Blue"
        matrixTail = "DarkBlue"
        accent = "Green"
        errorColor = "Red"
        briefColor = "Cyan"
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&<>*+="
        overlayMsgs = @(
            "TRYB NAUKI: AKTYWNY",
            "ZADANIE: WPROWADZ POLEGENIE"
        )
    }
}

function Get-Theme {
    param([string]$Id)
    if (-not $script:Themes.ContainsKey($Id)) { $Id = "realistic" }
    return $script:Themes[$Id]
}

function Get-AllThemes {
    return $script:Themes.Keys | ForEach-Object { $script:Themes[$_] }
}
