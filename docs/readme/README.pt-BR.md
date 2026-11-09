# EchoBar

[English](../../README.md) · [简体中文](README.zh-Hans.md) · [繁體中文](README.zh-Hant.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · [Español](README.es.md) · [Deutsch](README.de.md) · **Português (Brasil)** · [Italiano](README.it.md) · [हिन्दी](README.hi.md)

O EchoBar é um gravador compacto e nativo para macOS que captura o som reproduzido pelos apps. Clique para gravar e clique de novo para salvar em WAV.

![Capturas reais das janelas de gravação e configurações do EchoBar em uma composição inclinada](../../docs/assets/echoBar-hero.png)

## Recursos

- **Gravação do áudio do sistema.** O EchoBar usa o Core Audio da Apple para capturar a reprodução dos apps. O som continua audível durante a gravação e o app dispensa acesso ao microfone.
- **Janela compacta.** O espectro ao vivo tem sete bandas, com graves à esquerda e agudos à direita. Depois de uma hora, o contador mostra horas, minutos e segundos. Use o botão redondo ou **⌘R**.
- **Controle do tamanho do arquivo.** O WAV PCM pode manter a taxa original ou usar 16, 24, 32, 44,1 ou 48 kHz, com 8, 16 ou 24 bits. As configurações estimam o tamanho por hora. Valores menores reduzem o tamanho e a fidelidade.
- **Ajustes que ficam salvos.** Mantenha a janela em primeiro plano, abra a pasta no Finder e altere o destino, o formato e o comportamento ao fechar na mesma janela. As preferências ficam no Mac.
- **Dados locais.** Gravações, preferências e informações de recuperação permanecem no dispositivo. O EchoBar não inclui telemetria, função de upload ou dependências de terceiros.
- **13 idiomas.** Escolha o idioma no app ou siga o macOS. As configurações em árabe são exibidas da direita para a esquerda.
- **Confirmação visível.** As configurações deslizam na mesma janela. Depois de salvar, clique no status para mostrar o arquivo no Finder ou ative as notificações do macOS.

[Captura do gravador](../../docs/assets/recorder.png) · [Captura das configurações](../../docs/assets/settings.png)

## Como gravar

1. Compile e abra o EchoBar. Permita a captura de áudio do sistema quando o macOS pedir.
2. Reproduza som em outro app e clique no botão vermelho. Clique novamente para salvar. A pasta padrão é `~/Music/回聲錄音/`.
3. O ícone de pasta abre o destino e a engrenagem abre as configurações. As configurações de gravação valem para a próxima sessão.

## Recuperação e compatibilidade

Ao sair normalmente, o EchoBar termina de salvar a gravação. Depois de uma falha ou encerramento forçado, reabra o app para recuperar o áudio já escrito no disco. O trecho ainda na memória pode ser perdido.

Requer **macOS 14.2 ou posterior** em um Mac Intel ou Apple Silicon compatível. O Liquid Glass está disponível a partir do macOS 26. Versões anteriores usam os materiais padrão do sistema. A compilação inclui as duas arquiteturas. O funcionamento foi testado em Apple Silicon.

## Compilar a partir do código-fonte

Abra [EchoBar.xcodeproj](../../EchoBar.xcodeproj) no Xcode com o SDK do macOS 26 ou posterior. Selecione **EchoBar** e **My Mac**, depois pressione **⌘R**. Para uma compilação Release universal:

```sh
xcodebuild -project EchoBar.xcodeproj -scheme EchoBar -configuration Release \
  -destination 'generic/platform=macOS' -derivedDataPath DerivedData build
```

O app é gerado em `DerivedData/Build/Products/Release/EchoBar.app`. A compilação local usa assinatura ad hoc.

## Licença

[MIT](../../LICENSE).
