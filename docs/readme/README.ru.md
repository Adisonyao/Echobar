<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="Значок приложения EchoBar">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Записывайте звук, который воспроизводит Mac, одним нажатием.</strong><br>
Виртуальный аудиодрайвер не нужен.</p>

<p align="center"><strong>Около 1,9 МБ</strong> · Нативное приложение на Swift · macOS 14.2+ · Открытый код под лицензией MIT</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>Скачать EchoBar</strong></a> ·
  <a href="#install">Инструкция по установке</a> ·
  <a href="#project-structure">Структура проекта</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · **Русский** · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="Окна записи и настроек EchoBar">
</p>

## ✨ Главное

- **Компактное нативное приложение.** Написано на Swift и записывает системный звук через Apple Core Audio. Универсальная Release-сборка занимает около 1,9 МБ и не требует сторонних зависимостей.
- **Простой интерфейс.** Все элементы управления находятся в одном небольшом окне. Можно выбрать папку для записей и настроить формат WAV.
- **Сохранность записей.** Во время записи EchoBar непрерывно записывает аудиоданные и регулярно синхронизирует их с диском. При обычном выходе приложение сначала завершает сохранение.
- **Локальная запись.** EchoBar записывает только системный звук и не требует доступа к микрофону. Запись работает без интернета, а файлы остаются на Mac.

<a name="install"></a>

## 📥 Установка

1. Скачайте EchoBar из раздела **Assets** последней версии на странице [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases). Если файл скачался в виде архива, сначала распакуйте его.
2. Перетащите `EchoBar.app` в папку **Программы (Applications)** и откройте приложение.

**Системные требования** · macOS 14.2 или новее, Mac с чипом Apple или процессором Intel.

## ❓ Частые вопросы

<details>
<summary>Зачем macOS запрашивает разрешение?</summary>

При первой записи разрешите захват системного звука по запросу macOS. Это позволит EchoBar записывать звук, который воспроизводит Mac.

</details>

<details>
<summary>Можно ли восстановить запись после сбоя или принудительного завершения?</summary>

При следующем запуске EchoBar попытается восстановить звук, уже записанный на диск. Данные, оставшиеся в памяти в момент прерывания, могут быть потеряны.

</details>

<a name="project-structure"></a>

## 📂 Структура проекта

<details>
<summary>Показать структуру исходного кода и документации</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Проект Xcode и общая схема
├── EchoBar/
│   ├── EchoBarApp.swift           # Точка входа, настройки и состояние записи
│   ├── RecorderView.swift         # Окно записи и настройки
│   ├── SystemAudioRecorder.swift  # Захват системного звука и запись WAV
│   ├── RecordingRecovery.swift    # Восстановление прерванных записей
│   ├── AudioSpectrum.swift        # Спектр звука в реальном времени
│   ├── Localizable.xcstrings     # Переводы интерфейса
│   └── Assets.xcassets/           # Значок и ресурсы интерфейса
├── docs/
│   ├── assets/                    # Изображения для README
│   └── readme/                    # Переводы README
├── README.md                      # Главная страница проекта
└── LICENSE                        # Лицензия MIT
```

</details>

## 🛠️ Сборка из исходного кода

Откройте [EchoBar.xcodeproj](../../EchoBar.xcodeproj) в Xcode с **SDK macOS 26 или новее**. Выберите **EchoBar** и **My Mac**, затем нажмите **⌘R**.

Для универсальной Release-сборки выполните следующую команду в корне репозитория.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

Готовое приложение находится в `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 Лицензия

[MIT](../../LICENSE)
