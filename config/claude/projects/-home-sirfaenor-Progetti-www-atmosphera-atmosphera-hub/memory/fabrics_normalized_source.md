---
name: fabrics_normalized_source
description: Tessuti interior e outdoor.xlsx è la fonte normalizzata dei tessuti (dati tecnici); join col vecchio listino CAPITAL via Codice normalizzato
metadata: 
  node_type: memory
  type: project
  originSessionId: 87e50ed6-e9eb-43ab-8e47-ced9e620e0cf
  modified: 2026-07-20T11:04:47.717Z
---

`storage/app/private/import/Tessuti interior e outdoor.xlsx` (aggiornato 2026-07-20) è la fonte
normalizzata dei tessuti: 2 fogli INTERIOR (191 righe) / OUTDOOR (142), stesse 19 colonne,
porta i **dati tecnici** (composizione, certificazioni 0/1, altezza, peso, abrasione,
solidità, pilling, scheda tecnica). I codici non si sovrappongono tra i due fogli.

Importato da `app:import-fabrics` (`ImportFabrics`) — vedi roadmap task #32, fatto il
2026-07-20: reset di `fabrics` e reimport, 332 colori su 14 tipologie.

Il concetto di "listino CAPITAL" è stato **abbandonato** (decisione utente, 2026-07-20): le
6 colonne commerciali su `fabrics` sono droppate, la sezione "Dati listino" è fuori dal form.
Resta solo il parsing in `ImportCapitalFabricPrices`, non in uso e non funzionante (scrive
colonne che non esistono più), come riferimento se i dati commerciali torneranno.

**Join fra i due file**: colonna `Codice` del file nuovo vs colonna P (`CODICE`/sku) del
vecchio, **dopo aver rimosso tutti gli spazi** (il file nuovo scrive `VL 015`, `PV 034`,
`MSBO 01`; 42 righe hanno spazio interno, 13 hanno spazio/NBSP `\xa0` in coda).
Così matchano 68/77. I 9 non matchati sono `MAGI*` = pelle sintetica del vecchio listino,
sostituita nel nuovo dalla famiglia `Fenice` (FENI01-11) → cambio di gamma, non un errore.

**Decisioni dell'utente sulla normalizzazione** (2026-07-20):
- `PN002` è duplicato su INTERIOR (righe 120 e 122, identiche) → saltare il duplicato in import.
- Le 2 righe "Teli di copertura" (TCOBEI, TCODAR) hanno `Teli di copertura` anche nella
  colonna Categoria A/B/C → categoria prezzo **null**.
- Solidità del colore e Pilling restano **stringhe libere** (su INTERIOR contengono la norma
  nella cella, su OUTDOOR sono valori puri): niente parsing, non filtrabili.
- `NON PFAS` = 0 su tutte le righe INTERIOR è **corretto**, non è un "non compilato".

**Why:** il file consolida passate precedenti incoerenti; senza queste regole l'import
duplica record o rompe l'unicità del codice.

**How to apply:** i flag del file sono `BooleanCell` per OpenSpout, quindi arrivano come bool
PHP: vanno intercettati prima del cast a stringa, perché `(string) false` è `''` e finirebbe
in null invece che in 0 (bug preso in fase di import, vedi `ImportFabrics::bool()`).
Dopo ogni reimport dei colori il pivot `fabric_product` si azzera via cascade: va rigenerato
con `app:import-indoor --fabrics-only`, **mai** con `app:import-indoor` liscio, che cancella
e ricrea tutti i prodotti Indoor.
