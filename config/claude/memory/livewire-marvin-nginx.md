---
name: livewire-marvin-nginx
description: Fix per far girare Livewire (2 e 3) e il login Marvin CMS dietro nginx (livewire.js 404 + cartella public/admin reale)
metadata:
  type: reference
---

Due fix ricorrenti quando un progetto Laravel + Livewire 3 + Marvin CMS passa da Apache a **nginx** (riscontrati su mareno.it, commit 10e3fb6 e 5eace88 del 2026-06-24).

## 1. Livewire.js 404 su nginx
nginx serve `livewire.js` come file statico per via del punto nell'URL e restituisce 404. La soluzione dipende dalla versione di Livewire.

### Livewire 3 (mareno.it)
Si forza una route senza punto in `AppServiceProvider::boot()`:

```php
use Illuminate\Support\Facades\Route;
use Livewire\Livewire;

Livewire::setScriptRoute(function ($handle) {
    return Route::get('/livewire/livewirejs', $handle);
});
```

Rif: https://benjamincrozat.com/livewire-js-404-not-found e https://laracasts.com/discuss/channels/livewire/has-anyone-got-livewire-3-running-in-production-on-a-nginx-server

### Livewire 2 (sartobikes.com, v2.12.8, commit 0339f4e del 2026-06-23)
`setScriptRoute()` non esiste in Livewire 2. Si pubblicano gli asset come **file statici reali**, che nginx serve direttamente:
- aggiungere `@php artisan livewire:publish --assets` a `post-autoload-dump` in `composer.json` (così gira ad ogni deploy)
- committare gli asset pubblicati: `public/vendor/livewire/livewire.js`, `livewire.js.map`, `manifest.json`

## 2. Login Marvin CMS su nginx
La cartella `public/admin/` esiste davvero, quindi nginx non instrada `/admin` verso Laravel. Soluzione:
- `public/admin/index.php` fa un redirect statico: `header('Location: /admin/login'); exit;`
- route alternativa in `routes/web.php`:

```php
use AtrioTeam\Marvin\App\Http\Controllers\LoginController;

Route::get('/admin/login', [LoginController::class, 'showLoginForm'])->name('marvin.login_alt');
```
