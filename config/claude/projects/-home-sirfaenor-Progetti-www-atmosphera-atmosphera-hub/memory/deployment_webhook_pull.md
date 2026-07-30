---
name: deployment-webhook-pull
description: Architettura di deployment in produzione (build CI → release branch → SSH dal runner → git fetch/reset + deploy.sh) e fatti server non ovvi
metadata:
  node_type: memory
  type: project
  originSessionId: c9abc8f1-29aa-4707-a954-d8936c7fc426
---

Deployment **in produzione**. Modello attuale (2026-06-18, dopo aver abbandonato il trigger
curl/endpoint PHP per troppi timeout): **build in CI → branch `release` → SSH dal runner → il
server fa `git fetch/reset` + `deploy.sh`**. Niente SaaS, niente build in produzione. Due job in
`master.yml`: `build` (invariato) e `deploy` (`needs: build`).

**Doc di riferimento completo**: `.docs/deployment.md`. Vedi anche [[design_reference_doc]].

Flusso: push su `master` → CI (job build) fa `composer install` + `npm run build`, materializza
il path-package digital-hub in `vendor/`, e `git push -f origin release` (branch che contiene
sorgente + `vendor/` + `public/build`; gitignorati su master, force-add `-f` solo su release;
job con `permissions: contents:write`, push col GITHUB_TOKEN). Poi job `deploy` usa
`appleboy/ssh-action@v1.2.0` (`command_timeout: 30m`): apre SSH verso `SSH_HOST` come
`SSH_USERNAME` con `SSH_PRIVATE_KEY` ed esegue sul server, in `SSH_PATH`: `set -e; git fetch
--depth 1 origin release; git reset --hard FETCH_HEAD; bash .scripts/deploy.sh`
(down/optimize/migrate/queue:restart/up, [[asset_processing_queue]]). Il runner **non** spinge
file (niente rsync/artifact): i file viaggiano nel branch `release`, l'SSH fa da telecomando.
Exit code ≠0 (via `set -e`) → run GitHub rossa.

**OBSOLETI** (vecchio modello curl): `DeployController`, `config/deploy.php`, route
`/deploy/trigger`, nginx `location = /deploy/trigger`, `.scripts/deploy-bootstrap.sh.example`,
secret `DEPLOY_AUTH_KEY`/`DEPLOY_TRIGGER_URL`/`DOMAIN_IP`/`DOMAIN_NAME`. File ancora nel repo ma
fuori dal flusso (rimovibili).

Fatti server / GitHub non ovvi:
- Repo GitHub = org **`atrioteam/atmosphera-hub`** (il remote git locale è `sirfaenor/atmosphera-hub`).
- Utente di deploy/PHP-FPM: **`atmospheraitaly-digitalhub`**; APP_DIR =
  `/home/atmospheraitaly-digitalhub/htdocs/digitalhub.atmospheraitaly.com`.
- **Due chiavi SSH distinte, non confonderle**: (a) `SSH_PRIVATE_KEY` (secret GitHub) fa entrare il
  *runner* nel *server* — la sua pubblica sta in `~/.ssh/authorized_keys` dell'utente di deploy;
  (b) deploy key read-only fa entrare il *server* in *GitHub* per il `git fetch`.
- `deploy.sh` sta in APP_DIR e gira **dopo** il reset (fresco). La sessione SSH non è un file in
  APP_DIR (è in memoria del bash remoto), quindi il `git reset` che riscrive APP_DIR non la corrompe.
- Auth git del server = **deploy key SSH read-only** (alias `github-atmosphera` in `~/.ssh/config`,
  remote `git@github-atmosphera:atrioteam/atmosphera-hub.git`). NON si usano PAT/`github.env`.
- APP_DIR è un **working tree git** su `release`; `.env` e `storage/` sono gitignorati (untracked →
  il `reset --hard` non li tocca; mai `git clean`).
- Secret GitHub deploy: `SSH_HOST`, `SSH_USERNAME` (`atmospheraitaly-digitalhub`), `SSH_PRIVATE_KEY`,
  `SSH_PATH` (= APP_DIR). Più `GH_AUTH_TOKEN`/`WHIZZY_*` per composer in build.
- `deploy.sh` usa **PHP 8.5** (`/usr/bin/php8.5`) e riavvia **solo il gruppo code**
  (`supervisorctl restart <gruppo>:*`, default `atmosphera-digitalhub-worker`), mai reload globale.
  Worker in supervisor centralizzato (referenza `.conf/supervisord.conf.example`).
- CI: `atrioteam/digital-hub` è un **path repository** (`../digital-hub`) locale → in CI va clonato
  come repo fratello e **materializzato in `vendor/`** (no symlink penzolante prima del commit su release).
- IP server (ex `DOMAIN_IP`, candidato `SSH_HOST`): `145.223.80.116`.
- I commit li fa l'utente, non io.
