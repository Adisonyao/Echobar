# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · **한국어** · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

EchoBar는 앱에서 재생되는 소리를 녹음하는 작고 가벼운 macOS 네이티브 앱입니다. 한 번 눌러 녹음하고 다시 눌러 WAV로 저장합니다.

![실제 EchoBar 녹음 창과 설정 화면을 기울여 배치한 이미지](../../docs/assets/echoBar-hero.png)

## 주요 기능

- **시스템 오디오 녹음.** Apple Core Audio로 앱의 재생음을 캡처합니다. 녹음 중에도 소리가 들리며 마이크 접근 권한은 필요하지 않습니다.
- **작고 간편한 창.** 실시간 7밴드 스펙트럼의 왼쪽은 저음, 오른쪽은 고음입니다. 한 시간이 지나면 시·분·초를 표시합니다. 둥근 녹음 버튼이나 **⌘R**로 조작합니다.
- **파일 크기 조절.** 원본 샘플 레이트 또는 16, 24, 32, 44.1, 48 kHz와 8, 16, 24 bit 중에서 선택합니다. 설정에서 시간당 WAV 크기를 추정합니다. 낮은 설정은 파일 크기와 음질을 함께 줄입니다.
- **작업 환경에 맞는 설정.** 창을 일반 창 위에 고정하고 Finder에서 저장 폴더를 열 수 있습니다. 같은 창에서 폴더, 녹음 형식, 닫기 동작을 바꿀 수 있으며 설정은 다음 실행에도 유지됩니다.
- **로컬 저장.** 녹음, 설정, 복구 정보는 Mac에 저장됩니다. 원격 측정, 업로드 기능, 타사 의존성은 없습니다.
- **13개 언어.** 앱에서 언어를 선택하거나 시스템 설정을 따릅니다. 아랍어 설정은 오른쪽에서 왼쪽으로 배치됩니다.
- **명확한 상태 표시.** 같은 창에서 설정 화면이 슬라이드로 전환됩니다. 저장한 뒤 상태를 눌러 Finder에서 파일을 열거나 macOS 알림으로 저장 여부를 확인할 수 있습니다.

[녹음 화면](../../docs/assets/recorder.png) · [설정 화면](../../docs/assets/settings.png)

## 녹음 시작

1. EchoBar를 빌드해 실행하고, macOS가 묻는 경우 시스템 오디오 녹음을 허용합니다.
2. 다른 앱에서 소리를 재생한 뒤 빨간 버튼을 누릅니다. 다시 누르면 기본 위치 `~/Music/回聲錄音/`에 저장됩니다.
3. 폴더 아이콘으로 저장 위치를 열고 톱니바퀴로 설정을 바꿉니다. 녹음 설정은 다음 녹음부터 적용됩니다.

## 복구와 호환성

정상 종료할 때는 녹음을 저장한 후 앱이 종료됩니다. 충돌이나 강제 종료 후 앱을 다시 열면 디스크에 기록된 오디오를 복구할 수 있습니다. 메모리에만 남아 있던 끝부분은 손실될 수 있습니다.

지원되는 Intel 또는 Apple Silicon Mac에서 **macOS 14.2 이상**이 필요합니다. macOS 26 이상은 Liquid Glass를 사용하고 이전 버전은 표준 시스템 소재를 사용합니다. 두 아키텍처를 포함하며 실제 실행은 Apple Silicon에서 확인했습니다.

## 소스에서 빌드

macOS 26 SDK 이상을 포함한 Xcode에서 [EchoBar.xcodeproj](../../EchoBar.xcodeproj)를 열고 **EchoBar** 스킴과 **My Mac**을 선택한 뒤 **⌘R**을 누릅니다. 범용 Release 빌드:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

결과물은 `DerivedData/Build/Products/Release/EchoBar.app`에 생성됩니다. 로컬 빌드는 임시 서명을 사용합니다.

## 라이선스

[MIT](../../LICENSE).
