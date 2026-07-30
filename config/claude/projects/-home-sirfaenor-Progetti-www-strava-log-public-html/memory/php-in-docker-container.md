---
name: php-in-docker-container
description: "In strava-log, PHP/artisan/composer vanno eseguiti dentro il container web via docker compose exec"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2a4254ef-3d6d-4e3c-a326-01d1592b14fb
  modified: 2026-07-27T13:09:20.719Z
---

Eseguire sempre PHP, `artisan`, `composer` e `tinker` dentro il container:
`docker compose exec -T web php artisan ...` (dalla root del progetto).

Il `php` di sistema non è quello del progetto: `php` in PATH è un wrapper lerd che
fallisce ("PHP 8.5 FPM container is not running"), e `php8.3` è un binario host senza
le estensioni/config del progetto.

**Why:** l'utente ha interrotto un comando `php8.3 artisan` chiedendo esplicitamente
di usare il PHP del container.

**How to apply:** prefissare ogni comando PHP con `docker compose exec -T web`.
Vedi [[strava-log-struttura-progetto]].
