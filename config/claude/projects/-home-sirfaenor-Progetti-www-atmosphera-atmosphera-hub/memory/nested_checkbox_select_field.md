---
name: nested_checkbox_select_field
description: Campo Filament custom NestedCheckboxSelect per relazioni prodotto ↔ materiali/tessuti (categorie collassabili)
metadata: 
  node_type: memory
  type: project
  originSessionId: c711f0f6-1af4-49a5-a98e-4d34f2b63d17
---

**Campo generico del core** (spostato dall'app al package perché riusabile in altri progetti): classe `AtrioTeam\DigitalHub\Filament\Forms\Components\NestedCheckboxSelect` in `packages/digital-hub/src/Filament/Forms/Components/NestedCheckboxSelect.php` + view `digital-hub::filament.forms.components.nested-checkbox-select` (`packages/digital-hub/resources/views/filament/forms/components/nested-checkbox-select.blade.php`). Record e relazione tipizzati su `Model` (non su `Product`): il template passa i class-string dei modelli di dominio a `->relationship($name, $itemModel, $categoryModel, $categoryForeignKey, $noCategoryLabel)`. Usato nel `ProductForm` del template per materiali e tessuti.

Categorie collassabili (accordion, `x-collapse`) con checkbox-padre tri-state (indeterminate); le opzioni della categoria si aprono a dropdown. Salvataggio a livello di singolo item via `saveRelationshipsUsing` (`$relation->sync()`), stato `dehydrated(false)`.

La view usa **stili scoped inline** (classe `.ncs-*` in un blocco `<style>` @once), NON utility Tailwind arbitrarie. Motivo: il theme Vite del package (`DigitalHubPlugin::register()` applica `->viteTheme('.../digital-hub-theme.css')`) ha `@source` relativi al package e NON scansiona le view/PHP del template — classi non-Filament non verrebbero compilate. Dark mode via prefisso `.dark`. L'utente ha confermato che gli stili inline vanno bene.

Gotcha test correlato: [[product_form_livewire_test_gotcha]].
