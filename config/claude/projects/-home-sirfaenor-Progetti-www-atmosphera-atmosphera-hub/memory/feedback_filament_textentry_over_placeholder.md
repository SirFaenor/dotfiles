---
name: feedback_filament_textentry_over_placeholder
description: In Filament v5 usare TextEntry->state() invece di Placeholder (deprecato) per testo non-input nei form
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3f6be1e5-30dd-440f-802d-d8c6247d73ea
---

In Filament v5 il componente `Placeholder` (Filament\Forms\Components\Placeholder)
è deprecato. Per mostrare testo non-editabile / alert inline in un form usare
`TextEntry` (Filament\Infolists\Components\TextEntry) con `->state()`, più
`->html()` per HTML grezzo e `->color('warning')` per il colore.

**Why:** preferenza esplicita dell'utente sul progetto atmosphera-hub; allinea
il codice alle API non deprecate di Filament v5.

**How to apply:** quando serve un blocco di testo/alert dentro un form schema
Filament, non usare `Placeholder::make()->content()`; usare
`TextEntry::make()->state(...)->html()->color(...)`. Per la reattività,
avvolgere in un `Group::make()->schema(fn (Get $get, ?Model $record) => [...])`
così visibilità e contenuto si rivalutano al cambio di un campo `->live()`.
Vedi ProductForm (alert orfani PIM, task #17).
