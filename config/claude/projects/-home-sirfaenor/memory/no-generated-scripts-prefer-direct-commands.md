---
name: no-generated-scripts-prefer-direct-commands
description: "L'utente preferisce comandi shell diretti da incollare, non script generati da salvare su file"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d27a3a01-5bf6-4be3-b5a9-ac3c107da4fd
  modified: 2026-07-21T13:14:07.613Z
---

Quando servono operazioni di sistema (installazioni, configurazioni, sudo), fornire i **comandi diretti** da eseguire, non uno script `.sh` scritto su file. Detto esplicitamente: "non serve lo script".

**Why:** l'utente vuole vedere e controllare ogni comando prima di eseguirlo, e non accumulare file di appoggio nel filesystem. Uno script nasconde i passaggi dietro un'astrazione che deve comunque rileggere.

**How to apply:** proporre i comandi in blocchi copiabili, uno per passo logico, spiegando cosa fa ciascuno. Creare uno script solo se lo chiede esplicitamente (come in [[segoe-ui-ubuntu-sans-setup]], dove aveva chiesto "fammi uno script che lo metto da parte"). Su questa macchina `sudo` richiede autenticazione interattiva col lettore di impronte, quindi i comandi con sudo vanno eseguiti dall'utente, non da me.
