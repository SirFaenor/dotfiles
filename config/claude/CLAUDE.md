## Feedback

- **Non rimuovere i commenti dell'utente** quando editi un file. I commenti aggiunti manualmente dall'utente vanno preservati, anche se sembrano ridondanti o non necessari.

## Trigger / istruzioni

- Quando l'utente dice **"migra il sito per hostinger agency"** (o varianti), eseguire il playbook [hostinger-agency-migration.md](memory/hostinger-agency-migration.md): fix Livewire per nginx, fix login Marvin (solo se Marvin è nel progetto) e setup/verifica del deployment GitHub Actions verso Hostinger. Applicare solo i passi pertinenti al progetto corrente.

## Memoria globale (cross-project)

- [Livewire 3 + Marvin CMS dietro nginx](memory/livewire-marvin-nginx.md) — fix route livewire.js 404 e login Marvin con cartella public/admin reale.
- [Playbook migrazione Hostinger Agency](memory/hostinger-agency-migration.md) — passi per Livewire/Marvin su nginx + deployment Hostinger.
- [OPcache FPM stale su Hostinger → form Livewire 405](memory/hostinger-opcache-stale-livewire.md) — dopo deploy il backend Livewire resta vecchio in OPcache, il submit fa POST nativo su route GET = 405.
