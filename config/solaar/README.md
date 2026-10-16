# solaar

Regole custom di [Solaar](https://github.com/pwr-Solaar/Solaar) per la Logitech MX Keys Mini.

`rules.yaml` è collegato con un symlink:

```
ln -s ~/Dotfiles/config/solaar/rules.yaml ~/.config/solaar/rules.yaml
```

`config.yaml` resta fuori dal repo perché contiene il seriale del dispositivo e lo stato che Solaar riscrive di continuo.

## Regole

- **Fn+F8 (tasto screenshot)** → invia `Print`, che in GNOME apre l'interfaccia screenshot.
  Solaar chiama il tasto `Snipping Tool` (0x10a).

## Tasti da impostare come "Diverted"

Una regola `Key` scatta solo se il tasto è impostato come **Diverted**: altrimenti la tastiera gestisce il tasto
da sola e Solaar non riceve la pressione. Questa impostazione sta in `config.yaml`, non in `rules.yaml`, quindi va
rifatta su ogni macchina nuova (o dopo aver resettato la configurazione di Solaar):

```
solaar config "MX Keys Mini" divert-keys "Snipping Tool" Diverted
```

In alternativa, dall'interfaccia di Solaar: MX Keys Mini → *Key/Button Diversion* → `Snipping Tool` → *Diverted*.

Per verificarlo:

```
solaar show "MX Keys Mini" | grep "Diversion  "
```

## Note

- I tasti funzione sono in modalità nativa (`fn-swap: false`), quindi il tasto screenshot si attiva con Fn+F8.
- Su Wayland Solaar simula i tasti tramite `/dev/uinput`: l'utente deve avere accesso in scrittura
  (`getfacl /dev/uinput`).
- Dopo aver modificato `rules.yaml` a mano bisogna riavviare Solaar.
