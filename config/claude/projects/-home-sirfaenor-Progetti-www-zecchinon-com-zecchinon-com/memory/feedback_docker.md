---
name: PHP gira nel container Docker
description: PHP e artisan devono essere eseguiti dentro il container Docker zecchinon_web
type: feedback
---

PHP e i comandi artisan vanno eseguiti dentro il container Docker `zecchinon_web`.

**Why:** PHP locale non è alla versione richiesta (>= 8.4.0), il progetto gira in Docker.

**How to apply:** Usare sempre `docker exec zecchinon_web php artisan ...` invece di `php artisan ...` direttamente.
