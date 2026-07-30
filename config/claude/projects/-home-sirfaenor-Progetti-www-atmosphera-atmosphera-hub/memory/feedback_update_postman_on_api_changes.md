---
name: feedback-update-postman-on-api-changes
description: "Ogni intervento sulle API esterne va accompagnato dall'aggiornamento dei JSON in postman/"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aa0a423a-9ee6-469b-891f-41456108f371
  modified: 2026-07-24T09:34:14.436Z
---

Ogni volta che si tocca l'API esterna (roadmap #24) — nuovo endpoint, nuova risorsa esposta, campo aggiunto/rimosso dal payload, nuovo filtro — va aggiornata anche `postman/atmosphera-hub-api.postman_collection.json` (e `atmosphera-hub-local.postman_environment.json` se cambiano variabili d'ambiente).

**Why:** l'utente lo ha chiesto esplicitamente il 24 luglio 2026: la collection Postman è la prova end-to-end del contratto ([[api_external_read_pattern]]) citata anche in `.docs/riepilogo-design.md` ("Prova end-to-end: collection Postman in `postman/`"). Se non si aggiorna insieme al codice, diverge silenziosamente e smette di essere affidabile come riferimento per verificare manualmente l'API.

**How to apply:** ad ogni PR/intervento sull'API esterna, prima di considerare il lavoro concluso: aggiungere la request per il nuovo endpoint (o aggiornare quella esistente) nella cartella Postman pertinente, con esempio di response se la collection li usa. Vedi `postman/README.md` per la struttura delle cartelle (es. "Asset — lettura").
