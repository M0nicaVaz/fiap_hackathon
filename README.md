# SeniorEase | FIAP Hackathon

SeniorEase é um aplicativo focado em acessibilidade e autonomia para pessoas idosas. O projeto prioriza leitura, contraste, simplificação da interface e fluxos curtos para tarefas do dia a dia, como acompanhamento de atividades, lembretes e configurações de acessibilidade.

## Stack atual

- `Flutter` para `Web`, `Android` e `iOS`
- `Provider` para estado de apresentação
- `get_it` para injeção de dependência via `ContainerRegistry`
- `go_router` para navegação, shell principal e redirects de sessão
- `Supabase` para autenticação e persistência remota
- `SharedPreferences` para persistência local
- `Clean Architecture` por feature: `data`, `domain`, `presentation`

## Funcionalidades atuais

- autenticação por e-mail/senha e login com Google
- home com visão resumida das atividades e lembretes
- fluxo de atividades com listagem, criação, edição, conclusão e histórico
- wizard passo a passo para atividades com etapas
- preferências de acessibilidade com sincronização local/remota
- perfil do usuário

## Arquitetura

Princípios usados no projeto:

- `core/` contém design system, tratamento de erros e utilitários compartilhados
- `features/<feature>/` concentra regras, repositórios, use cases e estado de cada capability
- `app/` concentra bootstrap, DI, navegação e shell principal
- a UI usa um design system próprio, com tema, tokens e widgets compartilhados

Estrutura principal:

```text
lib/
├─ app/
│  ├─ di/                # registro de dependências com get_it
│  ├─ navigation/        # rotas, custom pages e AppRouter
│  └─ presentation/      # AppShell e estrutura de navegação principal
├─ core/
│  ├─ design_system/     # temas, tokens, builder de tema e widgets compartilhados
│  ├─ errors/            # falhas e mapeamento de mensagens
│  └─ result/            # abstração Result<T>
├─ features/
│  ├─ accessibility_preferences/
│  ├─ activities/
│  ├─ auth/
│  └─ profile/
└─ main.dart             # bootstrap do app, Supabase, DI e Providers
```

## Navegação

- a navegação principal usa `StatefulShellRoute`
- as abas atuais são `home`, `activities` e `customization`
- telas abertas por push usam a mesma transição customizada definida em `app/navigation/custom_page.dart`

## Como executar

### Pré-requisitos

- Flutter SDK compatível com o `sdk: ^3.11.0`
- Chrome ou outro target web instalado
- emulador/simulador configurado para mobile, se necessário

### Instalação

```bash
flutter pub get
```

### Configuração

O app inicializa o `Supabase` diretamente em [`lib/main.dart`](./lib/main.dart). Para rodar em outro projeto/ambiente, ajuste as credenciais de `url` e `anonKey` antes da execução.

### Execução

```bash
flutter run -d chrome
```

ou, para mobile:

```bash
flutter run
```

## Qualidade

Análise estática:

```bash
flutter analyze
```

Testes:

```bash
flutter test
```

Observação:

- atualmente existe teste de DI que depende de inicialização coerente do `Supabase`; se o ambiente de teste não simular isso, alguns testes podem falhar mesmo sem regressão funcional da UI
