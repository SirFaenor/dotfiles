---
name: deployment
description: "Come funziona il deployment di mareno.it allo stato attuale - GitHub Actions verso Hostinger (prod, rsync+ssh) e staging (FTP)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1354e1e9-5ea4-4332-ac3d-e5cedacb770c
---

Deployment di mareno.it allo stato attuale (giugno 2026). Hosting su **Hostinger**, server **nginx** (vedi fix [[livewire-marvin-nginx]] nella memoria globale). Due workflow GitHub Actions, triggerati su push.

## Produzione — `.github/workflows/deployment.yml` (push su `master`)
1. checkout, Node 20 (`npm ci`), PHP 8.3
2. `composer install --no-dev --optimize-autoloader` (auth via secret `GH_AUTH_TOKEN` per repo privati atrioteam)
3. **Build asset in CI**: `npm run production` — gli asset compilati sono gitignored, quindi vanno buildati qui e rsyncati
4. **rsync** (`burnett01/rsync-deployments`) con `--delete`, escludendo `.env *.env .git .github node_modules storage public/storage public/file_upload bootstrap/cache logs`
5. **SSH** (`appleboy/ssh-action`): esegue `sh .scripts/deploy.sh` nella remote path
6. Ping finale: prova HTTPS, fallback HTTP se il cert TLS non è ancora pronto

Secrets usati: `HOSTINGER_SSH_PATH/HOST/PORT/USERNAME/PRIVATE_KEY`, `HOSTINGER_DOMAIN_IP`, `DOMAIN_NAME`.

## `.scripts/deploy.sh` (eseguito via SSH sul server)
- forza `php` -> `/usr/bin/php8.3` (la CLI default di Hostinger può puntare a versione errata)
- `set -e`
- `php artisan storage:link || true` (non rompe il deploy se il link esiste già)
- `php artisan migrate --force`
- `php artisan optimize:clear`
- `php artisan view:cache`

## Staging — `.github/workflows/deployment-staging.yml` (push su `staging`)
Meccanismo diverso (FTP, no SSH):
1. `composer install --no-dev`, `npm run production`
2. **zip della cartella `vendor`** e rimozione della dir prima del sync (l'FTP di tanti file singoli è lento)
3. sync via **FTP** (`SamKirkland/FTP-Deploy-Action`) su server-dir `/`
4. estrazione vendor.zip lato server via endpoint HTTP `startup_vendor.php?dak=DEPLOY_AUTH_KEY`
5. operazioni post-deploy via endpoint HTTP `project_deployment?dak=...`

Secrets: `STAGING_FTP_HOST/USER/PASSWORD`, `STAGING_DOMAIN_NAME`, `DEPLOY_AUTH_KEY`.

## Note
- Build asset: sempre `npm run production` in CI (non committati nel repo).
- Config: valori non sensibili in `config/`, sensibili via `.env` dedicato sul server (vedi README). Supporto a file `.{HOSTNAME}.env` per override per-host da CLI.
