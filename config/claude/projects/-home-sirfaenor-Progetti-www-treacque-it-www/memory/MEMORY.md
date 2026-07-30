# treacque.it – Memoria di progetto

## Stack
- Laravel 12, PHP 8.4, Filament 4.4
- Spatie MediaLibrary v11, Spatie Translatable v6
- AtrioTeam: filament-helper ^4.0, lintilla, marvin, sitemapgenerator

## Locales
Definite in `config/lintilla.php`: `it` (Italiano) e `en` (English).

## Convenzioni Filament Resource
→ Dettagli completi in [filament-conventions.md](filament-conventions.md)

- Struttura a cartella col nome plurale: `app/Filament/Resources/ProductCategories/`
- Form separato in `Schemas/NomeForm.php` con `static configure(Schema $schema): Schema`
- Table separata in `Tables/NomeTable.php` con `static configure(Table $table): Table`
- Pages in `Pages/` con trait `CustomListPage` / `CustomInputPage` di AtrioTeam
- Namespace radice: `App\Filament\Resources\NomePlurali`

## Convenzioni Model
- Campi tradotti → colonne `json` in migrazione + `HasTranslations` (Spatie)
- Media → `HasMedia` + `InteractsWithMedia` + `registerMediaCollections()`
- SEO fields (slug, meta_title, meta_description) via `SeoMigration::up($table)` in migrazione

## Convenzioni Migrazioni
- `PublicationMigration::up($table)` (AtrioTeam FilamentHelper) va sempre incluso prima delle timestamp di Laravel
- `PublicationMigration::down($table)` nel metodo `down()`
- Import: `use AtrioTeam\FilamentHelper\Database\PublicationMigration;`
- **ATTENZIONE**: `PublicationMigration` aggiunge già `sort` — non aggiungerlo manualmente

## Environment
- PHP gira **dentro il container Docker** `treacque_web`, non sull'host
- Per eseguire comandi: `docker exec treacque_web php artisan ...`

## Componenti chiave
- `TranslationSection` (AtrioTeam) = locale switcher a tab per campi tradotti
- `->seoFields(ModelClass::class, slugSource: 'field')` su TranslationSection per SEO per-locale
- `TableDecorator::make($table, ModelClass::class)` per la table
- Label sempre in **italiano**
