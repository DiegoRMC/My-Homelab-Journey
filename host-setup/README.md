# Host Server Setup & Core Configuration

This document covers the bare-metal foundation of the server. Just the essential configurations applied directly to the host OS before spinning up any Docker containers.

## Base System & QoL Tools

The machine runs on Ubuntu Server 24.04 LTS. Right after the initial headless SSH access, I installed a basic survival kit to monitor and manage the system: **sudo apt install htop git curl neofetch -y**.

To make logins a bit more useful, I wrote a custom bash script located at `~/scripts/welcome.sh` that outputs system stats and pending updates. I hooked this to the bash profile by appending **alias welcome="sudo ~/scripts/welcome.sh"** to the `~/.bashrc` file.

## Host Network (Netplan)

To ensure the server doesn't get lost on the network after a reboot, DHCP is disabled. I assigned a static configuration directly in `/etc/netplan/00-installer-config.yaml`:

* **Interface:** `eno1`
* **Static IP:** `192.168.xx.50/24`
* **Gateway:** `192.168.xx.1`
* **DNS:** `1.1.1.1` and `8.8.8.8` (Fallback DNS to allow package downloads before Pi-hole is up)

## Docker networks

Instead of relying on Docker's default bridge for everything, the infrastructure relies on two manually created external networks. This separates physical LAN routing from internal reverse-proxy traffic.

| Network Name | Driver | Purpose | Subnet / Scope |
| :--- | :--- | :--- | :--- |
| **pihole_net** | macvlan | Bypasses host port restrictions. Gives containers (like Pi-hole) a dedicated physical IP directly from the router. | 192.168.xx.0/24 |
| **web_proxy** | bridge | Isolated internal routing. Allows the Cloudflare Tunnel and Nginx to communicate with other services via hostname. | Local |

To instantiate the Macvlan network (this must be done before deploying the compose files that rely on it):
**docker network create -d macvlan --subnet=192.168.xx.0/24 --gateway=192.168.xx.1 -o parent=eno1 pihole_net**

The internal bridge for the proxy is created simply with:
**docker network create web_proxy**

## File sharing

To facilitate secure data ingestion from the primary workstation to the server, an SMB share was configured natively on the host OS using Samba.

* **Security & Authentication:** To prevent unauthorized access from other devices on the local network, a dedicated Samba password was generated for the host user via **sudo smbpasswd -a diego**.
* **Configuration:** The share was defined by appending the following block to **/etc/samba/smb.conf**, locking read/write access strictly to the authenticated user:

```ini
[MINIPC]
   path = /home/diego/pcdiego
   valid users = diego
   read only = no
   browseable = yes
