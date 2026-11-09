<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="EchoBar App 圖示">
</p>

<h1 align="center">EchoBar · 回聲</h1>

<p align="center"><strong>一鍵錄下 Mac 播放的聲音。</strong><br>
停止後自動存成 WAV，免裝虛擬聲卡。</p>

<p align="center"><strong>約 1.9 MB</strong> · Swift 原生開發 · macOS 14.2+ · MIT 開源</p>

<p align="center">
  <a href="#開始錄音">開始錄音</a> · <a href="#從原始碼建置">從原始碼建置</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · **繁體中文** · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="EchoBar 的實機錄音與設定畫面">
</p>

## 為什麼用 EchoBar

- **小巧原生。** 以 Swift 開發，使用 Apple Core Audio 擷取系統音訊。通用 Release 版 App 約 1.9 MB，無第三方依賴。
- **操作簡潔。** 一個小視窗，按一下開始，再按一下停止。可自訂 WAV 格式與儲存位置。
- **優先保住錄音。** 錄音期間持續寫入檔案，並定期同步至磁碟。正常結束 App 會先完成儲存。遇到當機或強制結束，重開時會嘗試復原已寫入磁碟的音訊。
- **資料留在 Mac。** 只錄系統音訊，無需麥克風權限。WAV 直接儲存在本機，錄音可離線進行。

## 開始錄音

開啟 EchoBar，按紅色錄音鍵。第一次使用時，依 macOS 提示允許擷取系統音訊。再按一次就會停止並自動儲存，點資料夾圖示可在 Finder 找到錄音。

## 系統需求

需要 **macOS 14.2 或更新版本**。支援 Apple 晶片與 Intel 架構。

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
