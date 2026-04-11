# Architecture Design — BravoFlow AI

**Change:** `architecture-foundation`  
**Type:** Technical Design Document  
**Status:** Approved  
**Date:** 2026-04-11  
**Author:** Architecture Review

---

## 1. Architecture Overview

### Pattern: Hybrid Clean Architecture + Feature-First Organisation

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION                             │
│   Screens · Widgets · Riverpod UI Consumers · Navigation        │
├─────────────────────────────────────────────────────────────────┤
│                        APPLICATION                              │
│   AsyncNotifiers · Providers · Use Cases · State Models         │
├─────────────────────────────────────────────────────────────────┤
│                          DOMAIN                                 │
│   Entities · Value Objects · Repository Interfaces · Failures   │
├─────────────────────────────────────────────────────────────────┤
│                           DATA                                  │
│   Repository Impls · DTOs · Supabase · Remote · Local Cache     │
└─────────────────────────────────────────────────────────────────┘
```

### Dependency Rule (enforced, never broken)

```
Presentation → Application → Domain ← Data
                                ↑
                         (Data implements Domain interfaces)

Core (cross-cutting) ← depended on by all layers
Shared (UI primitives) ← depended on by Presentation only
```

- **Domain knows nothing** about Flutter, Supabase, or providers.
- **Data** implements domain interfaces. Supabase is an implementation detail.
- **Application** orchestrates domain use via notifiers.
- **Presentation** is dumb — it observes state, dispatches events.

---

## 2. Final Folder Structure

```
lib/
 ┣ core/                          ← Cross-cutting, no feature knowledge
 ┃ ┣ theme/
 ┃ ┃ ┣ app_colors.dart
 ┃ ┃ ┣ app_text_styles.dart
 ┃ ┃ ┗ app_theme.dart
 ┃ ┣ constants/
 ┃ ┃ ┗ app_constants.dart
 ┃ ┣ utils/
 ┃ ┃ ┗ app_utils.dart
 ┃ ┣ error/
 ┃ ┃ ┣ app_exception.dart         ← Sealed exception hierarchy
 ┃ ┃ ┗ failure.dart               ← Failure value objects
 ┃ ┣ network/
 ┃ ┃ ┗ network_info.dart          ← Connectivity check
 ┃ ┣ services/
 ┃ ┃ ┗ supabase_service.dart      ← Client init only
 ┃ ┗ router/
 ┃   ┗ app_router.dart            ← go_router definition
 ┣ domain/                        ← Pure Dart, zero Flutter deps
 ┃ ┣ entities/
 ┃ ┃ ┣ user.dart
 ┃ ┃ ┣ transaction.dart
 ┃ ┃ ┣ category.dart
 ┃ ┃ ┣ budget.dart
 ┃ ┃ ┗ ai_insight.dart
 ┃ ┣ repositories/                ← Abstract interfaces
 ┃ ┃ ┣ auth_repository.dart
 ┃ ┃ ┣ transaction_repository.dart
 ┃ ┃ ┣ budget_repository.dart
 ┃ ┃ ┗ ai_repository.dart
 ┃ ┗ value_objects/
 ┃   ┣ money.dart
 ┃   ┗ date_range.dart
 ┣ features/
 ┃ ┣ auth/
 ┃ ┃ ┣ data/
 ┃ ┃ ┃ ┣ dtos/                    ← Supabase row → DTO
 ┃ ┃ ┃ ┃ ┗ user_dto.dart
 ┃ ┃ ┃ ┗ repositories/
 ┃ ┃ ┃   ┗ auth_repository_impl.dart
 ┃ ┃ ┣ application/
 ┃ ┃ ┃ ┣ auth_notifier.dart       ← AsyncNotifier
 ┃ ┃ ┃ ┗ auth_providers.dart      ← Provider declarations
 ┃ ┃ ┗ presentation/
 ┃ ┃   ┣ screens/
 ┃ ┃   ┃ ┣ sign_in_screen.dart
 ┃ ┃   ┃ ┗ sign_up_screen.dart
 ┃ ┃   ┗ widgets/
 ┃ ┣ dashboard/
 ┃ ┃ ┣ application/
 ┃ ┃ ┃ ┣ dashboard_notifier.dart
 ┃ ┃ ┃ ┗ dashboard_providers.dart
 ┃ ┃ ┗ presentation/
 ┃ ┃   ┣ screens/
 ┃ ┃   ┃ ┗ dashboard_screen.dart
 ┃ ┃   ┗ widgets/
 ┃ ┃     ┣ balance_card.dart
 ┃ ┃     ┗ quick_actions_row.dart
 ┃ ┣ transactions/
 ┃ ┃ ┣ data/
 ┃ ┃ ┃ ┣ dtos/
 ┃ ┃ ┃ ┃ ┗ transaction_dto.dart
 ┃ ┃ ┃ ┗ repositories/
 ┃ ┃ ┃   ┗ transaction_repository_impl.dart
 ┃ ┃ ┣ application/
 ┃ ┃ ┃ ┣ transaction_notifier.dart
 ┃ ┃ ┃ ┗ transaction_providers.dart
 ┃ ┃ ┗ presentation/
 ┃ ┃   ┣ screens/
 ┃ ┃   ┃ ┣ transaction_list_screen.dart
 ┃ ┃   ┃ ┗ add_transaction_screen.dart
 ┃ ┃   ┗ widgets/
 ┃ ┃     ┗ transaction_tile.dart
 ┃ ┣ ai_insights/
 ┃ ┃ ┣ data/
 ┃ ┃ ┃ ┣ dtos/
 ┃ ┃ ┃ ┃ ┗ ai_insight_dto.dart
 ┃ ┃ ┃ ┗ repositories/
 ┃ ┃ ┃   ┗ ai_repository_impl.dart
 ┃ ┃ ┣ application/
 ┃ ┃ ┃ ┣ ai_notifier.dart
 ┃ ┃ ┃ ┗ ai_providers.dart
 ┃ ┃ ┗ presentation/
 ┃ ┃   ┣ screens/
 ┃ ┃   ┃ ┗ ai_insights_screen.dart
 ┃ ┃   ┗ widgets/
 ┃ ┃     ┗ insight_card.dart
 ┃ ┣ budget/
 ┃ ┃ ┗ ... (same pattern)
 ┃ ┗ onboarding/
 ┃   ┗ ... (same pattern)
 ┣ shared/
 ┃ ┣ widgets/                     ← Dumb, stateless, no providers
 ┃ ┃ ┣ gradient_card.dart
 ┃ ┃ ┣ ai_insight_chip.dart
 ┃ ┃ ┣ app_button.dart
 ┃ ┃ ┣ app_text_field.dart
 ┃ ┃ ┗ loading_overlay.dart
 ┃ ┗ extensions/
 ┃   ┣ context_extensions.dart
 ┃   ┗ datetime_extensions.dart
 ┗ main.dart
```

---

## 3. Layer Contracts

### 3.1 Domain Layer — Pure Dart Entities

Domain entities are **immutable**, use `const` constructors, and have **no Flutter or
Supabase imports**.

```
Transaction {
  id: String
  userId: String
  amount: Money         ← value object, not raw double
  category: Category
  description: String
  date: DateTime
  type: TransactionType (income | expense)
  createdAt: DateTime
}
```

Repository interfaces are abstract classes in `domain/repositories/`. They return
`Future<Either<Failure, T>>` — errors are first-class values, not exceptions.

### 3.2 Data Layer — DTOs + Implementations

```
TransactionDto {
  id: String
  user_id: String
  amount: double        ← raw Supabase field
  category_id: String
  description: String
  date: String          ← ISO 8601 string from Postgres
  type: String
  created_at: String
}

TransactionDto.fromJson(Map<String, dynamic> json)
TransactionDto.toJson() → Map<String, dynamic>
TransactionDto.toDomain() → Transaction   ← the key mapping method
```

**Rule:** DTOs live in `features/<name>/data/dtos/`. They know about Supabase JSON shape.
Domain entities know nothing about DTOs.

### 3.3 Application Layer — Riverpod Notifiers

```
// Pattern for every feature
class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  Future<List<Transaction>> build() => ref.read(transactionRepositoryProvider).getAll();

  Future<void> add(Transaction t) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(transactionRepositoryProvider).create(t),
    );
  }
}
```

Providers are declared in `<feature>/application/<feature>_providers.dart`:

```
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(
    client: ref.read(supabaseClientProvider),
  ),
);

final transactionNotifierProvider =
  AsyncNotifierProvider<TransactionNotifier, List<Transaction>>(
    TransactionNotifier.new,
  );
```

### 3.4 Presentation Layer — ConsumerWidget

Screens are `ConsumerWidget` or `ConsumerStatefulWidget`. They **read state, dispatch
events, render UI**. No business logic.

```
class TransactionListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionNotifierProvider);
    return state.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorView(message: e.toString()),
      data: (transactions) => TransactionList(items: transactions),
    );
  }
}
```

---

## 4. Supabase Architecture

### 4.1 Client Provider

```
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => SupabaseService.client,
);
```

The raw `SupabaseClient` is injected via Riverpod — never accessed globally via
`SupabaseService.client` from within features.

### 4.2 Auth Flow

```
App Launch
    │
    ▼
SupabaseService.initialize()
    │
    ▼
Check session (client.auth.currentSession)
    │
    ├── session exists ──▶ DashboardScreen
    │
    └── no session ──────▶ SignInScreen
```

Auth state changes are observed via a stream provider:

```
final authStateProvider = StreamProvider<AuthState>(
  (ref) => SupabaseService.client.auth.onAuthStateChange,
);
```

The router reacts to auth state — no manual navigation calls.

### 4.3 Repository Pattern — Example

```
// Domain (abstract)
abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getAll({DateRange? range});
  Future<Either<Failure, Transaction>> create(Transaction t);
  Future<Either<Failure, void>> delete(String id);
}

// Data (concrete)
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<Either<Failure, List<Transaction>>> getAll({DateRange? range}) async {
    try {
      final response = await client
          .from('transactions')
          .select()
          .order('date', ascending: false);
      return Right(
        (response as List).map((r) => TransactionDto.fromJson(r).toDomain()).toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

## 5. Error Model

All failures are typed value objects:

```
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class ServerFailure extends Failure { ... }
final class NetworkFailure extends Failure { ... }
final class AuthFailure extends Failure { ... }
final class CacheFailure extends Failure { ... }
final class UnknownFailure extends Failure { ... }
```

UI maps `Failure` → user-readable messages via an extension method.

---

## 6. Routing — go_router

```
final appRouterProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    return GoRouter(
      initialLocation: '/dashboard',
      redirect: (context, state) {
        final isAuthenticated = authState.valueOrNull?.session != null;
        final isAuthRoute = state.matchedLocation.startsWith('/auth');
        if (!isAuthenticated && !isAuthRoute) return '/auth/sign-in';
        if (isAuthenticated && isAuthRoute) return '/dashboard';
        return null;
      },
      routes: [
        GoRoute(path: '/auth/sign-in', builder: (_, __) => const SignInScreen()),
        GoRoute(path: '/auth/sign-up', builder: (_, __) => const SignUpScreen()),
        ShellRoute(
          builder: (_, __, child) => AppShell(child: child),
          routes: [
            GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
            GoRoute(path: '/transactions', builder: (_, __) => const TransactionListScreen()),
            GoRoute(path: '/ai', builder: (_, __) => const AiInsightsScreen()),
            GoRoute(path: '/budget', builder: (_, __) => const BudgetScreen()),
          ],
        ),
      ],
    );
  },
);
```

---

## 7. AI Architecture

### 7.1 Abstraction Strategy

AI is a **replaceable adapter** behind a domain interface. The UI never knows whether
insights come from rules, an OpenAI call, or a local ML model.

```
┌──────────────────────────────────────────┐
│         AiRepository (domain)            │
│  getInsights(userId) → List<AiInsight>   │
│  chatQuery(prompt) → AiResponse          │
└──────────┬───────────────────────────────┘
           │  implements
    ┌──────┴───────────────────────────────┐
    │   RulesBasedAiRepositoryImpl         │  ← MVP
    │   OpenAiAiRepositoryImpl             │  ← Phase 2
    │   GeminiAiRepositoryImpl             │  ← Phase 2 alt
    └──────────────────────────────────────┘
```

Switched via provider:
```
final aiRepositoryProvider = Provider<AiRepository>(
  (ref) => RulesBasedAiRepositoryImpl(
    transactionRepo: ref.read(transactionRepositoryProvider),
  ),
);
```

### 7.2 Data Flow

```
Transactions (Supabase)
       │
       ▼
TransactionRepository.getAll()
       │
       ▼
AiRepository.getInsights(transactions)
       │
       ├── Rules Engine (MVP)
       │     • Spending spike detection
       │     • Category overspend
       │     • Saving opportunity
       │
       └── ML / LLM (Phase 2)
             • Natural language summaries
             • Predictions
       │
       ▼
List<AiInsight> (domain entities)
       │
       ▼
AiNotifier (application layer)
       │
       ▼
AiInsightsScreen (presentation)
```

### 7.3 AiInsight Entity

```
AiInsight {
  id: String
  type: AiInsightType (spending | saving | prediction | alert)
  title: String
  body: String
  confidence: double        ← 0.0 → 1.0
  generatedAt: DateTime
  relatedTransactionIds: List<String>
}
```

### 7.4 Evolution Plan

| Phase | Engine | Storage | Trigger |
|-------|--------|---------|---------|
| MVP | Rules (Dart) | Supabase table | On sync |
| Phase 2 | OpenAI / Gemini API | Supabase + vector | On demand + scheduled |
| Phase 3 | Fine-tuned model | Edge functions | Realtime |

---

## 8. Database Schema (Supabase / PostgreSQL)

### Tables

```sql
-- Users (extends Supabase auth.users)
profiles (
  id          uuid PRIMARY KEY REFERENCES auth.users(id),
  name        text NOT NULL,
  currency    text NOT NULL DEFAULT 'USD',
  created_at  timestamptz DEFAULT now()
)

-- Categories
categories (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES profiles(id),
  name        text NOT NULL,
  icon        text,
  color       text,
  is_default  boolean DEFAULT false
)

-- Transactions
transactions (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid REFERENCES profiles(id) ON DELETE CASCADE,
  category_id  uuid REFERENCES categories(id),
  amount       numeric(12,2) NOT NULL,
  type         text CHECK (type IN ('income','expense')) NOT NULL,
  description  text,
  date         date NOT NULL,
  created_at   timestamptz DEFAULT now()
)

-- Budgets
budgets (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid REFERENCES profiles(id) ON DELETE CASCADE,
  category_id  uuid REFERENCES categories(id),
  amount       numeric(12,2) NOT NULL,
  period       text CHECK (period IN ('monthly','weekly','yearly')) NOT NULL,
  starts_at    date NOT NULL
)

-- AI Insights
ai_insights (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid REFERENCES profiles(id) ON DELETE CASCADE,
  type                  text NOT NULL,
  title                 text NOT NULL,
  body                  text NOT NULL,
  confidence            numeric(3,2) DEFAULT 1.0,
  generated_at          timestamptz DEFAULT now(),
  related_transaction_ids uuid[]
)
```

### RLS Policies (all tables)

```sql
-- Enable RLS
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY "own_data" ON transactions
  FOR ALL USING (auth.uid() = user_id);
```

### Key Relationships

```
auth.users
    │ 1:1
    ▼
  profiles
    │ 1:N
    ├──▶ transactions ──▶ categories
    ├──▶ budgets      ──▶ categories
    └──▶ ai_insights
```

---

## 9. State Management — Riverpod

### Why Riverpod over Bloc

| Criterion | Riverpod | Bloc |
|-----------|----------|------|
| Boilerplate | Low | High |
| Testability | Excellent | Good |
| Composability | Excellent (ref.watch chain) | Moderate |
| Async handling | Built-in (AsyncValue) | Manual |
| Code generation | riverpod_generator | bloc_generator |
| Flutter community | Primary recommendation | Secondary |

### State Shape Pattern

```
// Every feature follows this shape
AsyncValue<T>          ← loading / data / error, built-in

// Complex state (form, pagination)
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    required List<Transaction> transactions,
    required bool isLoading,
    String? errorMessage,
    required int currentPage,
  }) = _TransactionState;
}
```

### Provider Scoping

- **Global providers** (auth, theme): defined in `core/`
- **Feature providers**: defined in `features/<name>/application/`
- **Local state** (form fields, UI toggles): `StateProvider` or `useState` hook

---

## 10. Security & Auth Design

### Session Handling

```
┌─────────────────────────────────────────┐
│   Supabase manages JWT refresh          │
│   automatically via secure storage      │
│   (flutter_secure_storage on mobile)    │
└─────────────────────────────────────────┘
```

- Supabase Flutter SDK handles token refresh automatically.
- On iOS: stored in Keychain. On Android: EncryptedSharedPreferences.
- Never store tokens in SharedPreferences or local variables.

### Auth Checklist

- [ ] Email + password (MVP)
- [ ] OAuth (Google, Apple) — Phase 2
- [ ] MFA — Phase 3
- [ ] RLS on all tables (mandatory from day 1)
- [ ] HTTPS only (Supabase enforces this)
- [ ] No secrets in client bundle — use Edge Functions for sensitive ops

---

## 11. Testing Strategy

### Pyramid

```
        ┌─────────────────┐
        │   UI Tests      │  ← integration_test package
        │  (few, slow)    │    Smoke tests per feature
        ├─────────────────┤
        │ Widget Tests    │  ← flutter_test
        │  (moderate)     │    All shared widgets + screens
        ├─────────────────┤
        │  Unit Tests     │  ← dart test
        │  (many, fast)   │    All notifiers, repositories, entities
        └─────────────────┘
```

### What to Test

| Layer | What | Tool |
|-------|------|------|
| Domain | Entities, value objects, failure types | `dart test` |
| Data | DTO mapping (fromJson / toDomain) | `dart test` |
| Application | Notifiers (mock repository) | `dart test` + `riverpod` |
| Presentation | Widget rendering, state variations | `flutter_test` |
| Integration | Full user flows | `integration_test` |

### Mock Strategy

Repositories are interfaces → easily mocked with `mockito` or `mocktail`.

```
class MockTransactionRepository extends Mock implements TransactionRepository {}
```

---

## 12. Observability & Metrics

### Logging (MVP)

Use `logger` package. Structured log levels: verbose / debug / info / warning / error.

```
AppLogger.info('Transaction created', data: {'id': t.id});
AppLogger.error('Supabase query failed', error: e, stackTrace: st);
```

### Error Tracking (Phase 2)

- **Sentry** (recommended) or **Firebase Crashlytics**
- Capture: unhandled exceptions, Riverpod provider errors, Supabase failures

### Product Metrics (Phase 2)

- **PostHog** or **Mixpanel** (self-hosted option via Supabase Edge Functions)
- Key events: `transaction_added`, `ai_insight_viewed`, `budget_set`, `session_start`

---

## 13. Scalability Strategy

### MVP → Growth → Scale

```
MVP (now)                Growth (6–12 mo)          Scale (12+ mo)
──────────────────        ──────────────────────    ─────────────────────
Supabase (all-in-one)    Edge Functions for AI     Dedicated AI service
Rules-based AI           OpenAI / Gemini calls     Fine-tuned model
Local data sync          Background sync           Realtime streaming
go_router (client)       Deep link handling        Multi-platform (web)
Riverpod (local)         Server-side state hints   Offline-first (Drift)
```

### Microservices Readiness

The repository interface layer is the **seam**. Swapping
`TransactionRepositoryImpl(supabase)` → `TransactionRepositoryImpl(rest_api)` requires
zero changes to domain or presentation. This is intentional.

---

## 14. Development Workflow

### Git Strategy

```
main            ← production-ready, protected
  └── develop   ← integration branch
        └── feat/<change-name>   ← one branch per OpenSpec change
        └── fix/<issue-id>
        └── chore/<topic>
```

### Commit Convention

```
feat(transactions): add transaction creation flow
fix(auth): handle session expiry gracefully
chore(deps): upgrade supabase_flutter to 2.9.0
docs(arch): update design.md with AI flow
```

### CI Basics (GitHub Actions)

```yaml
on: [push, pull_request]
jobs:
  analyze:  flutter analyze
  test:     flutter test --coverage
  build:    flutter build apk --release (on main only)
```

---

## 15. Risks & Trade-offs

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Over-abstraction slows MVP | Medium | Medium | Keep domain thin, add layers only when a 2nd use case exists |
| Riverpod complexity for new devs | Low | Medium | Strong provider naming conventions + this design doc |
| Supabase vendor lock-in | Low | High | Repository pattern is the firewall — swap anytime |
| AI costs at scale | Medium | High | Rules-based MVP, gate LLM behind feature flag |
| RLS misconfiguration → data leak | Low | Critical | Mandatory RLS review checklist before each table ships |

---

## 16. Implementation Roadmap

### Phase 0 — Architecture Hardening (current)
- [ ] Introduce `domain/` layer with entities + repository interfaces
- [ ] Introduce `core/error/` failure hierarchy
- [ ] Wire `go_router` with auth redirect
- [ ] Migrate dashboard to `ConsumerWidget` + `AsyncNotifier`
- [ ] Add `riverpod_generator` for codegen

### Phase 1 — Auth Feature
- [ ] `AuthRepository` interface + Supabase impl
- [ ] `AuthNotifier` with sign-in / sign-up / sign-out
- [ ] Sign in / sign up screens
- [ ] Session guard in router

### Phase 2 — Transactions Feature
- [ ] `Transaction` entity + `Money` value object
- [ ] `TransactionRepository` + Supabase impl
- [ ] `TransactionNotifier`
- [ ] Transaction list + add screens

### Phase 3 — AI Insights (Rules Engine)
- [ ] `AiInsight` entity + `AiRepository` interface
- [ ] `RulesBasedAiRepositoryImpl`
- [ ] `AiNotifier`
- [ ] AI insights screen with real data

### Phase 4 — Budget Feature
- [ ] Budget entity + repository
- [ ] Budget creation + tracking screens

### Phase 5 — AI Phase 2 (LLM)
- [ ] `OpenAiAiRepositoryImpl` behind feature flag
- [ ] Chat interface
- [ ] Supabase Edge Function as AI proxy (key security)

