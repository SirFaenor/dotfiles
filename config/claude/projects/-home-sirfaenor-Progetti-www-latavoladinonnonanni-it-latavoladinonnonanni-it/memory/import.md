# Package: import

**Namespace:** `App\Import\`
**Path:** `packages/import/`
**Provider:** `ImportServiceProvider`

## Purpose
Migrazione dati da sistemi legacy ACL/SSO all'applicazione corrente.

## Models (Legacy DB)
- `UserAcl` — tabella `users` su connessione `old_acl`. Relazione: `data()` → `UserData`
- `UserSso` — tabella `users` su connessione `old_sso`
- `UserData` — metadati utente legacy, calcolo punteggi (`retrieveScores()`)

## Commands (6)
- `ImportUsers` — migra utenti da sistema legacy
- `ImportProfileFields` — sincronizza campi profilo
- `ImportPoints` — trasferisce punteggi
- `ImportActivities` — importa attività
- `ImportResetPoints` — reset punteggi (manutenzione)
- `ImportMultiplyPoints` — moltiplica punteggi
