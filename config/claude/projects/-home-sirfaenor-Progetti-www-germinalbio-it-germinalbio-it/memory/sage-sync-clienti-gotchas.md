---
name: sage-sync-clienti-gotchas
description: Insidie del sync clienti Sage↔web (CustomersImport/UserExport) e bug di duplicazione utente su sage_uuid
metadata: 
  node_type: memory
  type: project
  originSessionId: 1578c4fd-5072-4edb-8de4-9f93d07077ea
---

Sync anagrafiche clienti tra gestionale Sage (connessione `datasync`) e DB web,
package `app/bgo`. Documentazione completa + case history in
`packages/app/bgo/docs/sync-clienti-gotchas.md`.

Punti non ovvi da ricordare:

- **Sage scrive su `web_customers` con UPDATE diretti in DB** (utente DB `bgo@`),
  bypassando Eloquent → `updated_at` NON è affidabile (non viene aggiornato dai
  sync), nessuna `revisions` generata. Per datare un sync usare
  `sage_last_import_at`. Per ricostruire la storia degli update diretti di Sage:
  tabella `logs` su connessione `datasync` (campo `data` NON logga `sage_uuid`).
- **`web_customers.sage_uuid` può essere scritto da Sage dopo la creazione**,
  anche se `UserExport` lo valorizza solo alla creazione del record.
- **`CustomersImport` ha due cicli con chiavi di matching scollegate**: 1° ciclo
  (su `sage_customers`) abbina per sage_uuid/email via
  `SageCustomer::findOrCreateLocalUser()`; 2° ciclo (su `web_customers`) abbina
  per `web_uuid`. Fix applicato: il 1° ciclo ora controlla anche se un
  `web_customer` porta già quel sage_uuid e riusa l'utente collegato (a
  prescindere dall'email) — evita doppioni.
- **L'indice `users.users_sage_uuid_unique` vale anche per i soft-deleted**: per
  liberare un sage_uuid occupato da un record spazzatura serve `forceDelete()`
  (hard delete), non basta il soft-delete.

Case history reale: doppione utente su `G2010418` (Hotel Quelle), giugno 2026,
failed_jobs 304 — dettaglio nel file di docs sopra.
