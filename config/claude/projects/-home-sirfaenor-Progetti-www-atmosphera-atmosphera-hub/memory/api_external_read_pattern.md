---
name: api-external-read-pattern
description: "Pattern per esporre una nuova entità di dominio in sola lettura sull'API esterna (roadmap #24, consumer atmosphera-admin) — dove mettere i file, cosa NON serve creare, incluse traduzioni sempre complete e soft-delete"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1fc9ae75-8950-4c07-9576-ee2e2ebb8d09
  modified: 2026-07-24T14:03:31.765Z
---

Roadmap item **#24** (`.docs/roadmap.md` riga ~1250): API esterna di sola lettura per il CMS/client `atmosphera-admin`, che fa da mirror locale pull-only. Vincoli fissati dal consumer: attributi PIM già risolti nel payload (label tradotte, unità, enum mappati — il CMS non conosce il PIM), niente webhook, auth machine-to-machine a token statici con identità (`consumer:token`).

## Come esporre una nuova entità (pattern designers/categories/products)

Per un modello di **dominio** (non il media/asset, che è nel core e ha controller dedicato), il flusso è:

1. **Nessun nuovo controller/route da scrivere.** `packages/digital-hub/src/Api/Http/Controllers/ApiResourceController.php` (core) gestisce `index`/`show` in modo generico via `ApiResourceRegistry`, risolvendo model/JsonResource/eager-loads dallo slug. Route generiche già presenti in `packages/digital-hub/routes/api.php`: `GET {resource}` (paginato, filtro `updated_since` per sync incrementale) e `GET {resource}/{identifier}` (per id numerico o `global_id`).
2. **Creare solo la JsonResource** in `App\Http\Resources\Api\{Nome}Resource` (app root, non nel package), sul modello di `app/Http/Resources/Api/DesignerResource.php`: espone `global_id` (non l'id locale — chiave di join cross-sistema), `slug`, `updated_at` in ISO8601, `deleted_at` (vedi sotto).
   - **`name` e ogni altro campo translatable escono SEMPRE come mappa `locale => valore` con tutte le lingue di `config('digital-hub.locales')`** (`$this->getTranslations('name')`), mai risolti in una lingua sola dietro `?locale=` — quel parametro non esiste più nel contratto delle entità di dominio (decisione del 24 luglio 2026, rivede la scelta del tracer bullet iniziale). Vedi [[api_technical_attributes_resolution]] per lo stesso principio applicato agli attributi PIM (label ed enum inclusi).
3. **Se il modello deve poter sparire dal mirror del CMS, va reso soft-delete** (`Illuminate\Database\Eloquent\SoftDeletes`, colonna `deleted_at` via migration — attenzione a scrivere `Schema::table('nome_tabella', ...)` con **nomi letterali**, non in un loop su un array di stringhe: il parser statico delle migration di Larastan altrimenti non risolve `deleted_at` come proprietà magica del model, e `$model->deleted_at` diventa "undefined property" a sorpresa in phpstan). `ApiResourceController::query()` include già le righe soft-deleted per qualunque modello con `method_exists($model, 'trashed')`, nessuna modifica al controller serve. Basta aggiungere `'deleted_at' => $this->deleted_at?->toIso8601String()` alla Resource.
   - **Perché soft-delete e non un registro di cancellazioni separato**: proposto inizialmente un log dedicato (tabella `{resource, global_id, deleted_at}`, meno invasivo, non tocca il comportamento di cancellazione nell'admin). L'utente ha scelto il soft-delete vero esplicitamente: *"non vogliamo sapere come gestirà le sue relazioni il CMS"* — l'hub deve solo continuare a far vedere il record (col segnale di cancellazione) finché il CMS non decide di ignorarlo, non deve modellare un canale di notifica separato. Attrito accettato consapevolmente: `slug` resta `unique` a DB, un soft-deleted lo occupa ancora (oggi innocuo, lo slug lo scrivono solo i comandi di import).
4. **Registrare l'entità** in `config/digital-hub.php` sotto `'resources' => [...]`, es.:
   ```php
   'designers' => ['model' => Designer::class, 'resource' => DesignerResource::class],
   ```
5. **Test** in `tests/Feature/Api/{Nome}ApiTest.php`, pattern da `DesignerApiTest.php`: `RefreshDatabase`, token via `config(['digital-hub.api.tokens' => ...])`, assert 401 senza token, `assertJsonPath('data.0.global_id', ...)`, `meta.total`, `name` come mappa completa (non `?locale=`), lookup per `global_id`, e se soft-delete: un record cancellato resta raggiungibile (200, non 404) con `deleted_at` valorizzato e compare nel sync su `updated_since`.
6. **Se il modello ha una tabella Filament (`->digitalHubTable()`) ed è stato reso soft-delete, l'UI di restore arriva gratis**: `DigitalHubTableMacro` (core) aggiunge `TrashedFilter`/`RestoreAction`/`ForceDeleteAction` automaticamente per qualunque modello con `method_exists($model, 'restore')`, nessuna modifica alla singola tabella Filament.

Auth: middleware `AuthenticateApiToken` (core, `Api/Http/Middleware/`), prefisso versionato `api/v1`, header `Authorization: Bearer`. `ResolveApiLocale` esiste ancora ma non influenza più il payload delle entità di dominio — resta solo per i tag di `AssetResource`.

**Eccezione**: i modelli del *core* (es. Media/Asset) NON passano dal registry — hanno controller e Resource dedicati dentro il package (`AssetController`, `AssetResource` in `src/Api/Http/`), perché il payload non cambia da cliente a cliente.

Vedi anche [[api_technical_attributes_resolution]] per come includere attributi tecnici PIM risolti nel payload (Category1/Category2 e altre entità con `HasTechnicalAttributes`).
