<p align="center">
  <img src="../../EchoBar/Assets.xcassets/AppIcon.appiconset/icon-128.png" width="96" height="96" alt="Icône de l’application EchoBar">
</p>

<h1 align="center">🎙️ EchoBar</h1>

<p align="center"><strong>Enregistrez en un clic le son diffusé par votre Mac.</strong><br>
Aucun pilote audio virtuel à installer.</p>

<p align="center"><strong>Environ 1,9 Mo</strong> · Application native en Swift · macOS 14.2+ · Code ouvert sous licence MIT</p>

<p align="center">
  <a href="https://github.com/Adisonyao/EchoBar/releases"><strong>Télécharger EchoBar</strong></a> ·
  <a href="#install">Guide d’installation</a> ·
  <a href="#project-structure">Structure du projet</a>
</p>

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · **Français** · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

<p align="center">
  <img src="../assets/echoBar-hero.png" width="880" alt="Fenêtres d’enregistrement et de réglages d’EchoBar">
</p>

## ✨ Points forts

- **Une application native et légère.** Développée en Swift, elle capture le son du système via Apple Core Audio. La version Release universelle pèse environ 1,9 Mo et ne nécessite aucune dépendance tierce.
- **Une interface épurée.** Toutes les commandes tiennent dans une petite fenêtre. Vous pouvez choisir le dossier de destination et régler le format WAV.
- **La priorité à vos enregistrements.** EchoBar écrit le son en continu et le synchronise régulièrement sur le disque. En cas de fermeture normale, l’enregistrement est sauvegardé avant de quitter.
- **Enregistrement local.** Seul le son du système est capturé, sans accès au microphone. L’enregistrement fonctionne hors ligne et les fichiers restent sur votre Mac.

<a name="install"></a>

## 📥 Installation

1. Sur [GitHub Releases](https://github.com/Adisonyao/EchoBar/releases), téléchargez EchoBar depuis la section **Assets** de la dernière version. Si le fichier est une archive, décompressez-la.
2. Glissez `EchoBar.app` dans le dossier **Applications**, puis ouvrez l’application.

**Configuration requise** · macOS 14.2 ou version ultérieure, sur Mac avec puce Apple ou processeur Intel.

## ❓ Questions fréquentes

<details>
<summary>Pourquoi macOS demande-t-il une autorisation ?</summary>

Au premier enregistrement, suivez l’invite de macOS pour autoriser la capture du son du système. EchoBar pourra ainsi accéder au son diffusé par votre Mac.

</details>

<details>
<summary>Peut-on récupérer un enregistrement après un plantage ou une fermeture forcée ?</summary>

À la réouverture, EchoBar tente de récupérer le son déjà écrit sur le disque. Les données encore en mémoire au moment de l’interruption peuvent être perdues.

</details>

<a name="project-structure"></a>

## 📂 Structure du projet

<details>
<summary>Afficher l’arborescence du code et de la documentation</summary>

```text
EchoBar/
├── EchoBar.xcodeproj/             # Projet Xcode et schéma partagé
├── EchoBar/
│   ├── EchoBarApp.swift           # Point d’entrée, préférences et état de l’enregistrement
│   ├── RecorderView.swift         # Fenêtre d’enregistrement et réglages
│   ├── SystemAudioRecorder.swift  # Capture du son système et écriture WAV
│   ├── RecordingRecovery.swift    # Récupération des enregistrements interrompus
│   ├── AudioSpectrum.swift        # Spectre audio en temps réel
│   ├── Localizable.xcstrings     # Traductions de l’interface
│   └── Assets.xcassets/           # Icône et ressources de l’interface
├── docs/
│   ├── assets/                    # Images du README
│   └── readme/                    # README traduits
├── README.md                      # Page d’accueil du projet
└── LICENSE                        # Licence MIT
```

</details>

## 🛠️ Compiler depuis les sources

Ouvrez [EchoBar.xcodeproj](../../EchoBar.xcodeproj) dans une version de Xcode qui inclut le **SDK de macOS 26 ou ultérieur**. Sélectionnez **EchoBar** et **My Mac**, puis appuyez sur **⌘R**.

Pour compiler une version Release universelle, exécutez cette commande à la racine du dépôt.

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

L’application compilée se trouve dans `DerivedData/Build/Products/Release/EchoBar.app`.

## 📄 Licence

[MIT](../../LICENSE)
