function Get-LearningContent-docker {
    $fs = @{
        'home' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'admin' = @{
                    Type = 'dir'
                    Owner = 'admin'
                    Group = 'docker'
                    Children = @{
                        'docker-compose.yml' = @{
                            Type = 'file'
                            Owner = 'admin'
                            Group = 'docker'
                            Content = @(
                                'version: "3.8"',
                                'services:',
                                '  web:',
                                '    build: .',
                                '    ports:',
                                '      - "8080:80"',
                                '    volumes:',
                                '      - ./data:/var/www/html',
                                '    environment:',
                                '      - DB_HOST=db',
                                '      - DB_USER=root',
                                '      - DB_PASSWORD=${DB_PASSWORD}',
                                '    depends_on:',
                                '      - db',
                                '  db:',
                                '    image: mysql:8.0',
                                '    ports:',
                                '      - "3306:3306"',
                                '    volumes:',
                                '      - db_data:/var/lib/mysql',
                                '    environment:',
                                '      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}',
                                '      MYSQL_DATABASE: myapp',
                                'volumes:',
                                '  db_data:'
                            )
                        }
                        'Dockerfile' = @{
                            Type = 'file'
                            Owner = 'admin'
                            Group = 'docker'
                            Content = @(
                                '# Multi-stage build',
                                'FROM node:20-alpine AS builder',
                                'WORKDIR /app',
                                'COPY package*.json ./',
                                'RUN npm ci --only=production',
                                'COPY . .',
                                'RUN npm run build',
                                '',
                                'FROM nginx:1.25-alpine',
                                'COPY --from=builder /app/dist /usr/share/nginx/html',
                                'COPY nginx.conf /etc/nginx/conf.d/default.conf',
                                'EXPOSE 80',
                                'CMD ["nginx", "-g", "daemon off;"]'
                            )
                        }
                        '.env' = @{
                            Type = 'file'
                            Owner = 'admin'
                            Group = 'docker'
                            Content = @(
                                'DB_PASSWORD=s3cur3P@ss',
                                'DB_HOST=db',
                                'DB_USER=root',
                                'APP_ENV=production',
                                'APP_DEBUG=false',
                                'NGINX_PORT=80'
                            )
                        }
                        'projects' = @{
                            Type = 'dir'
                            Owner = 'admin'
                            Group = 'docker'
                            Children = @{
                                'webapp' = @{
                                    Type = 'dir'
                                    Owner = 'admin'
                                    Group = 'docker'
                                    Children = @{
                                        'nginx.conf' = @{
                                            Type = 'file'
                                            Owner = 'admin'
                                            Group = 'docker'
                                            Content = @(
                                                'server {',
                                                '    listen 80;',
                                                '    server_name example.com;',
                                                '    root /usr/share/nginx/html;',
                                                '    index index.html;',
                                                '    location / {',
                                                '        try_files $uri $uri/ /index.html;',
                                                '    }',
                                                '    location /api/ {',
                                                '        proxy_pass http://backend:3000;',
                                                '        proxy_set_header Host $host;',
                                                '    }',
                                                '    gzip on;',
                                                '    gzip_types text/plain application/json;',
                                                '}'
                                            )
                                        }
                                        'app_py' = @{
                                            Type = 'file'
                                            Owner = 'admin'
                                            Group = 'docker'
                                            Content = @(
                                                'from flask import Flask',
                                                'app = Flask(__name__)',
                                                '',
                                                '@app.route("/")',
                                                'def hello():',
                                                '    return "Hello from Docker container!"',
                                                '',
                                                '@app.route("/health")',
                                                'def health():',
                                                '    return "OK", 200',
                                                '',
                                                'if __name__ == "__main__":',
                                                '    app.run(host="0.0.0.0", port=5000)'
                                            )
                                        }
                                        'requirements_txt' = @{
                                            Type = 'file'
                                            Owner = 'admin'
                                            Group = 'docker'
                                            Content = @(
                                                'flask==3.0.0',
                                                'gunicorn==21.2.0',
                                                'redis==5.0.1',
                                                'requests==2.31.0'
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        'etc' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'docker' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'daemon.json' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '{',
                                '  "log-driver": "json-file",',
                                '  "log-opts": {',
                                '    "max-size": "10m",',
                                '    "max-file": "3"',
                                '  },',
                                '  "storage-driver": "overlay2",',
                                '  "exec-opts": ["native.cgroupdriver=systemd"],',
                                '  "insecure-registries": ["registry.internal:5000"],',
                                '  "registry-mirrors": ["https://mirror.gcr.io"],',
                                '  "live-restore": true,',
                                '  "userland-proxy": false,',
                                '  "iptables": true,',
                                '  "ipv6": false,',
                                '  "default-ulimits": {',
                                '    "nofile": {',
                                '      "Name": "nofile",',
                                '      "Hard": 65535,',
                                '      "Soft": 65535',
                                '    }',
                                '  }',
                                '}'
                            )
                        }
                        'key.json' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '{',
                                '  "crv": "P-256",',
                                '  "kid": "DOCKER:SWARM:KEY:001",',
                                '  "kty": "EC",',
                                '  "x": "sample-key-data-here",',
                                '  "y": "more-sample-key-data"',
                                '}'
                            )
                        }
                    }
                }
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'docker-host'
                    )
                }
                'os-release' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'PRETTY_NAME="Ubuntu 24.04 LTS (Docker Host)"',
                        'NAME="Ubuntu"',
                        'VERSION_ID="24.04"',
                        'VERSION="24.04 LTS (Noble Numbat)"',
                        'ID=ubuntu',
                        'ID_LIKE=debian'
                    )
                }
            }
        }
        'var' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'lib' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'docker' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'image' = @{
                                    Type = 'dir'
                                    Owner = 'root'
                                    Group = 'root'
                                    Children = @{
                                        'overlay2' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                'layerdb' = @{
                                                    Type = 'dir'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Children = @{
                                                        'sha256' = @{
                                                            Type = 'dir'
                                                            Owner = 'root'
                                                            Group = 'root'
                                                            Children = @{
                                                                'a1b2c3d4' = @{
                                                                    Type = 'file'
                                                                    Owner = 'root'
                                                                    Group = 'root'
                                                                    Content = @(
                                                                        '{"chain_id": "sha256:a1b2c3d4e5f6...", "diff_id": "sha256:abc123...", "size": 42873612}'
                                                                    )
                                                                }
                                                                'e5f6a7b8' = @{
                                                                    Type = 'file'
                                                                    Owner = 'root'
                                                                    Group = 'root'
                                                                    Content = @(
                                                                        '{"chain_id": "sha256:e5f6a7b8c9d0...", "diff_id": "sha256:def456...", "size": 21589344}'
                                                                    )
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                'containers' = @{
                                    Type = 'dir'
                                    Owner = 'root'
                                    Group = 'root'
                                    Children = @{
                                        'abc123def456' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                'config.v2.json' = @{
                                                    Type = 'file'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Content = @(
                                                        '{',
                                                        '  "ID": "abc123def456",',
                                                        '  "Name": "/web_app",',
                                                        '  "Image": "nginx:1.25-alpine",',
                                                        '  "State": {',
                                                        '    "Status": "running",',
                                                        '    "Running": true,',
                                                        '    "Pid": 1234,',
                                                        '    "StartedAt": "2026-06-07T08:00:00Z"',
                                                        '  },',
                                                        '  "Config": {',
                                                        '    "ExposedPorts": { "80/tcp": {} },',
                                                        '    "Env": [',
                                                        '      "NGINX_PORT=80"',
                                                        '    ]',
                                                        '  },',
                                                        '  "NetworkSettings": {',
                                                        '    "IPAddress": "172.17.0.2"',
                                                        '  }',
                                                        '}'
                                                    )
                                                }
                                            }
                                        }
                                        '789ghi012345' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                'config.v2.json' = @{
                                                    Type = 'file'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Content = @(
                                                        '{',
                                                        '  "ID": "789ghi012345",',
                                                        '  "Name": "/mysql_db",',
                                                        '  "Image": "mysql:8.0",',
                                                        '  "State": {',
                                                        '    "Status": "running",',
                                                        '    "Running": true,',
                                                        '    "Pid": 5678,',
                                                        '    "StartedAt": "2026-06-07T08:01:00Z"',
                                                        '  },',
                                                        '  "Config": {',
                                                        '    "ExposedPorts": { "3306/tcp": {} },',
                                                        '    "Env": [',
                                                        '      "MYSQL_ROOT_PASSWORD=****"',
                                                        '    ]',
                                                        '  },',
                                                        '  "NetworkSettings": {',
                                                        '    "IPAddress": "172.17.0.3"',
                                                        '  }',
                                                        '}'
                                                    )
                                                }
                                            }
                                        }
                                        'stopped_container_id' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                'config.v2.json' = @{
                                                    Type = 'file'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Content = @(
                                                        '{',
                                                        '  "ID": "stopped_container_id",',
                                                        '  "Name": "/old_worker",',
                                                        '  "Image": "python:3.12-slim",',
                                                        '  "State": {',
                                                        '    "Status": "exited",',
                                                        '    "Running": false,',
                                                        '    "ExitCode": 137,',
                                                        '    "StartedAt": "2026-06-06T12:00:00Z",',
                                                        '    "FinishedAt": "2026-06-06T14:30:00Z"',
                                                        '  },',
                                                        '  "Config": {',
                                                        '    "Cmd": ["python", "worker.py"]',
                                                        '  }',
                                                        '}'
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                'volumes' = @{
                                    Type = 'dir'
                                    Owner = 'root'
                                    Group = 'root'
                                    Children = @{
                                        'db_data' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                '_data' = @{
                                                    Type = 'dir'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Children = @{
                                                        'ibdata1' = @{
                                                            Type = 'file'
                                                            Owner = 'root'
                                                            Group = 'root'
                                                            Content = @(
                                                                'MySQL tablespace placeholder'
                                                            )
                                                        }
                                                        'ib_logfile0' = @{
                                                            Type = 'file'
                                                            Owner = 'root'
                                                            Group = 'root'
                                                            Content = @(
                                                                'MySQL redo log placeholder'
                                                            )
                                                        }
                                                        'mysql' = @{
                                                            Type = 'dir'
                                                            Owner = 'root'
                                                            Group = 'root'
                                                            Children = @{}
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        'web_uploads' = @{
                                            Type = 'dir'
                                            Owner = 'root'
                                            Group = 'root'
                                            Children = @{
                                                '_data' = @{
                                                    Type = 'dir'
                                                    Owner = 'root'
                                                    Group = 'root'
                                                    Children = @{
                                                        'uploads' = @{
                                                            Type = 'dir'
                                                            Owner = 'root'
                                                            Group = 'root'
                                                            Children = @{
                                                                'image1_png' = @{
                                                                    Type = 'file'
                                                                    Owner = 'root'
                                                                    Group = 'root'
                                                                    Content = @(
                                                                        'PNG image placeholder'
                                                                    )
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                'swarm' = @{
                                    Type = 'dir'
                                    Owner = 'root'
                                    Group = 'root'
                                    Children = @{
                                        'state.json' = @{
                                            Type = 'file'
                                            Owner = 'root'
                                            Group = 'root'
                                            Content = @(
                                                '{',
                                                '  "NodeID": "node-1",',
                                                '  "Role": "manager",',
                                                '  "ClusterID": "clust-12345",',
                                                '  "JoinTokens": {',
                                                '    "Worker": "SWMTKN-1-worker-token",',
                                                '    "Manager": "SWMTKN-1-manager-token"',
                                                '  },',
                                                '  "Nodes": [',
                                                '    { "ID": "node-1", "Role": "manager", "Status": "ready", "Addr": "192.168.1.10" },',
                                                '    { "ID": "node-2", "Role": "worker", "Status": "ready", "Addr": "192.168.1.11" },',
                                                '    { "ID": "node-3", "Role": "worker", "Status": "down", "Addr": "192.168.1.12" }',
                                                '  ],',
                                                '  "Services": [',
                                                '    { "Name": "web-frontend", "Replicas": 3, "Image": "nginx:1.25" },',
                                                '    { "Name": "api-backend", "Replicas": 2, "Image": "myapp:latest" }',
                                                '  ]',
                                                '}'
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                'log' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'docker.log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'time="2026-06-08T08:00:00Z" level=info msg="Docker daemon starting"',
                                'time="2026-06-08T08:00:01Z" level=info msg="Loading containers: start."',
                                'time="2026-06-08T08:00:02Z" level=info msg="Loading containers: done."',
                                'time="2026-06-08T08:00:03Z" level=info msg="Daemon has completed initialization"',
                                'time="2026-06-08T08:00:04Z" level=info msg="API listen on /var/run/docker.sock"',
                                'time="2026-06-08T08:05:00Z" level=info msg="Container abc123 started"',
                                'time="2026-06-08T08:05:10Z" level=info msg="Container 789ghi started"',
                                'time="2026-06-08T09:00:00Z" level=error msg="Health check failed for container abc123: timeout"',
                                'time="2026-06-08T09:00:15Z" level=info msg="Health check recovered for container abc123"',
                                'time="2026-06-08T09:30:00Z" level=warn msg="Disk space low on volume db_data: 85% used"',
                                'time="2026-06-08T10:00:00Z" level=info msg="Pulling image nginx:1.25-alpine"',
                                'time="2026-06-08T10:01:00Z" level=info msg="Image pulled successfully"',
                                'time="2026-06-08T10:15:00Z" level=error msg="Failed to pull image myapp:latest: not found"',
                                'time="2026-06-08T10:30:00Z" level=info msg="Container stopped_container_id exited with code 137"',
                                'time="2026-06-08T11:00:00Z" level=info msg="Swarm node node-3 is unreachable"',
                                'time="2026-06-08T11:05:00Z" level=error msg="Error response from daemon: No such container"',
                                'time="2026-06-08T11:30:00Z" level=info msg="Starting periodic image garbage collection"',
                                'time="2026-06-08T11:31:00Z" level=info msg="Removed unused image node:20-alpine"',
                                'time="2026-06-08T12:00:00Z" level=info msg="Backup of volumes completed successfully"'
                            )
                        }
                    }
                }
                'run' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'docker.sock' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'docker'
                            Content = @(
                                'Docker socket placeholder'
                            )
                        }
                    }
                }
            }
        }
        'usr' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'bin' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'docker' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/bin/bash',
                                'echo "Docker CLI v24.0.7"'
                            )
                        }
                        'docker-compose' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/bin/bash',
                                'echo "Docker Compose v2.24.0"'
                            )
                        }
                        'containerd' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/bin/bash',
                                'echo "containerd v1.7.12"'
                            )
                        }
                        'runc' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'root'
                            Content = @(
                                '#!/bin/bash',
                                'echo "runc v1.1.12"'
                            )
                        }
                    }
                }
                'libexec' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'docker' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'docker-init' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "docker-init v0.19.0"'
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        'tmp' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{}
        }
    }

    $tasks = @(
        @{
            Id = 'docker-b1'
            Title = 'List Docker containers on the host'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /var/lib/docker/containers/'
            Description = @(
                'List the contents of the Docker containers directory.',
                'This shows all container IDs managed by the Docker daemon.'
            )
            Hint = 'Try: ls /var/lib/docker/containers/'
        }
        @{
            Id = 'docker-b2'
            Title = 'View the docker-compose configuration'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/admin/docker-compose.yml'
            Description = @(
                'Display the docker-compose.yml file to see the multi-service',
                'application definition with web and database services.'
            )
            Hint = 'Use: cat /home/admin/docker-compose.yml'
        }
        @{
            Id = 'docker-b3'
            Title = 'Read the Dockerfile'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/admin/Dockerfile'
            Description = @(
                'Display the Dockerfile to understand the multi-stage build',
                'process for the container image.'
            )
            Hint = 'Use: cat /home/admin/Dockerfile'
        }
        @{
            Id = 'docker-b4'
            Title = 'Check environment variables'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/admin/.env'
            Description = @(
                'Read the .env file that stores environment variables',
                'used by the Docker Compose application.'
            )
            Hint = 'Use: cat /home/admin/.env'
        }
        @{
            Id = 'docker-b5'
            Title = 'List Docker images'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /var/lib/docker/image/overlay2/'
            Description = @(
                'List the contents of the Docker image storage directory.',
                'This is where Docker stores image layer metadata.'
            )
            Hint = 'Use: ls /var/lib/docker/image/overlay2/'
        }
        @{
            Id = 'docker-i1'
            Title = 'Inspect Docker daemon configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/docker/daemon.json'
            Description = @(
                'Display the Docker daemon configuration file.',
                'This shows storage driver, logging, and security settings.'
            )
            Hint = 'Use: cat /etc/docker/daemon.json'
        }
        @{
            Id = 'docker-i2'
            Title = 'Search for errors in Docker logs'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep error /var/log/docker.log'
            Description = @(
                'Search the Docker daemon log for lines containing "error".',
                'This helps identify issues with containers and operations.'
            )
            Hint = 'Use: grep error /var/log/docker.log'
        }
        @{
            Id = 'docker-i3'
            Title = 'Backup the Dockerfile'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cp /home/admin/Dockerfile /home/admin/Dockerfile.backup'
            Description = @(
                'Create a backup copy of the Dockerfile before making changes.',
                'Always back up critical configuration files.'
            )
            Hint = 'Use: cp /home/admin/Dockerfile /home/admin/Dockerfile.backup'
        }
        @{
            Id = 'docker-i4'
            Title = 'List Docker volumes'
            Difficulty = 'intermediate'
            ExpectedCommand = 'ls /var/lib/docker/volumes/'
            Description = @(
                'List all Docker volumes managed by the daemon.',
                'Volumes persist data even after containers are removed.'
            )
            Hint = 'Use: ls /var/lib/docker/volumes/'
        }
        @{
            Id = 'docker-i5'
            Title = 'View the web app nginx config'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/admin/projects/webapp/nginx.conf'
            Description = @(
                'Display the nginx configuration for the web application.',
                'This shows reverse proxy settings for the backend API.'
            )
            Hint = 'Use: cat /home/admin/projects/webapp/nginx.conf'
        }
        @{
            Id = 'docker-a1'
            Title = 'Find all Dockerfiles on the system'
            Difficulty = 'advanced'
            ExpectedCommand = 'find / -name "Dockerfile"'
            Description = @(
                'Use the find command to locate all files named "Dockerfile"',
                'anywhere on the filesystem.'
            )
            Hint = 'Use: find / -name "Dockerfile"'
        }
        @{
            Id = 'docker-a2'
            Title = 'Find exposed ports in docker-compose'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep ports /home/admin/docker-compose.yml'
            Description = @(
                'Search for port mappings in the docker-compose file.',
                'This shows which container ports are exposed to the host.'
            )
            Hint = 'Use: grep ports /home/admin/docker-compose.yml'
        }
        @{
            Id = 'docker-a3'
            Title = 'Check Swarm cluster state'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /var/lib/docker/swarm/state.json'
            Description = @(
                'Display the Docker Swarm orchestrator state.',
                'This shows cluster nodes, services, and join tokens.'
            )
            Hint = 'Use: cat /var/lib/docker/swarm/state.json'
        }
        @{
            Id = 'docker-a4'
            Title = 'View container configuration'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /var/lib/docker/containers/abc123def456/config.v2.json'
            Description = @(
                'Inspect the configuration of a running container.',
                'Container configs are stored as JSON in the Docker data directory.'
            )
            Hint = 'Use: cat /var/lib/docker/containers/abc123def456/config.v2.json'
        }
        @{
            Id = 'docker-a5'
            Title = 'Check Docker daemon key'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/docker/key.json'
            Description = @(
                'Display the Docker daemon key file used for Swarm and',
                'TLS authentication between nodes.'
            )
            Hint = 'Use: cat /etc/docker/key.json'
        }
        @{
            Id = 'docker-e1'
            Title = 'Analyze log error frequency'
            Difficulty = 'expert'
            ExpectedCommand = 'grep level=error /var/log/docker.log | sort | uniq -c'
            Description = @(
                'Extract all error-level log entries and count occurrences.',
                'Use sort and uniq -c to identify the most frequent errors.'
            )
            Hint = 'Use: grep level=error /var/log/docker.log | sort | uniq -c'
        }
        @{
            Id = 'docker-e2'
            Title = 'Create a compressed backup of Docker volumes'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf volumes_backup.tar.gz -C /var/lib/docker/volumes .'
            Description = @(
                'Create a gzipped tar archive of all Docker volumes.',
                'This is a common disaster recovery procedure for Docker data.'
            )
            Hint = 'Use: tar -czf volumes_backup.tar.gz -C /var/lib/docker/volumes .'
        }
        @{
            Id = 'docker-e3'
            Title = 'Find container configs with specific settings'
            Difficulty = 'expert'
            ExpectedCommand = 'find /var/lib/docker/containers -name "config.v2.json" -exec grep -l "running" {} \;'
            Description = @(
                'Find all container configuration files that contain',
                'the word "running" to identify active containers.'
            )
            Hint = 'Use: find /var/lib/docker/containers -name "config.v2.json" -exec grep -l "running" {} \;'
        }
        @{
            Id = 'docker-e4'
            Title = 'Analyze daemon security settings'
            Difficulty = 'expert'
            ExpectedCommand = 'grep -E "iptables|tls|secure" /etc/docker/daemon.json'
            Description = @(
                'Search the daemon config for security-related settings.',
                'This helps audit Docker daemon security posture.'
            )
            Hint = 'Use: grep -E "iptables|tls|secure" /etc/docker/daemon.json'
        }
        @{
            Id = 'docker-e5'
            Title = 'Check disk usage of Docker data directory'
            Difficulty = 'expert'
            ExpectedCommand = 'du -sh /var/lib/docker'
            Description = @(
                'Calculate the total disk space used by the Docker data',
                'directory, including images, containers, and volumes.'
            )
            Hint = 'Use: du -sh /var/lib/docker'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
