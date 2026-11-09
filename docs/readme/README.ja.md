<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="EchoBar のアプリアイコン">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Mac で再生している音をワンクリックで録音。</strong><br>
仮想オーディオドライバは不要です。</p>

<p align="center"><strong>約 1.9 MB</strong> · Swift 製のネイティブアプリ · macOS 14.2+ · MIT ライセンスのオープンソース</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>EchoBar をダウンロード</strong></a> ·
  <a href="#install">インストール方法</a> ·
  <a href="#project-structure">プロジェクト構成</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · **日本語** · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="EchoBar の録音画面と設定画面">
</p>

## ✨ 主な特長

- **小さなネイティブアプリ。** Swift で開発し、Apple Core Audio でシステム音声を取り込みます。ユニバーサル版の Release ビルドは約 1.9 MB で、サードパーティ製の依存ライブラリはありません。
- **シンプルな設計。** 操作は小さなウインドウひとつに集約。保存先や WAV 形式を変更できます。
- **録音データの保護を優先。** 録音中はデータを継続して書き込み、定期的にディスクへ同期します。通常終了時は保存を終えてからアプリを終了します。
- **ローカルで録音。** システム音声のみを取り込むため、マイクの許可は不要です。オフラインでも録音でき、ファイルは Mac に保存されます。

<a name="install"></a>

## 📥 インストール

1. [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases) の最新版の **Assets** から EchoBar をダウンロードします。圧縮ファイルの場合は先に展開してください。
2. `EchoBar.app` を **アプリケーション（Applications）** フォルダへドラッグし、アプリを開きます。

**動作環境** · macOS 14.2 以降。Apple シリコンと Intel の Mac に対応。

## ❓ よくある質問

<details>
<summary>macOS が許可を求めるのはなぜですか？</summary>

初回の録音時に、macOS の案内に従ってシステム音声の取り込みを許可してください。この許可により、EchoBar は Mac で再生中の音声にアクセスできます。

</details>

<details>
<summary>クラッシュや強制終了の後に録音を復元できますか？</summary>

EchoBar を開き直すと、ディスクに書き込まれた音声の復元を試みます。中断時にメモリに残っていた音声は失われることがあります。

</details>

<a name="project-structure"></a>

## 📂 プロジェクト構成

<details>
<summary>ソースコードとドキュメントの構成を表示</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode プロジェクトと共有スキーム
├── EchoBar/
│   ├── EchoBarApp.swift           # アプリの起点、設定、録音状態
│   ├── RecorderView.swift         # 録音ウインドウと設定画面
│   ├── SystemAudioRecorder.swift  # システム音声の取り込みと WAV 書き込み
│   ├── RecordingRecovery.swift    # 中断後の録音データ復元
│   ├── AudioSpectrum.swift        # リアルタイムの音声スペクトル
│   ├── Localizable.xcstrings     # UI の翻訳
│   └── Assets.xcassets/           # アプリアイコンと UI 素材
├── docs/
│   ├── assets/                    # README 用画像
│   └── readme/                    # 各言語の README
├── README.md                      # プロジェクトのトップページ
└── LICENSE                        # MIT ライセンス
```

</details>

## 🛠️ ソースからビルド

**macOS 26 SDK 以降**を搭載した Xcode で [EchoBar.xcodeproj](../../EchoBar.xcodeproj) を開きます。**EchoBar** と **My Mac** を選び、**⌘R** を押します。

ユニバーサル版の Release ビルドは、リポジトリのルートで次のコマンドを実行します。

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

ビルドしたアプリは `DerivedData/Build/Products/Release/EchoBar.app` にあります。

## 📄 ライセンス

[MIT](../../LICENSE)
