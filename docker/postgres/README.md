# PostgreSQL Database Engine

Main database for my homelab and custom projects (like Project Ame).

## Key Learnings & Architecture

* **The `POSTGRES_DB` Variable:** If omitted in the `.env` file, Postgres automatically creates a database named after your `POSTGRES_USER`. I missed this initially and ended up with a database named `diego` instead of a proper project name. Defining `POSTGRES_DB=media_pipeline_db` fixes this from the start.
* **DBeaver Connection Errors:** Postgres strictly isolates connections per database. When the default database was removed, DBeaver threw a `FATAL: database does not exist` error because it was still trying to connect to the old one. You have to manually update the target DB in the connection settings.
* **Volume Mount Breaking Change (v18+):** In `postgres:18`, you can no longer mount directly to `/var/lib/postgresql/data`. You have to mount one level up (`/var/lib/postgresql`) so the engine can manage version-specific folders internally. If you don't, the container crashes in a restart loop.
* **Direct Access:** Unlike my web apps hidden behind Nginx Proxy Manager, I mapped port `5432` directly to the host. This allows me to connect straight from my PC using DBeaver on the local network without routing through proxies.

## Deployment

1. **Secrets:** Configured `.env` with user, password, and target DB name.
2. **Storage:** Created a local `./data` folder mapped to `/var/lib/postgresql`.
3. **Container:** Deployed via Docker Compose, attached to the `web_proxy` network.
4. **Access:** Connected DBeaver from my Windows PC to the server's local IP.
