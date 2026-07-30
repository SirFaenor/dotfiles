# Germinalbio.it - Project Memory

## Docker
- PHP runs inside container: `new_germinalbio_php`
- Run artisan: `docker exec new_germinalbio_php php artisan <command>`
- Other containers: nginx (`new_germinalbio_nginx`), db (`new_germinalbio_db`), node (`new_germinalbio_node`)
- Local PHP is 8.3.6, container requires >= 8.4 — always use docker for artisan

## Blade Components
- Componenti anonimi in `resources/views/components/` gestiti solo con `@props` (senza classe PHP)
- Classi PHP in `app/View/Components/` — verificare se esistono prima di modificare blade
- `$slot` è disponibile solo nel template blade, non nella classe PHP del componente
- `shouldRender()` viene chiamato PRIMA della cattura dello slot — non può accedere a `$slot`

## Memorie
- [sage-sync-clienti-gotchas](sage-sync-clienti-gotchas.md) — insidie sync clienti Sage↔web (CustomersImport/UserExport), Sage scrive via query dirette, indice unique sage_uuid e soft-delete; case history doppione G2010418
