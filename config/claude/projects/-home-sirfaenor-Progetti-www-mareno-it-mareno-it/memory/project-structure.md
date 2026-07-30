# mareno.it - Struttura Dettagliata

## Controller principali
| Controller | Responsabilità |
|---|---|
| CategoryController | Catalogo categorie/prodotti |
| ProductController | Singoli prodotti |
| PortfolioController | Portfolio/case study |
| PagesController | Pagine statiche |
| JobController | Offerte lavoro |
| ContactController | Form contatto |
| SitemapController | Sitemap XML |

## Modelli con pattern Lang
Tutti i contenuti traducibili seguono il pattern `Model` + `ModelLang`.
Esempi: Portfolio/PortfolioLang, Product/ProductLang, Category/CategoryLang.

## Comandi Artisan notevoli
- `marvin:function-new` - Crea nuovo tipo contenuto (migration, model, CRUD)
- `portfolio:pdf` - Genera PDF da portfolio
- `portfolio:import` - Import bulk portfolio
- `stores:import` - Import punti vendita
- `highlight:embed` - Embed contenuto esterno

## Database
- MySQL 5.7
- Host (in Docker): `mareno-db-1`
- DB: `mareno`, user: `mareno_usr`
- Tabelle principali: portfolio, portfoliocat, product, category, news, job, store, page, gallery, download, banner
- Tutte con variante `*_lang` per traduzioni
- `revisions` per audit trail

## Frontend
- UIKit 3.6+ come UI framework base
- GSAP 3.6+ per animazioni
- Barba.js per page transitions
- Locomotive Scroll per smooth scrolling
- BrowserSync su porta 8848 per live reload

## Variabili .env rilevanti
- `APP_ENV=local`, `APP_DEBUG=true`
- `CACHE_DRIVER=array` (cache disabilitata in locale)
- `QUEUE_CONNECTION=database`
- `MAIL_DRIVER=log` (in sviluppo)
- `ARTISAN_GUI_ENABLED=true`
- `FORCE_HTTPS=false`
