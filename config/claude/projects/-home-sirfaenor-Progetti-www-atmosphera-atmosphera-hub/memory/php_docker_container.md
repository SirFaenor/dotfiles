---
name: php-docker-container
description: "PHP/Composer/artisan run inside Docker container \"atmosphera-hub_php\" (PHP 8.5), never on the host"
metadata: 
  node_type: memory
  type: reference
  originSessionId: dd6606cc-32ca-479d-8ec5-778ad258e510
---

PHP non è installato sull'host. Tutti i comandi `php`, `composer`, `artisan` vanno eseguiti nel container Docker `atmosphera-hub_php` (immagine `atmosphera-hub-web`, PHP 8.5.6 con Xdebug).

**Come applicare**: prefissare con `docker exec atmosphera-hub_php` (o `docker exec -w /var/www/html atmosphera-hub_php` se serve workdir specifico). Esempi:
- `docker exec atmosphera-hub_php php artisan migrate`
- `docker exec atmosphera-hub_php composer require pacchetto/x`

Altri container del progetto: `atmosphera-hub_nginx`, `atmosphera-hub_db` (mysql:8), `atmosphera-hub_pma`, `atmosphera-hub_smtp` (mailhog), `atmosphera-hub_node` (node:22).
