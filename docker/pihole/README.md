# Pi-hole (DNS & AdBlocker)

This container acts as the local DNS server and ad-blocker for my entire home network. It intercepts DNS queries at the network level and drops tracking or malicious domains before they can even resolve.

## Key Learnings & Architecture

Deploying Pi-hole with this specific architecture helped me understand high-level networking concepts regarding Docker interfaces, dual-network binding, and kernel capabilities:

* **The macvlan Network Integration:** Standard Docker containers share the host's IP and require port mapping. However, port 53 (DNS) is heavily guarded or already in use by Ubuntu Server. To bypass this, I deployed Pi-hole using a **macvlan network**, which assigns the container its own dedicated MAC address and a physical IP (`192.168.18.200`) directly from my home router.
* **Dual-Network Resolution (`FTLCONF_LOCAL_IPV4`):** This container is hooked up to two networks simultaneously: the physical LAN (`pihole_net`) for DNS traffic and the internal Docker bridge (`web_proxy`) for Nginx Proxy Manager management. To prevent Pi-hole's web server from binding to the internal Docker IP (`172.18.0.X`), I forced it to listen on the LAN interface using `FTLCONF_LOCAL_IPV4`.
* **Kernel Capabilities (`cap_add: NET_ADMIN`):** Docker containers are restricted by default for security reasons. By granting the `NET_ADMIN` capability, the container can interact directly with the host's network stack at a lower level. This is crucial for optimized macvlan routing and allows the container to act as a DHCP server for the local network if needed.

## Troubleshooting & Client-Side Gotchas

Getting Pi-hole to work seamlessly across the LAN required hotfixing several network isolation and bypass issues:

* **Host-to-Container Isolation (Promiscuous Mode):** The macvlan driver isolates the container from the host's network stack by default. To allow proper traffic flow for the container's virtual MAC address, I had to enable promiscuous mode on the host's physical network interface (`eno1`) using `sudo ip link set eno1 promisc on`.
* **IPv6 DNS Bypassing:** The ISP router was advertising its own IPv6 DNS via SLAAC, completely bypassing Pi-hole and allowing ads to load on client devices. Disabling IPv6 on the client's network adapter was necessary to force all traffic through the IPv4 Pi-hole address.
* **Browser DNS-over-HTTPS (DoH) Leaks:** Modern browsers (Chrome, Edge, Firefox) bypass local network DNS settings by default to query Google or Cloudflare directly via HTTPS. Disabling "Secure DNS" or "DNS over HTTPS" in the browser settings was mandatory to ensure local queries hit the Pi-hole.
* **Messed with my password:** Yeah, had to change it with `docker exec -it pihole pihole setpassword`.

## Deployment

Setting up Pi-hole requires configuring both the isolated physical network interface and its internal link to the reverse proxy:

1. **Spin up the Container:** Deployed via Docker Compose, including the `NET_ADMIN` capability and defining the environment variables for the time zone, web interface password, and the static LAN IP.
2. **External Macvlan Definition:** The configuration relies on a pre-existing, external macvlan network (`pihole_net`) that hooks the container directly into the host's physical network switch, allowing it to act as an independent node on the LAN.
3. **Internal Proxy Bridge Link:** By attaching the container to the external `web_proxy` bridge network at the same time, NPM can reach the Pi-hole admin dashboard internally via its service name (`http://pihole/admin`) without needing to route that management traffic through the public network interface.
