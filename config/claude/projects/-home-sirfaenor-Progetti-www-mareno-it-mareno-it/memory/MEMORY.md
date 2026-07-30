# mareno.it - Project Memory

## Overview
Sito web aziendale italiano (mareno.it) basato su **Laravel 8** con CMS custom **Marvin (AtrioCMS)**.
Ambiente di sviluppo: **Docker Compose**.

## Docker - IMPORTANTE
- Operazioni `php`, `composer`, `artisan` vanno eseguite **dentro il container web**:
  ```bash
  docker compose exec web php artisan ...
  docker compose exec web composer ...
  ```
- Servizi Docker:
  - `web`: PHP Apache (porta 8094:80)
  - `db`: MySQL 5.7 (porta 3094:3306)
  - `phpmyadmin`: porta 5094:80
  - `node`: Node 12, BrowserSync (porta 8848)
- `APP_URL=http://localhost:8094`

## Stack Tecnico
- PHP ^8.0, Laravel 8.40+
- Livewire 2.6 (componenti reattivi)
- Marvin CMS (`atrioteam/marvin`) - CMS custom
- OnPage PHP (SEO)
- Frontend: UIKit 3, GSAP, Barba.js, Locomotive Scroll
- Build: Laravel Mix (Webpack)
- DB: MySQL 5.7, host Docker `mareno-db-1`

## Struttura Chiave
- `app/Http/Controllers/` - 8 controller: Category, Contact, Job, Pages, Portfolio, Product, Sitemap, Auth
- `app/Models/` - 40+ modelli, pattern `Model` + `ModelLang` per multilingua
- `app/Marvin/` - Funzioni CMS custom
- `resources/views/` - Blade templates per feature
- `resources/sass/` - SASS separati per pagina (boot, main, prodotti, homepage, referenze...)
- `routes/web.php` - Route frontend
- `packages/` - Package locali (onpage)

## Convenzioni
- **Multilingua**: modelli `*Lang` (es. `Product` + `ProductLang`), tabelle `*_lang`
- **Categorie**: struttura nested set (`kalnoy/nestedset`)
- **Revisioni**: audit trail via `venturecraft/revisionable`
- Asset: `npm run dev` / `npm run watch` nel container node

## File Importanti
- `docker-compose.yaml` - Configurazione Docker
- `.env` - Configurazione locale (non committare)
- `composer.json` - Dipendenze PHP
- `package.json` - Dipendenze JS / build

## Stack attuale (post-upgrade Laravel 12)
- PHP 8.4.4, Laravel 12.53.0, Livewire 3.7.11, Marvin 3.1.8
- Upgrade completato. Vedi `UPGRADE_NOTES.md` per pacchetti rimossi e note.

## Issue post-upgrade Marvin 3
- `php artisan route:list` fallisce: errore `TypeError` in `Marvin\App\Functions\Base\Controller::__construct()`
  (API costruttore cambiata tra Marvin 2 e 3: il primo argomento è ora `Request` non `array`)
  → I controller delle funzioni CMS dell'app devono essere aggiornati per la nuova API Marvin 3.
- `resources/lang/vendor/marvin/links.json`: entry `privacy-iubenda` aveva `filename: "-"` (convenzione Marvin 2)
  corretta in `filename: ""` per compatibilità Marvin 3.

## Gotchas / Note operative
- [Endpoint artisan-web](artisan-web-endpoint.md) — rotta `/artisan/{command}` con whitelist e middleware ArtisanWeb.
- [Trap Artisan::starting con Marvin](marvin-artisan-starting-trap.md) — Marvin istanzia Console\Application nel boot, rompe la registrazione comandi via $this->commands() per i provider che bootano dopo.

## Deployment
- [Deployment](deployment.md) — GitHub Actions verso Hostinger/nginx: prod su `master` (rsync + ssh `.scripts/deploy.sh`), staging su `staging` (FTP + estrazione vendor.zip).

## Dettagli Estesi
→ Vedi [project-structure.md](project-structure.md)
