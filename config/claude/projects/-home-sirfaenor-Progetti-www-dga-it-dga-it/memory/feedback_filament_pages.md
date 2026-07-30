---
name: Filament resource pages convention
description: Convenzione per le pagine Create ed Edit delle risorse Filament in questo progetto
type: feedback
---

Nelle pagine Create e Edit delle risorse Filament, seguire sempre questa convenzione:

1. Includere il trait `CustomInputPage` da `AtrioTeam\FilamentHelper\Filament\Pages\Traits\CustomInputPage`
2. NON aggiungere il metodo `getHeaderActions()` (viene gestito dal trait)

**Why:** Il trait `CustomInputPage` gestisce già le azioni di header (inclusa DeleteAction in Edit). Aggiungere `getHeaderActions()` crea duplicati o conflitti.

**How to apply:** Ogni volta che si crea una nuova risorsa Filament, le pagine `CreateXxx` e `EditXxx` devono avere `use CustomInputPage;` e nessun `getHeaderActions()`.
