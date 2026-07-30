---
name: feedback-code-in-english
description: "Il codice va sempre scritto in inglese (nomi, identificatori, metodi di test)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7673379d-8481-4eb1-a743-34afa7d740a0
---

Scrivere **sempre il codice in inglese**: nomi di classi, metodi, variabili e
in particolare i nomi dei metodi di test (es. `test_anonymous_user_gets_403`,
non `test_anonimo_riceve_403`).

I **commenti** possono restare in italiano (è la lingua del progetto, vedi gli
altri file del package).

**Why:** convenzione del progetto richiesta esplicitamente dall'utente
(2026-06-25), emersa rinominando i metodi di `AssetServeTest`.

**How to apply:** alla creazione di nuovo codice usare identificatori inglesi;
se trovo nomi italiani in codice nuovo della stessa sessione, allinearli.
Collegato a [[feedback_preserve_comments]] (i commenti utente, anche in
italiano, non si toccano).
