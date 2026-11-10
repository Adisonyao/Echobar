<p align="center">
  <img src="../assets/icon/echobar-icon-128.png" width="96" height="96" alt="Icona dell’app EchoBar">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Registra con un clic l’audio riprodotto dal tuo Mac.</strong><br>
Non serve installare driver audio virtuali.</p>

<p align="center"><strong>Circa 2,8 MB</strong> · App nativa in Swift · macOS 14.2+ · Open source con licenza MIT</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases/latest/download/EchoBar-macOS.zip"><strong>Scarica EchoBar</strong></a> ·
  <a href="#install">Guida all’installazione</a> ·
  <a href="#project-structure">Struttura del progetto</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · **Italiano** · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="Finestre di registrazione e impostazioni di EchoBar">
</p>

## ✨ Caratteristiche principali

- **Nativa e leggera.** Sviluppata in Swift, acquisisce l’audio di sistema con Apple Core Audio. La build Release universale occupa circa 2,8 MB e non ha dipendenze di terze parti.
- **Interfaccia essenziale.** Tutti i comandi sono in una piccola finestra. Puoi scegliere la cartella di destinazione e configurare il formato WAV.
- **Le registrazioni vengono prima di tutto.** EchoBar scrive l’audio durante la registrazione e lo sincronizza periodicamente su disco. Alla chiusura normale, completa il salvataggio prima di uscire.
- **Registrazione locale.** Acquisisce solo l’audio di sistema e non accede al microfono. Funziona offline e i file restano sul Mac.

<a name="install"></a>

## 📥 Installazione

1. Scarica EchoBar dalla sezione **Assets** dell’ultima versione su [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases). Se scarichi un archivio, estrailo prima.
2. Trascina `EchoBar.app` nella cartella **Applicazioni (Applications)**, quindi aprila.

**Requisiti di sistema** · macOS 14.2 o successivo, su Mac con chip Apple o processore Intel.

## ❓ Domande frequenti

<details>
<summary>Perché macOS chiede un’autorizzazione?</summary>

Alla prima registrazione, segui le indicazioni di macOS per consentire l’acquisizione dell’audio di sistema. In questo modo EchoBar può accedere all’audio riprodotto dal Mac.

</details>

<details>
<summary>Posso recuperare una registrazione dopo un arresto anomalo o un’uscita forzata?</summary>

Quando riapri EchoBar, l’app tenta di recuperare l’audio già scritto su disco. L’audio ancora in memoria al momento dell’interruzione potrebbe andare perso.

</details>

<a name="project-structure"></a>

## 📂 Struttura del progetto

<details>
<summary>Mostra la struttura del codice e della documentazione</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Progetto Xcode e schema condiviso
├── EchoBar/
│   ├── EchoBarApp.swift           # Punto di ingresso, preferenze e stato della registrazione
│   ├── RecorderView.swift         # Finestra di registrazione e impostazioni
│   ├── SystemAudioRecorder.swift  # Acquisizione dell’audio di sistema e scrittura WAV
│   ├── RecordingRecovery.swift    # Recupero delle registrazioni interrotte
│   ├── AudioSpectrum.swift        # Spettro audio in tempo reale
│   ├── Localizable.xcstrings     # Traduzioni dell’interfaccia
│   └── AppIcon.icon/              # Icona dell’app (Icon Composer)
├── docs/
│   ├── assets/                    # Immagini del README
│   │   └── icon/echobar-icon-128.png
│   └── readme/                    # README tradotti
├── README.md                      # Pagina principale del progetto
└── LICENSE                        # Licenza MIT
```

</details>

## 🛠️ Compilazione dal codice sorgente

Apri [EchoBar.xcodeproj](../../EchoBar.xcodeproj) in Xcode con l’**SDK di macOS 26 o successivo**. Seleziona **EchoBar** e **My Mac**, poi premi **⌘R**.

Per una build Release universale, esegui il comando seguente dalla directory principale del repository.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

L’app compilata si trova in `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 Licenza

[MIT](../../LICENSE)
