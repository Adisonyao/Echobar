<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="EchoBar App 圖示">
</p>

<h1 align="center">EchoBar · 回聲</h1>

<p align="center"><strong>一鍵錄下 Mac 播放的聲音。</strong><br>
免裝虛擬聲卡。</p>

<p align="center"><strong>約 1.9 MB</strong> · Swift 原生開發 · macOS 14.2+ · MIT 開源</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>下載 EchoBar</strong></a> ·
  <a href="#安裝">安裝教學</a> ·
  <a href="#專案結構">專案結構</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · **繁體中文** · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="EchoBar 的實機錄音與設定畫面">
</p>

## 核心特色

- **小巧原生。** 以 Swift 開發，使用 Apple Core Audio 擷取系統音訊。通用 Release 版 App 約 1.9 MB，無第三方依賴。
- **極簡設計。** 所有操作集中在一個小視窗。儲存位置與 WAV 格式可依需要調整。
- **優先保住錄音。** 錄音期間持續寫入並定期同步至磁碟。正常結束 App 前會完成存檔。
- **本機錄音。** 只擷取系統音訊，無需麥克風權限。錄音可離線進行，檔案留在 Mac。

## 安裝

1. 前往 [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases)，從最新版的 **Assets** 下載 EchoBar。如下載的是壓縮檔，先解壓縮。
2. 把 `EchoBar.app` 拖到 **應用程式（Applications）** 資料夾，再開啟即可使用。

**系統需求** · macOS 14.2 或更新版本，支援 Apple 晶片與 Intel 架構。

## 常見問題

<details>
<summary>為什麼 macOS 會要求權限？</summary>

首次錄音時，請依 macOS 提示允許擷取系統音訊。這項權限讓 EchoBar 讀取 Mac 上正在播放的聲音。

</details>

<details>
<summary>當機或強制結束後，錄音還在嗎？</summary>

重新開啟 EchoBar 時，App 會嘗試復原已寫入磁碟的音訊。中斷前仍在記憶體中的音訊可能遺失。

</details>

## 專案結構

<details>
<summary>展開原始碼與文件目錄</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode 專案與共用 Scheme
├── EchoBar/
│   ├── EchoBarApp.swift           # App 入口、偏好與錄音狀態
│   ├── RecorderView.swift         # 錄音視窗與設定介面
│   ├── SystemAudioRecorder.swift  # 系統音訊擷取與 WAV 寫入
│   ├── RecordingRecovery.swift    # 中斷後的錄音復原
│   ├── AudioSpectrum.swift        # 即時音訊頻譜
│   ├── Localizable.xcstrings     # 介面翻譯
│   └── Assets.xcassets/           # App 圖示與介面資源
├── docs/
│   ├── assets/                    # README 配圖
│   └── readme/                    # 各語言版本
├── README.md                      # 專案首頁
└── LICENSE                        # MIT 授權
```

</details>

## 從原始碼建置

使用內含 **macOS 26 SDK 或更新版本**的 Xcode 開啟 [EchoBar.xcodeproj](../../EchoBar.xcodeproj)，選擇 **EchoBar** 和 **My Mac**，按 **⌘R**。

如需通用 Release 建置，在專案根目錄執行：

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

建置完成的 App 位於 `DerivedData/Build/Products/Release/EchoBar.app`。

## 授權

[MIT](../../LICENSE)
