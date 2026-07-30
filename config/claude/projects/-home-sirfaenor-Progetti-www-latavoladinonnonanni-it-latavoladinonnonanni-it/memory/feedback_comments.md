---
name: Preservare i commenti nel codice
description: Non rimuovere commenti esistenti quando si riscrive o si sposta del codice
type: feedback
originSessionId: 30ac8fb8-5ece-4a69-9548-3cf197085efd
---
Non rimuovere mai i commenti presenti nel codice originale quando si riscrivono o spostano file.

**Why:** L'utente li considera parte integrante del codice e non vuole perderli durante il refactoring.

**How to apply:** Quando si copia/sposta/riscrive codice, copiare fedelmente tutti i commenti esistenti (docblock, commenti inline, commenti di sezione). Aggiornare solo il namespace e gli import, non toccare i commenti.
