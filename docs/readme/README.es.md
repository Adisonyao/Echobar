# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · **Español** · [Deutsch](README.de.md) · [Português (Brasil)](README.pt-BR.md) · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

EchoBar es una grabadora nativa y compacta para macOS. Captura el audio que reproducen tus aplicaciones. Haz clic para iniciar y otra vez para guardar en WAV.

![Capturas reales de las ventanas de grabación y ajustes de EchoBar, presentadas en una composición inclinada](../../docs/assets/echoBar-hero.png)

## Funciones

- **Captura del audio del sistema.** Usa Core Audio de Apple para grabar lo que reproducen las aplicaciones. El sonido sigue siendo audible durante la grabación y no hace falta autorizar el micrófono.
- **Una ventana pequeña para grabar.** El espectro en directo tiene siete bandas, con graves a la izquierda y agudos a la derecha. Al pasar una hora, el contador muestra horas, minutos y segundos. Usa el botón redondo o **⌘R**.
- **Control del tamaño del archivo.** El WAV PCM puede seguir la frecuencia original o usar 16, 24, 32, 44,1 o 48 kHz, con 8, 16 o 24 bits. Los ajustes estiman el tamaño por hora. Los valores más bajos reducen el tamaño y la fidelidad.
- **Ajustes para tu forma de trabajar.** Puedes mantener la ventana en primer plano, abrir la carpeta en Finder y cambiar la carpeta, el formato y la acción de cierre en la misma ventana. Las preferencias se guardan localmente.
- **Datos en tu Mac.** Las grabaciones, preferencias y datos de recuperación se almacenan en el dispositivo. No hay telemetría, funciones de subida ni dependencias externas.
- **13 idiomas.** Elige el idioma en la app o sigue el de macOS. Los ajustes en árabe se presentan de derecha a izquierda.
- **Confirmación visible.** Los ajustes se deslizan dentro de la misma ventana. Al guardar, pulsa el estado para mostrar el archivo en Finder o activa las notificaciones de macOS.

[Captura de la grabadora](../../docs/assets/recorder.png) · [Captura de los ajustes](../../docs/assets/settings.png)

## Cómo grabar

1. Compila y abre EchoBar. Autoriza la captura de audio del sistema cuando lo solicite macOS.
2. Reproduce audio en otra app y pulsa el botón rojo. Pulsa de nuevo para guardar. La carpeta predeterminada es `~/Music/回聲錄音/`.
3. El icono de carpeta abre el destino y el engranaje abre los ajustes. Los ajustes de grabación se aplican a la siguiente sesión.

## Recuperación y compatibilidad

Al salir normalmente, EchoBar termina de guardar la grabación. Si la app falla o se fuerza su cierre, vuelve a abrirla para recuperar el audio que ya se escribió en disco. El fragmento que aún estaba en memoria podría perderse.

Requiere **macOS 14.2 o posterior** en un Mac Intel o Apple silicon compatible. Liquid Glass está disponible desde macOS 26. Las versiones anteriores usan los materiales estándar del sistema. La compilación incluye ambas arquitecturas. Se comprobó la ejecución en Apple silicon.

## Compilar desde el código fuente

Abre [EchoBar.xcodeproj](../../EchoBar.xcodeproj) en Xcode con el SDK de macOS 26 o posterior. Selecciona **EchoBar** y **My Mac**, y pulsa **⌘R**. Para una compilación Release universal:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

La aplicación queda en `DerivedData/Build/Products/Release/EchoBar.app`. La compilación local usa firma ad hoc.

## Licencia

[MIT](../../LICENSE).
