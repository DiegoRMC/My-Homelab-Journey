# Homepage Dashboard

Not configured yet but I will get to it

## Key Learnings & Troubleshooting

Even though it's just a dashboard, deploying it taught me a couple of solid concepts:

* **The Docker Socket (`/var/run/docker.sock:ro`):** Mapping this volume is important so this container can read and only read (that's why we append :ro at the end) things like the state of other containers in the machine and show them if configured to do so in the dashboard.
* **Permission Management (`PUID`/`PGID`):** This is a must-have for pretty much every container when you're mapping volumes into the host, if the image is not truly polished by the author, it could make `root` the owner of those mapped files.
* **Security & `ALLOWED_HOSTS`:** It restricts access to the dashboard, ensuring it only responds to requests coming from my specific domain or local network setup, preventing unauthorized cross-origin requests.

## Deployment

I handled the deployment using a simple Docker Compose file coupled with a `.env` file to inject my specific user IDs and allowed host domains without hardcoding them into the configuration, nothing special.
