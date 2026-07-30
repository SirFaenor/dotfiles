---
name: devcontainer_setup
description: "setup VS Code dev container del progetto (riusa docker-compose, xdebug via env var)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 43c4f56a-9e6d-4a21-b8e0-cfaabf2c0bcd
---

Il progetto si apre come VS Code Dev Container: `.devcontainer/devcontainer.json` riusa il `docker-compose.yaml` esistente (servizio `web`, workspaceFolder `/var/www`, remoteUser `www`). Per far partire tutti i servizi (non hanno dipendenze intrinseche) ci sono due leve: `runServices` in devcontainer.json (onorato da VS Code) e `depends_on` aggiunto al servizio `web` nel compose (più portabile, vale anche per `docker compose up web`).

- **Estensioni di progetto** → in `devcontainer.json` `customizations.vscode.extensions` (committate). **Estensioni personali** (Git Graph, Claude Code, Peacock) → nelle User Settings host via `dev.containers.defaultExtensions`, NON nel file condiviso.
- **php-cs-fixer on-save**: `junstyle.php-cs-fixer` come formatter PHP, settings in `devcontainer.json` (`executablePath` = `${workspaceFolder}/vendor/bin/php-cs-fixer`, config `.php-cs-fixer.dist.php`, `allowRisky: true` perché la config usa `setRiskyAllowed(true)`).
- **php-fpm va avviato a mano**: in dev container l'entrypoint di `web` è sovrascritto con `sleep infinity` (il container resta vivo, ma php-fpm NON parte come nel `docker compose up` normale). Senza php-fpm, nginx → `web:9000` risponde 502 (sia diretto su `:8077` sia via Traefik su `atmosphera.localhost`). Avvio: alias `fpm` (`php-fpm -D`) o `postStartCommand` nel devcontainer.json. Gira come `www` (uid 1000): worker come `www` anziché `www-data`, ok permessi. URL: Traefik `http://atmosphera.localhost` (porta 80), nginx diretto `http://localhost:8077` (`COMPOSE_WEB_PORT=8077:80`), o `http://atmosphera.localhost:8077` (`.localhost` si auto-risolve su loopback, niente /etc/hosts). Tutti passano per php-fpm.
- **Zed**: onora `postCreateCommand` e il compose, ma avvia SOLO il servizio `web` (di fatto `--no-deps`) → né `runServices` né `depends_on` fanno partire gli altri servizi; vanno avviati a mano (`docker compose up -d`). Ignora `customizations.vscode.*` (estensioni/settings VS Code-specifici). `postStartCommand` non verificato su Zed.
- **Xdebug**: listener gira DENTRO il container (estensione workspace). `xdebug.client_host` NON è in `local.ini` (i php.ini non espandono env var) ma passato via `XDEBUG_CONFIG=client_host=${XDEBUG_CLIENT_HOST:-localhost}` nel servizio `web`. Default `localhost` (dev container); per VS Code sull'host (docker-compose classico) impostare `XDEBUG_CLIENT_HOST=host.docker.internal` in `.env`. Debug config in `.vscode/launch.json` ("Listen for Xdebug", porta 9003) — gitignorato quindi personale, ma sopravvive ai rebuild perché sulla workspace montata.

Vedi anche [[php_docker_container]].
