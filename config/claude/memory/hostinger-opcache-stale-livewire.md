---
name: hostinger-opcache-stale-livewire
description: Su Hostinger (h5g) form Livewire restituisce 405 dopo aggiornamento per OPcache FPM bloccato su bytecode vecchio
metadata:
  type: reference
---

Riscontrato su technowrapp.com (2026-06-30). Sintomo: l'invio di un form Livewire 2 restituisce **405 Method Not Allowed**.

## Catena causale
- 405 = **submit nativo** del `<form method="post" wire:submit.prevent>` che finisce in POST sulla pagina stessa (route solo GET), perché Livewire JS non aggancia più il submit.
- Causa: **mismatch versione Livewire frontend/backend**. Il deploy aggiorna Livewire su disco e ripubblica `livewire.js` (nuovo), ma **PHP-FPM esegue ancora il bytecode vecchio** perché l'OPcache non è stato invalidato.

## Prove diagnostiche (senza browser)
- Nella pagina compare `window.livewire = new Livewire()` **senza argomenti** → backend vecchio (v2.12.8 genera `new Livewire({...options})`).
- Warning `"published Livewire assets are out of date"` + letterale `{$nonce}` nell'HTML, **impossibili** dal `LivewireManager.php` a disco (manifest byte-identici, heredoc interpolante). Verificabile via SSH: `cmp vendor/livewire/livewire/dist/manifest.json public/vendor/livewire/manifest.json`.
- Endpoint `/livewire/message/<component>` in POST risponde 419 (raggiunge Laravel), quindi la route Livewire funziona: il 405 è solo il submit nativo.

## Perché l'OPcache resta vecchio
- Il deploy GitHub Actions usa `rsync -a` che **preserva le mtime**: i file di `vendor/livewire` arrivano con la data del pacchetto (es. 2024-07-13), non quella del deploy.
- Il pool PHP-FPM ha `validate_timestamps` di fatto **off** (sul CLI risulta on, ma il pool no), quindi non ricompila finché FPM non riparte.
- `artisan optimize:clear/optimize` **non** resetta l'OPcache di FPM (gira in SAPI CLI).
- Ambiente Hostinger h5g isolato: da SSH **non** si raggiunge il processo/socket FPM né cachetool.

## Fix
- **Immediato (manuale, hPanel):** Websites → sito → Avanzate → Configurazione PHP → cambia versione PHP, salva, rimettila e salva → riavvia FPM e svuota OPcache.
- **Durevole:** route protetta `/__opcache-reset/{token}` che chiama `opcache_reset()`, richiamata via `curl` in fondo a `.scripts/deploy.sh` (gira in contesto FPM, l'unico che resetta davvero). In alternativa touch di tutti i `.php` nel deploy se il pool FPM ha `validate_timestamps=On`.

Collegato a [[hostinger-agency-migration]] e [[livewire-marvin-nginx]].
