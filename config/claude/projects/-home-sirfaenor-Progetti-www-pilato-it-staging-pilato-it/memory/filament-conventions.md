# Convenzioni Filament – staging.pilato.it

## Struttura cartelle resource

```
app/Filament/Resources/NomePlurali/
├── NomeSingolareResource.php      ← main resource (solo delega)
├── Schemas/
│   └── NomeSingolareForm.php      ← logica form
├── Tables/
│   └── NomePluraliTable.php       ← logica table
└── Pages/
    ├── ListNomePlurali.php
    ├── CreateNomeSingolare.php
    └── EditNomeSingolare.php
```

## Resource principale

```php
namespace App\Filament\Resources\ProductCategories;

class ProductCategoryResource extends Resource
{
    protected static ?string $model = ProductCategory::class;
    protected static BackedEnum|string|null $navigationIcon = 'heroicon-o-tag';

    public static function getNavigationGroup(): ?string  { return 'Prodotti'; }
    public static function getNavigationLabel(): string   { return 'Categorie prodotto'; }
    public static function getPluralModelLabel(): string  { return self::getNavigationLabel(); }
    public static function getModelLabel(): string        { return 'Categoria prodotto'; }

    public static function form(Schema $schema): Schema
    {
        return ProductCategoryForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ProductCategoriesTable::configure($table);
    }

    public static function getPages(): array
    {
        return [
            'index'  => ListProductCategories::route('/'),
            'create' => CreateProductCategory::route('/create'),
            'edit'   => EditProductCategory::route('/{record}/edit'),
        ];
    }
}
```

## Form (Schemas/NomeForm.php)

```php
namespace App\Filament\Resources\ProductCategories\Schemas;

class ProductCategoryForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema->schema([
            // campi NON tradotti in Section normale
            Section::make()->schema([
                ColorPicker::make('color')->label('Colore'),
            ]),

            // campi TRADOTTI in TranslationSection (crea tab IT/EN automaticamente)
            // ->seoFields() aggiunge slug + meta_title + meta_description per locale
            TranslationSection::make('Testi')->schema([
                TextInput::make('title')->label('Titolo')->required(),
                TextInput::make('short_title')->label('Titolo breve'),
            ])->seoFields(ProductCategory::class, slugSource: 'title'),

            // media (Spatie) fuori da TranslationSection
            // SEMPRE usare MediaGallery (AtrioTeam), mai SpatieMediaLibraryFileUpload direttamente
            Section::make('Hero')->schema([
                MediaGallery::make('hero_video')
                    ->collection('hero_video')
                    ->maxItems(1)
                    ->configureFileInput(fn ($input) => $input->acceptedFileTypes(['video/mp4', 'video/webm'])),

                // testo tradotto dentro la section
                TranslationSection::make('Testo hero')->schema([
                    RichEditor::make('hero_text')->label('Testo hero (HTML)'),
                ]),
            ])->columns(1),
        ]);
    }
}
```

## Table (Tables/NomeTable.php)

NON includere mai la colonna `created_at` nelle tabelle delle resource.

```php
namespace App\Filament\Resources\ProductCategories\Tables;

class ProductCategoriesTable
{
    public static function configure(Table $table): Table
    {
        $table
            ->columns([...])  // NO created_at
            ->filters([]);

        return TableDecorator::make($table, ProductCategory::class);
    }
}
```

## Pages

```php
// List
class ListProductCategories extends ListRecords
{
    use CustomListPage;  // AtrioTeam
    protected static string $resource = ProductCategoryResource::class;
}

// Create / Edit
class CreateProductCategory extends CreateRecord
{
    use CustomInputPage;  // AtrioTeam
    protected static string $resource = ProductCategoryResource::class;
}
```

## Migration

```php
use AtrioTeam\FilamentHelper\Database\SeoMigration;
use AtrioTeam\FilamentHelper\Database\PublicationMigration;

Schema::create('product_categories', function (Blueprint $table) {
    $table->id();
    $table->json('title')->nullable();           // translatable → json
    $table->json('short_title')->nullable();
    $table->string('color', 20)->nullable();     // non tradotto → tipo nativo
    $table->json('hero_text')->nullable();
    SeoMigration::up($table);                    // slug + meta_title + meta_description
    PublicationMigration::up($table);            // published_at, sort (NON aggiungere sort manualmente)
    $table->timestamps();
});
```

## Model

```php
class ProductCategory extends Model implements HasMedia
{
    use HasTranslations;
    use InteractsWithMedia;

    protected $fillable = ['title', 'short_title', 'color', 'hero_text', 'slug', 'meta_title', 'meta_description'];

    public $translatable = ['title', 'short_title', 'hero_text', 'slug', 'meta_title', 'meta_description'];

    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('hero_video')->singleFile();
    }
}
```

## Import Filament v4 da ricordare

```php
use Filament\Schemas\Schema;                    // NON Filament\Forms\Form
use Filament\Schemas\Components\Section;        // NON Filament\Forms\Components\Section
use Filament\Forms\Components\TextInput;        // i field rimangono in Forms\Components
use AtrioTeam\FilamentHelper\Filament\Forms\Components\TranslationSection;
use AtrioTeam\FilamentHelper\Filament\Forms\Components\MediaGallery;  // per upload file
use AtrioTeam\FilamentHelper\Filament\Tables\Decorators\TableDecorator;
use AtrioTeam\FilamentHelper\Filament\Pages\Traits\CustomListPage;
use AtrioTeam\FilamentHelper\Filament\Pages\Traits\CustomInputPage;
```
