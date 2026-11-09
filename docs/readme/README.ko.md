<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="EchoBar 앱 아이콘">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>클릭 한 번으로 Mac에서 재생되는 소리를 녹음하세요.</strong><br>
가상 오디오 드라이버를 설치할 필요가 없습니다.</p>

<p align="center"><strong>약 1.9 MB</strong> · Swift 네이티브 앱 · macOS 14.2+ · MIT 라이선스 오픈 소스</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>EchoBar 다운로드</strong></a> ·
  <a href="#install">설치 안내</a> ·
  <a href="#project-structure">프로젝트 구조</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · **한국어** · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="EchoBar의 실제 녹음 및 설정 화면">
</p>

## ✨ 주요 특징

- **작은 네이티브 앱.** Swift로 개발했으며 Apple Core Audio로 시스템 오디오를 캡처합니다. 유니버설 Release 앱은 약 1.9 MB이며 서드파티 종속성이 없습니다.
- **간결한 디자인.** 작은 창 하나에서 모든 기능을 이용할 수 있습니다. 저장 위치와 WAV 형식을 바꿀 수 있습니다.
- **녹음 보존을 우선.** 녹음 중 데이터를 계속 기록하고 주기적으로 디스크에 동기화합니다. 앱을 정상 종료할 때는 저장을 먼저 마칩니다.
- **로컬 녹음.** 시스템 오디오만 캡처하므로 마이크 권한이 필요 없습니다. 오프라인에서도 녹음할 수 있으며 파일은 Mac에 저장됩니다.

<a name="install"></a>

## 📥 설치

1. [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases)에서 최신 버전의 **Assets**를 열어 EchoBar를 다운로드합니다. 압축 파일이라면 먼저 압축을 풉니다.
2. `EchoBar.app`을 **응용 프로그램(Applications)** 폴더로 드래그한 뒤 실행합니다.

**시스템 요구 사항** · macOS 14.2 이상, Apple Silicon 및 Intel Mac 지원.

## ❓ 자주 묻는 질문

<details>
<summary>macOS가 권한을 요청하는 이유는 무엇인가요?</summary>

처음 녹음할 때 macOS 안내에 따라 시스템 오디오 캡처를 허용하세요. 이 권한으로 EchoBar가 Mac에서 재생 중인 소리에 접근할 수 있습니다.

</details>

<details>
<summary>앱이 충돌하거나 강제 종료되면 녹음을 복구할 수 있나요?</summary>

EchoBar를 다시 열면 디스크에 기록된 오디오를 복구하려고 시도합니다. 중단 당시 메모리에 남아 있던 오디오는 손실될 수 있습니다.

</details>

<a name="project-structure"></a>

## 📂 프로젝트 구조

<details>
<summary>소스 코드와 문서 구성 펼치기</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Xcode 프로젝트 및 공유 스킴
├── EchoBar/
│   ├── EchoBarApp.swift           # 앱 진입점, 환경설정, 녹음 상태
│   ├── RecorderView.swift         # 녹음 창 및 설정 화면
│   ├── SystemAudioRecorder.swift  # 시스템 오디오 캡처 및 WAV 기록
│   ├── RecordingRecovery.swift    # 중단된 녹음 복구
│   ├── AudioSpectrum.swift        # 실시간 오디오 스펙트럼
│   ├── Localizable.xcstrings     # 인터페이스 번역
│   └── Assets.xcassets/           # 앱 아이콘 및 UI 리소스
├── docs/
│   ├── assets/                    # README 이미지
│   └── readme/                    # 언어별 README
├── README.md                      # 프로젝트 홈
└── LICENSE                        # MIT 라이선스
```

</details>

## 🛠️ 소스에서 빌드

**macOS 26 SDK 이상**이 포함된 Xcode에서 [EchoBar.xcodeproj](../../EchoBar.xcodeproj)를 엽니다. **EchoBar**와 **My Mac**을 선택하고 **⌘R**을 누릅니다.

유니버설 Release 빌드는 저장소 루트에서 다음 명령을 실행합니다.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

빌드한 앱은 `DerivedData/Build/Products/Release/EchoBar.app`에 있습니다.

## 📄 라이선스

[MIT](../../LICENSE)
