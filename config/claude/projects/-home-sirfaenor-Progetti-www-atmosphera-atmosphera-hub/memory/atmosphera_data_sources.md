---
name: atmosphera_data_sources
description: "Dove stanno i dati sorgente del catalogo Atmosphera (indoor xlsx, outdoor PDF) e come estrarli"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6eea22b0-0f86-4d33-99ef-0c3c6fabb9d6
---

Fonti dati catalogo in `/home/sirfaenor/Progetti/Appunti e Schemi/2026.05 Atmosphera/dati/`:
- `INDOOR/Maschera_racolta_dati.xlsx` — maschera di raccolta dati indoor (foglio "Techincal section", colonne: Destinazione, Ambiente, Collezione, Categoria/tipologia, Designer, Anno, WDH, DH, H seat, H arm, A legs, Weight, W Wood, W Marble, WA Bar C*, Volume). È lo stesso template di `storage/app/private/import_dati.xlsx` già importato via `app:import-catalog`.
- `OUTDOOR/Atmosphera_OUTDOOR_CATALOGUE_2026.pdf` — catalogo outdoor (235 pagine PDF, layout **spread**: ogni pagina PDF = 2 pagine stampate, 963.78pt larghezza). I dati quotati sono nella **Technical Section** (PDF pagg. 211-231, 4 colonne da ~240pt).
- `OUTDOOR/Atmosphera_OUTDOOR_prodotti_estratti.xlsx` — elenco prodotti outdoor (~146 righe) estratto dal PDF, sulla falsariga della maschera indoor.

Estrazione PDF outdoor (best-effort): `pdftotext -layout` con crop per colonna (`-x N*241 -W 241`) per de-interlacciare le 4 colonne; ambiente ricavato dal `P. <pag>` di ogni blocco → capitolo (Living 8-185, Dining 186-285, Sunbeds 286-335, Accessories 336-357). poppler (`pdftotext`/`pdfinfo`) è sull'host, non nel container. Vedi [[php_docker_container]] e [[deployment_webhook_pull]].
