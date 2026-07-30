# Project Memory - La Tavola di Nonno Nanni

## Environment
- **Docker**: container `latavoladinonnonanni_web` per comandi PHP/artisan/test
- **PHP**: >= 8.4 (usare sempre Docker, non PHP locale)
- **Framework**: Laravel + Filament (admin panel)
- **Traduzioni**: Spatie Translatable (campi JSON)
- **DB test**: connection `testing`, migrare con `--database=testing`

## Project Structure
- App principale in root, packages custom in `packages/`
- 4 packages: [form-builder](form-builder.md), [report](report.md), [import](import.md), [development](development.md)

## Conventions
- Tabelle form-builder: prefisso `form_` (es. `form_fields`, `form_field_relateds`)
- FK: `form_field_id`, `form_section_id`, etc.
- Modelli con `SoftDeletes` — cascade delete manuale nel `booted()` (non via DB)
- Test: `DatabaseTransactions` + trait `FieldTestSupport` per field tests
- Namespace packages: `App\{PackageName}\`
- Filament repeater con trait dedicati: `HasOptionsRepeater`, `HasRelatedsRepeater`

## Feedback
- [Preservare i commenti](feedback_comments.md) — non rimuovere commenti esistenti quando si sposta/riscrive codice

## Key Patterns
- Field types registrati in `FieldTypeEnum` con classmap, label, icon, factory
- `BaseField` abstract: validazione, schema Filament, view rendering
- `FormFieldRelated` con `FieldRelatedTypeEnum` per typed relations filtrate via scope `ofType()`
- Repeater Filament: `modifyQueryUsing` per filtrare, `mutateRelationshipDataBeforeCreateUsing` per impostare type
