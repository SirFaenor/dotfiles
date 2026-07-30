---
name: asset_processing_queue
description: "ProcessAssetJob gira sulla coda dedicata 'assets' — il worker va avviato su quella coda"
metadata: 
  node_type: memory
  type: project
  originSessionId: ec20390f-b2fd-42ca-b273-13dd0a3eb669
---

`ProcessAssetJob` (elaborazione asset: estrazione metadati/dimensioni, future taglie) è dispatchato sulla coda dedicata **`assets`** (`$this->queue = 'assets'` nel costruttore del job).

**Why:** scelta dell'utente per isolare l'elaborazione asset dalle altre code.

**How to apply:** quando si configurerà il worker per l'asincronia reale (oggi `QUEUE_CONNECTION=sync`, gira inline), il processo deve ascoltare quella coda: `php artisan queue:work --queue=assets` (o includerla nella lista code del worker/Horizon). Altrimenti i job restano non processati e i media bloccati in stato `pending`/`processing`. Vedi pipeline in design §4.11 e [[design_reference_doc]].
