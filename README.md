# HomeLab Infrastructure & Journey

This repository is my personal logbook where I document everything I'm learning while building and managing my own home server. Just some raw notes, configurations, and concepts I learn and find interesting as I advance.

## Hardware Specifications

I'm running everything on a tiny, budget-friendly node that acts as my local production server (will definetely upgrade it as we go):

* **Machine:** Lenovo ThinkCentre M700 Tiny
* **CPU:** Intel Core i3-6100T (2 Cores, 4 Threads @ 3.20GHz)
* **RAM:** 8GB DDR4 Micron @ 2133MHz (1x8GB - 1 slot free)
* **Storage:** 128GB LiteOn LCH-128V2 SSD
* **Network:** Intel I219-V Gigabit Ethernet (10/100/1000 Mbit/s)

## Repository Structure

```text
.
├── README.md                 # This document
├── .gitignore                # Not really gonna be used for this repository since it's mostly notes, but it's good to have just in case
├── host-setup/               # Host OS configurations like scripts
└── docker/                   # Containerized services, what I learned deploying them, compose files...
    ├── pihole/
    ├── nginx-proxy-manager/
    ├── homepage/
    ├── postgresql/
    └── cloudflared/
```

## Architecture & Services

The infrastructure is built around a modular containerized approach. Current services deployed:

| Service | Category | Network Mode | Status |
| :--- | :--- | :--- | :--- |
| **Nginx Proxy Manager** | Reverse Proxy / SSL | Bridge | 🟢 Active |
| **Pi-hole** | DNS Server | Macvlan | 🟢 Active |
| **Homepage** | Dashboard | Bridge | 🟢 Active |
| **Cloudflared** | Zero Trust/Secure Tunnel | Bridge | 🟢 Active |
| **PostgreSQL** | Database | Bridge | 🟢 Active |

*More notes on each specific service and things I learned deploying them in their respective folders*
