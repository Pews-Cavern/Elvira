# Elvira App (Flutter)

Este diretório contém o código-fonte do aplicativo Flutter do projeto **Elvira**, um launcher Android com foco em acessibilidade para idosos.  

O projeto busca oferecer uma experiência simples, acessível e offline, com recursos adaptados para idosos com dificuldades visuais, cognitivas ou motoras.

---

## 🎯 Objetivos Técnicos

- Interface acessível e de alto contraste
- Navegação simplificada com botões grandes
- Funcionalidades offline (sem dependência de internet)
- Modularidade e arquitetura escalável
- Totalmente open-source

---

## 🗂 Estrutura

```bash
elvira/
├── assets/
│   ├── audio/                # Sons e alertas do sistema
│   ├── fonts/                # Tipografias customizadas
│   ├── icons/                # Ícones simples para botões e elementos de UI
│   └── images/               # Imagens da interface e conteúdo visual
│       ├── backgrounds/      # Fundos de tela (ex: tela inicial)
│       ├── personagens/      # Ilustrações dos personagens fictícios
│       │   ├── elvira/       # Imagens da personagem Elvira
│       │   ├── nelson/       # Imagens do personagem Nelson
│       │   └── paulo/        # Imagens do personagem Paulo
│       └── vida_real/        # Fotos reais da família (ex: Elvira, Nelson, etc.)
├── lib/
│   ├── main.dart             # Ponto de entrada da aplicação Flutter
│   └── src/
│       ├── config/           # Rotas e configurações globais
│       ├── core/             # Constantes, temas e helpers globais
│       ├── data/             # Models, banco local e estrutura de dados
│       │   ├── database/
│       │   └── models/
│       ├── logic/            # Controladores e serviços
│       │   ├── controllers/
│       │   └── services/
│       └── ui/               # Interface do usuário
│           ├── layout/       # Estrutura de layout e responsividade
│           ├── screens/      # Telas completas da aplicação
│           └── widgets/      # Componentes visuais reutilizáveis (ex: botões)
└── pubspec.yaml              # Arquivo de configuração do Flutter (dependências e assets)
```

---

### pew_buttons.dart

Este arquivo centraliza a exportação de todos os botões, permitindo que sejam importados de forma única em qualquer lugar do app:

```dart
import 'package:elvira/src/ui/widgets/buttons/pew_buttons.dart';
```

---

### ElviraButton

Botão principal utilizado no projeto, pensado para:

- Tamanho ampliado (180x90)
- Texto centralizado com `FittedBox`
- Cores padronizadas com nome simples (`"green"`, `"red"` etc.)
- Alto contraste e tipografia legível

#### Uso:
```dart
ElviraButton(
  text: 'Emergência',
  color: 'red', // verde, azul, etc. (mapa interno)
  onPressed: () {
    // ação aqui
  },
)
```

As cores são definidas por meio de um `Map<String, Color>` acessível em `elvira_colors.dart`, baseado em diretrizes de acessibilidade para idosos (contraste, daltonismo, conforto visual).

---

### Outros Componentes

- **ElviraEmergencyButton**: Pré-configurado com cor vermelha e estilo de destaque, ideal para ações de urgência.
- **ElviraIconButton**: Variante compacta e sem texto, usada para atalhos com ícones PNG/SVG.

---

### Vantagens

- Centralização: Todos os botões seguem o mesmo padrão visual.
- Acessibilidade: Contraste e tamanho respeitam recomendações da WCAG.
- Escalabilidade: Facilidade de manutenção ou adição de novos estilos centralizados.

---

> Para alterar a aparência de todos os botões, basta editar o arquivo `elvira_button.dart` ou ajustar os valores em `elvira_colors.dart`.

---

## 📱 Requisitos

- Flutter 3.7+
- Android SDK configurado
- Dispositivo Android real ou emulador

---

## ▶ Como rodar

```bash
# Instale as dependências
flutter pub get

# Rode em um dispositivo/emulador Android
flutter run
```

---

## 🧩 Principais Pacotes Usados

| Pacote             | Função                                 |
|--------------------|----------------------------------------|
| `provider`         | Gerenciamento de estado                |
| `flutter_tts`      | Texto para fala (modo offline)         |
| `sqflite`          | Banco de dados local SQLite            |
| `permission_handler` | Gerenciar permissões do sistema      |
| `path_provider`    | Acesso a diretórios do sistema         |

---

## 📌 Observações

- Este app é parte do projeto [Elvira Launcher](https://github.com/Pews-Cavern/Elvira)
- O foco está em manter o projeto leve, funcional e acessível.
- Para o design visual, veja o [protótipo no Figma](https://www.figma.com/design/XMdoM2kgV5p8qi8x8AAfzm/Elvira)

---

## 📄 Licença

Leia a nossa [LICENÇA](https://github.com/Pews-Cavern/Elvira/blob/main/LICENSE) antes de qualquer alteração  
Contribuições são bem-vindas!

