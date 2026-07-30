---
name: feedback_phpstan_template_config
description: "eseguire PHPStan sempre con la config del template, mai su path isolati"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ec20390f-b2fd-42ca-b273-13dd0a3eb669
---

Eseguire PHPStan SEMPRE con la configurazione dell'utente: dal container,
`cd /var/www && vendor/bin/phpstan analyse` (usa `atmosphera-hub/phpstan.neon`).
Mai passare path di file isolati.

**Why:** la config del template ha `paths: [app, config, database, routes, ../digital-hub/src]`
ed `excludePaths: [vendor/*]`. Il package `digital-hub` è symlinkato in `vendor/`,
quindi analizzare un file via path `vendor/atrioteam/digital-hub/...` lo ESCLUDE
silenziosamente (`vendor/*`) → falso "No errors" / "No files found". Va analizzato
via `../digital-hub/src` (cioè lasciando che sia la config a includerlo).

**How to apply:** per validare codice del core, lancia il phpstan completo senza
argomenti (eventualmente `clear-result-cache` prima). Il livello è `max`.
Lo stub `../digital-hub/stubs/Table.stub` definisce il macro `digitalHubTable()`.
Vedi [[php_docker_container]].
