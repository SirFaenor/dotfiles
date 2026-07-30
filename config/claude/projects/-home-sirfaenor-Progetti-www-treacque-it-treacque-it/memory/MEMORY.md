# treacque.it - Project Memory

## Environment
- Usa Docker; PHP gira nel container `web`
- Per eseguire comandi artisan: `docker compose exec web php artisan ...`

## Server di produzione
- [project_server.md](project_server.md) — SSH, web root, PHP path, MySQL host, limitazioni shell

## Route frontend
- [reference_routes.md](reference_routes.md) — Le route sono in `resources/lang/vendor/lintilla/links.json`, non in `routes/web.php`

## PHPStan
- Eseguire sempre senza `--level`: `docker compose exec web ./vendor/bin/phpstan analyse <file>`
- Il livello è configurato in `phpstan.dist.neon` (attualmente livello 7)
