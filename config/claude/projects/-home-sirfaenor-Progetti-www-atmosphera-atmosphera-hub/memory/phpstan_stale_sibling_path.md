---
name: phpstan-stale-sibling-path
description: "PHPStan analizza packages/digital-hub/src (subtree attiva); lanciare con `composer analyse`"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7673379d-8481-4eb1-a743-34afa7d740a0
---

Il codice del package core **effettivamente caricato** è `packages/digital-hub`
(vendor/atrioteam/digital-hub → symlink a packages/digital-hub; repo Composer
path su `./packages/digital-hub`), NON la cartella sibling
`/home/sirfaenor/Progetti/www/atmosphera-hub/digital-hub`.

`phpstan.neon` ora analizza correttamente `packages/digital-hub/src` con stub
`packages/digital-hub/stubs/Table.stub` (risolto il 2026-06-25; prima puntava
alla sibling `../digital-hub`, path stale pre-subtree non montato nel container
Docker → falliva con "Stub file /var/digital-hub/stubs/Table.stub does not
exist").

Stesso problema/fix per **php-cs-fixer**: `.php-cs-fixer.dist.php` ora include
`packages/digital-hub/src` (non `../digital-hub/src`).

**Comandi** (nel container `atmosphera-hub_php`, vedi [[php_docker_container]]):
- `composer analyse` (= `phpstan analyse --memory-limit=1G`), `composer
  analyse:baseline` per rigenerare la baseline.
- `composer fix` (php-cs-fixer apply), `composer fix:check` (dry-run).

Coerente con [[feedback_phpstan_template_config]].
