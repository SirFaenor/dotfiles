---
name: design-reference-doc
description: I documenti di riferimento del workspace sono .docs/riepilogo-design.md (architettura/decisioni) e .docs/roadmap.md (task list con checkbox)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8c017b51-b7ef-429f-95f5-82e9764b64db
---

I documenti di riferimento del progetto sono due (in `.docs/`):

1. **`riepilogo-design.md`** — fonte di verità su architettura, decisioni e razionale.
   `/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-hub/.docs/riepilogo-design.md`
   Contiene: posizionamento (agency white-label single-tenant), stack (Laravel + Filament v5 + spatie/*), workflow dev (Composer path repo dual-repo core/template), PIM (JSON column + schema PHP hard-coded + DSL Type, family per categoria via nested-set), DAM (HasTechnicalAttributes su Media spatie, AssetFolder polimorfico adjacency list, extractor pipeline), background jobs (database queue + spatie/laravel-health + Oh Dear), permessi (spatie/permission + filament-shield), audit (spatie/activitylog minimale).

2. **`roadmap.md`** — task operativi del tracer bullet + espansione post-validazione, formato come checkbox markdown.
   `/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-hub/.docs/roadmap.md`
   I task `[x]` sono fatti, `[ ]` sono pendenti. Quando completi/avanzi un task, aggiorna il checkbox lì.

3. **`import-prodotti-indoor.md`** — doc dedicato al parsing/import dell'anagrafica Indoor (estratto dalla §3.8 del design, luglio 2026). Stato presente, non stratificato. **IMPLEMENTATO** (luglio 2026): comando `app:import-indoor` (wipe Indoor + rebuild da `prodotti_v2_import.xlsx`), `MaterialFabricSeeder`, migration `products.parent_id`+`specifica` e pivot `fabric_category_product`, classi schema PIM (Divani/Moduli/Sedia/Tavoli/Specchi). Contiene: mapping colonne, moduli come `Product` con `parent_id`, parsing specifica in **5 assi** (posti/taglia/forma/config/codice_variante), promozione a schema di posti(int)/taglia(enum)/forma(enum)/braccioli(bool)/configurazione(enum), costruzione nome (senza collezione). **Decisioni chiave:** (a) **v1 ABBANDONATA** — ci si basa solo su v2, niente join dimensionale (no designer/anno/misure per ora); (b) matrice materiali **splittata** in 6 `Material` (Indoor) + 10 `FabricCategory` (tipologie tessuto, associate via `Product::fabricCategories()`); col "Pelli Nabuk, soft grain, Vintage" → 3 pelli; **import colori CAPITAL FATTO** (luglio 2026) via comando `app:import-fabrics` da `tessuti_capital.xlsx` → 83 `Fabric` sotto le FabricCategory (nome=colD+colE, slug=categoria+colP; +4 FabricCategory nuove per le 3 varianti trapuntate e "grana Da Vinci" che esistono solo nel listino colori, senza prodotti associati). Nel design §3.8 resta solo un puntatore a questo file.

**Quando applicare:** consultare riepilogo-design.md prima di proporre architettura, scelta di pacchetti, scope di una feature o priorità. Consultare roadmap.md per capire a che punto siamo e cosa viene dopo. Le decisioni "scartate" in riepilogo-design.md sono altrettanto importanti delle decisioni prese — evitano di riproporre strade già escluse (es. multi-tenancy, EAV, Filament dinamico, git submodule).

**Naming:** `core` = piattaforma riusabile (Composer package, vive in `digital-hub/` come `atrio/digital-hub`); `Atmosphera` = primo cliente, vive in `atmosphera-hub/`.
