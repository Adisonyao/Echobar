# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · **Français** · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

EchoBar est un enregistreur natif et compact pour macOS qui capture le son lu par vos apps. Un clic lance l’enregistrement, un autre le sauvegarde en WAV.

![Captures réelles des fenêtres d’enregistrement et de réglages d’EchoBar, présentées en biais](../../docs/assets/echoBar-hero.png)

## Fonctionnalités

- **Capture de l’audio système.** EchoBar utilise Core Audio d’Apple pour capter la lecture des apps. Le son reste audible pendant l’enregistrement, sans autorisation d’accès au micro.
- **Une petite fenêtre dédiée à l’enregistrement.** Le spectre en direct à sept bandes affiche les graves à gauche et les aigus à droite. Après une heure, le compteur affiche les heures, les minutes et les secondes. Utilisez le bouton rond ou **⌘R**.
- **Taille des fichiers réglable.** Le PCM WAV suit la source ou utilise 16, 24, 32, 44,1 ou 48 kHz, en 8, 16 ou 24 bits. Les réglages estiment le volume par heure. Une qualité réduite produit des fichiers plus petits.
- **Des réglages qui restent en place.** Gardez la fenêtre au premier plan, ouvrez le dossier dans le Finder et ajustez le dossier, le format et le comportement à la fermeture dans la même fenêtre. Les préférences sont conservées localement.
- **Stockage local.** Les enregistrements, préférences et informations de récupération restent sur le Mac. EchoBar ne comporte ni télémétrie, ni fonction de téléversement, ni dépendance tierce.
- **13 langues.** Choisissez une langue dans l’app ou suivez macOS. Les réglages en arabe se lisent de droite à gauche.
- **Un retour clair.** Les réglages glissent dans la même fenêtre. Après la sauvegarde, cliquez sur l’état pour afficher le fichier dans le Finder ou activez les notifications macOS.

[Capture de l’enregistreur](../../docs/assets/recorder.png) · [Capture des réglages](../../docs/assets/settings.png)

## Démarrer un enregistrement

1. Compilez puis lancez EchoBar. Autorisez la capture de l’audio système à la demande de macOS.
2. Lancez la lecture dans une autre app et cliquez sur le bouton rouge. Cliquez à nouveau pour sauvegarder. Le dossier par défaut est `~/Music/回聲錄音/`.
3. L’icône du dossier ouvre la destination. L’engrenage ouvre les réglages, qui s’appliquent au prochain enregistrement.

## Récupération et compatibilité

Lors d’une fermeture normale, EchoBar termine la sauvegarde avant de quitter. Après un plantage ou une fermeture forcée, rouvrez l’app pour récupérer l’audio déjà écrit sur le disque. La partie encore en mémoire peut être perdue.

Il faut **macOS 14.2 ou ultérieur** sur un Mac Intel ou Apple silicon compatible. Liquid Glass est disponible à partir de macOS 26. Les versions précédentes utilisent les matériaux standard du système. Le binaire inclut les deux architectures. L’exécution a été vérifiée sur Apple silicon.

## Compiler depuis le code source

Ouvrez [EchoBar.xcodeproj](../../EchoBar.xcodeproj) avec Xcode et le SDK macOS 26 ou ultérieur. Sélectionnez **EchoBar**, puis **My Mac** et appuyez sur **⌘R**. Pour une version Release universelle :

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

L’app se trouve dans `DerivedData/Build/Products/Release/EchoBar.app`. Les compilations locales utilisent une signature ad hoc.

## Licence

[MIT](../../LICENSE).
