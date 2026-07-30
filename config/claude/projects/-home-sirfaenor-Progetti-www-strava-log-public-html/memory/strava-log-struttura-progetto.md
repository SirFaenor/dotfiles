---
name: strava-log-struttura-progetto
description: "Struttura e stack del progetto strava-log (Laravel 13 + Filament 3, docker compose)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2a4254ef-3d6d-4e3c-a326-01d1592b14fb
  modified: 2026-07-27T13:09:29.705Z
---

App Laravel 13 / PHP 8.3 che sincronizza le attività Strava di un utente.
Root: `/home/sirfaenor/Progetti/www/strava-log/public_html` (branch principale: `develop`).

Stack: `basvandorst/stravaphp`, `filament/filament` ^3.3 (v3.3.54), `laravel/telescope`,
`laravel/breeze`. Frontend legacy con Laravel Mix (`webpack.mix.js`) + Tailwind.

Modelli (`app/Models/`): solo `User`, `Activity`, `Webhook`.
`Activity` mappa i campi Strava (`type`, `sport_type`, `distance` in metri,
`moving_time`/`elapsed_time` in secondi, `average_speed`/`max_speed` in m/s,
`start_date`/`start_date_local`/`end_date`/`end_date_local`, `raw_data` JSON) e ha gli
scope `valid`, `forWeek`, `from`, `to`. Usa SoftDeletes.
Nota: `Activity::user()` punta a `App\User` (namespace errato, la classe è `App\Models\User`);
`User::activities()` invece funziona.

Filament: pannello `admin` su `/admin`, `app/Providers/Filament/AdminPanelProvider.php`,
codice in `app/Filament/`. Locale app: `en`, ma UI dei widget scritta in italiano.

Docker compose (`docker-compose.yml`), container attivi:
`strava-log_web` (apache+php, porta 8098), `strava-log_db` (mysql 5.7, 3098),
`strava-log_pma` (phpmyadmin, 5098), `strava-log_node` (node 12, 8898).
Comandi PHP: vedi [[php-in-docker-container]].
