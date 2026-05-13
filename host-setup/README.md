# Host Server Provisioning & Configuration

This document serves as the Disaster Recovery and Initial Provisioning manual. It details the exact steps required to prepare the bare-metal machine (Ubuntu Server) before deploying any Docker containers.

## 1. Hardware & BIOS Configuration
To allow a headless server to function correctly after a power loss or reboot:
* **Secure Boot:** Disabled (Required for non-Windows OS).
* **Boot Priority:** Set USB (Ventoy) as primary boot device for initial install.

## 2. OS Installation & User Management
* **OS:** Ubuntu Server 24.04 LTS (installed via Ventoy).
* **Disk:** "Entire Disk" option with LVM group enabled.
* **Administrative User:** `diego`
* **SSH Server:** OpenSSH installed during the wizard.

## 3. Network Configuration (Netplan)
To ensure the host has a static IP and doesn't get lost on the network, DHCP is disabled in favor of a static configuration.

* **Interface:** `eno1`
* **Static IP:** `192.168.xx.50/24`
* **Gateway:** `192.168.xx.1`

*Configuration file: `/etc/netplan/00-installer-config.yaml`*
```yaml
# Example Netplan configuration applied:
network:
  ethernets:
    eno1:
      dhcp4: false
      addresses:
        - 192.168.xx.50/24
      routes:
        - to: default
          via: 192.168.xx.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
  version: 2
  ```

## 4. The "Survival Kit" (Essential Packages)
Right after the first SSH login (`ssh diego@192.168.xx.50`), the system is updated and essential administration tools are installed:

```bash
sudo apt update
sudo apt install htop git curl neofetch -y

```

## 5. Docker Engine (Native Installation)

To ensure security and package integrity, the official Docker repository is used instead of the convenience script.

1. Added Docker's official GPG key.


2. Added the stable repository for `noble` (24.04).


3. Installed `docker-ce`, `docker-ce-cli`, and `containerd.io`.


4. Applied Principle of Least Privilege by adding the user to the docker group:



```bash
sudo usermod -aG docker $USER

```

## 6. Host Network Tweaks (Promiscuous Mode)

To allow the host to communicate with containers running on Macvlan networks (like Pi-hole), the network interface must accept traffic for MAC addresses other than its own:

```bash
sudo ip link set eno1 promisc on

```

*(Verified with `ip a` checking for the PROMISC flag)*.

## 7. Custom Aliases & Scripting
To automate monitoring upon login, a custom welcome script is executed via a `.bashrc` alias.

* **Script Location:** `~/scripts/welcome.sh`
* **Configuration:** Edited the hidden file `~/.bashrc`].
* **Alias Created:** `welcome` executing `sudo ~/scripts/welcome.sh`.

```bash
# Appended to the end of ~/.bashrc
alias welcome="sudo ~/scripts/welcome.sh"

```

## 8. Foundational Docker Networking (Macvlan)

Before any compose files can be deployed, the physical Macvlan network must be instantiated to allow containers to request dedicated IPs from the local router subnet.

* 
**Driver:** `macvlan` 


* 
**Parent Interface:** `eno1` 


* 
**Subnet:** `192.168.xx.0/24` 


* 
**Gateway:** `192.168.xx.1` 



```bash
# Network creation command:
docker network create -d macvlan \
  --subnet=192.168.xx.0/24 \
  --gateway=192.168.xx.1 \
  -o parent=eno1 pihole_net

```

(Note: Ensure the subnet and gateway match the live router environment.)
