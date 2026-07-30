---
name: design-reference-doc
description: "Documento di riferimento canonico per il design di Digital Hub / Atmosphera — da consultare all'inizio di ogni conversazione su questo progetto"
metadata: 
  node_type: memory
  type: reference
  originSessionId: b3d4b7d5-94c7-4e1f-ba19-a625cd6a9549
  modified: 2026-07-20T10:25:49.911Z
---

Il documento `atmosphera-hub/.docs/riepilogo-design.md` (path assoluto:
`/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-hub/.docs/riepilogo-design.md`)
è il riferimento canonico per tutte le decisioni di design del progetto.

L'app sorella `atmosphera-admin` (CMS client dell'hub) ha il proprio design
doc con la stessa convenzione:
`/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-admin/.docs/riepilogo-design.md`
(creato il 20 luglio 2026). Per domande sul CMS leggere quello; per fatti
sull'hub resta autorevole il primo.

**Why:** L'utente ha esplicitamente chiesto di tenerlo come riferimento per
tutte le conversazioni in questo progetto. Contiene 40+ decisioni di design
consolidate (posizionamento, stack, distribuzione, PIM, DAM, jobs,
permessi, audit log, dev workflow, roadmap operativa con tracer bullet) e
spiega anche le opzioni scartate e il perché.

**How to apply:** All'inizio di una nuova conversazione su questo progetto,
leggi il documento prima di rispondere a domande di design o
implementazione. Quando l'utente fa scelte che sembrano divergere dal
documento, segnalalo esplicitamente. Quando vengono prese nuove decisioni
o si modificano quelle esistenti, ricorda che il documento andrebbe
aggiornato di conseguenza (chiedi se vuole che lo aggiorni).

**Contenuti chiave per orientamento rapido:**
- Parte 1: posizionamento (agency white-label, single-tenant)
- Parte 2: stack + distribuzione (Composer package `core` + skeleton template)
- Parte 3: PIM (JSON column + schema hard-coded PHP, family-per-category)
- Parte 4: DAM (3 concerni, folder polimorfiche, extractor)
- Parte 5: workflow dev locale (path repo Composer + symlink)
- Parte 6: background jobs + monitoring (queue database, spatie/health + Oh Dear)
- Parte 7: permessi (spatie/permission + filament-shield)
- Parte 8: audit log (spatie/activitylog minimale)
- Parte 9: topic ancora aperti (search, API, frontend, import/export, versioning)
- Sezione finale: tracer bullet (14 step) + roadmap espansione + riepilogo decisioni
