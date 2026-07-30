---
name: staboo-configuratore-stato
description: "Stato e decisioni tecniche del progetto configuratore prodotto Staboo (pre-offerta, luglio 2026)"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3ef7e0b-998c-4fad-a6d2-dd7fe8ad2a63
---

Cliente **Staboo**: portale configuratore/generatore schede tecniche PDF per pannelli (OSB/FSB). Requisiti nel docx `Progetto_Configuratore_Prodotto_v1.1.docx` (cartella progetto): ~30 commerciali, catalogo 4.000→100.000 prodotti, 8 parametri di filtro, logica "Vedi di più" (match parziali 1-2 parametri, pari peso), PDF brandizzato multilingua (riferimento scheda EGGER, non ancora fornita), target go-live Interzum 2027. Fasi: 1 MVP, 2 ERP, 3 Salesforce, 4 SSO/Mixer.

Decisioni prese (2026-07-09) per la risposta al cliente:
- **App Laravel dedicata** su sottodominio (es. configuratore.staboo.com), **VPS dedicato in UE/Germania** (Hetzner o Hostinger), canone VPS + gestione sistemistica.
- **Login standalone (scenario A)** in Fase 1; SSO Entra ID come evoluzione, possibile convivenza (SSO interni + credenziali locali agenti).
- **Ricerca**: MySQL Scout-ready in Fase 1; **Meilisearch come upgrade dichiarato**; "Mixer" quotato come opzione legata a quell'upgrade. "Vedi di più" da implementare lato app (N query con un parametro rilasciato alla volta).
- **PDF via Api2Pdf** a consumo (tier a carico cliente); nota trasparenza: rendering extra-UE ma solo dati tecnici, no GDPR.
- **Versioning schede**: revisione auto-incrementata su rilevamento modifiche dati (hash del record), niente override manuale.
- **DB locale del cliente**: effort import non stimabile senza campione dati; da capire anche import asset (immagini) prodotto. Possibile alternativa: catalogo gestito direttamente nel portale (proposta nostra, NON nel documento cliente).
- ERP fase 2: fonte dati dietro repository layer; possiamo anche esporre API di scrittura verso di loro.

Il file `2026.07.09 Staboo - configuratore prodotto.md` nella cartella è l'appunto interno (riscritto dall'utente dalla mia bozza) destinato al collega commerciale — non modificarlo senza richiesta. Elementi mancanti dal cliente: campione DB, lista completa parametri, scheda EGGER + brand book, elenco mercati e regola prodotto→mercato.
