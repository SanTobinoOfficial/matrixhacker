function Get-LearningContent-cloud {
    $fs = @{
        'home' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'devops' = @{
                    Type = 'dir'
                    Owner = 'devops'
                    Group = 'devops'
                    Children = @{
                        '.kube' = @{
                            Type = 'dir'
                            Owner = 'devops'
                            Group = 'devops'
                            Children = @{
                                'config' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'apiVersion: v1',
                                        'kind: Config',
                                        'current-context: staging',
                                        'clusters:',
                                        '- cluster:',
                                        '    server: https://dev.k8s.example.com',
                                        '    certificate-authority-data: FAKECA',
                                        '  name: dev-cluster',
                                        '- cluster:',
                                        '    server: https://staging.k8s.example.com',
                                        '    certificate-authority-data: FAKECA',
                                        '  name: staging-cluster',
                                        '- cluster:',
                                        '    server: https://prod.k8s.example.com',
                                        '    certificate-authority-data: FAKECA',
                                        '  name: prod-cluster',
                                        'contexts:',
                                        '- context:',
                                        '    cluster: dev-cluster',
                                        '    namespace: dev-ns',
                                        '    user: dev-user',
                                        '  name: dev',
                                        '- context:',
                                        '    cluster: staging-cluster',
                                        '    namespace: staging-ns',
                                        '    user: staging-user',
                                        '  name: staging',
                                        '- context:',
                                        '    cluster: prod-cluster',
                                        '    namespace: prod-ns',
                                        '    user: prod-user',
                                        '  name: production',
                                        'users:',
                                        '- name: dev-user',
                                        '  user:',
                                        '    token: fake-token-dev',
                                        '- name: staging-user',
                                        '  user:',
                                        '    token: fake-token-staging',
                                        '- name: prod-user',
                                        '  user:',
                                        '    token: fake-token-prod'
                                    )
                                }
                            }
                        }
                        '.aws' = @{
                            Type = 'dir'
                            Owner = 'devops'
                            Group = 'devops'
                            Children = @{
                                'config' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        '[default]',
                                        'region = us-east-1',
                                        'output = json',
                                        '',
                                        '[profile staging]',
                                        'region = eu-west-1',
                                        'output = json',
                                        '',
                                        '[profile production]',
                                        'region = eu-central-1',
                                        'output = json'
                                    )
                                }
                                'credentials' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        '[default]',
                                        'aws_access_key_id = AKIAIOSFODNN7EXAMPLE',
                                        'aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
                                        '',
                                        '[staging]',
                                        'aws_access_key_id = AKIASTAGINGEXAMPLE',
                                        'aws_secret_access_key = StagingSecretKeyExample12345',
                                        '',
                                        '[production]',
                                        'aws_access_key_id = AKIAPRODEXAMPLEKEY',
                                        'aws_secret_access_key = ProdSecretKeyExample67890'
                                    )
                                }
                            }
                        }
                        '.terraformrc' = @{
                            Type = 'file'
                            Owner = 'devops'
                            Group = 'devops'
                            Content = @(
                                'provider_installation {',
                                '  filesystem_mirror {',
                                '    path = "/usr/share/terraform/providers"',
                                '  }',
                                '  direct {',
                                '    exclude = ["example.com/*/*"]',
                                '  }',
                                '}'
                            )
                        }
                        'terraform' = @{
                            Type = 'dir'
                            Owner = 'devops'
                            Group = 'devops'
                            Children = @{
                                'main.tf' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'provider "aws" {',
                                        '  region = var.aws_region',
                                        '  profile = var.aws_profile',
                                        '}',
                                        '',
                                        'resource "aws_vpc" "main" {',
                                        '  cidr_block = "10.0.0.0/16"',
                                        '  enable_dns_support = true',
                                        '  enable_dns_hostnames = true',
                                        '  tags = {',
                                        '    Name = "${var.project_name}-vpc"',
                                        '    Environment = var.environment',
                                        '  }',
                                        '}',
                                        '',
                                        'resource "aws_subnet" "public" {',
                                        '  vpc_id = aws_vpc.main.id',
                                        '  cidr_block = "10.0.1.0/24"',
                                        '  map_public_ip_on_launch = true',
                                        '  availability_zone = "${var.aws_region}a"',
                                        '}',
                                        '',
                                        'resource "aws_subnet" "private" {',
                                        '  vpc_id = aws_vpc.main.id',
                                        '  cidr_block = "10.0.2.0/24"',
                                        '  availability_zone = "${var.aws_region}b"',
                                        '}',
                                        '',
                                        'resource "aws_internet_gateway" "gw" {',
                                        '  vpc_id = aws_vpc.main.id',
                                        '}',
                                        '',
                                        'resource "aws_instance" "web" {',
                                        '  ami = var.ami_id',
                                        '  instance_type = var.instance_type',
                                        '  subnet_id = aws_subnet.public.id',
                                        '  associate_public_ip_address = true',
                                        '  vpc_security_group_ids = [aws_security_group.web.id]',
                                        '  user_data = file("${path.module}/scripts/deploy.sh")',
                                        '  tags = {',
                                        '    Name = "${var.project_name}-web-server"',
                                        '  }',
                                        '}',
                                        '',
                                        'resource "aws_security_group" "web" {',
                                        '  vpc_id = aws_vpc.main.id',
                                        '  ingress {',
                                        '    from_port = 80',
                                        '    to_port = 80',
                                        '    protocol = "tcp"',
                                        '    cidr_blocks = ["0.0.0.0/0"]',
                                        '  }',
                                        '  ingress {',
                                        '    from_port = 443',
                                        '    to_port = 443',
                                        '    protocol = "tcp"',
                                        '    cidr_blocks = ["0.0.0.0/0"]',
                                        '  }',
                                        '  ingress {',
                                        '    from_port = 22',
                                        '    to_port = 22',
                                        '    protocol = "tcp"',
                                        '    cidr_blocks = ["10.0.0.0/8"]',
                                        '  }',
                                        '  egress {',
                                        '    from_port = 0',
                                        '    to_port = 0',
                                        '    protocol = "-1"',
                                        '    cidr_blocks = ["0.0.0.0/0"]',
                                        '  }',
                                        '}',
                                        '',
                                        'resource "aws_s3_bucket" "assets" {',
                                        '  bucket = "${var.project_name}-assets-${random_id.suffix.hex}"',
                                        '  force_destroy = var.environment != "production"',
                                        '}',
                                        '',
                                        'resource "random_id" "suffix" {',
                                        '  byte_length = 4',
                                        '}',
                                        '',
                                        'output "vpc_id" {',
                                        '  value = aws_vpc.main.id',
                                        '}',
                                        '',
                                        'output "web_public_ip" {',
                                        '  value = aws_instance.web.public_ip',
                                        '}',
                                        '',
                                        'output "s3_bucket" {',
                                        '  value = aws_s3_bucket.assets.bucket',
                                        '}'
                                    )
                                }
                                'variables.tf' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'variable "project_name" {',
                                        '  description = "Name of the project"',
                                        '  type = string',
                                        '  default = "myapp"',
                                        '}',
                                        '',
                                        'variable "environment" {',
                                        '  description = "Deployment environment"',
                                        '  type = string',
                                        '  default = "development"',
                                        '}',
                                        '',
                                        'variable "aws_region" {',
                                        '  description = "AWS region"',
                                        '  type = string',
                                        '  default = "us-east-1"',
                                        '}',
                                        '',
                                        'variable "aws_profile" {',
                                        '  description = "AWS CLI profile"',
                                        '  type = string',
                                        '  default = "default"',
                                        '}',
                                        '',
                                        'variable "instance_type" {',
                                        '  description = "EC2 instance type"',
                                        '  type = string',
                                        '  default = "t3.medium"',
                                        '}',
                                        '',
                                        'variable "ami_id" {',
                                        '  description = "AMI ID for the web server"',
                                        '  type = string',
                                        '  default = "ami-0c55b159cbfafe1f0"',
                                        '}',
                                        '',
                                        'variable "instance_count" {',
                                        '  description = "Number of instances"',
                                        '  type = number',
                                        '  default = 2',
                                        '}'
                                    )
                                }
                                'outputs.tf' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'output "vpc_details" {',
                                        '  description = "VPC configuration details"',
                                        '  value = {',
                                        '    vpc_id = aws_vpc.main.id',
                                        '    cidr = aws_vpc.main.cidr_block',
                                        '    public_subnet = aws_subnet.public.id',
                                        '    private_subnet = aws_subnet.private.id',
                                        '  }',
                                        '}',
                                        '',
                                        'output "web_endpoint" {',
                                        '  description = "Web server public endpoint"',
                                        '  value = "http://${aws_instance.web.public_ip}"',
                                        '}',
                                        '',
                                        'output "environment_info" {',
                                        '  description = "Environment metadata"',
                                        '  value = {',
                                        '    project = var.project_name',
                                        '    env = var.environment',
                                        '    region = var.aws_region',
                                        '  }',
                                        '}'
                                    )
                                }
                            }
                        }
                        'k8s' = @{
                            Type = 'dir'
                            Owner = 'devops'
                            Group = 'devops'
                            Children = @{
                                'deployment.yml' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'apiVersion: apps/v1',
                                        'kind: Deployment',
                                        'metadata:',
                                        '  name: nginx-deployment',
                                        '  labels:',
                                        '    app: nginx',
                                        '    env: staging',
                                        'spec:',
                                        '  replicas: 3',
                                        '  selector:',
                                        '    matchLabels:',
                                        '      app: nginx',
                                        '  template:',
                                        '    metadata:',
                                        '      labels:',
                                        '        app: nginx',
                                        '    spec:',
                                        '      containers:',
                                        '      - name: nginx',
                                        '        image: nginx:1.25',
                                        '        ports:',
                                        '        - containerPort: 80',
                                        '        resources:',
                                        '          requests:',
                                        '            memory: "256Mi"',
                                        '            cpu: "250m"',
                                        '          limits:',
                                        '            memory: "512Mi"',
                                        '            cpu: "500m"',
                                        '        livenessProbe:',
                                        '          httpGet:',
                                        '            path: /',
                                        '            port: 80',
                                        '          initialDelaySeconds: 30',
                                        '          periodSeconds: 10',
                                        '        readinessProbe:',
                                        '          httpGet:',
                                        '            path: /',
                                        '            port: 80',
                                        '          initialDelaySeconds: 5',
                                        '          periodSeconds: 5'
                                    )
                                }
                                'service.yml' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'apiVersion: v1',
                                        'kind: Service',
                                        'metadata:',
                                        '  name: nginx-service',
                                        '  labels:',
                                        '    app: nginx',
                                        'spec:',
                                        '  type: LoadBalancer',
                                        '  selector:',
                                        '    app: nginx',
                                        '  ports:',
                                        '  - protocol: TCP',
                                        '    port: 80',
                                        '    targetPort: 80',
                                        '    nodePort: 30080'
                                    )
                                }
                                'ingress.yml' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        'apiVersion: networking.k8s.io/v1',
                                        'kind: Ingress',
                                        'metadata:',
                                        '  name: nginx-ingress',
                                        '  annotations:',
                                        '    nginx.ingress.kubernetes.io/rewrite-target: /',
                                        '    cert-manager.io/cluster-issuer: letsencrypt-prod',
                                        'spec:',
                                        '  ingressClassName: nginx',
                                        '  tls:',
                                        '  - hosts:',
                                        '    - app.staging.example.com',
                                        '    secretName: nginx-tls',
                                        '  rules:',
                                        '  - host: app.staging.example.com',
                                        '    http:',
                                        '      paths:',
                                        '      - path: /',
                                        '        pathType: Prefix',
                                        '        backend:',
                                        '          service:',
                                        '            name: nginx-service',
                                        '            port:',
                                        '              number: 80'
                                    )
                                }
                            }
                        }
                        'scripts' = @{
                            Type = 'dir'
                            Owner = 'devops'
                            Group = 'devops'
                            Children = @{
                                'deploy.sh' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        '#!/bin/bash',
                                        'set -euo pipefail',
                                        'echo "Starting deployment pipeline..."',
                                        'cd "$(dirname "$0")/.."',
                                        '',
                                        'echo "Initializing Terraform..."',
                                        'terraform -chdir=terraform init',
                                        '',
                                        'echo "Applying infrastructure..."',
                                        'terraform -chdir=terraform apply -auto-approve',
                                        '',
                                        'echo "Configuring kubectl..."',
                                        'kubectl apply -f k8s/deployment.yml',
                                        'kubectl apply -f k8s/service.yml',
                                        'kubectl apply -f k8s/ingress.yml',
                                        '',
                                        'echo "Deployment complete."'
                                    )
                                }
                                'backup.sh' = @{
                                    Type = 'file'
                                    Owner = 'devops'
                                    Group = 'devops'
                                    Content = @(
                                        '#!/bin/bash',
                                        'set -euo pipefail',
                                        'BACKUP_DIR="/backup/$(date +%Y-%m-%d)"',
                                        'mkdir -p "$BACKUP_DIR"',
                                        '',
                                        'echo "Backing up Terraform state..."',
                                        'cp -r terraform "$BACKUP_DIR/terraform"',
                                        '',
                                        'echo "Backing up Kubernetes manifests..."',
                                        'cp -r k8s "$BACKUP_DIR/k8s"',
                                        '',
                                        'echo "Backup saved to $BACKUP_DIR"'
                                    )
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
                'hostname' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'cloud-box'
                    )
                }
                'os-release' = @{
                    Type = 'file'
                    Owner = 'root'
                    Group = 'root'
                    Content = @(
                        'PRETTY_NAME="Ubuntu 24.04 LTS (Cloud Workstation)"',
                        'NAME="Ubuntu"',
                        'VERSION_ID="24.04"',
                        'VERSION="24.04 LTS (Noble Numbat)"',
                        'ID=ubuntu',
                        'ID_LIKE=debian'
                    )
                }
            }
        }
        'usr' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'local' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'bin' = @{
                            Type = 'dir'
                            Owner = 'root'
                            Group = 'root'
                            Children = @{
                                'kubectl' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "kubectl v1.29.0"'
                                    )
                                }
                                'terraform' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "Terraform v1.8.0"'
                                    )
                                }
                                'helm' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "Helm v3.14.0"'
                                    )
                                }
                                'aws' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "AWS CLI v2.15.0"'
                                    )
                                }
                                'gcloud' = @{
                                    Type = 'file'
                                    Owner = 'root'
                                    Group = 'root'
                                    Content = @(
                                        '#!/bin/bash',
                                        'echo "Google Cloud SDK v475.0.0"'
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        'var' = @{
            Type = 'dir'
            Owner = 'root'
            Group = 'root'
            Children = @{
                'log' = @{
                    Type = 'dir'
                    Owner = 'root'
                    Group = 'root'
                    Children = @{
                        'cloud-init.log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'Cloud-init v.24.2 running init stage',
                                'Cloud-init: started networking',
                                'Cloud-init: using datasource DataSourceNoCloud',
                                'Cloud-init: module apt_configure (enabled)',
                                'Cloud-init: installing packages: curl git jq',
                                'Cloud-init: writing files to /etc/kubernetes/',
                                'Cloud-init: module kubectl configured',
                                'Cloud-init: module terraform configured',
                                'Cloud-init: Cloud-init completed successfully at 2026-06-08 08:00:45',
                                'Cloud-init: Datasource DataSourceNoCloud seed: /var/lib/cloud/seed/nocloud'
                            )
                        }
                        'kubelet.log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                'I0608 08:00:01.000000 1 server.go:450] Kubelet version 1.29.0',
                                'I0608 08:00:02.000000 1 kubelet.go:550] Node cloud-box ready',
                                'I0608 08:00:05.000000 1 kubelet.go:600] Registered node cloud-box in cluster',
                                'I0608 08:01:00.000000 1 kubelet.go:700] SyncLoop (ADD): pod nginx-deployment-6b7fdf8b9c-abc01',
                                'I0608 08:01:01.000000 1 kubelet.go:700] SyncLoop (ADD): pod nginx-deployment-6b7fdf8b9c-abc02',
                                'I0608 08:01:02.000000 1 kubelet.go:700] SyncLoop (ADD): pod nginx-deployment-6b7fdf8b9c-abc03',
                                'I0608 08:01:05.000000 1 prober.go:120] Prober: pod nginx-deployment-abc01: readiness probe succeeded',
                                'I0608 08:01:06.000000 1 prober.go:120] Prober: pod nginx-deployment-abc02: readiness probe succeeded',
                                'I0608 08:01:07.000000 1 prober.go:120] Prober: pod nginx-deployment-abc03: readiness probe succeeded',
                                'I0608 08:02:00.000000 1 kubelet.go:800] Pod nginx-deployment-abc01 started at 172.17.0.2',
                                'I0608 08:02:10.000000 1 kubelet.go:800] Pod nginx-deployment-abc02 started at 172.17.0.3',
                                'I0608 08:02:20.000000 1 kubelet.go:800] Pod nginx-deployment-abc03 started at 172.17.0.4',
                                'E0608 09:00:00.000000 1 kubelet.go:900] Failed to sync pod nginx-deployment-abc01: OOMKilled',
                                'I0608 09:00:05.000000 1 kubelet.go:700] SyncLoop (RECONCILE): pod nginx-deployment-6b7fdf8b9c-abc01',
                                'I0608 09:01:00.000000 1 kubelet.go:700] SyncLoop (ADD): pod nginx-deployment-6b7fdf8b9c-abc04',
                                'I0608 09:01:30.000000 1 prober.go:120] Prober: pod nginx-deployment-abc04: readiness probe succeeded',
                                'I0608 10:00:00.000000 1 kubelet.go:600] Node cloud-box heartbeat sent',
                                'I0608 11:00:00.000000 1 kubelet.go:600] Node cloud-box heartbeat sent'
                            )
                        }
                        'terraform.log' = @{
                            Type = 'file'
                            Owner = 'root'
                            Group = 'adm'
                            Content = @(
                                '2026-06-08T08:05:00.000Z [INFO] Terraform v1.8.0',
                                '2026-06-08T08:05:01.000Z [INFO] Initializing provider plugins',
                                '2026-06-08T08:05:02.000Z [INFO] Finding hashicorp/aws versions',
                                '2026-06-08T08:05:03.000Z [INFO] Installing hashicorp/aws v5.40.0',
                                '2026-06-08T08:05:10.000Z [INFO] Provider installed successfully',
                                '2026-06-08T08:05:15.000Z [INFO] Planning infrastructure changes',
                                '2026-06-08T08:05:16.000Z [INFO] Plan: 6 to add, 0 to change, 0 to destroy',
                                '2026-06-08T08:05:20.000Z [INFO] aws_vpc.main: Creating...',
                                '2026-06-08T08:05:22.000Z [INFO] aws_vpc.main: Creation complete',
                                '2026-06-08T08:05:25.000Z [INFO] aws_subnet.public: Creating...',
                                '2026-06-08T08:05:26.000Z [INFO] aws_subnet.public: Creation complete',
                                '2026-06-08T08:05:30.000Z [INFO] aws_instance.web: Creating...',
                                '2026-06-08T08:06:00.000Z [INFO] aws_instance.web: Creation complete',
                                '2026-06-08T08:06:05.000Z [INFO] Apply complete! Resources: 6 added.'
                            )
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
            Id = 'cloud-b1'
            Title = 'List Kubernetes config clusters'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/devops/.kube/config'
            Description = @(
                'Display the kubeconfig file to see all configured clusters,',
                'contexts for dev, staging, and production environments.'
            )
            Hint = 'Use: cat /home/devops/.kube/config'
        }
        @{
            Id = 'cloud-b2'
            Title = 'View AWS CLI configuration'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/devops/.aws/config'
            Description = @(
                'Show the AWS CLI configuration file with region settings',
                'for default, staging, and production profiles.'
            )
            Hint = 'Use: cat /home/devops/.aws/config'
        }
        @{
            Id = 'cloud-b3'
            Title = 'List Terraform project files'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /home/devops/terraform/'
            Description = @(
                'List all files in the Terraform infrastructure directory.',
                'This configuration defines AWS cloud resources.'
            )
            Hint = 'Use: ls /home/devops/terraform/'
        }
        @{
            Id = 'cloud-b4'
            Title = 'View Kubernetes deployment manifest'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/devops/k8s/deployment.yml'
            Description = @(
                'Display the Kubernetes Deployment YAML for the nginx',
                'application with 3 replicas and resource limits.'
            )
            Hint = 'Use: cat /home/devops/k8s/deployment.yml'
        }
        @{
            Id = 'cloud-b5'
            Title = 'List available cloud CLI tools'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /usr/local/bin/'
            Description = @(
                'List the contents of /usr/local/bin to see installed',
                'cloud and DevOps command-line tools.'
            )
            Hint = 'Use: ls /usr/local/bin/'
        }
        @{
            Id = 'cloud-i1'
            Title = 'View AWS credentials file'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/devops/.aws/credentials'
            Description = @(
                'Display the AWS credentials file with access keys.',
                'Note: Never commit this file to version control!'
            )
            Hint = 'Use: cat /home/devops/.aws/credentials'
        }
        @{
            Id = 'cloud-i2'
            Title = 'Read the main Terraform configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/devops/terraform/main.tf'
            Description = @(
                'Display the main Terraform file defining AWS infrastructure,',
                'including VPC, subnets, EC2 instances, and S3 buckets.'
            )
            Hint = 'Use: cat /home/devops/terraform/main.tf'
        }
        @{
            Id = 'cloud-i3'
            Title = 'Check Terraform variables'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/devops/terraform/variables.tf'
            Description = @(
                'View the Terraform variables file with input definitions',
                'for project name, environment, instance type, and AMI.'
            )
            Hint = 'Use: cat /home/devops/terraform/variables.tf'
        }
        @{
            Id = 'cloud-i4'
            Title = 'View the Kubernetes Service manifest'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /home/devops/k8s/service.yml'
            Description = @(
                'Display the Kubernetes Service YAML of type LoadBalancer',
                'that exposes the nginx deployment on port 80.'
            )
            Hint = 'Use: cat /home/devops/k8s/service.yml'
        }
        @{
            Id = 'cloud-i5'
            Title = 'Find AWS regions in config'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep region /home/devops/.aws/config'
            Description = @(
                'Search the AWS config file for all region settings',
                'across all configured profiles.'
            )
            Hint = 'Use: grep region /home/devops/.aws/config'
        }
        @{
            Id = 'cloud-a1'
            Title = 'Find all Terraform files'
            Difficulty = 'advanced'
            ExpectedCommand = 'find /home/devops -name "*.tf"'
            Description = @(
                'Locate all Terraform configuration files in the',
                'devops home directory using the find command.'
            )
            Hint = 'Use: find /home/devops -name "*.tf"'
        }
        @{
            Id = 'cloud-a2'
            Title = 'Find AWS resource types in Terraform'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep resource /home/devops/terraform/main.tf'
            Description = @(
                'Search the main Terraform file for all declared',
                'resource types like aws_vpc, aws_subnet, aws_instance.'
            )
            Hint = 'Use: grep resource /home/devops/terraform/main.tf'
        }
        @{
            Id = 'cloud-a3'
            Title = 'Check kubelet logs for errors'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep -i "error\|fail" /var/log/kubelet.log'
            Description = @(
                'Search the kubelet log for error or failure messages.',
                'This helps diagnose Kubernetes node issues.'
            )
            Hint = 'Use: grep -i "error\|fail" /var/log/kubelet.log'
        }
        @{
            Id = 'cloud-a4'
            Title = 'View cloud-init startup log'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /var/log/cloud-init.log'
            Description = @(
                'Display the cloud-init log to see how the workstation',
                'was provisioned with tools and configurations.'
            )
            Hint = 'Use: cat /var/log/cloud-init.log'
        }
        @{
            Id = 'cloud-a5'
            Title = 'View the Ingress manifest'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /home/devops/k8s/ingress.yml'
            Description = @(
                'Display the Kubernetes Ingress manifest with TLS',
                'and path-based routing configuration.'
            )
            Hint = 'Use: cat /home/devops/k8s/ingress.yml'
        }
        @{
            Id = 'cloud-e1'
            Title = 'List all unique AWS resource types used'
            Difficulty = 'expert'
            ExpectedCommand = 'grep resource /home/devops/terraform/main.tf | awk "{print \$3}" | sort | uniq'
            Description = @(
                'Extract all unique AWS resource type names from',
                'the Terraform configuration using grep and awk.'
            )
            Hint = 'Use: grep resource /home/devops/terraform/main.tf | awk "{print \$3}" | sort | uniq'
        }
        @{
            Id = 'cloud-e2'
            Title = 'Create a backup of Terraform configs'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf terraform_backup.tar.gz -C /home/devops/terraform .'
            Description = @(
                'Create a compressed archive of all Terraform files.',
                'Always back up infrastructure-as-code before major changes.'
            )
            Hint = 'Use: tar -czf terraform_backup.tar.gz -C /home/devops/terraform .'
        }
        @{
            Id = 'cloud-e3'
            Title = 'Compare Kubernetes contexts in kubeconfig'
            Difficulty = 'expert'
            ExpectedCommand = 'grep -A 3 "context:" /home/devops/.kube/config'
            Description = @(
                'Extract all context definitions from the kubeconfig file,',
                'showing cluster and namespace mappings for each environment.'
            )
            Hint = 'Use: grep -A 3 "context:" /home/devops/.kube/config'
        }
        @{
            Id = 'cloud-e4'
            Title = 'Check disk usage of project directories'
            Difficulty = 'expert'
            ExpectedCommand = 'du -sh /home/devops/terraform /home/devops/k8s /home/devops/scripts'
            Description = @(
                'Show total disk usage for the terraform, k8s, and scripts',
                'directories to understand project storage requirements.'
            )
            Hint = 'Use: du -sh /home/devops/terraform /home/devops/k8s /home/devops/scripts'
        }
        @{
            Id = 'cloud-e5'
            Title = 'Analyze the deployment pipeline script'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /home/devops/scripts/deploy.sh'
            Description = @(
                'Display the full deployment pipeline script that',
                'runs Terraform and kubectl commands to provision infrastructure.'
            )
            Hint = 'Use: cat /home/devops/scripts/deploy.sh'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
