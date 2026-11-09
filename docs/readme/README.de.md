# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · **Deutsch** · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

EchoBar ist ein kompakter, nativer Audiorekorder für macOS. Er zeichnet den Ton auf, den deine Apps wiedergeben. Ein Klick startet die Aufnahme, ein weiterer speichert sie als WAV.

![Echte Bildschirmfotos des Aufnahme- und Einstellungsfensters von EchoBar in einer schrägen Anordnung](../../docs/assets/echoBar-hero.png)

## Funktionen

- **Systemaudio aufnehmen.** EchoBar erfasst die Wiedergabe von Apps über Apples Core Audio. Der Ton bleibt während der Aufnahme hörbar. Ein Mikrofonzugriff ist nicht erforderlich.
- **Ein kompaktes Aufnahmefenster.** Das Live-Spektrum zeigt sieben Frequenzbänder, von tief links bis hoch rechts. Nach einer Stunde zeigt der Timer Stunden, Minuten und Sekunden. Nutze die runde Taste oder **⌘R**.
- **Dateigröße steuern.** PCM-WAV folgt der Quellrate oder nutzt 16, 24, 32, 44,1 oder 48 kHz bei 8, 16 oder 24 Bit. Die Einstellungen zeigen die geschätzte Größe pro Stunde. Niedrigere Werte sparen Platz und verringern die Klangtreue.
- **Deine Einstellungen bleiben erhalten.** Halte das Fenster im Vordergrund, öffne den Aufnahmeordner im Finder und ändere Speicherort, Format und Verhalten beim Schließen im selben Fenster. Die Einstellungen werden lokal gespeichert.
- **Daten bleiben auf dem Mac.** Aufnahmen, Einstellungen und Wiederherstellungsdaten bleiben lokal. EchoBar enthält keine Telemetrie, Upload-Funktion oder Abhängigkeiten von Drittanbietern.
- **13 Sprachen.** Wähle die Sprache in der App oder übernimm die macOS-Einstellung. Arabische Einstellungen werden von rechts nach links dargestellt.
- **Klare Rückmeldung.** Die Einstellungen gleiten im selben Fenster ins Bild. Klicke nach dem Speichern auf den Status, um die Datei im Finder zu sehen, oder aktiviere macOS-Mitteilungen.

[Aufnahmefenster](../../docs/assets/recorder.png) · [Einstellungsfenster](../../docs/assets/settings.png)

## Aufnahme starten

1. Baue und starte EchoBar. Erlaube die Aufnahme von Systemaudio, wenn macOS danach fragt.
2. Spiele in einer anderen App Ton ab und klicke die rote Taste. Ein weiterer Klick speichert die WAV-Datei. Der Standardordner ist `~/Music/回聲錄音/`.
3. Das Ordnersymbol öffnet den Speicherort. Das Zahnrad öffnet die Einstellungen. Änderungen gelten für die nächste Aufnahme.

## Wiederherstellung und Kompatibilität

Beim normalen Beenden speichert EchoBar die laufende Aufnahme zuerst. Nach einem Absturz oder erzwungenen Beenden stellt ein Neustart der App bereits auf die Festplatte geschriebene Audiodaten wieder her. Ein Ende, das nur im Arbeitsspeicher lag, kann verloren gehen.

Erfordert **macOS 14.2 oder neuer** auf einem kompatiblen Intel-Mac oder Mac mit Apple-Chip. Liquid Glass ist ab macOS 26 verfügbar. Frühere Versionen nutzen Standardmaterialien des Systems. Der Build enthält beide Architekturen. Die App wurde auf Apple-Chip ausgeführt und geprüft.

## Aus dem Quellcode bauen

Öffne [EchoBar.xcodeproj](../../EchoBar.xcodeproj) in Xcode mit macOS-26-SDK oder neuer. Wähle das Schema **EchoBar** und **My Mac** und drücke **⌘R**. Universeller Release-Build:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

Die App liegt in `DerivedData/Build/Products/Release/EchoBar.app`. Lokale Builds verwenden eine Ad-hoc-Signatur.

## Lizenz

[MIT](../../LICENSE).
