---
name: feedback-lang-en-translations
description: "Quando si aggiungono chiavi di traduzione in lang/it, creare sempre anche la versione inglese in lang/en"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9bd796d2-c4d0-4ca8-be95-9ff9757cafb5
---

Quando si aggiungono label/chiavi di traduzione in `lang/it/*.php`, creare sempre anche il file/chiavi corrispondenti in `lang/en/*.php`.

**Why:** il progetto è bilingue (it/en); l'utente ha chiesto esplicitamente di non lasciare le traduzioni inglesi indietro (2026-07-07).

**How to apply:** ogni volta che si tocca un file in `lang/it`, replicare le stesse chiavi tradotte in inglese in `lang/en`, mantenendo struttura e ordine identici. Vedi anche [[feedback-code-in-english]].
