# SeniorEase | FIAP Hackathon

SeniorEase é uma plataforma digital inclusiva para pessoas idosas, com foco em acessibilidade.

## Stack

- `Flutter` como plataforma única para `Web`, `Android` e `iOS`.
- `Clean Architecture` por feature: `domain`, `data`, `presentation`.
- `Provider` para estado/apresentação.
- `get_it` manual para injeção de dependência (`ContainerRegistry`).
- `go_router` para navegação e regras de redirect por sessão.
- `Firebase` (`firebase_core`, `firebase_auth`, `cloud_firestore`) como backend inicial.

## Estrutura do projeto

```text
lib/
 ├─ core/
 │   ├─ errors/            # falhas padronizadas + mapper para mensagem amigável
 │   └─ result/            # Result<T> (Success/FailureResult)
 ├─ app/
 │   ├─ di/                # ContainerRegistry (get_it manual)
 │   ├─ navigation/        # AppRouter + constantes de rota
 │   └─ presentation/      # Home shell base
 ├─ features/
 │   └─ auth/
 │      └─ {domain,data,presentation}  # exemplo Clean Architecture
 ├─ firebase_options.dart  # opções Firebase (placeholder nesta fase)
 └─ main.dart              # bootstrap Firebase + DI + Providers + Router
```

## Como executar

1. Instalar dependências:
   - `flutter pub get`
2. Configurar Firebase:
   - `firebase login`
   - `flutterfire configure --platforms=android,ios,web --project=<id-projeto>`
3. Executar:
   - `flutter run -d chrome` (Web)
   - `flutter run` (Mobile, com emulador/simulador ativo)

## Qualidade e validação

- Análise estática:
  - `flutter analyze`
- Testes:
  - `flutter test`
