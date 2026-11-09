<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="EchoBar 应用图标">
</p>

<h1 align="center">🎙️ EchoBar · 回声</h1>

<p align="center"><strong>一键录下 Mac 播放的声音。</strong><br>
免装虚拟声卡。</p>

<p align="center"><strong>约 1.9 MB</strong> · 原生 Swift 开发 · macOS 14.2+ · MIT 开源</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>下载 EchoBar</strong></a> ·
  <a href="#install">安装教程</a> ·
  <a href="#project-structure">项目结构</a>
</p>

[English](../../README.md) · **简体中文** · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="EchoBar 的实际录音与设置界面">
</p>

## ✨ 核心特色

- **小巧原生。** 使用 Swift 开发，通过 Apple Core Audio 捕获系统音频。通用 Release 版约 1.9 MB，无第三方依赖。
- **极简设计。** 所有操作集中在一个小窗口。可按需调整保存位置和 WAV 格式。
- **优先保住录音。** 录音过程中持续写入并定期同步到磁盘。正常退出应用前会完成保存。
- **本地录音。** 只捕获系统音频，无需麦克风权限。录音可离线进行，文件保留在 Mac 上。

<a name="install"></a>

## 📥 安装

1. 前往 [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases)，在最新版本的 **Assets** 中下载 EchoBar。如果下载的是压缩包，请先解压。
2. 将 `EchoBar.app` 拖到 **应用程序（Applications）** 文件夹，然后打开即可使用。

**系统要求** · macOS 14.2 或更高版本，支持 Apple 芯片和 Intel 架构。

## ❓ 常见问题

<details>
<summary>为什么 macOS 会请求权限？</summary>

首次录音时，请按照 macOS 提示允许捕获系统音频。此权限允许 EchoBar 读取 Mac 正在播放的声音。

</details>

<details>
<summary>崩溃或强制退出后，录音还能找回来吗？</summary>

重新打开 EchoBar 时，应用会尝试恢复已写入磁盘的音频。中断时仍在内存中的音频可能丢失。

</details>

<a name="project-structure"></a>

## 📂 项目结构

<details>
<summary>展开源代码和文档目录</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode 项目与共享 Scheme
├── EchoBar/
│   ├── EchoBarApp.swift           # 应用入口、偏好设置与录音状态
│   ├── RecorderView.swift         # 录音窗口与设置界面
│   ├── SystemAudioRecorder.swift  # 系统音频捕获与 WAV 写入
│   ├── RecordingRecovery.swift    # 中断后的录音恢复
│   ├── AudioSpectrum.swift        # 实时音频频谱
│   ├── Localizable.xcstrings     # 界面翻译
│   └── Assets.xcassets/           # 应用图标与界面资源
├── docs/
│   ├── assets/                    # README 配图
│   └── readme/                    # 各语言版本
├── README.md                      # 项目首页
└── LICENSE                        # MIT 许可证
```

</details>

## 🛠️ 从源代码构建

使用包含 **macOS 26 SDK 或更新版本**的 Xcode 打开 [EchoBar.xcodeproj](../../EchoBar.xcodeproj)，选择 **EchoBar** 和 **My Mac**，然后按 **⌘R**。

要构建通用 Release 版，请在项目根目录执行以下命令。

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

构建完成的应用位于 `DerivedData/Build/Products/Release/EchoBar.app`。

## 📄 许可证

[MIT](../../LICENSE)
