---
name: feedback-never-migrate-fresh
description: "Never run migrate:fresh (or other DB-wiping commands) on the project database without explicit permission, even in local dev"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f3b71b3e-abc4-4747-b53f-7a5984298f63
  modified: 2026-07-23T14:27:21.970Z
---

Non lanciare mai `php artisan migrate:fresh` (o equivalenti distruttivi: `db:wipe`,
drop/truncate manuali) sul database del progetto senza chiedere esplicitamente
all'utente prima, anche se l'ambiente è locale/dev (`APP_ENV=local`).

**Perché**: l'utente mi ha corretto duramente dopo che ho girato `migrate:fresh
--seed` più volte di fila per validare l'introduzione di spatie/permission +
filament-shield (13 luglio 2026). Il DB locale può contenere dati di lavoro
non ripristinabili dai seeder (record creati a mano, esperimenti in corso),
e "è solo dev" non è una giustificazione sufficiente: è comunque un'azione
distruttiva e irreversibile che va confermata, coerente con la policy generale
del Safety Protocol su azioni difficili da annullare.

**Come applicarla**: per validare una nuova migration o un seeder, preferire
`php artisan migrate` (incrementale) + seeding mirato/idempotente. Se serve
davvero uno stato pulito per testare un flusso end-to-end (es. dopo aver
introdotto tabelle nuove che richiedono un giro pulito), chiedere prima
esplicitamente il permesso, spiegando perché non basta l'incrementale.

**Aggiornamento (23 luglio 2026)**: l'utente ha chiarito che *sui comandi in
generale non vuole essere interrotto* per chiedere permessi dentro la cartella
di progetto — l'unico limite che resta è questo: **non droppare né troncare
tabelle del database**. Quindi: piena autonomia sui comandi (artisan, docker,
git, script di verifica), ma le operazioni distruttive sul DB restano da
confermare. Per provare un flusso end-to-end su stato pulito, la strada
preferita è creare un **database di scarto separato** (es.
`atmosphera_sqlcheck`) e lavorare lì, senza toccare `atmosphera`.
