# Nginx Proxy Manager (NPM)

Nginx Proxy Manager acts as a **Reverse Proxy**. It stands at the edge of the local network, intercepts all incoming web traffic on the standard HTTP/HTTPS ports (or whichever ports we specify), and routes it to the correct container.

## Key Learnings & Architecture

Deploying this service helped me understand how traffic routing, lightweight databases, and state management work in production:

* **Reverse Proxy Mechanics & SSL:** NPM listens on standard web ports (`80` for HTTP and `443` for HTTPS). It allows me to map user-friendly domain names to my local services while handling SSL certificates automatically via Let's Encrypt, ensuring all traffic inside my lab is encrypted.
* **The SQLite Architecture:** By default, this runs a very lightweight database, which is fine for my homelab. In bigger environments this is usually replaced by a heavier database engine like MariaDB, which allows scalabily, for example allowing various workers to edit its tables.
* **The Permission Exception:** Because of how the SQLite mode is programmed, this container **ignores `PUID` and `PGID` variables**. The internal scripts handle file ownership automatically, which is a great example of how different container architectures manage host volumes.
* **Troubleshooting Orphan Containers:** I learned that changing a service name in the `docker-compose.yaml` while the old container is still running causes a name conflict. Docker flags the old instance as "orphaned" because its original service link is gone. To fix this, you must run `docker compose down --remove-orphans` to wipe the old state before deploying the new configuration.

## Deployment

Setting up NPM requires configuring the full network chain, from local DNS resolution to Docker's internal routing:

1. **Spin up the Container:** Standard deploy using Docker Compose alongside the `.env` template to manage external listening ports.
2. **Local DNS Mapping (on my DNS server):** Nginx cannot route traffic if the packets never reach the server. Because the server lives in a private LAN, I configured **Pi-hole as an Authoritative DNS server** for my local setup. 
   * For local domains (`.home`), Pi-hole maps the hostname directly to the Lenovo's local IP and npm port.
   * For the public domain I have it's also interesting to do it. When I'm home, Pi-hole intercepts the request and routes it directly via LAN instead of forcing the traffic out to the internet and back through the Cloudflare tunnel, skipping it (this is called *NAT Loopback*).
3. **Internal Docker Routing:** Once a request hits NPM on port 80/443, I configure a **Proxy Host** in the admin UI (port 81). Thanks to the shared `web_proxy` bridge network, I don't need to expose any ports on the other containers; I just tell NPM to forward the traffic to the container's service name and its internal port (e.g., `http://homepage:3000`).
