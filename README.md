# EchoBar

**English** · [简体中文](docs/readme/README.zh-Hans.md) · [繁體中文](docs/readme/README.zh-Hant.md) · [日本語](docs/readme/README.ja.md) · [한국어](docs/readme/README.ko.md) · [العربية](docs/readme/README.ar.md) · [Français](docs/readme/README.fr.md) · [Русский](docs/readme/README.ru.md) · [Español](docs/readme/README.es.md) · [Deutsch](docs/readme/README.de.md) · [Português (Brasil)](docs/readme/README.pt-BR.md) · [Italiano](docs/readme/README.it.md) · [हिन्दी](docs/readme/README.hi.md)

A compact, native macOS recorder for the audio your apps play. Click once to start and again to save a WAV.

![Actual EchoBar recorder and settings windows in a tilted composition](docs/assets/echoBar-hero.png)

## What EchoBar offers

- **System audio capture.** Records app playback using Apple’s Core Audio taps. It keeps the sound audible while recording and doesn’t request microphone access.
- **A small window built for recording.** A seven-band live spectrum shows bass on the left and treble on the right. The timer switches to hours, minutes and seconds after one hour. Use the round record button or press **⌘R**.
- **Control over file size.** Save PCM WAV at the source rate or at 16, 24, 32, 44.1 or 48 kHz, with 8, 16 or 24 bit depth. Settings show an estimated size per hour. Lower settings trade fidelity for smaller files.
- **Your workspace, your preferences.** Pin the window above normal windows, reveal your recordings in Finder, and change the folder, audio format and close behaviour in the same window. Preferences are saved locally between launches.
- **Local by design.** Recordings, preferences and recovery information stay on the Mac. EchoBar has no telemetry, upload feature or third-party dependencies.
- **13 interface languages.** Choose a language in the app or follow macOS. Arabic settings support right-to-left layout.
- **Clear feedback.** The same window slides into Settings. After saving, click the status to reveal the file in Finder, or enable macOS notifications for a save confirmation.

[Recorder screenshot](docs/assets/recorder.png) · [Settings screenshot](docs/assets/settings.png)

## Start recording

1. Build and run EchoBar, then allow system audio capture when macOS asks.
2. Play audio in an app and press the red button. Press it again to save. The default folder is `~/Music/回聲錄音/`.
3. Use the folder icon to open the destination. Use the gear to change settings. Recording settings apply to the next session.

## Recovery and compatibility

On a normal quit, EchoBar finishes saving the recording before it exits. After a crash or force quit, reopen EchoBar to recover the audio already written to disk. A hard interruption can lose the part still in memory.

Requires **macOS 14.2 or later** on a compatible Intel or Apple silicon Mac. Native Liquid Glass is available on macOS 26 and later. Earlier versions use standard system materials. The build includes both architectures. Runtime checks were performed on Apple silicon.

## Build from source

Open [EchoBar.xcodeproj](EchoBar.xcodeproj), select the **EchoBar** scheme and **My Mac**, then press **⌘R**. Use Xcode with the macOS 26 SDK or later to compile the Liquid Glass code. For a universal Release build:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

The app is at `DerivedData/Build/Products/Release/EchoBar.app`. The project uses ad hoc signing for local builds.

## License

[MIT](LICENSE).
