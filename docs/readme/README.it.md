# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · **Italiano** · [हिन्दी](README.hi.md)

EchoBar è un registratore nativo e compatto per macOS. Registra l’audio riprodotto dalle app. Un clic avvia la registrazione, un secondo clic salva il WAV.

![Schermate reali delle finestre di registrazione e impostazioni di EchoBar, disposte in diagonale](../../docs/assets/echoBar-hero.png)

## Funzionalità

- **Cattura dell’audio di sistema.** EchoBar usa Core Audio di Apple per registrare la riproduzione delle app. L’audio resta udibile durante la registrazione e non serve il permesso per il microfono.
- **Finestra compatta.** Lo spettro in tempo reale ha sette bande, con i bassi a sinistra e gli alti a destra. Dopo un’ora il timer mostra ore, minuti e secondi. Usa il pulsante rotondo o **⌘R**.
- **Controllo della dimensione del file.** Il WAV PCM può seguire la sorgente o usare 16, 24, 32, 44,1 o 48 kHz, a 8, 16 o 24 bit. Le impostazioni stimano la dimensione per ora. Valori più bassi riducono la dimensione e la fedeltà.
- **Preferenze persistenti.** Tieni la finestra in primo piano, apri la cartella nel Finder e modifica destinazione, formato e comportamento alla chiusura dalla stessa finestra. Le preferenze sono salvate in locale.
- **Dati sul Mac.** Registrazioni, preferenze e dati di recupero restano sul dispositivo. EchoBar non include telemetria, funzioni di caricamento o dipendenze di terze parti.
- **13 lingue.** Scegli la lingua nell’app o segui macOS. Le impostazioni in arabo si leggono da destra a sinistra.
- **Riscontro immediato.** Le impostazioni scorrono nella stessa finestra. Dopo il salvataggio, fai clic sullo stato per mostrare il file nel Finder oppure attiva le notifiche di macOS.

[Schermata del registratore](../../docs/assets/recorder.png) · [Schermata delle impostazioni](../../docs/assets/settings.png)

## Avviare una registrazione

1. Compila e avvia EchoBar. Consenti la cattura dell’audio di sistema quando macOS lo chiede.
2. Riproduci l’audio in un’altra app e premi il pulsante rosso. Premilo di nuovo per salvare. La cartella predefinita è `~/Music/回聲錄音/`.
3. L’icona della cartella apre la destinazione e l’ingranaggio apre le impostazioni. Le modifiche di registrazione valgono dalla sessione successiva.

## Recupero e compatibilità

Durante l’uscita normale, EchoBar completa prima il salvataggio. Dopo un arresto anomalo o forzato, riapri l’app per recuperare l’audio già scritto sul disco. La parte ancora in memoria potrebbe andare persa.

Serve **macOS 14.2 o successivo** su un Mac Intel o Apple silicon compatibile. Liquid Glass è disponibile da macOS 26. Le versioni precedenti usano i materiali standard di sistema. La build comprende entrambe le architetture. L’esecuzione è stata verificata su Apple silicon.

## Compilare dal sorgente

Apri [EchoBar.xcodeproj](../../EchoBar.xcodeproj) in Xcode con SDK macOS 26 o successivo. Seleziona **EchoBar** e **My Mac**, poi premi **⌘R**. Per una build Release universale:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

L’app si trova in `DerivedData/Build/Products/Release/EchoBar.app`. Le build locali usano una firma ad hoc.

## Licenza

[MIT](../../LICENSE).
