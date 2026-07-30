---
name: design-doc-history-plan
description: Divisione dei ruoli tra riepilogo-design.md (corpo deliberativo + consolidato specchio) e roadmap.md
metadata: 
  node_type: memory
  type: project
  originSessionId: 1e12f32e-7a64-4aa2-81da-50d045745013
---

Decisione aggiornata (2026-07-15) — sostituisce il piano del 2026-07-01 ("a lavoro concluso
si produrrà un doc nuovo allineato al presente, tenendo riepilogo-design.md come archivio").
Non serve più un doc nuovo: la sezione **"Riepilogo consolidato delle decisioni finali"**
in fondo a `.docs/riepilogo-design.md` **è** lo specchio dello stato attuale ed è la
**fonte autorevole**. Va allineata a ogni intervento sul codice.

**Tre ruoli distinti, niente duplicazione:**
- `riepilogo-design.md` Parti 1-9 = **deliberazione**, stratificata/storica. Conserva le
  opzioni scartate e il perché (niente EAV / multi-tenant / SaaS / submodule): questo
  materiale **non esiste da nessun'altra parte**, la roadmap non lo ha. Non riscrivere lo
  storico: quando una decisione è superata si aggiunge un marker `> ⚠️ Superato` che
  rimanda al consolidato e alla voce di roadmap.
- `riepilogo-design.md` → Riepilogo consolidato = **specchio dello stato**, per topic,
  senza storia. Se diverge dal codice è un bug del documento.
- `roadmap.md` = **storico per task** con il dettaglio implementativo del come/perché.
  Il design rimanda qui, non copia (già ~12 rimandi design→roadmap, ~32 roadmap→design).

**Perché**: l'utente voleva "design = specchio dello stato attuale"; applicarlo all'intero
doc avrebbe distrutto il perché-delle-opzioni-scartate (irrecuperabile) e duplicato la
roadmap. Il doc aveva già entrambi i layer — bastava dichiarare quale è autorevole.

**Regola operativa (decisa 2026-07-15)**: il consolidato si allinea **a valle di ogni task
chiuso in roadmap**, come parte del task. Marca nel corpo (Parti 1-9) solo ciò che il task
rende *falso*, non ciò che è meramente incompleto. La regola è scritta in testa a
`.docs/roadmap.md` ("Rapporto con il design doc") e in testa al consolidato — non vive
solo qui.

**Perché serve un trigger esplicito**: la passata del 15 luglio 2026 ha trovato ~10
affermazioni false nel consolidato (health checks mai configurati, migration helpers PIM
mai scritti, `manage_asset_folders` inesistente, `FallbackExtractor` mai implementato,
`AttributesEditorColumn/Filter` inesistenti, job/coda sbagliati, "un panel solo" mentre
sono due). Caso emblematico: il passaggio a **git subtree** era in roadmap dal 24 giugno,
il design ha detto "subtree scartato, due cartelle sibling" per 3 settimane indicando come
core attivo la sibling morta `../digital-hub`. La roadmap si aggiorna perché è dove si
lavora; il consolidato no.

**Non ancora fatto**: passata completa delle Parti 1-9 (~2000 righe) contro il codice — ho
messo marker solo dove sono inciampato. Rischio concentrato nelle Parti 3, 4, 6, 7 (quelle
che descrivono implementazione). Vedi [[design_reference_doc]].
