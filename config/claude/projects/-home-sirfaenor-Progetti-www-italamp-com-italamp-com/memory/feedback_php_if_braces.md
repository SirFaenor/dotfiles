---
name: feedback_php_if_braces
description: "Nei blocchi PHP usare sempre le parentesi graffe per i corpi degli if, anche quando il corpo è su una sola riga"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e64a9ebe-4b4e-464a-a7b2-d8643f24c514
---

Usare sempre le parentesi graffe `{}` per il corpo degli `if` in PHP, anche quando è una sola istruzione su una riga.

**Why:** Preferenza esplicita del progetto/utente per coerenza e leggibilità.

**How to apply:** In qualsiasi blocco `@php` o file `.php`, scrivere sempre `if (...) { ... }` e mai `if (...) istruzione;` senza graffe.
