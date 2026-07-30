# eventi.zalf.com - Project Memory

## Stack
- Laravel 12 + Filament v4 + Livewire
- Docker Compose, PHP runs in container "web"
- Run artisan commands via: `docker compose -f /home/sirfaenor/Progetti/www/zalf.com/eventi.zalf.com/docker-compose.yaml exec web php artisan ...`
- App URL: http://eventi.zalf.localhost

## Users table
- `id`, `firstname`, `lastname`, `fullname` (stored computed), `email`, `password`, `is_admin`, `email_verified_at`, `published`, `starts_at`, `ends_at`
- Fillable: firstname, lastname, email, password, is_admin, email_verified_at, published, starts_at, ends_at
- User model: `app/Models/User.php` — implements `FilamentUser`, `HasName`, uses `HasRoles`, `IsFilamentUser`

## Filament Panels
- **admin** panel: `app/Providers/Filament/AdminPanelProvider.php` — uses `PanelDefaults::make()` from atrioteam/filament-helper, adds Shield, MinimalTheme
- **user** panel: `app/Providers/Filament/UserPanelProvider.php` — public panel (no authMiddleware), path `/user`
  - Pages: `app/Filament/User/Pages/`
  - Home redirect: `/user` → `/user/registrazione`

## Filament v4 Key Patterns
- Form API uses `Schema` not `Form`: `form(Schema $schema): Schema`
- `Page::content(Schema $schema)` defines page content — use `Form::make([EmbeddedSchema::make('form')])` + `Actions::make()`
- `SimplePage` does NOT have `registerRoutes` → cannot be used in `->pages([])`
- For public pages with simple layout, extend `Page` and set:
  - `protected static string $layout = 'filament-panels::components.layout.simple';`
  - `protected string $view = 'filament-panels::pages.simple';`
  - Add `use HasMaxWidth; use HasTopbar;` traits
  - Add `hasLogo(): bool` method
  - Override `getLayoutData()` with hasTopbar/maxContentWidth
- Panels with no `->authMiddleware()` call are publicly accessible by default

## Key Files
- `bootstrap/providers.php` — service providers list
- `app/Providers/Filament/AdminPanelProvider.php`
- `app/Providers/Filament/UserPanelProvider.php`
- `vendor/atrioteam/filament-helper/src/PanelDefaults.php` — admin panel defaults

## atrioteam/filament-helper
- `PanelDefaults::make($panel)` configures admin panel with auth, Shield, MinimalTheme, Translatable plugin
- Custom Login: `AtrioTeam\FilamentHelper\Filament\Pages\Auth\Login`
