# lyrics-now

Mostra in una finestra di terminale il testo del brano in riproduzione, sincronizzato con la canzone quando possibile.
Pensato per Strawberry, ma funziona con qualsiasi player MPRIS (Spotify, VLC, …).

![icona](../../home/.local/share/icons/hicolor/scalable/apps/lyrics-now.svg)

```
♪ Linkin Park — Valentine's Day (2007)                     1:59 / 3:16
──────────────────────────────────────────────────────────────────────
                          So now you're gone        ← righe passate (attenuate)
                           And I was wrong          ← riga corrente (gialla)
                    I never knew what it was like
```

## Funzionamento

- Legge dal player, via D-Bus/MPRIS, artista, titolo, album, anno, durata e posizione.
- Fonti del testo:
  - **locali**: un file `.lrc` o `.txt` con lo stesso nome del brano, nella stessa cartella, e i tag incorporati
    nel file audio, letti con `mutagen`. Per gli mp3 `SYLT` (sincronizzato) e `USLT`; per FLAC/Ogg/Opus `LYRICS` /
    `UNSYNCEDLYRICS`; per m4a `©lyr`. Un testo in formato LRC dentro un tag viene riconosciuto come sincronizzato;
  - **[lrclib.net](https://lrclib.net)**: gratuito e senza chiave API, con cache in `~/.cache/lyrics-now/`;
  - il testo nei metadati MPRIS (`xesam:asText`), se il player lo fornisce, come ultima possibilità.

  Vince il testo sincronizzato: prima quello locale, poi quello di lrclib. Solo se nessuno dei due c'è si usa
  un testo semplice, prima quello locale e poi quello di lrclib. Molti mp3 hanno solo `USLT`, cioè il testo senza tempi:
  in quel caso lrclib viene interrogato comunque, per non perdere la riga evidenziata.

  Le fonti locali (1 e 2) vengono rilette ogni volta e non vanno in cache, così le modifiche ai tag si vedono subito.
- **Testo sincronizzato** (LRC): la riga corrente è evidenziata e scorre insieme alla canzone.
- **Testo semplice**: viene mostrato dall'inizio, senza scorrimento.
- In alto: artista, titolo, anno (dal campo `year` di Strawberry, preso dalla traccia o dall'album) e tempo trascorso / totale.
- Quando cambi brano si aggiorna da solo; se il player è chiuso aspetta che venga aperto.

Dipendenze: `python3` con `gi` (PyGObject) e `mutagen` (`python3-mutagen`), già presenti su Ubuntu.
Senza `mutagen` i tag non vengono letti, ma il resto funziona.

## File

| File nel repo | Collegato in | Contenuto |
|---|---|---|
| `home/.local/bin/lyrics-now` | `~/.local/bin/lyrics-now` | lo script |
| `home/.local/bin/lyrics-now-window` | `~/.local/bin/lyrics-now-window` | apre lo script in una finestra gnome-terminal dedicata |
| `home/.local/share/applications/it.atrio.LyricsNow.desktop` | `~/.local/share/applications/` | launcher "Testi (Strawberry)" |
| `home/.local/share/icons/hicolor/scalable/apps/lyrics-now.svg` | `~/.local/share/icons/hicolor/scalable/apps/` | icona del launcher |
| `config/lyrics-now/gnome-terminal-profile.dconf` | caricato in dconf | profilo gnome-terminal "Testi" |

`bin/setup` crea i link, carica il profilo e lo aggiunge all'elenco dei profili di gnome-terminal.

## Uso

- Dalla lista delle applicazioni: **Testi (Strawberry)**.
- Da terminale, nella finestra corrente: `lyrics-now` (Strawberry) oppure `lyrics-now <player>`, ad es. `lyrics-now spotify`.
  Il nome è quello dopo `org.mpris.MediaPlayer2.`; per vedere quali player sono attivi:
  ```
  gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus \
    --method org.freedesktop.DBus.ListNames | tr ',' '\n' | grep mpris
  ```
- In una finestra separata come quella del launcher: `lyrics-now-window [player]`.
- `Ctrl+C`, oppure chiudere la finestra, per uscire.
- **Sempre in primo piano**: `Alt+Spazio` → "Sempre in primo piano". Su GNOME con Wayland un'applicazione non può attivarlo da sola.

## Profilo gnome-terminal "Testi"

UUID `88859262-7e59-487d-be35-5c9bfc53dc27`, usato con `--profile` dal launcher. Il profilo predefinito non viene toccato.
Imposta sfondo antracite trasparente al 25%, niente barra di scorrimento, niente suoni e dimensione 60×30.

Per cambiarlo, la cosa più comoda è usare Preferenze di gnome-terminal → profilo "Testi" e poi salvare nel repo:

```
dconf dump /org/gnome/terminal/legacy/profiles:/:88859262-7e59-487d-be35-5c9bfc53dc27/ \
  > ~/Dotfiles/config/lyrics-now/gnome-terminal-profile.dconf
```

In alternativa si modifica il `.dconf`, ad esempio `background-transparency-percent`, e si rilancia `bin/setup`.

## Finestra dedicata e dash

Tutte le finestre di gnome-terminal appartengono all'app "Terminale", quindi GNOME non le collegherebbe al launcher:
nella dash l'icona fissata non mostrerebbe il pallino e ogni clic aprirebbe un'altra finestra.
`lyrics-now-window` avvia allora un'istanza separata di `gnome-terminal-server` con identificativo `it.atrio.LyricsNow`
(`--app-id` è un'opzione non documentata) e ci apre dentro la finestra. Il `.desktop` ha
`StartupWMClass=it.atrio.LyricsNow` ed è chiamato `it.atrio.LyricsNow.desktop`: GNOME abbina la finestra al launcher
tramite il nome del file, come fa `org.gnome.Terminal.desktop` con il Terminale.
L'istanza si chiude da sola quando si chiude la finestra.

## Problemi noti

- **"Testo non trovato"**: nessuna delle fonti lo ha. Si può:
  - mettere un file `.lrc` (sincronizzato) o `.txt` accanto al brano, con lo stesso nome: è la via più rapida;
  - incorporarlo nei tag del file, ad esempio con l'editor dei tag di Strawberry, Picard o kid3;
  - aggiungerlo a lrclib.net, ad esempio con [LRCGET](https://github.com/tranxuanthang/lrcget), che sa anche scaricare
    in blocco i `.lrc` per tutta la libreria.

  Le fonti locali hanno effetto al prossimo cambio brano. Per lrclib invece il "non trovato" resta in cache: cancella
  il file del brano in `~/.cache/lyrics-now/` perché venga cercato di nuovo.
- **Testo sbagliato**: se viene da lrclib, cancella il file in cache come sopra; se viene dal file locale, correggi
  il `.lrc`/`.txt` o il tag.
- **Il launcher usa ancora la versione vecchia del `.desktop`**: GNOME controlla `~/.local/share/applications`, dove c'è solo il link, e quindi non si accorge delle modifiche fatte al file nel repo. Ricrea il link:
  ```
  ln -sf ~/Dotfiles/home/.local/share/applications/it.atrio.LyricsNow.desktop ~/.local/share/applications/
  ```
  Se non basta, esci e rientra nella sessione.
- **"Failed to execve" all'avvio**: il terminale avviato da GNOME non ha `~/.local/bin` fra i percorsi in cui cerca i comandi, perché viene aggiunto solo da `.zshrc`. Per questo il launcher indica il percorso completo `$HOME/.local/bin/lyrics-now`.
