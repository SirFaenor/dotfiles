---
name: project-stale-admin-js-bundle
description: "Il JS admin servito è public/admin/js/app.js (bundle), non il sorgente vendor input.js; il bundle è stale"
metadata: 
  node_type: memory
  type: project
  originSessionId: 5f02b389-75b5-445c-837e-05a3fbbb00c6
  modified: 2026-07-24T07:33:11.544Z
---

Il CMS Marvin serve il JavaScript admin da `public/admin/js/app.js`, un bundle (prepros) che concatena `vendor/atrioteam/marvin/src/resources/js/lib/input.js` e altri. Nei DevTools il browser mostra nomi tipo `input.js:110` tramite **source map** (`app.js.map`), ma il codice eseguito è il bundle.

**Il bundle è stale**: modifiche al sorgente `input.js` (es. il fix a riga ~88 che rimuove `<span>...<br>...</span>` per evitare il crash dell'optimizer di Quill) NON sono nel bundle servito. Verifica: `grep -c 'replace(/<span' public/admin/js/app.js` → 0, mentre il sorgente ne ha 1.

**Why:** debug di errori JS admin va fatto sul codice REALMENTE servito (app.js), non sul sorgente vendor; e i fix al sorgente non hanno effetto finché il bundle non viene ricostruito/ripubblicato.

**How to apply:** dopo aver toccato `src/resources/js/lib/*.js` ricostruire il bundle e ripubblicarlo in `public/admin/js/app.js` (v. commit tipo "Ripubblicazione js di marvin"). `quill_config.js` invece è servito standalone e resta aggiornato. Vedi anche [[project_php_in_docker_compose]].
