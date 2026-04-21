# Elvira — Contexto do Projeto

> Leia também `PI_V_TADS_Proposta_de_Tema_1-1_1.pdf` nesta pasta para o documento acadêmico completo.

---

## 1. O que é

Launcher Android para idosos e pessoas com necessidades especiais.  
Projeto Integrador V — ADS — Universidade Tuiuti do Paraná — 2026.  
Desenvolvedor: Paulo Eduardo Konopka.  
Licença: MIT / Open Source.

---

## 2. Motivação

A Vó Elvira tinha smartphone e não conseguia ligar para a filha sozinha.  
O Vô Nelson esquecia os remédios porque a letra era pequena demais.  
O app existe para devolver autonomia a quem tanto nos ensinou a ser independentes.

---

## 3. Stack definida

- **Flutter** (Android, mínimo API 26 / Android 8.0 Oreo)
- Armazenamento local: `sqflite` ou `hive` — sem backend, sem nuvem
- Alarmes: `flutter_local_notifications` + `alarm` package
- Launcher real: `home_widget` ou integração nativa via `MethodChannel`
- Tema: material 3, sem dark mode por padrão (idosos usam tela clara)

---

## 4. Princípios de acessibilidade (inegociáveis)

- Fonte mínima de corpo: **18sp**
- Botões de ação principal: altura mínima **64dp**
- Alto contraste: texto escuro em fundo claro, nunca cinza claro
- Sem animações desnecessárias (reduz confusão cognitiva)
- Nenhuma ação destrutiva sem confirmação explícita
- Botão de emergência sempre visível na tela principal
- Ícones sempre acompanhados de label textual
- Calibração de fonte no onboarding (usuário define o tamanho ideal)

---

## 5. Paleta de cores

| Uso | Hex |
|---|---|
| Primário (navy) | `#0C447C` |
| Secundário (blue) | `#185FA5` |
| Accent blue | `#378ADD` |
| Blue claro | `#B5D4F4` |
| Blue xclaro | `#E6F1FB` |
| Verde (sucesso/tomado) | `#1D9E75` |
| Verde escuro | `#085041` |
| Verde claro | `#9FE1CB` |
| Vermelho (alerta/emergência) | `#A32D2D` |
| Vermelho médio | `#E24B4A` |
| Vermelho claro | `#FCEBEB` |
| Âmbar (atenção) | `#BA7517` |
| Fundo geral | `#F0F4F8` |
| Fundo card | `#FFFFFF` |
| Texto principal | `#0C447C` |
| Texto secundário | `#185FA5` |
| Texto desabilitado | `#888780` |

---

## 6. Arquitetura de telas

### Fluxo do idoso

```
Onboarding (primeira vez)
  └── Boas-vindas (storytelling Vó Elvira + Vô Nelson)
  └── Wizard passo 1/4 — Nome
  └── Wizard passo 2/4 — Gênero / como ser chamado
  └── Wizard passo 3/4 — Tem cuidador?
  └── Wizard passo 4/4 — Calibração de acessibilidade
        ├── Teste de tamanho de fonte (botão que cresce a cada toque)
        └── Teste de volume (Sim/Não)

App principal (launcher)
  └── Launcher Home
        ├── Hora/data em destaque (48sp+)
        ├── Bateria
        ├── Grade de apps (2x2, ícone + label grande)
        └── Botão EMERGÊNCIA (vermelho, sempre visível)
  └── Discagem
        ├── Display do número digitado
        ├── Numpad grande com letras
        └── Botões: ligar (verde) / apagar / desligar
  └── Contatos
        └── Lista com avatar, nome grande, relação, telefone, botão ligar
  └── Remédios de Hoje
        └── Timeline vertical por horário
              ├── ✅ Tomado (verde)
              ├── ❌ Atrasado (vermelho + botão "Tomar agora")
              ├── 🕒 Próximo (azul + botão "Já tomei")
              └── ⏳ Mais tarde (cinza)
  └── Identidade (Cara Crachá)
        ├── Foto, nome completo, idade
        ├── Tipo sanguíneo (destaque vermelho)
        ├── Alergias
        ├── Condições de saúde
        └── Contatos de emergência com botão ligar
  └── Notificações / Avisos
        └── Lista cronológica: doses perdidas, lembretes, chamadas perdidas
  └── Alarme Full Screen (sobrepõe tudo quando dispara)
        ├── Hora
        ├── Ícone do remédio gigante
        ├── Nome e dosagem
        ├── Instrução de uso
        ├── Botão verde gigante "JÁ TOMEI"
        └── Botão âmbar "LEMBRAR DEPOIS (15 min)"
```

### Fluxo do cuidador

```
Login Cuidador (PIN 4 dígitos)
  └── Home do Cuidador
        ├── Alerta de doses perdidas no dia
        └── Grid de configurações:
              ├── Medicamentos — adicionar/editar/remover doses e horários
              ├── Contatos — família, médicos, emergência
              ├── Identidade — dados pessoais, sangue, alergias
              ├── Relatórios — histórico semanal de adesão + log de uso
              ├── Apps visíveis — quais apps aparecem no launcher
              └── Configurações — PIN, fonte, acessibilidade
  └── [Sair] volta para launcher do idoso
```

### Telas institucionais

```
Sobre o Projeto
  ├── Hero com ilustração Vó Elvira + Vô Nelson
  ├── Storytelling da motivação
  └── Ficha técnica da equipe

Privacidade e Termos
  ├── Badge "funciona 100% offline"
  ├── Badge "dados ficam no celular"
  ├── O que armazena
  ├── O que NÃO faz
  └── Botão "Entendi, continuar"
```

---

## 7. Requisitos funcionais (do documento PI)

| ID | Descrição |
|---|---|
| RF1 | Painel de status: hora, data, bateria em tamanho ampliado |
| RF2 | Grade de atalhos com ícones grandes e alta visibilidade |
| RF3 | Botão de pânico visível na tela inicial para discagem rápida ou alerta |
| RF4 | Gestão de contatos pelo cuidador (nome, telefone, relação com o idoso) |
| RF5 | Módulo de medicamentos: cadastro, edição, remoção, horários e frequência |
| RF6 | Área de administração protegida por senha (PIN) |
| RF7 | Bloqueio de edição: ícones não podem ser movidos/removidos sem PIN |
| RF8 | Relatórios: histórico de medicamentos, atrasos, horários de uso, ligações |

---

## 8. Requisitos não funcionais

| ID | Descrição |
|---|---|
| RNF1 | Acessibilidade: visão reduzida, baixa precisão motora, navegação simples |
| RNF2 | Performance: baixo consumo de memória, funcional em Android de entrada |
| RNF3 | Compatibilidade: Android 8.0+ (API 26+) |
| RNF4 | Open Source: licença MIT ou Apache 2.0 |

---

## 9. Modelo de dados local (referência)

```
Usuario
  id, nome, genero, foto_path, data_nascimento,
  tipo_sanguineo, alergias, condicoes_saude,
  pin_cuidador, tamanho_fonte_base, onboarding_completo

Contato
  id, nome, relacao (familiar|medico|cuidador|emergencia),
  telefone, eh_emergencia (bool), ordem_exibicao

Medicamento
  id, nome, dosagem, unidade, instrucao_uso,
  foto_path, ativo (bool)

DoseMedicamento
  id, medicamento_id, horario (HH:mm),
  dias_semana (lista), ativo (bool)

RegistroDose
  id, dose_id, data_hora_prevista, data_hora_registrada,
  status (tomado|perdido|pulado|adiado)

AppVisivel
  id, package_name, label_customizado, icone_path, ordem

LogUso
  id, tipo (ligacao|app_aberto|tela_visitada),
  detalhe, data_hora
```

---

## 10. Entregáveis do PI (cronograma junho/2026)

- Protótipo funcional (APK)
- Repositório no GitHub
- Documentação técnica da arquitetura
- Documentação UML
- Manual do usuário e guia do cuidador
- Relatório de testes

---

