---
name: Docker environment
description: PHP runs inside a Docker container, commands must be run via docker-compose
type: project
---

PHP (e quindi `php artisan`) gira dentro al container `web` di docker-compose.

**Why:** L'host ha PHP 8.3 ma il progetto richiede >= 8.4.

**How to apply:** Qualsiasi comando `php artisan` va eseguito come:
```bash
docker compose exec web php artisan <comando>
```
