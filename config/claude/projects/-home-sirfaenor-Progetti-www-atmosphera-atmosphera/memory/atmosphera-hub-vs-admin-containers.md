---
name: atmosphera-hub-vs-admin-containers
description: "atmosphera-hub e atmosphera-admin sono due progetti Laravel separati con stack docker distinti, facilmente confondibili"
metadata: 
  node_type: memory
  type: project
  originSessionId: 52a62310-cc54-49d6-87bf-d8b6176e0f8b
  modified: 2026-07-28T12:59:29.542Z
---

`atmosphera-hub` (in `/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-hub`) e `atmosphera-admin` (in `/home/sirfaenor/Progetti/www/atmosphera-hub/atmosphera-admin`) sono due progetti Laravel **separati**, ognuno con il proprio stack docker-compose. `atmosphera-hub` è il PIM/DAM centrale; `atmosphera-admin` è un client CMS che sincronizza dati da esso (vedi [[php-container]]).

**Why:** i container hanno spesso lo stesso pattern di nome (`${COMPOSE_PROJECT_NAME}_php`, `_node`, ecc.) e capita che uno dei due stack sia in esecuzione e l'altro fermo (o viceversa). Durante un lavoro su atmosphera-admin, `docker ps` mostrava `atmosphera-hub_php` attivo (progetto sbagliato) mentre `atmosphera-admin_php` era fermo da giorni: un `composer require` lanciato su `atmosphera-hub_php` non ha toccato affatto il composer.json di atmosphera-admin (bind mount da directory diversa), fallendo silenziosamente ("Nothing to modify in lock file") senza errori evidenti.

**How to apply:** prima di eseguire comandi `docker exec` su un progetto, verificare sempre con `docker inspect <container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{end}}'` che il bind mount corrisponda alla directory del progetto su cui si sta lavorando, oppure controllare `docker ps` per lo stato esatto del container atteso (`${COMPOSE_PROJECT_NAME}_php` da `.env` del progetto). Se il container giusto è fermo, avviarlo con `docker compose up -d` dalla directory del progetto prima di procedere.
