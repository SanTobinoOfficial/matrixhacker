# Ultra Matrix Terminal

15 cinematic terminal simulation modes for Windows — realistic SSH sessions, CTF challenges, Hollywood hacking, cyberpunk netrunning, and more. No external dependencies, pure PowerShell 5.1+.

## One-Liner Install

```powershell
irm https://raw.githubusercontent.com/<user>/ultra-matrix-terminal/main/install.ps1 | iex
```

## Manual Start

```powershell
.\launcher.ps1          # WinForms GUI (default)
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

## Features

- **Matrix Rain v3** — multi-style falling columns, overlay typing, bright heads, fading trails
- **Press-to-Reveal** — commands auto-type with realistic speed; press Enter to finish instantly
- **Smart Delays** — nmap scans pause longer than ls; contextual timing per command
- **Auto-Typos** — ~20% of commands have a typo + correction (backspace + retype)
- **Dir Tracking** — `cd` commands update the simulated prompt path
- **History Recall** — Up arrow recalls the last command
- **System Noise** — random syslog messages, mail alerts, broadcast warnings
- **Pager** — `--More--` for output longer than terminal height
- **MOTD** — per-session message of the day with load/mem stats
- **Failure Simulation** — ~20% context-aware command failures
- **Session Timeout** — auto-exit after ~5 minutes per mode
- **Escape to Exit** — press Escape at any time to quit

## Project Structure

```
ultra-matrix-terminal/
├── launcher.ps1        # WinForms GUI + CLI launcher
├── install.ps1         # One-liner installer
├── engine/
│   ├── core.ps1        # Matrix-Rain, Type-Command, Show-Output, session loop
│   ├── helpers.ps1     # Utility functions (Rand, RandIP, C, Get-DynamicPrompt)
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
│   ├── splash/         # Ascii art splash screens
│   └── sounds/         # WAV audio effects (optional)
└── config/             # User settings (future)
```

## Requirements

- Windows 7 / 8 / 10 / 11
- PowerShell 5.1+ (built-in on Windows)
- No external dependencies

## License

MIT
