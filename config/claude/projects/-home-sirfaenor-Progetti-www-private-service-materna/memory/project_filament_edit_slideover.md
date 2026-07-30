---
name: project_filament_edit_slideover
description: Tutte le EditAction nelle risorse Filament di questo progetto devono usare ->slideOver()
metadata: 
  node_type: memory
  type: project
  originSessionId: 72766d0f-1ed9-45a4-a904-403f631f93c0
  modified: 2026-07-28T15:31:16.198Z
---

In questo progetto (Filament v4), tutte le azioni di modifica (`Filament\Actions\EditAction`) nelle tabelle delle Resource devono usare `->slideOver()` invece del modale centrato di default.

**Why:** richiesta esplicita dell'utente (2026-07-28) per uniformare l'esperienza di edit su tutte le resource, attuali e future.

**How to apply:** quando si crea una nuova Filament Resource in questo progetto, aggiungere `->slideOver()` a `EditAction::make()` nel file `Tables/*Table.php`. Applicato retroattivamente a:
- `app/Filament/Resources/CostEntries/Tables/CostEntriesTable.php`
- `app/Filament/Resources/ImputazioneCosti/Tables/ImputazioneCostiTable.php`

Nota tecnica: `EditAction::make()` è di per sé un'azione modale, MA se la Resource ha una route `'edit'` registrata in `getPages()` (chiave esattamente `'edit'`), Filament (`Filament\Resources\Pages\Page::getDefaultActionUrl()`) forza l'azione a comportarsi come link verso quella pagina, ignorando `->slideOver()`. Per evitarlo bisogna rinominare la chiave della route edit (es. `'edit-page'` invece di `'edit'`) in `getPages()`, così `hasPage('edit')` torna `false` e l'azione resta modale/slideover. La classe `EditRecord` e la route restano comunque raggiungibili via URL diretto, solo non vengono più agganciate automaticamente dalla EditAction. Applicato a:
- `app/Filament/Resources/CostEntries/CostEntryResource.php` (`'edit'` → `'edit-page'`)
- `app/Filament/Resources/ImputazioneCosti/ImputazioneCostResource.php` (`'edit'` → `'edit-page'`)

**How to apply (futuro):** per ogni nuova Resource, se si registra una pagina Edit dedicata in `getPages()`, usare una chiave diversa da `'edit'` (es. `'edit-page'`) fin da subito, altrimenti l'EditAction con `->slideOver()` verrà comunque reindirizzata alla pagina.
