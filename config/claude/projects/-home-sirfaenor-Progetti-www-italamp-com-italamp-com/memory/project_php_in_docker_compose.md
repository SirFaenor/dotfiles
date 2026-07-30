---
name: project-php-in-docker-compose
description: "PHP/artisan/composer vanno eseguiti dentro il container docker compose \"web\", non sull'host"
metadata: 
  node_type: memory
  type: project
  originSessionId: f78b5592-53bb-42a0-8db3-d53335b9168b
---

In questo progetto (italamp.com) PHP gira dentro un container docker compose: il servizio si chiama `web` (container `italamp_web`).

**Why:** l'host non ha il PHP del progetto attivo (tentare `php artisan` sull'host fallisce o richiede container FPM esterni non pertinenti).

**How to apply:** usare `docker compose exec -T web php artisan ...` (idem per `php -l`, tinker, composer). Il sito locale risponde su `http://localhost:8009` con header `Host: italamp.localhost`.
