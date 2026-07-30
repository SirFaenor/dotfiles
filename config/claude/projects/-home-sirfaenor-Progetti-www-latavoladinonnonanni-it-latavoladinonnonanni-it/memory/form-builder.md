# Package: form-builder

**Namespace:** `App\FormBuilder\`
**Path:** `packages/form-builder/`
**Provider:** `FormBuilderServiceProvider` — registra macro `filterByMeta()` su Collection

## Models
- `Form` — container polimorfico, soft deletes, traduzioni
- `FormSection` — organizza i field in sezioni
- `FormField` — campo del form (question, field_type, properties, meta). Cascade delete su options e relateds nel `booted()`
- `FormFieldOption` — opzioni per campi a scelta (label translatable, value, image, sort)
- `FormFieldRelated` — relazioni tipizzate (type enum, label translatable, sort). Tabella: `form_field_relateds`
- `FormResponse` — risposta utente al form
- `FormResponseField` — singola risposta a un campo
- `HasForm` — trait per modelli polimorfici che hanno un form

## Enums
- `FieldTypeEnum` — 27 tipi campo. Metodi: `classmap()`, `label()`, `icon()`, `factory()`, `aggregateReport()`
- `FieldRelatedTypeEnum` — tipi related (`Column`). Metodi: `label()`, `labelForAddAction()`

## Field Types (27)
Text: ShortText, LongText | Select: Select, SelectMultiple, Radio, Checkbox | Image: ImageRadio, ImageCheckbox | Matrix: RadioTable | Rating: Rating, Score | Product: ProductSelect | Media: UploadImage, UploadFile, UploadVideo, Signature | Meta: BirthDate, FiscalCode, Instagram | Compliance: Terms, Acceptance | Other: Hidden, CustomView

## Architecture
- `BaseField` (abstract Component) → implements `IsFormField` contract
- `FieldFactory` — crea istanze campo da enum/model
- Traits Filament: `HasOptionsRepeater`, `HasRelatedsRepeater` (in `src/Concerns/`)
- Services: `FormResponseService` — init risposte e submit risposte
- Constraints: `SameQuestionCannotBeAnsweredTwice`

## Testing
- Factories: `FormFactory`, `FormSectionFactory`, `FormFieldFactory`, `FormResponseFactory`, `FormResponseFieldFactory`
- Test trait: `FieldTestSupport` (in `src/Tests/`) — metodi helper: `factory()`, `testVariableRequired()`, `testMaxChoices()`, `testSingleChoice()`, `testAllowedOptions()`, `testMaxLength()`, `testFileUploadField()`
- Test dir: `tests/Fields/`, `tests/Models/`, `tests/Feature/`
