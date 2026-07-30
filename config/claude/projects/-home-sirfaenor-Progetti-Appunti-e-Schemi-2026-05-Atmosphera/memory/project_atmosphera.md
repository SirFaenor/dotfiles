---
name: project-atmosphera
description: Atmosphera is a Laravel + Filament starter kit for white-label PIM/DAM customizations sold via agency model (not a generic SaaS platform)
metadata: 
  node_type: memory
  type: project
  originSessionId: 73711513-e0fb-4f68-88f9-b6557ac27cb2
---

User is designing a Laravel + Filament starter kit reused and customized per client.

**Naming convention (2026-05-22):** The platform/starter kit itself is called **"core"**. "Atmosphera" is the name of the FIRST CLIENT instance, not the platform. Each future client install will have its own name. Do not call the platform "Atmosphera" — always say "core".

**Direction decided (2026-05-22):** white-label customizzato via agency model — NOT a generic self-service SaaS platform.

**Why:** User initially considered a fully generic CMS-like platform (user-defined collections, configurable relations, EAV-everywhere, multi-tenant SaaS) for reselling across different client domains. After discussion, complexity (~5-10× dev time vs. specific app: dynamic Filament resources, schema migration self-service, multi-tenant isolation, EAV at scale) was deemed unjustified given the realistic sales model — 10-50 clients followed individually, not thousands self-service. Directus/Strapi/Payload already occupy the generic-SaaS space.

**How to apply:** When suggesting architecture or code, default to:
- Concrete Eloquent models per collection (Product, Designer, Material, Category) cloned/customized per client
- spatie/media-library for DAM with logical folder structure (folders are UI-only, NOT filesystem)
- PIM technical attributes via **JSON column with code-defined schema** (NOT EAV — see below)
- Categories as nested-set (likely kalnoy/nestedset)
- Single-tenant per client install unless explicitly needed otherwise
- Reusable traits/abstract classes (e.g. `HasAssets`, `HasTechnicalAttributes`) + reusable Filament components, NOT dynamic-resource generation

Avoid suggesting: dynamic Filament resources, fully generic schema-as-data, complex multi-tenant patterns, EAV tables for PIM attributes — these were considered and rejected.

**Stack confirmed (2026-05-22):** Laravel + Filament v5 + spatie/media-library.
Note on Filament v5: architecturally identical to v4 (Panel Builder unified API, schema components), only difference is Livewire v4 underneath. Released January 2026. Upgrade from v4 trivial. So when reasoning about Filament APIs/patterns, use v4 references — they apply unchanged.

**Tenancy decided (2026-05-22):** SINGLE-TENANT per client installation.
One Laravel install + one database per client. User explicitly accepts the operational overhead of per-client DB migrations and noted the *benefit* of being able to "diverge legitimately per client" (custom fields, integrations, schema patches). No spatie/laravel-multitenancy, no panel tenancy in Filament, no row-level scoping. Per-client divergence is treated as a feature, not a bug.

The one acknowledged downside: **upgrade fanout** (security patches × N installs). Mitigation depends on distribution model (next open decision).

**Distribution model decided (2026-05-22):** Composer package + skeleton template (hybrid).
- The platform is a private Composer package called `core/core` (private Packagist / Satis / VCS).
- A skeleton/template Laravel repo (that `require`s the core package) is cloned once per client.
- Each client's app code lives in `app/` of their own repo, on top of the package.
- Upgrades = `composer update core/core` per client install. NOT a git-fork model — the fork-with-merge approach was explicitly considered and rejected.
- For clients needing core-level patches, they may fork the package itself and point composer at the fork (rare, explicit).

**PIM attributes decided (2026-05-22): JSON column with code-defined schema.** NOT EAV tables.

**Storage:**
- Single `attributes` JSON column on PIM-enabled models. The column name is parameterized in the trait (`protected static string $attributesColumn`) so a model can use a different column (e.g. Media uses `custom_properties` from spatie).
- Scale confirmed under 100K products per client — JSON path queries (MySQL 8+ / Postgres) are fine at this scale, with optional JSON indexes on frequently-filtered keys.

**Schema definition (code-only, versioned):**
- Hard-coded PHP classes in the client repo, editable only by developers — no admin UI for definitions, no DB-managed definitions, no runtime mutations.
- Base class `AttributeSchema` in core package; each schema declares `attributes(): array` and `groups(): array`.
- Fluent `Type::...` API: `Type::decimal()->unit('mm')->required()->filterable()->min(0)->max(2000)`, `Type::enum([...])`, `Type::string()->translatable()`, `Type::int()->min()->max()`, plus `rule('regex:...')`, `in(...)`.
- Validation surface supports: type, required, min, max, regex, in (CONFIRMED 2026-05-22).

**Multi-entity (CONFIRMED 2026-05-22):** The trait is universal — applied to any model. Static schema via `protected static string $attributeSchemaClass = XAttributes::class` for entities like Designer/Material; dynamic schema via overriding `resolveAttributeSchemaClass()` for entities like Product whose schema depends on something (e.g. category).

**Per-category schema for Product (Akeneo-style families, CONFIRMED 2026-05-22):**
- Category (nested-set, kalnoy/nestedset) has a nullable `attribute_schema_class` column storing the FQN of the schema class.
- Schemas are declared at family-root categories (e.g. `lighting/` declares `LampAttributes::class`); descendants inherit via `Category::resolveAttributeSchemaClass()` walking up the parent chain.
- Common product attributes (sku, release_year, etc.) live in an abstract `ProductBaseAttributes`; family classes (`LampAttributes`, `TableAttributes`, …) extend it via PHP inheritance + array spread in `attributes()` and `groups()`. No magic merging — plain PHP. CONFIRMED.

**Orphan attribute values on category change (CONFIRMED 2026-05-22): strategy C** — strip + warning UI. When a Product's category changes and the new schema doesn't include some attributes, Filament shows a confirmation modal listing the values that will be lost; on confirm, those keys are stripped from the JSON on save.

**Localization (CONFIRMED 2026-05-22):**
- BOTH labels and values are localizable.
- Labels: Laravel i18n files (`lang/{locale}/product-attributes.php` etc.) — attribute names, enum option labels, group names.
- Values: three categories — (1) scalars (numbers/dates/bool) stored raw; (2) enums store canonical key, label looked up via i18n; (3) `translatable()` strings stored as `{locale: value}` map in the JSON.
- Available locales sourced from `config('app.available_locales')` (CONFIRMED).
- Fallback for missing translatable value: fall back to app default locale (CONFIRMED).

**Runtime API (trait `HasTechnicalAttributes`):**
- `$model->attr('key')` — locale-aware read for current `app()->getLocale()`
- `$model->attr('key', $locale)` — explicit locale
- `$model->attrLabel('key')` — translated label from i18n
- `$model->attrOption('enum_key', 'option')` — translated enum option label
- Query scopes: `whereAttr()`, `whereAttrBetween()` using native JSON path queries

**Filament components in package:**
- `AttributesEditor::for(Model::class)` — auto-generated form with Tabs per group (essential at 50 attributes — confirmed scale)
- `AttributesColumn::for(...)` — table column
- `AttributesFilter::for(...)` — filter set from filterable attributes
- For Product: editor reacts to category selection (`->live()`), re-resolves schema dynamically.
- Translatable fields render per-locale inputs (stile filament-spatie-translatable).

**Schema migration helpers (CONFIRMED 2026-05-22):**
- Package provides helpers callable from Laravel migrations: `ProductAttributes::rename('old', 'new')`, `ProductAttributes::remove('old')`, etc. These iterate existing rows and rewrite JSON.

**Asset metadata architecture (2026-05-22):** Asset metadata splits into THREE concerns:
1. **Curated metadata** (caption, alt, credit, usage rights, …): reuses `HasTechnicalAttributes` trait on an extended `Media` model (extends spatie's), using `custom_properties` JSON column. Schema class e.g. `MediaAttributes`. Same Filament components, same i18n. The trait's column is parameterized (`$attributesColumn = 'custom_properties'`) to make this work without touching spatie's schema.
2. **Extracted technical metadata** (EXIF, dimensions, codec, …): SEPARATE column `extracted_metadata` JSON added by core package via migration. Auto-populated by core's `MetadataExtractor` interface (with built-in `ExifExtractor`, `PdfExtractor`, `VideoExtractor`, extensible by client) on `MediaHasBeenAdded` event. Read-only in UI, shown in a "Technical info" tab.
3. **Tags**: use `spatie/laravel-tags` directly. Many-to-many, taxonomy, translations native, existing Filament plugin. NOT an attribute.

The Media model in core extends spatie's. Client config sets `media-library.media_model` to point to the core extended class.

**Media families decided (2026-05-22):** Single universal `MediaAttributes` schema for ALL asset mime-types. NOT per-mime-type families. Rationale: over-engineering for the current need; can be revisited if/when curated metadata genuinely diverges between asset types.

**Asset folders decided (2026-05-22):**
- Polymorphic table `asset_folders(id, folderable_type, folderable_id, parent_id nullable, name, position, timestamps)`.
- **Adjacency list** (parent_id only — NOT nested-set). Rationale: trees are shallow, writes (drag-drop, reorg) are frequent, opposite tradeoff from categories.
- **Max depth: 5 nesting levels**, enforced at `AssetFolder::saving` event via `computeDepth()` walking parent chain, plus client-side validation in Filament form.
- **Media→folder: 1-to-many**, single nullable `asset_folder_id` column added to `media` via core migration. Cross-folder classification via tags, not many-to-many folder membership.
- **Non-empty folder delete: REFUSE.** Throws DomainException if folder has children or media. Forces explicit user action (move or delete contents first) — no implicit data displacement.
- **Trait: single `HasAssets`** (wraps spatie's HasMedia + folder support + media-attributes infra). Folders always included with assets — opt-in split was rejected as unnecessary overhead.
- Filament UI: a custom **AssetManager Livewire component** in core (tree-left + grid-right + drag-drop + breadcrumbs). Significant frontend work — probably the biggest single UI piece in the core package.

**Briefing now substantially covered.** 

**`extracted_metadata` JSON structure decided (2026-05-22): hybrid (option C).**
- Top-level `common` object: normalized fields shared across asset types (`width`, `height`, `size_bytes`, `captured_at`, `pages`, `duration_seconds`, `mime`, `original_filename`).
- Per-extractor verbatim sub-objects (`exif`, `iptc`, `xmp`, `pdf`, `ffprobe`, …) preserve full raw output for power users / debug.
- Filament UI shows `common` prominently in a "Technical info" tab; verbatim sub-objects behind a "Show full metadata" toggle.

**Extractors v1 scope (2026-05-22):** Image + PDF + VideoAudio + Fallback. Video/audio EXPLICITLY requested by user — not deferred.
- `ImageExtractor`: EXIF (PHP native `exif_read_data`) + IPTC + XMP via light libs.
- `PdfExtractor`: `smalot/pdfparser` (pure PHP, no system deps).
- `VideoAudioExtractor`: SINGLE class for both video and audio (CONFIRMED 2026-05-22), uses `ffprobe` (ffmpeg binary) with graceful degradation when binary missing (CONFIRMED 2026-05-22). `supports()` returns false if ffprobe absent → falls through to `FallbackExtractor`.
- `FallbackExtractor`: catch-all writing only `common.size_bytes`, `common.mime`, `common.original_filename`.
- Extensible: clients register extra extractors (Office, custom formats) via service container; package iterates via `supports()` and uses first match.

**ffprobe dependency rationale**: pure-PHP video metadata (e.g. getid3) is unreliable for modern codecs. Single-tenant per client makes a documented system dependency acceptable. ffmpeg available on standard repos (apt/yum/brew). Graceful degradation via `VideoAudioExtractor::supports()` returning false if `ffprobe` binary not found — FallbackExtractor then handles the file.

**Background jobs decided (2026-05-22):**
- Queue driver default: **`database`** in skeleton template. Redis available on demand for clients with higher volume. NEVER `sync` outside of tests (use `database` even in dev).
- **Horizon NOT included** in core package — would require Redis as hard dep, incompatible with `database` driver default. Documented as optional for clients on Redis.
- **Monitoring via spatie/laravel-health + Oh Dear** — NOT a Filament resource for failed jobs. Core ships pre-configured checks: `QueueCheck`, `FailedJobsCheck`, `DatabaseCheck`, `ScheduleCheck`, `UsedDiskSpaceCheck`, possibly a custom `MetadataExtractionCheck`. Endpoint `/health` exposed; Oh Dear pings it centrally across all client installs.
- **Worker management**: `supervisord`, example config provided in skeleton template README.
- **Metadata extraction job flow**: listener `DispatchMediaMetadataExtraction` on spatie's `MediaHasBeenAddedEvent` → dispatches `ExtractMediaMetadata` job on dedicated `media-extraction` queue with `$timeout = 300` (5 min). Job iterates registered extractors using `supports()` and writes to `extracted_metadata` column.
- **Media replacement nuance**: in spatie/media-library, replacing a media = DELETE + ADD. There is no `MediaHasBeenUpdated` event to handle. The `MediaHasBeenAddedEvent` listener intrinsically covers both first upload and replacement, since both create a new Media model.

**Permissions decided (2026-05-22):**
- **Stack: spatie/permission + filament-shield** — standard combo for Filament authz.
- **Granularity: A (per-resource) + B (per-action), with C (per-record) on demand**. D (per-attribute) EXPLICITLY OUT OF SCOPE — would add UI complexity (field-level gating in forms/tables) without a pressing use case.
- A + B auto-generated by filament-shield. C achieved without extra infrastructure: shield's auto-generated policy methods accept the record (`update(User $user, Product $product)`), so the client implements per-record logic in policy methods only when needed.
- **Single Filament admin panel** — no separation by audience; role-based access within one panel.
- **Roles UI:** the filament-shield resource for editing roles + permissions is exposed; client end-users configure roles via UI.
- **Baseline role seeding:** NOT in core. The skeleton template includes a default `RoleSeeder` (Admin, Editor, Viewer) that each client customizes (approach C — agency-style, package agnostic, skeleton suggests).
- **Super-admin pattern:** `Gate::before()` bypass in client's AuthServiceProvider — `fn (User $user) => $user->hasRole('super-admin') ? true : null`. NOT explicit per-permission assignment (rejected as error-prone when adding new features).
- **Custom permissions shipped by core: only `manage_asset_folders`** (cross-resource folder create/move/delete authorization). Other custom permissions (`export_*`, `bulk_edit_*`, `view_extracted_metadata`, etc.) deferred until their respective feature lands.
- **Localization:** client overrides `lang/{locale}/filament-shield.php` for translated permission labels. Standard shield pattern.
- **`shield:generate`:** run MANUALLY by client developer when adding a resource. NOT automated via post-migrate hook (edge cases; developer knows when).
- **Client integration requirements:** `HasRoles` trait on User model; `Gate::before()` in AuthServiceProvider; lang file overrides for i18n; manual `shield:generate` after new resources; optional custom Policy logic for scenario C.

**Authentication decided (2026-05-22): Filament default, no customization in v1.**
- Email + password (Filament's standard login on Laravel auth)
- **Registration: closed** — admin creates users via UserResource (consistent with agency model)
- Password reset: Laravel standard via email
- Rate limiting: Laravel default (5 attempts/minute on `LoginRequest`)
- User explicitly chose to NOT complicate v1 with auth features that can be layered later. Quote: "non vorrei che in una prima fase questo complicasse troppo. Facciamo utente e password per ora, così non modifichiamo il login standard di filament. Poi vediamo".

**Auth features DEFERRED (not rejected — likely added post-tracer-bullet):**
- 2FA / TOTP (recommended package when needed: `stephenjude/filament-two-factor-authentication`)
- Magic link (would be roll-your-own, ~half day of dev — no dominant Filament package)
- SSO (SAML, OAuth, Microsoft 365 / Google Workspace) — rivalutare per clienti enterprise futuri
- Impersonation (recommended package when needed: `stechstudio/laravel-impersonate` + Filament plugin)
- Login audit (successful + failed login events) — può integrarsi con l'audit log generale quando arriverà
- Session management custom (single-session-per-user, timeout aggressivo)

**Audit log decided (2026-05-22): MINIMAL, LOW PRIORITY.**
- Package: `spatie/laravel-activitylog` (default choice, aligned with spatie ecosystem).
- **Scope confirmed to use cases 1+2 only**: (1) accountability ("chi ha modificato cosa, quando") + (2) inline "modified by X on Y" UI attribution. NOT use case 3 (forensic per-field diff) and NOT use case 4 (regulatory compliance).
- **Implementation kept minimal**:
  - spatie/activitylog default config on domain models + User + Role/Permission + AssetFolder.
  - `updated_by` field via observer, shown inline on Filament resource pages.
  - Community Filament plugin for activity log view (e.g. `noxoua/filament-activitylog` or similar) — NOT bespoke UI.
  - NO custom PIM JSON diff logic — raw column blob in log is enough for the rare forensic case.
  - NO retention policy in v1 — defer until table growth becomes a real problem.
- **Priority: low.** Not required for tracer bullet; can land after architecture validation. NOT a v1 blocker.

**Next direction (2026-05-22): TRACER BULLET.**
User explicitly shifted from design-only conversation to wanting a thin end-to-end slice that exercises every architectural layer, before approfondire altri topic. Rationale: 40+ design decisions accumulated; validate the whole stack works together before deepening any single piece.

**Tracer bullet scope CONFIRMED (2026-05-22):**
- Dual-repo dev setup (core + template via path repo + symlink)
- Core package skeleton (composer.json, ServiceProvider, src/ structure)
- Skeleton template (Laravel + Filament v5 + spatie packages)
- **Category** model (nested-set, kalnoy/nestedset) + CategoryResource Filament with tree UI + Product belongsTo Category — ADDED to tracer scope at user request: "categorie è una feature che in mvp il cliente deve vedere"
- One Product model + minimal ProductAttributes schema (2-3 attributes, single schema for all products — family-per-category deferred)
- HasTechnicalAttributes + HasAssets traits exercised
- filament-shield installed, ProductPolicy + CategoryPolicy generated, super-admin gate
- MediaHasBeenAdded → ExtractMediaMetadata job using only FallbackExtractor
- /health endpoint with DatabaseCheck
- spatie/activitylog logging on Product + Category (no UI)
- ProductResource + CategoryResource (form + table + AttributesEditor on Product)

**Tracer bullet — CONFIRMED operational approach (2026-05-22):**
- **Free exploration**, NOT a detailed pre-planned roadmap. User drives, consults Claude where needed, discovers obstacles as they emerge.
- **First client = Atmosphera directly** — NOT a separate demo-client. Tracer bullet built in the real first client install. User accepts some resets/rollbacks in early days as the price for starting with a real client from day one.

**Explicitly DEFERRED from tracer bullet:**
- Family-per-category (single ProductAttributes schema for all products in tracer; nested-set inheritance comes later as natural expansion)
- AssetFolder + custom AssetManager Livewire UI (biggest single piece, do after validation)
- Multilingual values
- Image/Pdf/VideoAudio extractors (only Fallback for tracer)
- Migration helpers for schema change
- Custom audit log Filament UI
- Retention, custom health checks, articulated RoleSeeder

**IMPORTANT: User plans to MOVE `riepilogo-design.md` to the actual project folder and continue work from there.** When the user restarts the conversation in the new project path, THIS memory file will NOT follow (memory is path-specific to `/home/sirfaenor/.../2026.05 Atmosphera/`). The `riepilogo-design.md` document is the bridge — it has been kept fully self-contained for that reason. Future Claude in the new project path should read the document fresh as the source of truth.

**Topics still NOT discussed** (deferred until after tracer bullet):
- Global cross-collection search (likely Scout + Meilisearch)
- External API (REST/GraphQL) — or admin-only?
- Public frontend (browsable catalog) — or backend-only?
- Import/export (CSV/Excel)
- Record versioning (rare in PIM but sometimes requested) Domain example mentioned: furniture/design (categorie, designer, materiali, prodotti) but the kit must be adaptable to other product-catalog domains.

Related: [[feedback-exploratory-dialogue]]
