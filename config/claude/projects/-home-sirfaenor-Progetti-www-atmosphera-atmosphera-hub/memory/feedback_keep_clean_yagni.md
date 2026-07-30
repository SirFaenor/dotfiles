---
name: feedback-keep-clean-yagni
description: "Regola generale — tenere il codice/schema il più pulito possibile, rimuovere ciò che non serve (YAGNI)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: fc1b0450-c09f-4f81-b82b-45b5d0832902
  modified: 2026-07-24T10:51:51.046Z
---

Come regola generale l'utente vuole tenere il codebase e lo schema DB **il più puliti possibile**: rimuovere tabelle, colonne, relazioni e codice che non servono / non vengono usati, anziché lasciarli "per ogni evenienza".

**Why:** preferenza esplicita ("teniamo più pulito possibile come regola"), emersa rimuovendo il pivot inutilizzato `fabric_product` (associazione prodotto↔colore mai popolata, perché l'associazione è a livello di tipologia via [[design-reference-doc]]).

**How to apply:** quando individui codice morto o strutture non popolate/non referenziate, proponine la rimozione invece di conservarle; segnala l'unico scenario futuro in cui varrebbe la pena tenerle e lascia decidere. Non introdurre astrazioni/tabelle "anticipatorie" senza un uso concreto attuale.

**Si applica anche al design di contratti/API, non solo a schema/codice.** Il 24 luglio 2026, in fase di design della sync multi-lingua dell'API esterna (roadmap #24, [[api_technical_attributes_resolution]]), avevo proposto un flag opt-in retrocompatibile (`?with_translations=1`) per non toccare il comportamento di default. L'utente l'ha respinto ("non mi piace, riscriviamo tutto") e ha chiesto il rewrite diretto verso il comportamento corretto (tutte le lingue sempre, senza flag) — perché **l'API non ha ancora consumer reali**, quindi non c'è nulla da cui essere retrocompatibili: mantenere un vecchio comportamento dietro un flag "per sicurezza" è la stessa cosa di tenere codice morto "per ogni evenienza". Quando un contratto non ha ancora consumer di produzione, non proporre shim di compatibilità di default: proporre direttamente il design corretto, e lasciare che sia l'utente a chiedere compatibilità se davvero serve.
