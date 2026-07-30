---
name: hostinger-agency-migration
description: Playbook per "migra il sito per hostinger agency" - fix Livewire/Marvin per nginx + setup deployment GitHub Actions verso Hostinger
metadata:
  type: reference
---

Playbook attivato dall'istruzione utente **"migra il sito per hostinger agency"** (cross-project, Laravel + Livewire 3 + eventualmente Marvin CMS). Hostinger Agency gira su **nginx**, quindi servono adattamenti rispetto ad Apache. Applicare i passi pertinenti al progetto corrente; chiedere conferma prima di toccare i workflow di deploy se ce ne sono già di diversi.

## 1. Livewire su nginx (sempre, se il progetto usa Livewire) — DIPENDE DALLA VERSIONE
Vedi [[livewire-marvin-nginx]] §1. Controllare prima la versione di Livewire in `composer.lock`.

**Livewire 3**: in `AppServiceProvider::boot()` forzare la route dello script senza punto:
```php
Livewire::setScriptRoute(function ($handle) {
    return Route::get('/livewire/livewirejs', $handle);
});
```

**Livewire 2** (`setScriptRoute` non esiste): pubblicare gli asset come file statici:
- aggiungere `@php artisan livewire:publish --assets` a `post-autoload-dump` in `composer.json`
- committare `public/vendor/livewire/livewire.js`, `.js.map`, `manifest.json`

## 2. Login Marvin su nginx (solo se il progetto include Marvin CMS)
Vedi [[livewire-marvin-nginx]] §2. Verificare prima che `atrioteam/marvin` sia in `composer.json`.
- `public/admin/index.php` → redirect statico a `/admin/login`
- route `marvin.login_alt` -> `LoginController@showLoginForm` in `routes/web.php`

## 3. Deployment GitHub Actions verso Hostinger
Setup di riferimento (pattern usato su mareno.it; per i dettagli concreti vedi la memoria di progetto `deployment.md` del progetto specifico):

**Produzione** — `.github/workflows/deployment.yml`, push su `master`:
- checkout, Node 20 (`npm ci`), PHP 8.3
- `composer install --no-dev --optimize-autoloader` (auth `GH_AUTH_TOKEN` per repo privati atrioteam)
- `npm run production` (asset gitignored → buildati in CI)
- **rsync** (`burnett01/rsync-deployments`) `-avz --delete` escludendo `.env *.env .git .github node_modules storage public/storage public/file_upload bootstrap/cache logs`
- **ssh** (`appleboy/ssh-action`) che lancia `sh .scripts/deploy.sh`
- ping finale HTTPS con fallback HTTP (cert TLS può non essere pronto)
- secrets: `HOSTINGER_SSH_PATH/HOST/PORT/USERNAME/PRIVATE_KEY`, `HOSTINGER_DOMAIN_IP`, `DOMAIN_NAME`, `GH_AUTH_TOKEN`

**`.scripts/deploy.sh`** (via ssh sul server):
```bash
php() { /usr/bin/php8.3 $@; }   # la CLI default Hostinger può puntare a versione errata
set -e
php artisan storage:link || true
php artisan migrate --force
php artisan optimize:clear
php artisan view:cache
```

**Staging** (opzionale) — `deployment-staging.yml`, push su `staging`: via FTP (`SamKirkland/FTP-Deploy-Action`), zip di `vendor` + estrazione lato server via endpoint `startup_vendor.php` e post-deploy `project_deployment` (auth `DEPLOY_AUTH_KEY`).

## 4. Comando `queue:test` per verificare le code (mareno.it, commit ed34a44)
Su Hostinger le code vanno verificate dopo la migrazione. Creare un comando diagnostico che fa un round-trip dispatch→worker. Tre file:

- `app/Console/Commands/QueueTest.php` — comando `queue:test {--wait=0}`: genera un token UUID, logga su canale `queue_test`, fa `QueueTestJob::dispatch()`. Con `--wait=N` fa polling (ogni 0,5s) sulla cache file `queue-test:{token}` finché il worker non deposita il marker, poi riporta latenza/host/queue; timeout → `FAILURE`. Senza `--wait` ritorna subito invitando ad avviare `queue:work`.
- `app/Jobs/QueueTestJob.php` — `ShouldQueue`; in `handle()` calcola la latenza dispatch→process, logga su `queue_test` e mette il marker in `Cache::store('file')` (TTL 300s) — store **file** perché condiviso tra processi (non `array`).
- `config/logging.php` — aggiungere il canale `queue_test` (driver `single`, path `storage/logs/queue_test.log`).

Uso: `php artisan queue:test --wait=30` con un `queue:work` attivo sulla connection di default.

## Note operative
- Adattare versioni PHP/Node a quelle del progetto.
- Se mancano i secrets su GitHub, segnalarli all'utente (vanno impostati nelle repo settings).
- Non sovrascrivere `.env`/config sensibili: gestiti sul server.
