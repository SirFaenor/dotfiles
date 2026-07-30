## Ambiente di esecuzione

- La macchina locale ha PHP 8.3, ma il progetto richiede PHP 8.4. Usare sempre `docker compose exec web` per eseguire comandi PHP (test, artisan, composer, ecc.).
  - Esempio: `docker compose exec web php artisan test --testsuite=MyDga`

## Convenzioni Filament

- [Pagine Create/Edit delle risorse](feedback_filament_pages.md): usare il trait `CustomInputPage`, niente `getHeaderActions()`
