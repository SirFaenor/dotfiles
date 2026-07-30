---
name: feedback_clean_db_presentation_accessor
description: Tenere i dati puliti in DB e aggiungere il markup di presentazione a runtime via accessor
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 395bae18-eee2-4d45-ac64-895d96ccc9c3
---

Preferenza: mantenere i **dati puliti in DB** (es. il titolo categoria = solo il nome, senza HTML) e aggiungere il markup di presentazione (es. prefisso `<span>Collezione</span>` tradotto) **a runtime**, in punti mirati, tramite un accessor dedicato (es. `ProdcatLang::title_collection`).

**Why:** mettere HTML nei campi DB crea problemi di retro-compatibilità con tutti i consumatori non-HTML (sitemap, JSON-LD, ricerca, liste admin, area download) che usano il valore come testo semplice.

**How to apply:** quando serve markup attorno a un valore mostrato a video, non salvarlo nel campo; crea un accessor che ritorna `HtmlString` e usalo solo nei punti di display che lo richiedono. Per il testo puro (attributi `alt`, iniziali, label) usa il campo grezzo. Vedi anche [[feedback_php_if_braces]].
