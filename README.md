<p align="center">
  <img src="docs/assets/icon/echobar-icon-128.png" width="96" height="96" alt="EchoBar app icon">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Record the sound your Mac plays with one click.</strong><br>
No virtual audio driver required.</p>

<p align="center"><strong>About 2.8 MB</strong> · Built natively in Swift · macOS 14.2+ · Open source under MIT</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases/latest/download/EchoBar-macOS.zip"><strong>Download EchoBar</strong></a> ·
  <a href="#install">Installation</a> ·
  <a href="#project-structure">Project structure</a>
</p>

**English** · [简体中文](docs/readme/README.zh-Hans.md) · [繁體中文](docs/readme/README.zh-Hant.md) · [日本語](docs/readme/README.ja.md) · [한국어](docs/readme/README.ko.md) · [العربية](docs/readme/README.ar.md) · [Français](docs/readme/README.fr.md) · [Русский](docs/readme/README.ru.md) · [Español](docs/readme/README.es.md) · [Deutsch](docs/readme/README.de.md) · [Português (Brasil)](docs/readme/README.pt-BR.md) · [Italiano](docs/readme/README.it.md) · [हिन्दी](docs/readme/README.hi.md)

<p align="center">
  <img src="docs/assets/echoBar-hero.png" width="880" alt="EchoBar’s recording and settings windows">
</p>

## ✨ Highlights

- **Small and native.** Built in Swift and powered by Apple Core Audio. The universal Release app is about 2.8 MB and has no third-party dependencies.
- **Simple by design.** Everything fits in one small window. Choose where to save recordings and adjust the WAV format.
- **Built to preserve recordings.** EchoBar writes audio throughout the session and regularly syncs it to disk. It finishes saving before a normal quit.
- **Local recording.** Captures system audio without microphone access. Recording works offline, and files stay on your Mac.

<a name="install"></a>

## 📥 Installation

1. Open [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases) and download EchoBar from the latest release’s **Assets**. If you downloaded an archive, extract it first.
2. Drag `EchoBar.app` into **Applications**, then open it.

**System requirements** · macOS 14.2 or later, on Apple silicon or Intel Macs.

## ❓ FAQ

<details>
<summary>Why does macOS ask for permission?</summary>

When you first record, follow the macOS prompt to allow system audio capture. This gives EchoBar access to the sound your Mac is playing.

</details>

<details>
<summary>Can I recover a recording after a crash or force quit?</summary>

When you reopen EchoBar, it attempts to recover audio already written to disk. Audio still in memory at the time of the interruption may be lost.

</details>

<a name="project-structure"></a>

## 📂 Project structure

<details>
<summary>Show source and documentation layout</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode project and shared scheme
├── EchoBar/
│   ├── EchoBarApp.swift           # App entry point, preferences, and recording state
│   ├── RecorderView.swift         # Recorder window and settings
│   ├── SystemAudioRecorder.swift  # System audio capture and WAV writing
│   ├── RecordingRecovery.swift    # Recording recovery after interruptions
│   ├── AudioSpectrum.swift        # Live audio spectrum
│   ├── Localizable.xcstrings     # Interface translations
│   └── AppIcon.icon/              # App icon source (Icon Composer)
├── docs/
│   ├── assets/                    # README images
│   │   └── icon/echobar-icon-128.png
│   └── readme/                    # Localized READMEs
├── README.md                      # Project homepage
└── LICENSE                        # MIT license
```

</details>

## 🛠️ Build from source

Open [EchoBar.xcodeproj](EchoBar.xcodeproj) in Xcode with the **macOS 26 SDK or later**. Select **EchoBar** and **My Mac**, then press **⌘R**.

For a universal Release build, run the following from the repository root.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

The built app is at `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 License

[MIT](LICENSE)
