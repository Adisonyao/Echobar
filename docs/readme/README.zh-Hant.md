# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · **繁體中文** · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

回聲是一款小巧的原生 macOS 錄音工具，用來錄製 App 播放的聲音。按一下開始，再按一下儲存成 WAV。

![以真實介面截圖製作的傾斜構圖，展示錄音主視窗和設定頁](../../docs/assets/echoBar-hero.png)

## 主要功能

- **錄製系統音訊。** 使用 Apple Core Audio 擷取 App 播放的聲音。錄音時仍可正常聽到聲音，無需麥克風權限。
- **小視窗，操作直接。** 七段即時頻譜從左到右對應低頻到高頻。一小時後，計時器改用時、分、秒。按圓形錄音鍵或 **⌘R** 即可操作。
- **自行控制檔案大小。** PCM WAV 可跟隨來源採樣率，或選 16、24、32、44.1、48 kHz，位元深度可選 8、16、24 bit。設定頁顯示每小時的預估大小。降低規格可以縮小檔案，也會犧牲部分音質。
- **照自己的方式使用。** 可將視窗置頂於一般視窗上方，在 Finder 開啟錄音資料夾，並在同一視窗更改資料夾、格式及關窗行為。偏好保存在本機，重開後會恢復。
- **資料留在本機。** 錄音、偏好和復原資訊都留在 Mac。沒有遙測、上傳功能或第三方依賴。
- **13 種介面語言。** 可在 App 內切換或跟隨系統。阿拉伯文設定支援由右至左排列。
- **操作有回饋。** 設定頁在同一視窗內滑動切換。儲存後可按狀態在 Finder 查看檔案，也可允許 macOS 通知接收儲存提示。

[錄音畫面截圖](../../docs/assets/recorder.png) · [設定頁截圖](../../docs/assets/settings.png)

## 開始錄音

1. 建置並執行回聲，在 macOS 提示時允許系統音訊擷取。
2. 在其他 App 播放聲音，按紅色錄音鍵開始，再按一次儲存。預設資料夾是 `~/Music/回聲錄音/`。
3. 按資料夾圖示開啟儲存位置，按齒輪更改設定。錄音設定會在下次錄音生效。

## 復原與相容性

正常退出時，回聲會先儲存錄音。當機或強制結束後，重開 App 可復原已寫入磁碟的音訊。突然中斷時，還在記憶體中的尾端音訊可能遺失。

需要 **macOS 14.2 或以上**及相容的 Intel 或 Apple 晶片 Mac。macOS 26 起使用原生 Liquid Glass，較早的版本使用標準系統材質。建置包含兩種架構，實際執行在 Apple 晶片 Mac 上驗證。

## 從原始碼建置

使用內含 macOS 26 SDK 或更新版本的 Xcode 開啟 [EchoBar.xcodeproj](../../EchoBar.xcodeproj)，選 **EchoBar** scheme 和 **My Mac**，按 **⌘R**。通用 Release 建置：

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

建置產物位於 `DerivedData/Build/Products/Release/EchoBar.app`，本機建置使用臨時簽署。

## 授權

[MIT](../../LICENSE)。
