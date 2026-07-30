---
name: Route registration
description: Le route frontend del sito sono definite in resources/lang/vendor/lintilla/links.json (non in routes/web.php)
type: reference
---

Le route frontend localizzate sono registrate nel file:

`resources/lang/vendor/lintilla/links.json`

Il sistema lintilla le carica tramite `AtrioTeam\Lintilla\Localization\Router` (registrato in `AppServiceProvider`).

Ogni entry ha: `code`, `type`, `filename` (Controller@method o blade), `link_it`, `link_en`, ecc.
I nomi delle route nel codice hanno il suffisso `_it` / `_en` (es. `download_all_it`), ma `route('download_all', ...)` funziona grazie al helper di lintilla.
