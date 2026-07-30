# Package: development

**Namespace:** `App\Development\`
**Path:** `packages/development/`
**Provider:** `DevelopmentServiceProvider` — registra 14 comandi console

## Purpose
Utility di sviluppo, debugging e manutenzione. Solo comandi console, nessun modello.

## Commands (14)
- `NormalizeAnonymizedUsers` — anonimizzazione utenti
- `UpdateRanking` — aggiorna classifiche
- `UserActivitiesReport` — report attività utenti
- `AddPoints` / `CancelPoints` — gestione punteggi
- `FixPointsDeducted` — fix deduzioni punti
- `UnsubscribeDeletedUsersFromNewsletter` — cleanup utenti cancellati
- `UserRecipeMediaCopy` — gestione media ricette
- `ResendEmailVerification` — reinvio email verifica
- `NormalizeProvince` — normalizzazione province
- `LoadOrCreateUser` — creazione/caricamento utenti
- Debug notifications: `UserRecipeApproved`, `Published`, `Rejected`

## Structure
- `Console/Commands/` — comandi principali
- `Console/Commands/AdHoc/` — comandi ad-hoc per eventi specifici
- `Console/Commands/Debug/Notifications/` — debug notifiche
- `Concerns/Console/Commands/` — trait condivisi
