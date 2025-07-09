# 🐳 Inception - 42 Project

## 🌟 Overview

### ✅ [125/100] 

**Inception** is a system administration project that introduces Docker containerization and infrastructure management, developed as part of the 42 curriculum.

This project involves setting up a complete web infrastructure using Docker containers, including a WordPress site with MariaDB database, Redis cache, and additional services. The entire setup is orchestrated using Docker Compose with proper networking, volume management, and security configurations.

The purpose of this project is to provide hands-on experience with containerization, orchestration, and modern DevOps practices.

---

## 📋 Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [Services](#services)
- [Bonus Features](#bonus-features)
- [Usage](#usage)
- [License](#license)

---

## ✨ Features

### Mandatory

- **NGINX**: Web server with TLS/SSL encryption (port 443 only)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server for WordPress data storage
- **Docker Compose**: Complete orchestration with custom Dockerfiles
- **Volumes**: Persistent data storage for database and website files
- **Networks**: Isolated Docker network for secure communication
- **Environment Variables**: Secure configuration management
- **Health Checks**: Service monitoring and dependency management

### Security

- **TLS Certificate**: Self-signed SSL certificate for HTTPS
- **Docker Secrets**: Secure password and credential management
- **Isolated Network**: Services communicate only through internal network
- **No Latest Tags**: Specific version tags for all base images
- **Restart Policies**: Automatic service recovery on failure

---

## 🚀 Getting Started

### Prerequisites

- Docker Engine (20.10+)
- Docker Compose (2.0+)
- Make utility
- Linux environment (tested on Ubuntu/Debian)

### Installation

```bash
git clone https://github.com/Eutrius/inception.git
cd inception
make
```

---

## 🏗️ Architecture

The project consists of multiple Docker containers orchestrated with Docker Compose:

```
┌─────────────────────────────────────────────────────────────┐
│                        Host Machine                         │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                Docker Network: inception               │ │
│  │                                                        │ │
│  │  ┌─────────┐    ┌─────────┐    ┌─────────┐             │ │
│  │  │  NGINX  │    │WordPress│    │ MariaDB │             │ │
│  │  │  :443   │◄──►│  :9000  │◄──►│  :3306  │             │ │
│  │  └─────────┘    └─────────┘    └─────────┘             │ │
│  │       │              │              │                  │ │
│  │       │              ▼              │                  │ │
│  │       │         ┌─────────┐         │                  │ │
│  │       │         │  Redis  │         │                  │ │
│  │       │         │  :6379  │         │                  │ │
│  │       │         └─────────┘         │                  │ │
│  │       │                             │                  │ │
│  │       ▼                             ▼                  │ │
│  │  ┌─────────┐    ┌─────────┐    ┌─────────┐             │ │
│  │  │Portfolio│    │ Adminer │    │   FTP   │             │ │
│  │  │  :3000  │    │  :8080  │    │  :21    │             │ │
│  │  └─────────┘    └─────────┘    └─────────┘             │ │
│  │                                                        │ │
│  │                 ┌─────────┐                            │ │
│  │                 │Portainer│                            │ │
│  │                 │  :9000  │                            │ │
│  │                 └─────────┘                            │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Services

### Core Services

#### NGINX
- **Purpose**: Reverse proxy and web server
- **Port**: 443 (HTTPS only)
- **Features**: TLS encryption, static file serving, PHP-FPM proxy

#### WordPress
- **Purpose**: Content management system
- **Port**: 9000 (internal)
- **Features**: PHP-FPM, MySQL connectivity, Redis caching

#### MariaDB
- **Purpose**: Database server
- **Port**: 3306 (internal)
- **Features**: WordPress database, user management, persistent storage

---

## 🎯 Bonus Features

### Additional Services

#### Redis
- **Purpose**: Caching layer
- **Port**: 6379 (internal)
- **Features**: WordPress object caching, session storage

#### FTP Server
- **Purpose**: File transfer protocol server
- **Ports**: 21, 21000-21010
- **Features**: WordPress file management, passive mode support

#### Adminer
- **Purpose**: Database administration tool
- **Access**: Via NGINX reverse proxy
- **Features**: Web-based MySQL management interface

#### Portfolio
- **Purpose**: Personal portfolio website
- **Port**: 3000 (internal)
- **Features**: Custom Node.js application, static site serving

#### Portainer
- **Purpose**: Docker container management
- **Port**: 9000 (internal)
- **Features**: Web-based Docker administration, container monitoring

---

## 💻 Usage

### Accessing Services

Once deployed, access the services through:

- **WordPress**: `https://jyriarte.42.fr/`
- **Adminer**: `https://jyriarte.42.fr/adminer/`
- **Portfolio**: `https://jyriarte.42.fr/portfolio/`
- **Portainer**: `https://jyriarte.42.fr/portainer/`

### Environment Configuration

Create a `.env` file in the `srcs/` directory with:

```bash
# Domain Configuration
WP_URL=https://jyriarte.42.fr

# Database Configuration
MARIA_DB_NAME=wordpress_db
MARIA_USER=db_user

# WordPress Configuration
WP_TITLE="Inception"
WP_ROOT_USER=wp_root
WP_ROOT_EMAIL=wp_root@example.com
WP_USER=wp_user
WP_USER_EMAIL=wp_user@example.com

# FTP Configuration
FTP_USER=ftp_user

# Portainer Configuration
PT_USER=pt_user
```

### Secret Management

Create password files in `../secrets/`:

```bash
mkdir -p ../secrets
echo "your_maria_user_password" > ../secrets/maria_user_password.txt
echo "your_root_password" > ../secrets/maria_root_password.txt
echo "your_wp_user_password" > ../secrets/wp_user_password.txt
echo "your_wp_root_password" > ../secrets/wp_root_password.txt
echo "your_redis_password" > ../secrets/redis_password.txt
echo "your_ftp_password" > ../secrets/ftp_user_password.txt
echo "your_portainer_password" > ../secrets/pt_user_password.txt
```

### Makefile Commands

```bash
# Full deployment
make all              # Build and deploy all services

# Individual operations
make build            # Build all Docker images
make deploy           # Start all services
make up               # Force recreate and start services

# Monitoring
make ps               # Show running containers
make logs             # Show all logs
make watch            # Follow logs in real-time

# Cleanup
make down             # Stop all services
make clean            # Remove volumes and images
make fclean           # Complete system cleanup
make re               # Full rebuild and redeploy
```

### Health Monitoring

All services include health checks:

- **Database**: MySQL ping test
- **WordPress**: PHP-FPM process check
- **NGINX**: HTTPS connectivity test
- **Redis**: Redis ping command
- **FTP**: Port connectivity test
- **Adminer**: PHP-FPM process check
- **Portfolio**: HTTP status endpoint
- **Portainer**: API status endpoint

---

## 📁 Project Structure

```
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── wordpress/
│       ├── mariadb/
│       └── bonus/
│           ├── redis/
│           ├── ftp/
│           ├── adminer/
│           ├── portfolio/
│           └── portainer/
└── secrets/
    ├── maria_user_password.txt
    ├── maria_root_password.txt
    ├── wp_user_password.txt
    ├── wp_root_password.txt
    ├── redis_password.txt
    ├── ftp_user_password.txt
    └── pt_user_password.txt
```

---

## 🔒 Security Features

- **TLS Encryption**: All web traffic encrypted with SSL/TLS
- **Docker Secrets**: Sensitive data stored securely
- **Network Isolation**: Services isolated in custom Docker network
- **Non-root Users**: Containers run with minimal privileges
- **Health Checks**: Automatic service monitoring and restart
- **Volume Permissions**: Proper file system permissions

---

## License

This project is part of the 42 curriculum and follows its academic policies.
