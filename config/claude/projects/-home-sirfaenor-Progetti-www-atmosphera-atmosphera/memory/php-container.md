---
name: php-container
description: "In atmosphera-admin i comandi PHP/artisan vanno eseguiti dentro il container web, non sull'host"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d8b2803-e7ad-4329-95f2-0726af7a7863
  modified: 2026-07-28T12:51:27.138Z
---

I comandi PHP (`php artisan`, `composer`, `tinker`, ecc.) di **atmosphera-admin** vanno eseguiti dentro il container web, non sull'host. Il nome container è `${COMPOSE_PROJECT_NAME}_php` (da docker-compose.yaml): a seconda del valore di `COMPOSE_PROJECT_NAME` nell'.env può essere `atmosphera-admin_php` o, dopo rinomina progetto, `atmosphera-hub_php` — verificare con `docker ps` prima di assumere il nome. Per npm/node c'è analogamente `${COMPOSE_PROJECT_NAME}_node`.

Esempio: `docker exec atmosphera-hub_php php artisan ...`

**Why:** Sull'host il PHP FPM richiesto non è disponibile; l'ambiente PHP corretto vive nel container Docker del progetto. Il nome container è cambiato nel tempo (rinomina progetto da atmosphera-admin ad atmosphera-hub), da qui la necessità di verificare con `docker ps` invece di assumere un nome fisso.

**How to apply:** Prima di ogni comando PHP/npm, verificare il nome container attuale con `docker ps`, poi prefissare con `docker exec <nome_container>`.
