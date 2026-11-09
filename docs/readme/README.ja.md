# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · **日本語** · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

EchoBar は、アプリが再生する音を録音できる小さな macOS ネイティブアプリです。クリックで録音を開始し、もう一度クリックすると WAV で保存します。

![EchoBar の録音画面と設定画面を実際に撮影し、傾けて配置した画像](../../docs/assets/echoBar-hero.png)

## 主な機能

- **システム音声を録音。** Apple の Core Audio でアプリの再生音を取得します。録音中も音は聞こえ、マイクへのアクセス許可は不要です。
- **コンパクトな操作画面。** 7 バンドのリアルタイムスペクトルは左が低音、右が高音です。1 時間を超えると時・分・秒を表示します。録音ボタンまたは **⌘R** で操作できます。
- **WAV の容量を調整。** 入力に合わせるか、16、24、32、44.1、48 kHz から選択できます。ビット深度は 8、16、24 bit です。設定画面に 1 時間あたりの目安を表示します。低い設定では容量と音質の両方が下がります。
- **作業環境に合わせる。** ウインドウの最前面固定、Finder での保存先表示、同じウインドウでの保存先・形式・終了動作の設定が可能です。設定は次回起動時にも引き継がれます。
- **Mac 内で完結。** 録音、設定、復旧情報は Mac に保存されます。テレメトリ、アップロード機能、サードパーティー依存はありません。
- **13 言語。** アプリ内で言語を選べます。アラビア語の設定は右から左に並びます。
- **操作結果が分かりやすい。** 設定画面は同じウインドウ内でスライドします。保存後にステータスをクリックすると Finder に表示でき、macOS の通知でも保存を確認できます。

[録音画面](../../docs/assets/recorder.png) · [設定画面](../../docs/assets/settings.png)

## 録音を始める

1. EchoBar をビルドして起動し、macOS の確認画面でシステム音声の録音を許可します。
2. 別のアプリで音を再生し、赤いボタンを押します。もう一度押すと保存されます。既定の保存先は `~/Music/回聲錄音/` です。
3. フォルダアイコンで保存先を開き、歯車アイコンで設定を変更できます。録音設定は次回から適用されます。

## 復旧と動作環境

通常終了時は録音の保存を完了してから終了します。クラッシュや強制終了後は再起動すると、ディスクに書き込まれた音声を復旧できます。メモリに残っていた末尾の音声は失われることがあります。

対応する Intel または Apple シリコン搭載 Mac と **macOS 14.2 以降**が必要です。macOS 26 以降では Liquid Glass、それ以前では標準のシステムマテリアルを使用します。両アーキテクチャ向けにビルドされ、実機確認は Apple シリコンで行いました。

## ソースからビルド

macOS 26 SDK 以降を含む Xcode で [EchoBar.xcodeproj](../../EchoBar.xcodeproj) を開き、**EchoBar** スキームと **My Mac** を選択して **⌘R** を押します。ユニバーサル Release ビルド：

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

成果物は `DerivedData/Build/Products/Release/EchoBar.app` に生成されます。ローカルビルドはアドホック署名を使います。

## ライセンス

[MIT](../../LICENSE)。
