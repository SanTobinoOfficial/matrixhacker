function Get-LearningContent-ctf_mode {
    $fs = @{
            'home' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'player' = @{
                        Type = 'dir'; Owner = 'player'; Group = 'player'
                        Children = @{
                            'challenge_txt' = @{
                                Type = 'file'; Owner = 'player'; Group = 'player'
                                Content = @(
                                    '=== CTF Challenge Terminal ===',
                                    '',
                                    'Welcome, agent. You are connected to a remote CTF environment.',
                                    'Your objective: Capture all flags hidden across the challenge categories.',
                                    '',
                                    'Flag format: CTF{...}',
                                    '',
                                    'Challenge categories available:',
                                    '  /challenges/web/       - Web exploitation',
                                    '  /challenges/crypto/    - Cryptography',
                                    '  /challenges/forensics/ - Forensics & stego',
                                    '  /challenges/binary/    - Reverse engineering',
                                    '  /challenges/pwn/       - Binary exploitation',
                                    '',
                                    'Tip: Start by exploring /challenges/ with ls and cat.',
                                    'Hidden files, base64, and steganography are common.'
                                )
                            }
                            'hint_txt' = @{
                                Type = 'file'; Owner = 'player'; Group = 'player'
                                Content = @(
                                    '=== CTF HINTS ===',
                                    '',
                                    '1. Always check hidden files (ls -la)',
                                    '2. base64 is not encryption - decode suspicious text',
                                    '3. Check file types with the file command',
                                    '4. strings can reveal hidden data in binaries',
                                    '5. grep -r for flag patterns across directories',
                                    '6. Check file permissions - SUID bits are clues',
                                    '7. Environment variables can contain secrets',
                                    '8. XOR is common in beginner crypto challenges',
                                    '9. Look at file metadata / timestamps',
                                    '10. When stuck, try different approaches'
                                )
                            }
                            'solve_sh' = @{
                                Type = 'file'; Owner = 'player'; Group = 'player'
                                Content = @(
                                    '#!/bin/bash',
                                    '# CTF Challenge Solve Script Template',
                                    '# Use this as a starting point for automation',
                                    '',
                                    'echo "Checking for flags..."',
                                    'find / -name "*.txt" -type f 2>/dev/null | while read f; do',
                                    '  if grep -q "CTF{" "$f" 2>/dev/null; then',
                                    '    echo "FLAG FOUND: $(grep -o "CTF{[^}]*}" "$f") in $f"',
                                    '  fi',
                                    'done',
                                    '',
                                    'echo "Checking environment variables..."',
                                    'env | grep -i flag',
                                    '',
                                    'echo "Done."'
                                )
                            }
                            '.bashrc' = @{
                                Type = 'file'; Owner = 'player'; Group = 'player'
                                Content = @(
                                    '# CTF Player .bashrc',
                                    "export PS1='\[\e[32m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\w\$ '",
                                    'alias ll="ls -alF"',
                                    'alias la="ls -A"',
                                    'alias l="ls -CF"',
                                    'alias grep="grep --color=auto"',
                                    'alias flag="find / -name flag* -type f 2>/dev/null"',
                                    'alias decode64="base64 -d"',
                                    'alias strings="strings -n 4"',
                                    'alias ctf_scan="find / -type f -exec grep -l \"CTF{\" {} \\; 2>/dev/null"',
                                    'export EDITOR=nano',
                                    'export CTF_HOME=/home/player',
                                    'export CHALL_DIR=/challenges'
                                )
                            }
                        }
                    }
                }
            }
            'challenges' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'web' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'readme_md' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Web Exploitation Challenges',
                                    '',
                                    'Web challenges involve finding vulnerabilities in',
                                    'web applications: SQL injection, XSS, LFI, SSRF.',
                                    '',
                                    'Tools: curl, netcat, python requests',
                                    'Hint: Check for admin panels and hidden parameters'
                                )
                            }
                            'challenge_yml' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'name: sql_injection_basic',
                                    'category: web',
                                    'difficulty: medium',
                                    'points: 200',
                                    'description: Find the admin password in the login form',
                                    'flag: CTF{sql_1nj3ct10n_101}',
                                    'hint: Try a simple OR injection in the username field'
                                )
                            }
                            'login_html' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '<html><body>',
                                    '<h2>Admin Login Portal</h2>',
                                    '<form action="/login" method="POST">',
                                    '  <input name="username" type="text"><br>',
                                    '  <input name="password" type="password"><br>',
                                    '  <input type="submit" value="Login">',
                                    '</form>',
                                    '<!-- Hint: SELECT * FROM users WHERE username = -->',
                                    '</body></html>'
                                )
                            }
                            'flag_web_txt' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'VGhpcyBmbGFnIGlzIGJhc2U2NCBlbmNvZGVkLg0KDQpDVEZ7cjN2M3JzM19zcWxfYjRzMTN9'
                                )
                            }
                        }
                    }
                    'crypto' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'readme_md' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Cryptography Challenges',
                                    '',
                                    'Crypto challenges test your ability to break',
                                    'encryption: Caesar, XOR, base64, RSA, hashes.',
                                    '',
                                    'Tools: openssl, python, xxd, base64',
                                    'Hint: Look for patterns in the ciphertext'
                                )
                            }
                            'ciphertext_txt' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'Encrypted message (XOR with key 0x2A):',
                                    'a8aba7b8a9aea5b8ada8aba7b8a9aea5b8ad',
                                    '',
                                    'Hint: The flag starts with CTF{',
                                    'Hint: XOR each hex byte with 0x2A',
                                    'Hint: a8 ^ 2a = 82 (not printable) - try different key',
                                    'Actual key: single byte XOR where a8 decodes to C'
                                )
                            }
                            'challenge_yml' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'name: xor_decoder',
                                    'category: crypto',
                                    'difficulty: easy',
                                    'points: 100',
                                    'description: Decode the XOR encrypted message',
                                    'flag: CTF{x0r_br34k3r}',
                                    'hint: XOR the first byte of ciphertext with C (0x43)'
                                )
                            }
                        }
                    }
                    'forensics' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'readme_md' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Forensics Challenges',
                                    '',
                                    'Forensics involves analyzing files to find',
                                    'hidden data: steganography, file carving, metadata.',
                                    '',
                                    'Tools: strings, hexdump, binwalk, steghide, exiftool',
                                    'Hint: Always check the file type and strings output'
                                )
                            }
                            'image_data_txt' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Simulated image analysis output',
                                    '# File: secret.png',
                                    'Size: 340 x 240 pixels',
                                    'Color depth: 24-bit RGB',
                                    '',
                                    '# strings output - interesting findings:',
                                    '>>> found at offset 0x1A45: "CTF{st3g0_h1dd3n_d4t4}"',
                                    '>>> found at offset 0x2F00: "IHDR"',
                                    '>>> found at offset 0x2F10: "sRGB"',
                                    '',
                                    '# Stego analysis:',
                                    'LSB analysis suggests data embedded after offset 0x1000',
                                    'Recommended tool: steghide extract -sf secret.png'
                                )
                            }
                            'challenge_yml' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'name: hidden_in_plain_sight',
                                    'category: forensics',
                                    'difficulty: easy',
                                    'points: 150',
                                    'description: Find the hidden flag in the image data',
                                    'flag: CTF{st3g0_h1dd3n_d4t4}',
                                    'hint: Use strings to find the flag'
                                )
                            }
                        }
                    }
                    'binary' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'readme_md' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Reverse Engineering Challenges',
                                    '',
                                    'Reverse engineering means analyzing compiled',
                                    'binaries to understand their logic and find secrets.',
                                    '',
                                    'Tools: strings, objdump, gdb, radare2, ghidra',
                                    'Hint: Run strings on binaries to find embedded data'
                                )
                            }
                            'sample_bin_dump_txt' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '$ file sample_bin',
                                    'sample_bin: ELF 64-bit LSB executable, x86-64',
                                    '',
                                    '$ strings -n 6 sample_bin',
                                    '/lib64/ld-linux-x86-64.so.2',
                                    'libc.so.6',
                                    'Enter the secret password:',
                                    'Correct! Flag: CTF{r3v_3ng1n33r1ng}',
                                    'Wrong password. Try again.',
                                    's3cr3t_p4ssw0rd',
                                    '',
                                    'Analysis: The binary compares input against',
                                    '"s3cr3t_p4ssw0rd" and prints the flag if correct.'
                                )
                            }
                            'challenge_yml' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'name: crack_the_bin',
                                    'category: binary',
                                    'difficulty: medium',
                                    'points: 250',
                                    'description: Extract the hardcoded password and flag',
                                    'flag: CTF{r3v_3ng1n33r1ng}',
                                    'hint: strings reveals both password and flag'
                                )
                            }
                        }
                    }
                    'pwn' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'readme_md' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '# Binary Exploitation (PWN) Challenges',
                                    '',
                                    'PWN challenges involve exploiting memory corruption',
                                    'vulnerabilities: buffer overflows, ROP, format strings.',
                                    '',
                                    'Tools: python3, pwntools, gdb, checksec, ropper',
                                    'Hint: Check for SUID binaries and weak permissions'
                                )
                            }
                            'vuln_c' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '#include <stdio.h>',
                                    '#include <string.h>',
                                    '',
                                    'void secret_function() {',
                                    '    printf("Flag: CTF{buff3r_0v3rfl0w_m4st3r}\n");',
                                    '}',
                                    '',
                                    'int main(int argc, char **argv) {',
                                    '    char buffer[64];',
                                    '    printf("Enter your input: ");',
                                    '    gets(buffer);',
                                    '    printf("You entered: %s\n", buffer);',
                                    '    return 0;',
                                    '}',
                                    '',
                                    '// Compile: gcc -fno-stack-protector -no-pie vuln.c -o vuln',
                                    '// Exploit: overflow buffer to call secret_function()'
                                )
                            }
                            'challenge_yml' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    'name: buffer_overflow_basic',
                                    'category: pwn',
                                    'difficulty: hard',
                                    'points: 350',
                                    'description: Overflow the buffer and hijack execution',
                                    'flag: CTF{ret2w1n_st4ck_ov3rfl0w}',
                                    'hint: Use python -c with pwntools to send payload'
                                )
                            }
                        }
                    }
                }
            }
            'flags' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'flag1_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'RkxBRzpDVEZ7ZjFyNTNfZDBfZjFuZF9tM30='
                        )
                    }
                    'dot_flag2_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '# Hidden flag file - did you use ls -la?',
                            'CTF{h1dd3n_f1l3s_4r3_cl4ss1c}'
                        )
                    }
                    'flag_encoded_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '--[ Encoded Flag ]--',
                            'Hex: 4354467b 6d756c74 695f7374 6167655f 6368616c 6c656e67 657d',
                            '',
                            'Decode from hex to ASCII to reveal the flag.',
                            'Tip: echo "..." | xxd -r -p'
                        )
                    }
                }
            }
            'tools' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'nc_readme_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'netcat - networking utility for CTF challenges',
                            '',
                            'Usage:',
                            '  nc -lvnp 4444          - Listen on port 4444',
                            '  nc target_ip 8080      - Connect to remote port',
                            '  echo "payload" | nc target 80  - Send HTTP payload',
                            '',
                            'Common CTF uses:',
                            '  - Connect to challenge servers',
                            '  - Set up reverse shells',
                            '  - Port scanning (basic)',
                            '  - Banner grabbing'
                        )
                    }
                    'pwntools_readme_txt' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'pwntools - CTF framework for exploit development',
                            '',
                            'Key modules:',
                            '  pwn.asm()       - Assembler',
                            '  pwn.elf()       - ELF binary manipulation',
                            '  pwn.ssh()       - SSH connection',
                            '  pwn.process()   - Local binary interaction',
                            '  pwn.remote()    - Remote challenge connection',
                            '',
                            'Example exploit template:',
                            '  from pwn import *',
                            '  r = remote("challenge.host", 1337)',
                            '  r.recvuntil("> ")',
                            '  r.sendline("%7$p")  # format string leak',
                            '  r.interactive()'
                        )
                    }
                    'exploit_template_py' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '#!/usr/bin/env python3',
                            '# CTF Exploit Template',
                            'from pwn import *',
                            '',
                            'context.log_level = "debug"',
                            'context.arch = "amd64"',
                            '',
                            'def exploit():',
                            '    if args.REMOTE:',
                            '        r = remote(args.HOST, int(args.PORT))',
                            '    else:',
                            '        r = process("./vuln")',
                            '',
                            '    payload = b"A" * 72',
                            '    payload += p64(0x40101a)  # ret gadget',
                            '    payload += p64(0x401234)  # win function',
                            '',
                            '    r.recvuntil(b"> ")',
                            '    r.sendline(payload)',
                            '    r.interactive()',
                            '',
                            'if __name__ == "__main__":',
                            '    exploit()'
                        )
                    }
                }
            }
            'root' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'solve_master_sh' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '#!/bin/bash',
                            '# Master solve script - automated flag collector',
                            '',
                            'echo "[*] Starting automated flag collection..."',
                            '',
                            'echo "[*] Checking challenge files..."',
                            'grep -r "CTF{" /challenges/ 2>/dev/null',
                            '',
                            'echo "[*] Checking flags directory..."',
                            'for f in /flags/*; do',
                            '    echo "--- $f ---"',
                            '    cat "$f" 2>/dev/null',
                            'done',
                            '',
                            'echo "[*] Checking environment..."',
                            'env | grep -i "CTF\|FLAG"',
                            '',
                            'echo "[*] All flags collected."'
                        )
                    }
                    'scripts' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'decode_all_sh' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '#!/bin/bash',
                                    '# Decode all base64 encoded flag files',
                                    'for f in /flags/*; do',
                                    '    content=$(cat "$f" 2>/dev/null)',
                                    '    echo "Original: $content"',
                                    '    decoded=$(echo "$content" | base64 -d 2>/dev/null)',
                                    '    if [ -n "$decoded" ]; then',
                                    '        echo "Decoded: $decoded"',
                                    '    fi',
                                    'done'
                                )
                            }
                        }
                    }
                }
            }
            'etc' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'hostname' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @('ctf-box')
                    }
                    'passwd' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'root:x:0:0:root:/root:/bin/bash',
                            'player:x:1001:1001:CTF Player,,,:/home/player:/bin/bash',
                            'ctfadmin:x:1002:1002:Challenge Admin,,,:/home/ctfadmin:/bin/bash'
                        )
                    }
                    'os-release' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"',
                            'NAME="Debian GNU/Linux"',
                            'VERSION_ID="12"',
                            'VERSION="12 (bookworm)"',
                            'VERSION_CODENAME=bookworm',
                            'ID=debian',
                            'HOME_URL="https://www.debian.org/"'
                        )
                    }
                }
            }
            'tmp' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'payloads' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{}
                    }
                    'exploit_test_sh' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            '#!/bin/bash',
                            '# Quick exploit test script',
                            'echo "Testing exploit chain..."',
                            'python3 /tools/exploit_template_py 2>&1',
                            'echo "Done."'
                        )
                    }
                }
            }
    }

    $tasks = @(
        @{
            Id = 'ctf-b1'
            Title = 'List challenges directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /challenges/'
            Description = @(
                'List all challenge categories available in the CTF environment.',
                'Each directory contains a different type of challenge.'
            )
            Hint = 'Use: ls /challenges/'
        }
        @{
            Id = 'ctf-b2'
            Title = 'Read the CTF description'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat challenge_txt'
            Description = @(
                'Read the challenge.txt file in your home directory',
                'to understand the CTF objectives.'
            )
            Hint = 'Use: cat challenge_txt (or: cat /home/player/challenge_txt)'
        }
        @{
            Id = 'ctf-b3'
            Title = 'Explore available tools'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /tools/'
            Description = @(
                'List the tools directory to see what CTF utilities',
                'are available (pwntools templates, nc documentation, etc.)'
            )
            Hint = 'Use: ls /tools/'
        }
        @{
            Id = 'ctf-b4'
            Title = 'Find flag files'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /flags/'
            Description = @(
                'List the flags directory to see what flag files',
                'are available. Some may be encoded or hidden.'
            )
            Hint = 'Use: ls /flags/'
        }
        @{
            Id = 'ctf-b5'
            Title = 'Search for CTF flag pattern'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /flags/flag1_txt'
            Description = @(
                'Display the first flag file. It may be encoded.',
                'Look carefully at the content format.'
            )
            Hint = 'Use: cat /flags/flag1_txt'
        }
        @{
            Id = 'ctf-i1'
            Title = 'Run strings on binary analysis'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /challenges/binary/sample_bin_dump_txt | grep CTF'
            Description = @(
                'Search the binary analysis output for the CTF flag.',
                'The sample_bin_dump.txt simulates strings output from an ELF binary.'
            )
            Hint = 'Use: cat /challenges/binary/sample_bin_dump_txt | grep CTF'
        }
        @{
            Id = 'ctf-i2'
            Title = 'Find hidden files in flags'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ls -la /flags/'
            Description = @(
                'List all files including hidden ones in the flags directory.',
                'Use the -la flag to reveal dot-files that may contain flags.'
            )
            Hint = 'Use: ls -la /flags/'
        }
        @{
            Id = 'ctf-i3'
            Title = 'Grep for flag pattern recursively'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep -r "CTF{" /challenges/'
            Description = @(
                'Recursively search all challenge files for the CTF flag pattern.',
                'This reveals which challenges have flags embedded in their configs.'
            )
            Hint = 'Use: grep -r "CTF{" /challenges/'
        }
        @{
            Id = 'ctf-i4'
            Title = 'Decode base64 flag'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /flags/flag1_txt | base64 -d'
            Description = @(
                'The flag1.txt file contains a base64-encoded message.',
                'Pipe the content into the base64 decoder to reveal the flag.'
            )
            Hint = 'Use: cat /flags/flag1_txt | base64 -d'
        }
        @{
            Id = 'ctf-i5'
            Title = 'Explore web challenge details'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /challenges/web/challenge_yml'
            Description = @(
                'Display the web challenge configuration to see',
                'the challenge name, difficulty, points, and flag.'
            )
            Hint = 'Use: cat /challenges/web/challenge_yml'
        }
        @{
            Id = 'ctf-a1'
            Title = 'Find all flag occurrences'
            Difficulty = 'advanced'
            ExpectedCommand = 'find / -name "flag*" -type f 2>/dev/null'
            Description = @(
                'Use find to locate all files with "flag" in their name',
                'across the entire filesystem. Redirect stderr to hide errors.'
            )
            Hint = 'Use: find / -name "flag*" -type f 2>/dev/null'
        }
        @{
            Id = 'ctf-a2'
            Title = 'Checksum challenge files'
            Difficulty = 'advanced'
            ExpectedCommand = 'sha256sum /challenges/crypto/ciphertext_txt /challenges/binary/sample_bin_dump_txt'
            Description = @(
                'Generate SHA256 checksums of challenge files to verify',
                'their integrity. This is useful for tamper detection.'
            )
            Hint = 'Use: sha256sum /challenges/crypto/ciphertext_txt'
        }
        @{
            Id = 'ctf-a3'
            Title = 'Analyze image forensics output'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /challenges/forensics/image_data_txt | grep -i steg'
            Description = @(
                'Search the forensics challenge output for steganography-related',
                'information. This reveals how the flag was hidden.'
            )
            Hint = 'Use: cat /challenges/forensics/image_data_txt | grep -i steg'
        }
        @{
            Id = 'ctf-a4'
            Title = 'Read the pwntools template'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /tools/exploit_template_py'
            Description = @(
                'Display the pwntools exploit template to understand',
                'the structure of a binary exploitation script.'
            )
            Hint = 'Use: cat /tools/exploit_template_py'
        }
        @{
            Id = 'ctf-a5'
            Title = 'Decode hex flag'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /flags/flag_encoded_txt | grep "Hex:" | cut -d" " -f2-'
            Description = @(
                'Extract the hex-encoded flag from the encoded flag file.',
                'Use grep to find the hex line and cut to extract the value.'
            )
            Hint = 'Use: cat /flags/flag_encoded_txt | grep Hex'
        }
        @{
            Id = 'ctf-e1'
            Title = 'Pipeline: strings, grep, and sort'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /challenges/forensics/image_data_txt | grep ">>>" | sort'
            Description = @(
                'Use a command pipeline to extract all lines containing ">>>"',
                'from the forensics output and sort them alphabetically.',
                'This simulates extracting notable findings from a file analysis.'
            )
            Hint = 'Use: cat /challenges/forensics/image_data_txt | grep ">>>" | sort'
        }
        @{
            Id = 'ctf-e2'
            Title = 'Hidden flag detection chain'
            Difficulty = 'expert'
            ExpectedCommand = 'find / -name ".flag*" -type f 2>/dev/null'
            Description = @(
                'Search for hidden files starting with ".flag" across the',
                'entire filesystem. Hidden files are a common CTF hiding technique.'
            )
            Hint = 'Use: find / -name ".flag*" -type f 2>/dev/null'
        }
        @{
            Id = 'ctf-e3'
            Title = 'Master solve script execution'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /root/solve_master_sh'
            Description = @(
                'Display the master solve script to understand how an automated',
                'flag collection tool works. This script greps for flags recursively.'
            )
            Hint = 'Use: cat /root/solve_master_sh'
        }
        @{
            Id = 'ctf-e4'
            Title = 'Analyze exploit chain from pwn'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /challenges/pwn/vuln_c | grep -E "secret|Flag"'
            Description = @(
                'Search the vulnerable C source code for the secret function',
                'and flag. This simulates reverse engineering a buffer overflow.'
            )
            Hint = 'Use: cat /challenges/pwn/vuln_c | grep -E "secret|Flag"'
        }
        @{
            Id = 'ctf-e5'
            Title = 'Cross-reference all challenge flags'
            Difficulty = 'expert'
            ExpectedCommand = 'grep -r "flag:" /challenges/'
            Description = @(
                'Recursively search for all "flag:" entries across challenge',
                'YAML configs. This collects every flag in one view.'
            )
            Hint = 'Use: grep -r "flag:" /challenges/'
        }
    )
    return @{ Filesystem = $fs; Tasks = $tasks }
}
