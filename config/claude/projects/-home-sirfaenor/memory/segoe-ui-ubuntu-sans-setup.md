---
name: segoe-ui-ubuntu-sans-setup
description: Setup font della macchina — alias Segoe UI→Ubuntu Sans e Firefox migrato da snap a deb Mozilla
metadata: 
  node_type: memory
  type: project
  originSessionId: d27a3a01-5bf6-4be3-b5a9-ac3c107da4fd
  modified: 2026-07-21T13:14:23.030Z
---

Sulla workstation Ubuntu 24.04, dal 2026-07-21: alias fontconfig `Segoe UI` → `Ubuntu Sans` in `~/.config/fontconfig/conf.d/99-segoe-to-ubuntu-sans.conf`, gestito da `~/Scripts/segoe-to-ubuntu-sans.sh`. Firefox migrato da snap a deb del repo ufficiale Mozilla (`packages.mozilla.org`, pin APT priorità 1000), profilo in `~/.mozilla/firefox/tjsohqwj.default`.

**Why:** lo snap era il problema — HOME riscritto in `~/snap/firefox/`, fontconfig isolato da `~/.config`, e i font dell'host non visibili nel confinamento. Chrome (deb) applicava l'alias, Firefox snap no.

**How to apply:** due regole non ovvie da ricordare prima di diagnosticare font.

1. **Firefox applica le sostituzioni fontconfig solo come ultima risorsa**, cioè quando *nessuna* famiglia della stack CSS corrisponde a un font realmente installato. Chrome invece interroga fontconfig per ogni nome. Perciò su stack tipo `"Segoe UI", "Noto Sans", Helvetica, ...` Firefox usa Noto Sans (reale) e non consulta mai l'alias. In Firefox l'unica leva è il CSS: l'utente ha **Stylus**, si passa da lì (per GitHub si sovrascrivono le variabili Primer `--fontStack-system` / `--fontStack-sansSerif` / `--fontStack-sansSerifDisplay`).

2. **Le app snap non leggono `~/.config/fontconfig`**: `XDG_CONFIG_HOME` punta dentro lo snap. Nei flatpak invece `HOME` resta reale, i font dell'host *sono* visibili, ma `XDG_CONFIG_HOME` è `~/.var/app/<id>/config`. Restano snap Chromium e Thunderbird, con copie inerti dell'alias.

Migrando un profilo Firefox tra installazioni diverse va sistemato `installs.ini` (e la sezione `[InstallXXX]` in `profiles.ini`): l'hash del percorso d'installazione cambia e Firefox crea un profilo nuovo vuoto invece di riusare quello marcato `Default=1`.
