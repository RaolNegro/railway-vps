# Railway VPS

Docker VPS di Railway dengan SSH + Tailscale.

## Deploy

```
https://github.com/RaolNegro/railway-vps
```

1. Buka https://railway.app → **New Project** → **Deploy from GitHub URL**
2. Paste URL di atas
3. Railway auto-deploy
4. Setelah deploy, masukin **TAILSCALE_AUTH_KEY** di tab Variables
5. Redeploy

SSH: `ssh root@<tailscale-ip>` password: `2010`
