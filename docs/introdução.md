# Introdução

O Projeto Elvira é um launcher para Android criado com foco total em acessibilidade para pessoas idosas. Inspirado em Dona Elvira, bisavó do desenvolvedor, o projeto surge como uma resposta afetiva e funcional às dificuldades enfrentadas por idosos no uso de smartphones modernos.

A proposta vai além de uma interface simplificada: Elvira é uma experiência completa, com assistente virtual, interação por voz, lembretes de medicamentos, leitura de mensagens e um sistema de detecção de risco para casos de Alzheimer.

O objetivo é garantir mais autonomia, segurança e dignidade digital para pessoas da terceira idade, ao mesmo tempo que se oferece um sistema gratuito, leve e independente de conexão com a internet.

## Objetivos do Projeto
- Tornar o uso de smartphones acessível para idosos com limitações visuais, motoras ou cognitivas leves.
- Proporcionar uma experiência amigável, acolhedora e intuitiva.
- Garantir que o app seja funcional mesmo offline.
- Manter o projeto 100% gratuito, com código aberto e licença livre.

## Estrutura de Pastas do Projeto

```bash
elvira_launcher/
├── android/
├── ios/
├── web/
├── macos/
├── linux/
├── windows/
├── assets/
│   ├── images/
│   ├── audio/
│   └── fonts/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── core/               # Constantes globais, helpers e temas
│       ├── data/               # Models, banco de dados local
│       ├── logic/              # Serviços, controladores, lógica do app
│       ├── ui/                 # Telas, widgets, componentes de interface
│       └── config/             # Rotas, configurações globais
└── pubspec.yaml
```

Cada pasta tem uma função bem definida e foi pensada para permitir escalabilidade e manutenção fácil. A modularização segue princípios comuns de clean architecture adaptados à estrutura Flutter.

## Links úteis
- [Repositório no GitHub](https://github.com/Pews-Cavern/Elvira)
- [Protótipo no Figma](https://www.figma.com/design/XMdoM2kgV5p8qi8x8AAfzm/Elvira)
- [README Principal](https://github.com/Pews-Cavern/Elvira/blob/main/README.md)
