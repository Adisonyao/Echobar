<div dir="rtl" lang="ar">

<p align="center">
  <img src="../assets/icon/echobar-icon-128.png" width="96" height="96" alt="أيقونة تطبيق EchoBar">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>سجّل بنقرة واحدة الصوت الذي يشغّله جهاز Mac.</strong><br>
دون الحاجة إلى تثبيت برنامج تشغيل صوت افتراضي.</p>

<p align="center"><strong>نحو 2.8 ميغابايت</strong> · تطبيق أصلي بلغة Swift · macOS 14.2+ · مفتوح المصدر بترخيص MIT</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases/latest/download/EchoBar-macOS.zip"><strong>تنزيل EchoBar</strong></a> ·
  <a href="#install">دليل التثبيت</a> ·
  <a href="#project-structure">بنية المشروع</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · **العربية** · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="نافذتا التسجيل والإعدادات في EchoBar">
</p>

## ✨ أبرز المزايا

- **تطبيق أصلي خفيف.** كُتب بلغة Swift ويستخدم Apple Core Audio لالتقاط صوت النظام. يبلغ حجم الإصدار العام لكلا المعماريتين نحو 2.8 ميغابايت ولا يعتمد على مكتبات خارجية.
- **تصميم بسيط.** جميع عناصر التحكم في نافذة صغيرة واحدة. يمكنك تغيير مكان الحفظ وإعدادات صيغة WAV.
- **الأولوية لحفظ التسجيل.** يكتب EchoBar بيانات الصوت طوال مدة التسجيل ويزامنها مع القرص دوريًا. عند إنهاء التطبيق بالطريقة المعتادة، يُكمل الحفظ أولًا.
- **تسجيل محلي.** يلتقط صوت النظام فقط ولا يحتاج إلى إذن الميكروفون. يعمل التسجيل دون اتصال بالإنترنت وتبقى الملفات على جهاز Mac.

<a name="install"></a>

## 📥 التثبيت

1. انتقل إلى [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases) ونزّل EchoBar من قسم **Assets** في أحدث إصدار. إذا كان الملف مضغوطًا، ففك ضغطه أولًا.
2. اسحب `EchoBar.app` إلى مجلد **التطبيقات (Applications)** ثم افتحه.

**متطلبات النظام** · macOS 14.2 أو أحدث، على أجهزة Mac المزوّدة بشرائح Apple أو معالجات Intel.

## ❓ الأسئلة الشائعة

<details>
<summary>لماذا يطلب macOS إذنًا؟</summary>

عند التسجيل لأول مرة، اتبع مطالبة macOS للسماح بالتقاط صوت النظام. يتيح هذا الإذن لـ EchoBar الوصول إلى الصوت الذي يشغّله جهاز Mac.

</details>

<details>
<summary>هل يمكن استعادة التسجيل بعد تعطل التطبيق أو فرض إنهائه؟</summary>

عند إعادة فتح EchoBar، يحاول التطبيق استعادة الصوت الذي سبق حفظه على القرص. قد تفقد بيانات الصوت التي كانت لا تزال في الذاكرة عند الانقطاع.

</details>

<a name="project-structure"></a>

## 📂 بنية المشروع

<details>
<summary>عرض بنية الشيفرة المصدرية والوثائق</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # مشروع Xcode ومخطط البناء المشترك
├── EchoBar/
│   ├── EchoBarApp.swift           # نقطة بدء التطبيق والتفضيلات وحالة التسجيل
│   ├── RecorderView.swift         # نافذة التسجيل والإعدادات
│   ├── SystemAudioRecorder.swift  # التقاط صوت النظام والكتابة بصيغة WAV
│   ├── RecordingRecovery.swift    # استعادة التسجيل بعد الانقطاع
│   ├── AudioSpectrum.swift        # طيف الصوت في الوقت الفعلي
│   ├── Localizable.xcstrings     # ترجمات الواجهة
│   └── AppIcon.icon/              # ملف أيقونة التطبيق (Icon Composer)
├── docs/
│   ├── assets/                    # صور README
│   │   └── icon/echobar-icon-128.png
│   └── readme/                    # نسخ README باللغات المختلفة
├── README.md                      # الصفحة الرئيسية للمشروع
└── LICENSE                        # ترخيص MIT
```

</details>

## 🛠️ البناء من الشيفرة المصدرية

افتح [EchoBar.xcodeproj](../../EchoBar.xcodeproj) في Xcode المزود بـ **حزمة SDK لنظام macOS 26 أو أحدث**. اختر **EchoBar** و**My Mac**، ثم اضغط **⌘R**.

لبناء إصدار Release لكلا المعماريتين، نفّذ الأمر التالي من المجلد الرئيسي للمستودع.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

ستجد التطبيق بعد البناء في `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 الترخيص

[MIT](../../LICENSE)

</div>
