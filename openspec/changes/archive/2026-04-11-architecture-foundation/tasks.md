# Architecture Foundation — Task Breakdown

**Change:** `architecture-foundation`  
**Status:** Ready to implement  
**Date:** 2026-04-11

---

## Phase 0 — Architecture Hardening

### P0-1 · Error Model
- [x] Create `lib/core/error/failure.dart` — sealed `Failure` hierarchy
- [x] Create `lib/core/error/app_exception.dart` — exception wrapper

### P0-2 · Domain Layer
- [x] Create `lib/domain/entities/user.dart`
- [x] Create `lib/domain/entities/transaction.dart`
- [x] Create `lib/domain/entities/category.dart`
- [x] Create `lib/domain/entities/budget.dart`
- [x] Create `lib/domain/entities/ai_insight.dart`
- [x] Create `lib/domain/value_objects/money.dart`
- [x] Create `lib/domain/value_objects/date_range.dart`
- [x] Create `lib/domain/repositories/auth_repository.dart`
- [x] Create `lib/domain/repositories/transaction_repository.dart`
- [x] Create `lib/domain/repositories/budget_repository.dart`
- [x] Create `lib/domain/repositories/ai_repository.dart`

### P0-3 · Routing
- [x] Add `go_router` to `pubspec.yaml`
- [x] Create `lib/core/router/app_router.dart`
- [x] Wire router in `main.dart` (replace `home:` with `routerConfig:`)
- [x] Add auth redirect logic (reads `authStateProvider`)

### P0-4 · Supabase Client Provider
- [x] Add `supabaseClientProvider` in `core/services/`
- [x] Add `authStateProvider` (stream)

### P0-5 · Dashboard Refactor
- [x] Create `lib/features/dashboard/application/dashboard_notifier.dart`
- [x] Create `lib/features/dashboard/application/dashboard_providers.dart`
- [x] Migrate `DashboardScreen` → `ConsumerWidget`
- [x] Remove mock data from screen, inject via provider

### P0-6 · Shared Extensions
- [x] Create `lib/shared/extensions/context_extensions.dart`
- [x] Create `lib/shared/extensions/datetime_extensions.dart`

---

## Phase 1 — Auth Feature

### P1-1 · Auth Data Layer
- [x] Create `lib/features/auth/data/dtos/user_dto.dart`
- [x] Create `lib/features/auth/data/repositories/auth_repository_impl.dart`

### P1-2 · Auth Application Layer
- [x] Create `lib/features/auth/application/auth_notifier.dart`
- [x] Create `lib/features/auth/application/auth_providers.dart`

### P1-3 · Auth UI
- [x] Create `lib/features/auth/presentation/screens/sign_in_screen.dart`
- [x] Create `lib/features/auth/presentation/screens/sign_up_screen.dart`
- [x] Create `lib/features/auth/presentation/widgets/auth_form.dart`

---

## Phase 2 — Transactions Feature

### P2-1 · Transactions Data Layer
- [x] Create `lib/features/transactions/data/dtos/transaction_dto.dart`
- [x] Create `lib/features/transactions/data/repositories/transaction_repository_impl.dart`

### P2-2 · Transactions Application Layer
- [x] Create `lib/features/transactions/application/transaction_notifier.dart`
- [x] Create `lib/features/transactions/application/transaction_providers.dart`

### P2-3 · Transactions UI
- [x] Create `lib/features/transactions/presentation/screens/transaction_list_screen.dart`
- [x] Create `lib/features/transactions/presentation/screens/add_transaction_screen.dart`
- [x] Create `lib/features/transactions/presentation/widgets/transaction_tile.dart`

---

## Phase 3 — AI Insights (Rules Engine)

### P3-1 · AI Data Layer
- [x] Create `lib/features/ai_insights/data/dtos/ai_insight_dto.dart`
- [x] Create `lib/features/ai_insights/data/repositories/ai_repository_impl.dart` (rules-based)

### P3-2 · AI Application Layer
- [x] Create `lib/features/ai_insights/application/ai_notifier.dart`
- [x] Create `lib/features/ai_insights/application/ai_providers.dart`

### P3-3 · AI UI Refactor
- [x] Migrate `AiInsightsScreen` → `ConsumerWidget`
- [x] Replace static placeholder with real `AiNotifier` state

---

## Phase 4 — Budget Feature

- [x] Budget entity + `BudgetRepository` interface
- [x] `budget_repository_impl.dart`
- [x] `BudgetNotifier` + providers
- [x] Budget screen + progress widgets

---

## Phase 5 — Testing Infrastructure

- [x] Add `mockito` / `mocktail` to dev dependencies
- [x] Unit tests for all domain entities
- [x] Unit tests for all DTO `fromJson` / `toDomain`
- [x] Unit tests for notifiers (mock repositories)
- [x] Widget tests for shared widgets
- [x] Widget tests for screen states (loading / data / error)
- [x] Integration smoke test per feature flow

---

## Database (Supabase)

- [x] Create `profiles` table + RLS
- [x] Create `categories` table + RLS + seed defaults
- [x] Create `transactions` table + RLS
- [x] Create `budgets` table + RLS
- [x] Create `ai_insights` table + RLS
- [x] Document Supabase schema in `openspec/specs/database/schema.md`
