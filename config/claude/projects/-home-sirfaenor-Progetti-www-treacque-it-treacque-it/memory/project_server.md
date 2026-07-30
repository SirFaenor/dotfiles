---
name: Remote server info
description: SSH access and infrastructure details for the treacque.it production server
type: project
---

Il server remoto di produzione è raggiungibile via SSH:
- **Host:** treacque.it (Aruba shared hosting, `ssh.nk10yg4.webhostingaruba.it`, porta 2222)
- **Chiave SSH:** `/home/sirfaenor/.ssh/siti/treacque`
- **Web root:** `/web/htdocs/www.treacque.it/home/`
- **PHP:** `/usr/local/bin/php8.4` (non `/usr/bin/php8.4`)
- **Shell di login:** `/bin/false` — SSH funziona solo per comandi diretti, non sessioni interattive (VSCode Remote SSH non supportato)
- **MySQL:** host `31.11.39.161` (non localhost/127.0.0.1), DB `Sql1921331_1`, user `Sql1921331`

**Why:** Aruba shared hosting — MySQL è su host separato, shell ristretta.
**How to apply:** Usare sempre `-i /home/sirfaenor/.ssh/siti/treacque` per SSH. Per comandi artisan remoti: `ssh -i /home/sirfaenor/.ssh/siti/treacque treacque.it "cd /web/htdocs/www.treacque.it/home && /usr/local/bin/php8.4 artisan ..."`.
