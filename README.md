# HomeLab Infrastructure & Journey

Welcome to my Infrastructure as Code (IaC) and system administration repository. This project documents the provisioning, notes on best practices, configuration, and management of a bare-metal home server. 

The primary objective is to bridge the gap between theoretical systems administration and real-world Cloud/DevOps workflows, focusing on headless Linux environments, Docker containerization, and network security.

## Hardware Specifications

The environment runs on a dedicated micro-node to simulate a lightweight production server:

* **Machine:** Lenovo ThinkCentre M700 Tiny
* **CPU:** Intel Core i3-6100T
* **RAM:** 8GB DDR4
* **Storage:** 128GB SSD (SATA)

## Tech Stack & OS

* **Operating System:** Ubuntu Server 24.04 LTS (Headless)
* **Containerization:** Docker Engine (Native apt repository)
* **Networking:** Advanced Docker Networking (Macvlan driver for dedicated physical IPs)
* **Access Management:** SSH with strict key/permission policies

## Repository Structure

```text
.
├── README.md                 # Main overview and architecture
├── .gitignore                # Security wall (ignoring secrets, .env, etc.)
├── host-setup/               # Host OS configurations (Ubuntu Server)
│   ├── network/
│   │   └── netplan.yaml      # Static IP configuration
│   └── scripts/
│       └── welcome.sh        # Custom MOTD / status script
└── docker/                   # Containerized services & compose files
    ├── pihole/
    │   ├── README.md         # Service docs (IPs, Macvlan notes)
    │   └── docker-compose.yml
    ├── nginx-proxy-manager/
    │   ├── README.md         # Proxy routing rules and ACLs
    │   └── docker-compose.yml
    └── homepage/
        ├── README.md         # Dashboard specific notes
        ├── docker-compose.yml
        └── config/           # YAML configs (services, widgets)
```

## Core Architecture & Services

The infrastructure is built around a modular containerized approach. Current services deployed:

| Service | Category | Network Mode | Status |
| :--- | :--- | :--- | :--- |
| **Nginx Proxy Manager** | Reverse Proxy / SSL | Macvlan (Dedicated IP) | 🟢 Active |
| **Pi-hole** | DNS Sinkhole & DHCP | Macvlan (Dedicated IP) | 🟢 Active |
| **Homepage** | Infrastructure Dashboard | Macvlan (Port mapped) | 🟢 Active |

*(Note: Detailed configuration files, environment setups, and deployment notes for each service are located in their respective folders within this repository).*

## Security Practices Implemented

* **Principle of Least Privilege:** Containers run under dedicated non-root users (`PUID`/`PGID`).
* **Secret Management:** Sensitive data (passwords, specific IPs) is managed via `.env` files and excluded from version control via `.gitignore`.
* **Network Segregation:** Services are mapped through a dedicated `macvlan` network to prevent direct host exposure and avoid port mapping conflicts.
