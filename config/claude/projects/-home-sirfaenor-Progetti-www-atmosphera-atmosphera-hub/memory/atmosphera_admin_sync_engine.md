---
name: atmosphera-admin-sync-engine
description: "Il CMS/client atmosphera-admin (cartella sorella di atmosphera-hub) HA GIÀ un motore di sync funzionante — dove sta il codice, come tocca il contratto API dell'hub"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1fc9ae75-8950-4c07-9576-ee2e2ebb8d09
  modified: 2026-07-24T14:46:58.741Z
---

`atmosphera-admin` (sibling dir di `atmosphera-hub`, stesso livello: `Progetti/www/atmosphera-hub/atmosphera-admin`) è il CMS/client che consuma l'API esterna dell'hub (roadmap hub #24). Il suo design doc (`.docs/riepilogo-design.md`) è rimasto per settimane allo stadio "nessun codice scritto", **ma il 24 luglio 2026 il motore di sync è stato scritto davvero** — non fidarsi del preambolo del doc ("Nessun codice ancora scritto") senza controllare `app/Sync/` e `packages/hub-sync/` prima.

**Dove sta il codice:**
- `packages/hub-sync/` — package locale (subtree, come `digital-hub` nell'hub) con la meccanica generica: `HubClient` (chiamate HTTP verso l'hub, config `hub-sync.base_url`/`token`/`per_page`), `AbstractSyncer` (paginazione, watermark incrementale su `SyncRun` dell'ultimo run `success`, cattura errori per item senza bloccare il run), `SyncRegistry` (risorse dichiarate in `config('hub-sync.resources')`), `Models\SyncRun` (entità di dominio dello storico sync, non solo log), `Jobs\RunSyncJob`.
- `app/Sync/{Product,Category1,Category2}Syncer.php` — una sottoclasse di `AbstractSyncer` per risorsa, implementano solo `resource()` (slug lato hub), `modelClass()` (model Eloquent locale, aggiunto 24 luglio per il path di cancellazione) e `upsert(array $item): bool`.
- `app/Models/{Product,Category1,Category2}.php` — mirror locali, colonne `global_id`/`name` (json, già mappa multi-lingua — combacia col contratto hub post-revisione)/`slug`/`hub_updated_at`, ora anche soft-delete (`deleted_at`).
- `app/Filament/Pages/Sync/SyncResourceDetail.php` + `Widgets/Sync/SyncOverviewWidget.php` — la UI "Import dati" del design doc: storico, trigger manuale, conteggi (`created_count`/`updated_count`/`deleted_count`/`failed_count`).

**Allineamento col contratto hub**: il payload che questi Syncer consumano è esattamente quello di `atmosphera-hub` API v1 (vedi [[api_external_read_pattern]] lato hub). Ogni volta che il contratto hub cambia forma (nuovo campo, nuova entità, cambio di shape come la revisione "tutto translatable sempre mappa" del 24 luglio), **questo repo va aggiornato nello stesso intervento**: `upsert()` dei tre Syncer per i campi, eventualmente `modelClass()`/migration per nuove colonne. Esempio già fatto: quando l'hub è diventato soft-delete su Designer/Category1/Category2/Product, `AbstractSyncer::sync()` è stato esteso per riconoscere `deleted_at` nell'item e soft-cancellare il mirror locale invece di fare upsert di un record ormai cancellato a monte (`SyncRun::deleted_count`).

**Gotcha phpstan condiviso con l'hub**: stesso vincolo di Larastan sul parsing statico delle migration — `Schema::table('nome_letterale', ...)` sempre per esteso, mai in loop su un array di tabelle, altrimenti le colonne aggiunte restano "undefined property" quando un model le usa via accesso magico. Il `phpstan.neon` di questo repo dichiara esplicitamente `databaseMigrationsPath` per includere anche `packages/hub-sync/database/migrations`, che sta fuori da `database/migrations`.

**Nota**: al 24 luglio 2026 `vendor/bin/phpstan analyse` in questo repo fallisce con un errore *pre-esistente e non correlato* (`Class AtrioTeam\FilamentHelper\Jobs\OptimizeImage was not found`, in `AdminPanelProvider.php`) — verificato con `git stash` che fallisce identico anche senza modifiche. Non è qualcosa da fixare distrattamente in un intervento su altro; se serve verificare phpstan qui, va prima risolto quel problema di autoload/discovery a parte.

Container docker: `atmosphera-admin_php` (analogo a `atmosphera-hub_php`).
