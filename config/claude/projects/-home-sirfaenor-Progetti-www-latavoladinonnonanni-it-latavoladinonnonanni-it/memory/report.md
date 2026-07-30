# Package: report

**Namespace:** `App\Report\`
**Path:** `packages/report/`
**Provider:** `ReportServiceProvider` — singleton `ReportFileGenerator`, 3 comandi console

## Models
- `Report` — container report (tabella `stats_reports`). Belongs to Activity. Metodi: `makeHash()` (filtri parametri), `getParamsDescriptions()`
- `ReportField` — statistiche singolo campo
- `ReportFieldAnswer` — dati aggregati risposte
- `Average` — valori medi e aggregazioni

## Services
- `ReportFileGenerator` — genera CSV da report data (headers configurabili, esclusioni colonne)

## Answer Processors (14)
Elaborano risposte per tipo campo: LongText, ShortText, Radio, Checkbox, RadioImage, Image, BirthDate, FiscalCode, Video, Pdf, Instagram, Terms, Hidden

## Answer Reports (6)
- `BaseReport`, `ResponsesReport`, `RadioReport`, `CheckboxReport`, `RatingReport`, `ProductReport`

## Jobs & Notifications
- `MakeActivityReport` — job queued per generazione report
- `ReportCompletedNotification` — notifica completamento

## Commands
- `ActivityReport` — genera report attività
- `ActivityReportCsv` — export CSV
- `ActivityResponses56` — aggregazione specifica
- `Average` — calcola medie
