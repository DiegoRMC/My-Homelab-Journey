# HomeLab Infrastructure & Journey

Welcome to my Infrastructure as Code (IaC) and system administration repository. This project documents the provisioning, configuration, and management of a bare-metal home server. 

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
