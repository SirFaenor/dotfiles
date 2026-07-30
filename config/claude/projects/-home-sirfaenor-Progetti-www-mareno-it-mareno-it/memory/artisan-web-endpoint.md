---
name: artisan-web-endpoint
description: "Endpoint GET /artisan/{command} per eseguire comandi artisan via web, protetto da middleware ArtisanWeb + throttle + whitelist"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21c662b6-460e-4be6-8bd2-5f1464dfbb9a
---

Endpoint `GET /artisan/{command}` definito in `routes/web.php` permette di eseguire comandi Artisan via HTTP. Parametri/opzioni del comando passati come query string (es. `?family=all`, `?--force=1`) e inoltrati a `Artisan::call()`. Risposta JSON con `command`, `parameters`, `exit_code`, `output`.

**Why:** utile per triggerare manualmente sync/cache-clear/queue-restart in produzione senza shell SSH.

**How to apply:** quando si aggiungono nuovi comandi al progetto e devono essere richiamabili da web:
1. Aggiungere il nome del comando a `config/artisan-web.php` → `allowed_commands` (whitelist obbligatoria, default è "nessuno").
2. Eseguire `php artisan config:clear` nel container web.
3. Se il comando viene da un package locale (es. `packages/onpage`), registrarlo anche in `App\Console\Kernel::$commands` per evitare il problema descritto in [[marvin-artisan-starting-trap]].

Protezione: master switch `ARTISAN_WEB_ENABLED` in `.env` (default false), whitelist comandi + utenti, bypass auth solo in `local`, rate limit `throttle:10,1`, audit log `Log::warning('artisan-web command', ...)`.
