function Get-LearningContent-sql {
    $fs = @{
            'home' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'dba' = @{
                        Type = 'dir'; Owner = 'dba'; Group = 'dba'
                        Children = @{
                            'sql_scripts' = @{
                                Type = 'dir'; Owner = 'dba'; Group = 'dba'
                                Children = @{
                                    'backup_sql' = @{
                                        Type = 'file'; Owner = 'dba'; Group = 'dba'
                                        Content = @(
                                            '-- Database backup script',
                                            '-- Generated: 2026-06-08 03:00:00',
                                            'mysqldump -u root -p --all-databases --single-transaction --routines --triggers > /backup/full_backup_$(date +%Y%m%d).sql',
                                            'echo "Backup completed successfully"',
                                            'gzip /backup/full_backup_$(date +%Y%m%d).sql'
                                        )
                                    }
                                    'init_schema_sql' = @{
                                        Type = 'file'; Owner = 'dba'; Group = 'dba'
                                        Content = @(
                                            '-- Initial database schema for ecommerce platform',
                                            'CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;',
                                            'USE ecommerce;',
                                            'CREATE TABLE users (',
                                            '    id INT AUTO_INCREMENT PRIMARY KEY,',
                                            '    username VARCHAR(50) NOT NULL UNIQUE,',
                                            '    email VARCHAR(255) NOT NULL UNIQUE,',
                                            '    password_hash VARCHAR(255) NOT NULL,',
                                            '    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
                                            ') ENGINE=InnoDB;',
                                            'CREATE TABLE products (',
                                            '    id INT AUTO_INCREMENT PRIMARY KEY,',
                                            '    name VARCHAR(255) NOT NULL,',
                                            '    price DECIMAL(10,2) NOT NULL,',
                                            '    stock INT DEFAULT 0,',
                                            '    category_id INT,',
                                            '    INDEX idx_category (category_id)',
                                            ') ENGINE=InnoDB;',
                                            'CREATE TABLE orders (',
                                            '    id INT AUTO_INCREMENT PRIMARY KEY,',
                                            '    user_id INT NOT NULL,',
                                            '    total DECIMAL(10,2) NOT NULL,',
                                            '    status ENUM("pending","shipped","delivered") DEFAULT "pending",',
                                            '    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,',
                                            '    FOREIGN KEY (user_id) REFERENCES users(id)',
                                            ') ENGINE=InnoDB;'
                                        )
                                    }
                                    'query_optimization_sql' = @{
                                        Type = 'file'; Owner = 'dba'; Group = 'dba'
                                        Content = @(
                                            '-- Query optimization notes',
                                            '-- Slow query identified: full table scan on orders',
                                            'EXPLAIN SELECT * FROM orders WHERE user_id = 42;',
                                            '-- Add missing index',
                                            'CREATE INDEX idx_orders_user_id ON orders(user_id);',
                                            'CREATE INDEX idx_orders_created_at ON orders(created_at);',
                                            '-- Optimized query with covering index',
                                            'EXPLAIN SELECT id, user_id, total, status FROM orders WHERE user_id = 42;',
                                            '-- Partition large tables by date',
                                            'ALTER TABLE orders PARTITION BY RANGE (YEAR(created_at)) (',
                                            '    PARTITION p2024 VALUES LESS THAN (2025),',
                                            '    PARTITION p2025 VALUES LESS THAN (2026),',
                                            '    PARTITION p2026 VALUES LESS THAN (2027)',
                                            ');'
                                        )
                                    }
                                }
                            }
                            '.my_cnf' = @{
                                Type = 'file'; Owner = 'dba'; Group = 'dba'
                                Content = @(
                                    '[client]',
                                    'user = dbadmin',
                                    'password = s3cur3_DB_p@ss',
                                    'host = localhost',
                                    'port = 3306',
                                    '',
                                    '[mysql]',
                                    'prompt = "\\u@\\h:\\d> "',
                                    'pager = less',
                                    'safe-updates = 1'
                                )
                            }
                            'README_md' = @{
                                Type = 'file'; Owner = 'dba'; Group = 'dba'
                                Content = @(
                                    '# Database Server Administration',
                                    '',
                                    '## Overview',
                                    'This server manages both MySQL 8.0 and PostgreSQL 16 databases',
                                    'for production and development environments.',
                                    '',
                                    '## MySQL',
                                    '- Version: 8.0.35 (Ubuntu 24.04)',
                                    '- Config: /etc/mysql/my.cnf',
                                    '- Data: /var/lib/mysql/',
                                    '- Logs: /var/log/mysql/',
                                    '',
                                    '## PostgreSQL',
                                    '- Version: 16.3 (Ubuntu 24.04)',
                                    '- Config: /etc/postgresql/16/main/postgresql.conf',
                                    '- Data: /var/lib/postgresql/16/main/',
                                    '- Logs: /var/log/postgresql/',
                                    '',
                                    '## Backup Schedule',
                                    '- Daily: mysqldump at 03:00 AM',
                                    '- Weekly: pg_dump at 04:00 AM (Sunday)',
                                    '- Monthly: Full system backup',
                                    '',
                                    '## Quick Commands',
                                    '- mysql -u root -p',
                                    '- psql -U postgres -h localhost',
                                    '- mysqladmin status',
                                    '- pg_isready'
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
                        Content = @('db-server')
                    }
                    'os_release' = @{
                        Type = 'file'; Owner = 'root'; Group = 'root'
                        Content = @(
                            'PRETTY_NAME="Ubuntu 24.04 LTS (Database Server)"',
                            'NAME="Ubuntu"',
                            'VERSION_ID="24.04"',
                            'VERSION="24.04 LTS (Noble Numbat)"',
                            'ID=ubuntu',
                            'ID_LIKE=debian',
                            'HOME_URL="https://www.ubuntu.com/"'
                        )
                    }
                    'mysql' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'my_cnf' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @(
                                    '[client]',
                                    'port = 3306',
                                    'socket = /var/run/mysqld/mysqld.sock',
                                    '',
                                    '[mysqld]',
                                    'port = 3306',
                                    'bind-address = 0.0.0.0',
                                    'socket = /var/run/mysqld/mysqld.sock',
                                    'pid-file = /var/run/mysqld/mysqld.pid',
                                    'datadir = /var/lib/mysql',
                                    'tmpdir = /tmp',
                                    'user = mysql',
                                    'character-set-server = utf8mb4',
                                    'collation-server = utf8mb4_unicode_ci',
                                    'skip-external-locking',
                                    '',
                                    '# InnoDB settings',
                                    'innodb_buffer_pool_size = 2G',
                                    'innodb_log_file_size = 256M',
                                    'innodb_flush_log_at_trx_commit = 2',
                                    'innodb_file_per_table = 1',
                                    'innodb_flush_method = O_DIRECT',
                                    'innodb_autoinc_lock_mode = 2',
                                    'innodb_lock_wait_timeout = 50',
                                    '',
                                    '# Connection settings',
                                    'max_connections = 500',
                                    'max_allowed_packet = 64M',
                                    'wait_timeout = 600',
                                    'interactive_timeout = 28800',
                                    'thread_cache_size = 128',
                                    '',
                                    '# Binary logging for replication',
                                    'log_bin = /var/log/mysql/mysql-bin',
                                    'expire_logs_days = 7',
                                    'max_binlog_size = 100M',
                                    'binlog_format = ROW',
                                    'server-id = 1',
                                    '',
                                    '# Slow query log',
                                    'slow_query_log = 1',
                                    'slow_query_log_file = /var/log/mysql/slow_query.log',
                                    'long_query_time = 2',
                                    'log_queries_not_using_indexes = 1',
                                    '',
                                    '# Security',
                                    'local-infile = 0',
                                    'symbolic-links = 0'
                                )
                            }
                            'mysql_conf_d' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'mysqld_cnf' = @{
                                        Type = 'file'; Owner = 'root'; Group = 'root'
                                        Content = @(
                                            '# Custom MySQL overrides',
                                            '[mysqld]',
                                            'bind-address = 127.0.0.1',
                                            'port = 3307',
                                            'max_connections = 250'
                                        )
                                    }
                                }
                            }
                            'mariadb' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{}
                            }
                        }
                    }
                    'postgresql' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            '16' = @{
                                Type = 'dir'; Owner = 'root'; Group = 'root'
                                Children = @{
                                    'main' = @{
                                        Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                        Children = @{
                                            'postgresql_conf' = @{
                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                Content = @(
                                                    '# PostgreSQL 16 Configuration File',
                                                    '# Database: production_db',
                                                    '',
                                                    '# Connections',
                                                    "listen_addresses = '*'",
                                                    'port = 5432',
                                                    'max_connections = 200',
                                                    'superuser_reserved_connections = 10',
                                                    'unix_socket_directories = /var/run/postgresql',
                                                    '',
                                                    '# Memory settings',
                                                    'shared_buffers = 1GB',
                                                    'work_mem = 128MB',
                                                    'maintenance_work_mem = 256MB',
                                                    'effective_cache_size = 3GB',
                                                    'wal_buffers = 16MB',
                                                    '',
                                                    '# Write Ahead Log',
                                                    'wal_level = replica',
                                                    'max_wal_size = 2GB',
                                                    'min_wal_size = 80MB',
                                                    'wal_compression = on',
                                                    '',
                                                    '# Query tuning',
                                                    'random_page_cost = 1.1',
                                                    'effective_io_concurrency = 200',
                                                    'default_statistics_target = 100',
                                                    '',
                                                    '# Logging',
                                                    "log_destination = 'stderr'",
                                                    'logging_collector = on',
                                                    "log_directory = '/var/log/postgresql'",
                                                    "log_filename = 'postgresql-%Y-%m-%d.log'",
                                                    'log_min_duration_statement = 1000',
                                                    'log_checkpoints = on',
                                                    'log_connections = on',
                                                    'log_disconnections = on',
                                                    'log_lock_waits = on',
                                                    '',
                                                    '# Autovacuum',
                                                    'autovacuum = on',
                                                    'autovacuum_max_workers = 4',
                                                    'autovacuum_naptime = 1min',
                                                    '',
                                                    '# Replication',
                                                    "primary_conninfo = 'host=replica_host port=5432 user=replicator password=rep_pass'",
                                                    'max_replication_slots = 5',
                                                    'max_wal_senders = 5',
                                                    'hot_standby = on'
                                                )
                                            }
                                            'pg_hba_conf' = @{
                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                Content = @(
                                                    '# PostgreSQL Client Authentication Configuration',
                                                    '# TYPE  DATABASE        USER            ADDRESS                 METHOD',
                                                    '',
                                                    '# Local connections',
                                                    'local   all             postgres                                peer',
                                                    'local   all             all                                     md5',
                                                    '',
                                                    '# IPv4 local connections',
                                                    'host    all             postgres        127.0.0.1/32            reject',
                                                    'host    all             all             127.0.0.1/32            scram-sha-256',
                                                    '',
                                                    '# IPv4 remote connections',
                                                    'host    all             all             10.0.0.0/8              md5',
                                                    'host    all             all             172.16.0.0/12           md5',
                                                    'host    all             all             192.168.0.0/16          md5',
                                                    '',
                                                    '# Application-specific',
                                                    'host    ecommerce       app_user        10.0.0.0/8              md5',
                                                    'host    analytics       readonly_user   10.0.1.0/24             md5',
                                                    '',
                                                    '# Replication connections',
                                                    'host    replication     replicator      10.0.0.0/8              md5',
                                                    '',
                                                    '# Deny all other connections',
                                                    'host    all             all             0.0.0.0/0               reject'
                                                )
                                            }
                                            'pg_ident_conf' = @{
                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                Content = @(
                                                    '# PostgreSQL User Name Maps',
                                                    '# MAPNAME       SYSTEM-USERNAME         PG-USERNAME',
                                                    '',
                                                    '# Map system root to postgres',
                                                    'root_map        root                    postgres',
                                                    '',
                                                    '# Map system dba to dbadmin',
                                                    'dba_map         dba                     dbadmin',
                                                    '',
                                                    '# Map LDAP users',
                                                    'ldap_map        /^(.*)@domain\.com$      admin_\\1'
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
            'var' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'lib' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'mysql' = @{
                                Type = 'dir'; Owner = 'mysql'; Group = 'mysql'
                                Children = @{
                                    'ibdata1' = @{
                                        Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                        Content = @('MySQL system tablespace placeholder - 256MB')
                                    }
                                    'ib_logfile0' = @{
                                        Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                        Content = @('MySQL InnoDB redo log #0 - 256MB')
                                    }
                                    'mysql' = @{
                                        Type = 'dir'; Owner = 'mysql'; Group = 'mysql'
                                        Children = @{
                                            'user_mad' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('MySQL system table: user')
                                            }
                                            'db_mad' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('MySQL system table: db')
                                            }
                                            'tables_priv_mad' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('MySQL system table: tables_priv')
                                            }
                                        }
                                    }
                                    'wordpress' = @{
                                        Type = 'dir'; Owner = 'mysql'; Group = 'mysql'
                                        Children = @{
                                            'wp_posts_idb' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('InnoDB tablespace: wordpress.wp_posts')
                                            }
                                            'wp_options_idb' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('InnoDB tablespace: wordpress.wp_options')
                                            }
                                            'wp_users_idb' = @{
                                                Type = 'file'; Owner = 'mysql'; Group = 'mysql'
                                                Content = @('InnoDB tablespace: wordpress.wp_users')
                                            }
                                        }
                                    }
                                    'performance_schema' = @{
                                        Type = 'dir'; Owner = 'mysql'; Group = 'mysql'
                                        Children = @{}
                                    }
                                }
                            }
                            'postgresql' = @{
                                Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                Children = @{
                                    '16' = @{
                                        Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                        Children = @{
                                            'main' = @{
                                                Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                                Children = @{
                                                    'base' = @{
                                                        Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                                        Children = @{
                                                            '1' = @{
                                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                                Content = @('PostgreSQL template1 database')
                                                            }
                                                            '16384' = @{
                                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                                Content = @('PostgreSQL production_db')
                                                            }
                                                        }
                                                    }
                                                    'global' = @{
                                                        Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                                        Children = @{
                                                            'pg_control' = @{
                                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                                Content = @('PostgreSQL cluster control file')
                                                            }
                                                            'pg_authid' = @{
                                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                                Content = @('PostgreSQL authentication data')
                                                            }
                                                        }
                                                    }
                                                    'pg_wal' = @{
                                                        Type = 'dir'; Owner = 'postgres'; Group = 'postgres'
                                                        Children = @{
                                                            '000000010000000000000001' = @{
                                                                Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                                Content = @('PostgreSQL WAL segment - 16MB')
                                                            }
                                                        }
                                                    }
                                                    'pg_xlog' = @{
                                                        Type = 'file'; Owner = 'postgres'; Group = 'postgres'
                                                        Content = @('Symbolic link to pg_wal - WAL directory')
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    'log' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'mysql' = @{
                                Type = 'dir'; Owner = 'mysql'; Group = 'adm'
                                Children = @{
                                    'error_log' = @{
                                        Type = 'file'; Owner = 'mysql'; Group = 'adm'
                                        Content = @(
                                            '2026-06-08T00:15:23.001234Z 0 [Warning] [MY-010139] InnoDB: Page cleaner took 456ms to flush',
                                            '2026-06-08T01:00:00.001234Z 0 [Note] [MY-010914] InnoDB: Starting shutdown...',
                                            '2026-06-08T01:00:02.001234Z 0 [Note] [MY-010915] InnoDB: Shutdown completed',
                                            '2026-06-08T01:00:05.001234Z 0 [Note] [MY-010914] InnoDB: Starting crash recovery...',
                                            '2026-06-08T01:00:10.001234Z 0 [Note] [MY-010915] InnoDB: Crash recovery completed',
                                            '2026-06-08T01:00:15.001234Z 0 [Note] [MY-010101] InnoDB: Started; log sequence number 98765432',
                                            '2026-06-08T01:00:15.001234Z 0 [Note] [MY-010733] Server socket created on IP: 0.0.0.0:3306',
                                            '2026-06-08T02:30:45.001234Z 0 [Warning] [MY-011068] InnoDB: Deprecated variable innodb_log_file_size',
                                            '2026-06-08T02:30:45.001234Z 0 [Note] [MY-011069] InnoDB: Adjusting to innodb_redo_log_capacity setting',
                                            '2026-06-08T03:00:00.001234Z 0 [Note] [MY-010176] Aborted connection 42 to db: unconnected user: root host: localhost',
                                            '2026-06-08T04:15:23.001234Z 0 [ERROR] [MY-013129] InnoDB: Table ecommerce/orders is corrupted',
                                            '2026-06-08T04:15:23.001234Z 0 [Note] [MY-010733] InnoDB: Please run CHECK TABLE',
                                            '2026-06-08T05:00:00.001234Z 0 [Warning] [MY-010068] Disk space is below 10% on datadir /var/lib/mysql',
                                            '2026-06-08T06:30:00.001234Z 0 [ERROR] [MY-010584] Replication slave SQL thread failed with errno 1062',
                                            '2026-06-08T06:30:01.001234Z 0 [Note] [MY-010586] Slave: Error inserting duplicate key in orders table',
                                            '2026-06-08T07:00:00.001234Z 0 [Note] [MY-010176] Aborted connection 55 to db: ecommerce user: app_user host: 10.0.0.15',
                                            '2026-06-08T08:00:00.001234Z 0 [Warning] [MY-011084] InnoDB: Redo log archiving is enabled',
                                            '2026-06-08T08:15:30.001234Z 0 [ERROR] [MY-013118] InnoDB: Page 256 in tablespace 35 is corrupted',
                                            '2026-06-08T08:15:31.001234Z 0 [Note] [MY-013119] InnoDB: Initiating forced recovery',
                                            '2026-06-08T08:30:00.001234Z 0 [ERROR] [MY-010584] Replication slave SQL thread failed again'
                                        )
                                    }
                                    'slow_query_log' = @{
                                        Type = 'file'; Owner = 'mysql'; Group = 'adm'
                                        Content = @(
                                            '# Time: 2026-06-08T01:15:22.123456Z',
                                            '# Query_time: 12.345  Lock_time: 0.001 Rows_sent: 5000  Rows_examined: 500000',
                                            'SELECT p.* FROM products p LEFT JOIN order_items oi ON p.id = oi.product_id WHERE oi.product_id IS NULL;',
                                            '',
                                            '# Time: 2026-06-08T02:30:10.654321Z',
                                            '# Query_time: 8.912  Lock_time: 0.002 Rows_sent: 0  Rows_examined: 250000',
                                            'UPDATE orders SET status = "shipped" WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);',
                                            '',
                                            '# Time: 2026-06-08T03:45:33.987654Z',
                                            '# Query_time: 15.678  Lock_time: 0.005 Rows_sent: 100  Rows_examined: 750000',
                                            'SELECT u.username, COUNT(o.id) as order_count FROM users u JOIN orders o ON u.id = o.user_id GROUP BY u.id HAVING order_count > 10;',
                                            '',
                                            '# Time: 2026-06-08T04:00:01.111111Z',
                                            '# Query_time: 5.234  Lock_time: 0.001 Rows_sent: 2000  Rows_examined: 500000',
                                            'SELECT * FROM products WHERE MATCH(name, description) AGAINST("search term" IN BOOLEAN MODE);',
                                            '',
                                            '# Time: 2026-06-08T05:20:45.222222Z',
                                            '# Query_time: 22.567  Lock_time: 0.010 Rows_sent: 50  Rows_examined: 1000000',
                                            'SELECT * FROM orders o JOIN order_items oi ON o.id = oi.order_id JOIN products p ON oi.product_id = p.id WHERE o.status = "pending" ORDER BY o.created_at DESC;'
                                        )
                                    }
                                    'general_log' = @{
                                        Type = 'file'; Owner = 'mysql'; Group = 'adm'
                                        Content = @(
                                            '2026-06-08T00:00:01.000001Z       42 Connect     root@localhost on',
                                            '2026-06-08T00:00:01.000002Z       42 Query       SET NAMES utf8mb4',
                                            '2026-06-08T00:00:01.000003Z       42 Query       SELECT VERSION()',
                                            '2026-06-08T00:05:00.000001Z       42 Query       SHOW DATABASES',
                                            '2026-06-08T00:05:10.000001Z       42 Query       USE ecommerce',
                                            '2026-06-08T00:05:15.000001Z       42 Query       SHOW TABLES',
                                            '2026-06-08T01:00:00.000001Z       55 Connect     app_user@10.0.0.15 on ecommerce',
                                            '2026-06-08T01:00:00.000002Z       55 Query       SELECT * FROM products LIMIT 10',
                                            '2026-06-08T01:00:00.000003Z       55 Query       INSERT INTO orders (user_id, total) VALUES (42, 99.99)',
                                            '2026-06-08T02:00:00.000001Z       68 Connect     readonly_user@10.0.1.25 on analytics',
                                            '2026-06-08T02:00:00.000002Z       68 Query       SELECT COUNT(*) FROM page_views WHERE date = CURDATE()'
                                        )
                                    }
                                }
                            }
                            'postgresql' = @{
                                Type = 'dir'; Owner = 'postgres'; Group = 'adm'
                                Children = @{
                                    'postgresql_log' = @{
                                        Type = 'file'; Owner = 'postgres'; Group = 'adm'
                                        Content = @(
                                            '2026-06-08 00:00:00 UTC [12345] LOG:  checkpoint starting: time',
                                            '2026-06-08 00:01:00 UTC [12345] LOG:  checkpoint complete: wrote 42 buffers',
                                            '2026-06-08 01:00:00 UTC [12346] LOG:  connection received: host=10.0.0.15 port=54321',
                                            '2026-06-08 01:00:01 UTC [12346] LOG:  authentication successful for user "app_user"',
                                            '2026-06-08 01:00:01 UTC [12346] LOG:  duration: 3450.123 ms  statement: SELECT COUNT(*) FROM orders WHERE status = "pending"',
                                            '2026-06-08 02:00:00 UTC [12347] LOG:  connection received: host=10.0.1.25 port=54322',
                                            '2026-06-08 02:00:01 UTC [12347] LOG:  authentication failed for user "readonly_user" from 10.0.1.25',
                                            '2026-06-08 03:00:00 UTC [12348] LOG:  checkpoint starting: time',
                                            '2026-06-08 03:00:30 UTC [12348] LOG:  checkpoint complete: wrote 128 buffers',
                                            '2026-06-08 04:00:00 UTC [12349] WARNING:  connection to replica_host lost',
                                            '2026-06-08 04:00:01 UTC [12349] LOG:  replication terminated due to network error',
                                            '2026-06-08 04:00:05 UTC [12349] LOG:  attempting reconnection to replica_host',
                                            '2026-06-08 05:00:00 UTC [12350] WARNING:  database "production_db" has high bloat on table orders',
                                            '2026-06-08 05:00:01 UTC [12350] LOG:  automatic vacuum of table "production_db.public.orders" started',
                                            '2026-06-08 05:05:00 UTC [12350] LOG:  automatic vacuum of table "production_db.public.orders" finished',
                                            '2026-06-08 06:00:00 UTC [12351] LOG:  connection received: host=10.0.0.1 port=54323',
                                            '2026-06-08 06:00:01 UTC [12351] LOG:  authentication successful for user "replicator"',
                                            '2026-06-08 07:00:00 UTC [12352] ERROR:  deadlock detected on table orders',
                                            '2026-06-08 07:00:01 UTC [12352] DETAIL:  Process 12352 waited for ShareLock on transaction 56789',
                                            '2026-06-08 07:00:02 UTC [12352] LOG:  process 12352 released ShareLock on transaction 56789'
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            'usr' = @{
                Type = 'dir'; Owner = 'root'; Group = 'root'
                Children = @{
                    'bin' = @{
                        Type = 'dir'; Owner = 'root'; Group = 'root'
                        Children = @{
                            'mysql' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('#!/bin/bash', 'echo "MySQL CLI 8.0.35"')
                            }
                            'mysqldump' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('#!/bin/bash', 'echo "mysqldump Ver 8.0.35"')
                            }
                            'psql' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('#!/bin/bash', 'echo "psql (PostgreSQL 16.3)"')
                            }
                            'pg_dump' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('#!/bin/bash', 'echo "pg_dump (PostgreSQL 16.3)"')
                            }
                            'sqlite3' = @{
                                Type = 'file'; Owner = 'root'; Group = 'root'
                                Content = @('#!/bin/bash', 'echo "sqlite3 3.45.0"')
                            }
                        }
                    }
                }
            }
    }

    $tasks = @(
        @{
            Id = 'sql-b1'
            Title = 'List SQL scripts directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /home/dba/sql_scripts/'
            Description = @(
                'List the contents of the dba scripts directory to see available',
                'SQL scripts for backup, schema management, and query optimization.'
            )
            Hint = 'Use: ls /home/dba/sql_scripts/'
        }
        @{
            Id = 'sql-b2'
            Title = 'Read the database server README'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/dba/README_md'
            Description = @(
                'Display the README file to learn about the database server',
                'configuration, versions, and available commands.'
            )
            Hint = 'Use: cat /home/dba/README_md'
        }
        @{
            Id = 'sql-b3'
            Title = 'Check MySQL client config'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /home/dba/.my_cnf'
            Description = @(
                'Read the MySQL client configuration file to see connection',
                'credentials and client settings for the dba user.'
            )
            Hint = 'Use: cat /home/dba/.my_cnf'
        }
        @{
            Id = 'sql-b4'
            Title = 'List MySQL config directory'
            Difficulty = 'beginner'
            ExpectedCommand = 'ls /etc/mysql/'
            Description = @(
                'List the MySQL configuration directory to see available',
                'config files and subdirectories including conf.d and mariadb.'
            )
            Hint = 'Use: ls /etc/mysql/'
        }
        @{
            Id = 'sql-b5'
            Title = 'Check server hostname'
            Difficulty = 'beginner'
            ExpectedCommand = 'cat /etc/hostname'
            Description = @(
                'Display the server hostname to confirm you are logged',
                'into the database server.'
            )
            Hint = 'Use: cat /etc/hostname'
        }
        @{
            Id = 'sql-i1'
            Title = 'View MySQL server configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/mysql/my_cnf'
            Description = @(
                'Display the main MySQL configuration file to review server',
                'settings including InnoDB tuning, connections, and logging.'
            )
            Hint = 'Use: cat /etc/mysql/my_cnf'
        }
        @{
            Id = 'sql-i2'
            Title = 'View PostgreSQL configuration'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/postgresql/16/main/postgresql_conf'
            Description = @(
                'Display the PostgreSQL 16 configuration file to review',
                'memory settings, WAL configuration, and logging parameters.'
            )
            Hint = 'Use: cat /etc/postgresql/16/main/postgresql_conf'
        }
        @{
            Id = 'sql-i3'
            Title = 'Find MySQL port settings'
            Difficulty = 'intermediate'
            ExpectedCommand = 'grep port /etc/mysql/my_cnf'
            Description = @(
                'Search the MySQL configuration for lines containing "port"',
                'to find the configured ports for client and server connections.'
            )
            Hint = 'Use: grep port /etc/mysql/my_cnf'
        }
        @{
            Id = 'sql-i4'
            Title = 'Check MySQL error log'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /var/log/mysql/error_log'
            Description = @(
                'Display the MySQL error log to identify warnings, errors,',
                'and potential issues with the database server.'
            )
            Hint = 'Use: cat /var/log/mysql/error_log'
        }
        @{
            Id = 'sql-i5'
            Title = 'Check PostgreSQL client authentication'
            Difficulty = 'intermediate'
            ExpectedCommand = 'cat /etc/postgresql/16/main/pg_hba_conf'
            Description = @(
                'Display the pg_hba.conf file to review client authentication',
                'rules and allowed connection methods for PostgreSQL.'
            )
            Hint = 'Use: cat /etc/postgresql/16/main/pg_hba_conf'
        }
        @{
            Id = 'sql-a1'
            Title = 'Find all SQL scripts on the system'
            Difficulty = 'advanced'
            ExpectedCommand = 'find / -name "*_sql" 2>/dev/null'
            Description = @(
                'Use the find command to locate all files ending in _sql',
                'anywhere on the filesystem to discover database scripts.'
            )
            Hint = 'Use: find / -name "*_sql" 2>/dev/null'
        }
        @{
            Id = 'sql-a2'
            Title = 'Search InnoDB settings in MySQL config'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep innodb /etc/mysql/my_cnf'
            Description = @(
                'Search the MySQL configuration for InnoDB storage engine',
                'parameters to understand buffer pool and flush settings.'
            )
            Hint = 'Use: grep innodb /etc/mysql/my_cnf'
        }
        @{
            Id = 'sql-a3'
            Title = 'Find ERROR entries in MySQL error log'
            Difficulty = 'advanced'
            ExpectedCommand = 'grep ERROR /var/log/mysql/error_log'
            Description = @(
                'Filter the MySQL error log for lines containing ERROR',
                'to identify critical database problems needing attention.'
            )
            Hint = 'Use: grep ERROR /var/log/mysql/error_log'
        }
        @{
            Id = 'sql-a4'
            Title = 'View the database initialization schema'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /home/dba/sql_scripts/init_schema_sql'
            Description = @(
                'Display the database initialization script to understand',
                'the table structure, indexes, and schema design patterns.'
            )
            Hint = 'Use: cat /home/dba/sql_scripts/init_schema_sql'
        }
        @{
            Id = 'sql-a5'
            Title = 'Check pg_hba authentication methods'
            Difficulty = 'advanced'
            ExpectedCommand = 'cat /etc/postgresql/16/main/pg_hba_conf | grep -v "^#" | grep -v "^$"'
            Description = @(
                'Display pg_hba.conf with comments and blank lines removed',
                'to see only the active authentication rules.'
            )
            Hint = 'Use: cat /etc/postgresql/16/main/pg_hba_conf | grep -v "^#" | grep -v "^$"'
        }
        @{
            Id = 'sql-e1'
            Title = 'Analyze slow query patterns'
            Difficulty = 'expert'
            ExpectedCommand = 'grep Query_time /var/log/mysql/slow_query_log | sort -n'
            Description = @(
                'Extract all Query_time values from the slow query log',
                'and sort them numerically to identify the worst-performing queries.'
            )
            Hint = 'Use: grep Query_time /var/log/mysql/slow_query_log | sort -n'
        }
        @{
            Id = 'sql-e2'
            Title = 'Create compressed backup of SQL scripts'
            Difficulty = 'expert'
            ExpectedCommand = 'tar -czf dba_scripts_backup.tar.gz -C /home/dba/sql_scripts .'
            Description = @(
                'Create a gzipped tar archive of all SQL scripts in the',
                'dba scripts directory for backup or migration.'
            )
            Hint = 'Use: tar -czf dba_scripts_backup.tar.gz -C /home/dba/sql_scripts .'
        }
        @{
            Id = 'sql-e3'
            Title = 'List database directories'
            Difficulty = 'expert'
            ExpectedCommand = 'ls -la /var/lib/mysql/'
            Description = @(
                'List the MySQL data directory with details to see all',
                'databases, InnoDB tablespaces, and redo logs.'
            )
            Hint = 'Use: ls -la /var/lib/mysql/'
        }
        @{
            Id = 'sql-e4'
            Title = 'Compare MySQL and PostgreSQL port and buffer settings'
            Difficulty = 'expert'
            ExpectedCommand = 'grep -E "port|buffer" /etc/mysql/my_cnf /etc/postgresql/16/main/postgresql_conf'
            Description = @(
                'Use grep across both MySQL and PostgreSQL config files to',
                'compare port numbers and buffer size settings side by side.'
            )
            Hint = 'Use: grep -E "port|buffer" /etc/mysql/my_cnf /etc/postgresql/16/main/postgresql_conf'
        }
        @{
            Id = 'sql-e5'
            Title = 'Analyze PostgreSQL authentication entries'
            Difficulty = 'expert'
            ExpectedCommand = 'cat /etc/postgresql/16/main/pg_hba_conf | grep "^host" | awk "{print \$1, \$2, \$3, \$4, \$5}"'
            Description = @(
                'Extract only the host-based authentication entries from',
                'pg_hba.conf to analyze which networks can access which databases.'
            )
            Hint = 'Use: cat /etc/postgresql/16/main/pg_hba_conf | grep "^host" | awk "{print \$1, \$2, \$3, \$4, \$5}"'
        }
    )

    return @{ Filesystem = $fs; Tasks = $tasks }
}
