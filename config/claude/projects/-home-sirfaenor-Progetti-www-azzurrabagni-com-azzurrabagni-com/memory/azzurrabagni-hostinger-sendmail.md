---
name: azzurrabagni-hostinger-sendmail
description: "azzurrabagni.com invia mail via driver sendmail (Hostinger Sendmail Utility), consegna con possibili ritardi, nessuna coda/log exim locale"
metadata: 
  node_type: memory
  type: project
  originSessionId: bc05b607-4b42-4d4f-9f40-0473ae52c96f
---

Su azzurrabagni.com (host Hostinger, `/home/u158652952/websites/Oy9sRrbyu/public_html`) l'invio mail Laravel usa `MAIL_DRIVER=sendmail` (impostato nel `.env` remoto, backup `.env.bak.*`). `/usr/sbin/sendmail` è un symlink a `exim4` che in realtà è la **"Hostinger Sendmail Utility"**: uno shim che inoltra al relay Hostinger, supporta solo `-bm -bs -t -f -i`.

**Why:** non è un vero exim → **non esiste coda né mainlog locale** (`exim -bp`, `/var/log/exim4/` assenti), quindi non si può rintracciare un invio via SSH; il tracciamento va fatto lato casella destinataria. Le mail possono arrivare **con ritardo** (latenza relay Hostinger), non è un bug.

**How to apply:** per verificare la consegna usa un test diretto `php -r 'mail(...)'` sul server (torna `MAIL-OK` se accettato) e poi controlla la casella (anche spam), tenendo conto del possibile ritardo. La config del form contatti gestisce la BCC via `config('mail.contatti.bcc')` in [config/mail.php] usata da ContattiController; il valore effettivo è quello del codice deployato sul server, non fidarsi della copia locale.
