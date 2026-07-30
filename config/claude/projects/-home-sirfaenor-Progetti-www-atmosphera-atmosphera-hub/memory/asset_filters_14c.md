---
name: asset_filters_14c
description: Filtri AssetManager (14c) fatti per tipo/autore/data; tag e dimensioni rinviati
metadata: 
  node_type: memory
  type: project
  originSessionId: 566c660f-af9f-486d-9d35-46035aa81484
---

Task 14c (filtri asset nell'AssetManager) completato per tre filtri: **tipo di file**
(categorie `AssetFileType`), **caricato da** (autori upload), **data di caricamento**
(intervallo su `created_at`). Con filtri attivi la griglia va in vista piatta su tutti
i file del record (cartelle nascoste); `selectFolder` azzera i filtri.

**Rinviati (non ancora fatti):** filtro **tag** e filtro **dimensioni** — l'utente sta
ancora definendo il criterio, da riprendere quando lo comunica. Il tag userebbe il pivot
`taggables`, le dimensioni un range su width/height dai metadati estratti.

Vedi [[design_reference_doc]] (roadmap 14c per i dettagli).
