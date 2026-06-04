# Cloudflare Tunnel (cloudflared)

This container establishes a secure, outbound connection (Zero Trust Tunnel) to Cloudflare's edge network. It allows me to expose local Homelab services to the public internet securely, without opening any incoming ports on the physical router or exposing my public residential IP.

## Key Learnings & Architecture

* **Outbound Architecture (No Ports):** Unlike reverse proxies that listen for incoming connections, `cloudflared` operates exclusively via outbound traffic. It "dials out" to Cloudflare to establish the tunnel. Consequently, no `ports:` declaration is required in the `docker-compose.yaml`, keeping the host server's firewall completely sealed.
* **Zero Trust Routing & Internal DNS:** Traffic enters Cloudflare's global network, travels down the tunnel, and lands in this container. Cloudflare is instructed to forward requests to `http://npm:80`. Because both `cloudflared` and NPM share the `web_proxy` Docker bridge network, the tunnel uses Docker's internal DNS to pass the packets directly to NPM by its container name, without ever hitting the host's physical network stack.
* **Secrets Management (.env):** Implemented an `.env` file to securely store the `TUNNEL_TOKEN`. This variable is read by Docker Compose and passed to the container at runtime. This practice ensures sensitive credentials remain out of the primary configuration file and makes it easier to edit the container if needed.
* **Domain Registration & Privacy:** Learned that purchasing a `.xyz` domain requires accurate personal data per ICANN regulations, but WHOIS Privacy protection combined with EU GDPR regulations masks this billing information from public lookup databases. Also did some research and turns out different domain extensions have reputation??? I like xyz because it sounded funny but it apparently is a popular tool for spammers, scammers, and malicious actors. Some corporate firewalls and email providers frequently flag or block .xyz sites to protect users.

## Deployment

1. **Domain & Tunnel Initialization:** Purchased the domain via Cloudflare Registrar and generated a Zero Trust Tunnel in the dashboard, securing the provided authentication token.
2. **Container Deployment:** Deployed the `cloudflare/cloudflared:latest` image using Docker Compose. Injected the secure token via the `.env` file and attached the container to the external `web_proxy` network.
3. **Cloudflare Routing:** Configured the Public Hostname inside the Zero Trust dashboard to route external traffic targeting the domain directly to the service.
4. **NPM Proxy Host:** Configured Nginx Proxy Manager to catch the traffic coming from the tunnel and forward it to the final destination container (e.g., `homepage:3000`), effectively bridging the public edge network to the local service.
