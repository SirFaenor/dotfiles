---
name: api-technical-attributes-resolution
description: "Come risolvere gli attributi tecnici PIM (HasTechnicalAttributes) dentro una JsonResource dell'API esterna — nessun helper pronto nel trait, pattern di riferimento in ProductResource; tutto il translatable esce come mappa per tutte le lingue"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1fc9ae75-8950-4c07-9576-ee2e2ebb8d09
  modified: 2026-07-24T10:51:19.910Z
---

Il trait `AtrioTeam\DigitalHub\Pim\Concerns\HasTechnicalAttributes` (core, `packages/digital-hub/src/Pim/Concerns/HasTechnicalAttributes.php`) **non** espone un metodo "risolvi tutto per API". Metodi atomici componibili sul model:
- `attr(string $key, ?string $locale = null): mixed` — valore risolto (translatable con fallback locale)
- `attrLabel(string $key, ?string $locale = null): string` — label i18n (`{modello}.attributes.{attr}.label`)
- `attrOption(string $key, string $option, ?string $locale = null): string` — label enum
- `attrGroupLabel(string $group, ?string $locale = null): string`
- `attributeSchema(): ?AttributeSchema`, `orphanAttributeKeys()`, `stripOrphanAttributes()`

Il parametro `$locale` esplicito su `attrLabel`/`attrOption`/`attrGroupLabel` (aggiunto 24 luglio 2026, `attr()` lo aveva già) serve a risolvere la stessa label in più lingue nella stessa request senza toccare `app()->setLocale()` — è ciò che rende possibile il punto sotto.

**Decisione (24 luglio 2026): tutto ciò che è translatable nel payload API esce come mappa `locale => valore` con TUTTE le lingue di `config('digital-hub.locales')`, mai risolto dietro un `?locale=`.** Prima iterazione (stesso giorno) aveva provato un flag opt-in (`?with_translations=1`) che aggiungeva un campo parallelo mantenendo `name` risolto per compatibilità — **scartata** su richiesta esplicita dell'utente ("non mi piace, riscriviamo tutto per restituire tutti i locale disponibili"): il default deve essere il mirror completo, non un flag da scoprire. `?locale=` non è più nel contratto delle entità di dominio; resta solo per i tag di `AssetResource` (core, non toccato da questa decisione).

**Pattern di riferimento: `App\Http\Resources\Api\ProductResource`** — prima e finora unica JsonResource che risolve attributi PIM. Itera `attributeSchema()->attributes()` (dà `TypeBuilder` diretto, non serve un secondo `getType()`), per ogni chiave:
- `label`: sempre una mappa `locale => testo`, un `attrLabel($key, $locale)` per lingua configurata.
- `value`: mappa `locale => testo` se `TypeBuilder::isTranslatable()` (un `attr($key, $locale)` per lingua) o se `TypeBuilder::kind() === Type::Enum` (un `attrOption($key, $valoreGrezzo, $locale)` per lingua — la label dell'opzione, non la chiave canonica); altrimenti un valore singolo via `attr($key)` (numeri/date/stringhe semplici non dipendono dalla lingua).
- `unit`: sempre singola (`TypeBuilder::getUnit()`), le unità di misura non sono translatable.
- Chiavi omesse quando il valore grezzo è blank su tutte le lingue (coerente con lo strip degli orfani lato scrittura) — il check va fatto sul valore **grezzo** (via `getAttribute($this->attributesColumn())`, JsonResource lo proxya sul model tramite `__call`/`__get`), non su un `attr()` già risolto per una sola lingua, altrimenti un attributo translatable con solo `en` valorizzato sparirebbe.

Payload finale per attributo: `{label: {it, en}, value: ... , unit: string|null}`. `name` (entità: Designer/Category1/Category2/Product) segue la stessa regola ma più semplice: `$this->getTranslations('name')` (metodo nativo di `Spatie\Translatable\HasTranslations`) restituisce già la mappa grezza, nessuna iterazione locale per locale necessaria.

Prodotto senza `ProductType`/schema → `attributes: []`. Test: `tests/Feature/Api/ProductApiTest.php` (include uno schema di test locale al file, `ProductApiTestTranslatableSchema`, per esercitare il ramo `translatable()`: nessuno schema di produzione ne ha uno oggi).

Quando si espone via API un'altra entità con attributi tecnici popolati, riusare questo pattern (stesso blocco di iterazione) invece di reinventarlo — [[api_external_read_pattern]] per lo scheletro della Resource, questo file per il blocco attributi.

Nota: `App\Pim\Schemas\Category1Attributes` e `Category2Attributes` restano **entrambi vuoti** (`attributes(): array { return []; }`) — `Category1Resource`/`Category2Resource` non hanno nulla da risolvere.
