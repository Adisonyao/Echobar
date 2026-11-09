<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="App-Symbol von EchoBar">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Nimm mit einem Klick auf, was dein Mac abspielt.</strong><br>
Kein virtueller Audiotreiber nötig.</p>

<p align="center"><strong>Rund 1,9 MB</strong> · Native App in Swift · macOS 14.2+ · Open Source unter der MIT-Lizenz</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>EchoBar herunterladen</strong></a> ·
  <a href="#install">Installationsanleitung</a> ·
  <a href="#project-structure">Projektstruktur</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · **Deutsch** · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="Aufnahme- und Einstellungsfenster von EchoBar">
</p>

## ✨ Auf einen Blick

- **Klein und nativ.** EchoBar ist in Swift geschrieben und erfasst den Systemton über Apple Core Audio. Die universelle Release-Version ist rund 1,9 MB groß und kommt ohne Abhängigkeiten von Drittanbietern aus.
- **Übersichtliches Design.** Alle Bedienelemente passen in ein kleines Fenster. Speicherort und WAV-Format lassen sich anpassen.
- **Aufnahmen sichern.** EchoBar schreibt die Audiodaten während der Aufnahme fortlaufend und synchronisiert sie regelmäßig mit dem Datenträger. Beim regulären Beenden schließt die App zuerst den Speichervorgang ab.
- **Lokale Aufnahme.** EchoBar nimmt nur den Systemton auf und benötigt keinen Mikrofonzugriff. Die Aufnahme funktioniert offline und die Dateien bleiben auf deinem Mac.

<a name="install"></a>

## 📥 Installation

1. Lade EchoBar auf [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases) unter **Assets** der neuesten Version herunter. Entpacke die Datei zuerst, falls sie als Archiv vorliegt.
2. Ziehe `EchoBar.app` in den Ordner **Programme (Applications)** und öffne die App.

**Systemanforderungen** · macOS 14.2 oder neuer, auf Macs mit Apple-Chip oder Intel-Prozessor.

## ❓ Häufige Fragen

<details>
<summary>Warum fragt macOS nach einer Berechtigung?</summary>

Erlaube bei der ersten Aufnahme die Erfassung des Systemtons, sobald macOS danach fragt. Damit kann EchoBar auf den Ton zugreifen, den dein Mac abspielt.

</details>

<details>
<summary>Lässt sich eine Aufnahme nach einem Absturz oder erzwungenen Beenden wiederherstellen?</summary>

Beim nächsten Start versucht EchoBar, bereits auf den Datenträger geschriebene Audiodaten wiederherzustellen. Daten, die bei der Unterbrechung noch im Arbeitsspeicher waren, können verloren gehen.

</details>

<a name="project-structure"></a>

## 📂 Projektstruktur

<details>
<summary>Quellcode- und Dokumentationsstruktur anzeigen</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode-Projekt und gemeinsames Schema
├── EchoBar/
│   ├── EchoBarApp.swift           # App-Einstieg, Einstellungen und Aufnahmestatus
│   ├── RecorderView.swift         # Aufnahmefenster und Einstellungen
│   ├── SystemAudioRecorder.swift  # Systemton erfassen und WAV schreiben
│   ├── RecordingRecovery.swift    # Wiederherstellung unterbrochener Aufnahmen
│   ├── AudioSpectrum.swift        # Live-Audiospektrum
│   ├── Localizable.xcstrings     # Übersetzungen der Oberfläche
│   └── Assets.xcassets/           # App-Symbol und UI-Ressourcen
├── docs/
│   ├── assets/                    # README-Bilder
│   └── readme/                    # README-Sprachversionen
├── README.md                      # Projektstartseite
└── LICENSE                        # MIT-Lizenz
```

</details>

## 🛠️ Aus dem Quellcode bauen

Öffne [EchoBar.xcodeproj](../../EchoBar.xcodeproj) in Xcode mit dem **macOS 26 SDK oder neuer**. Wähle **EchoBar** und **My Mac** und drücke **⌘R**.

Führe für einen universellen Release-Build diesen Befehl im Stammverzeichnis des Repositorys aus.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

Die fertige App liegt unter `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 Lizenz

[MIT](../../LICENSE)
