---
name: marvin-artisan-starting-trap
description: "Marvin istanzia Console\\Application nel boot() (via Artisan::call con marvin.lang_autoexport_file=true), rompendo Artisan::starting per i provider che boot dopo"
metadata: 
  node_type: memory
  type: project
  originSessionId: 21c662b6-460e-4be6-8bd2-5f1464dfbb9a
---

In questo progetto Marvin chiama `Artisan::call("marvin:translations-export")` dentro il proprio `boot()` quando `marvin.lang_autoexport_file === true` e l'app NON è in CLI (vedi `vendor/atrioteam/marvin/src/ServiceProvider.php` metodo `registerLangs`). La config locale ha quel flag a `true` (default di progetto in `config/marvin.php`).

Effetto: Marvin istanzia `Illuminate\Console\Application` **durante il bootstrap dei provider**. Il costruttore di Console\Application esegue `bootstrap()` una sola volta e scatena tutte le callback `Artisan::starting` registrate fino a quel momento. Tutte le callback registrate **dopo** non scatteranno mai, perché Console\Application è cached in `Kernel::$artisan`.

In `bootstrap/cache/packages.php` Marvin (`atrioteam/marvin`) precede alfabeticamente OnPage (`packages/onpage`), quindi i comandi OnPage registrati via `$this->commands([...])` non finiscono nel registry Artisan in web context.

**Why:** non è un bug di Laravel — è un side effect del fatto che Marvin fa lavoro CLI-like durante boot HTTP. Sintomo classico: `Artisan::call('onpage:sync-variants')` da una rotta web fallisce con CommandNotFoundException, mentre da CLI funziona.

**How to apply:** se un package locale registra comandi via `$this->commands()` nel suo provider e quei comandi non sono raggiungibili da web (es. la rotta `/artisan/{command}` esposta da `ArtisanWeb`), registrali direttamente in `App\Console\Kernel::$commands` — quella lista viene risolta in `getArtisan()` via `resolveCommands($this->commands)`, indipendentemente dalle callback `Artisan::starting`. Già fatto per `Packages\OnPage\Console\Commands\SyncVariants` e `SyncProducts`. Vedi anche [[artisan-web-endpoint]].
