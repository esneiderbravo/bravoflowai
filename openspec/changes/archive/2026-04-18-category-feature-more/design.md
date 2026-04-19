## Context

The app has a `categories` table in Supabase (seeded with 6 default categories per user), a `Category` domain entity, and a `category_id` FK on the `transactions` table. The Add Transaction screen currently uses a hardcoded placeholder (`Category(id:'', name:'General')`). No category data layer, providers, or UI exist yet. The Accounts feature (`lib/features/accounts/`) serves as the canonical reference pattern for feature architecture.

## Goals / Non-Goals

**Goals:**
- Implement full category CRUD UI following the same layered architecture as Accounts
- Add a Categories tile to the More screen under Finance
- Replace the placeholder category in Add Transaction with a real picker backed by live data

**Non-Goals:**
- Budget management (categories will eventually link to budgets, but that is a separate change)
- Custom icon picker UI (icon is stored as a material icon name string; editing will accept freeform text input for now)
- Category-level analytics or reporting

## Decisions

### 1. Mirror Accounts feature architecture

**Decision**: `lib/features/categories/` with the same layers — `domain/`, `data/`, `application/`, `presentation/`.

**Rationale**: Consistency; developers familiar with Accounts can navigate Categories immediately. Alternatives (global domain layer, shared repo) add indirection without benefit at this size.

### 2. Riverpod `AsyncNotifier` for category state

**Decision**: `CategoryNotifier extends AsyncNotifier<List<Category>>` exposed via `categoryNotifierProvider`, mirroring `AccountNotifier`.

**Rationale**: Async state handling (loading / error / data) is already established via Riverpod. A separate FutureProvider for the list would duplicate invalidation logic.

### 3. Supabase repository — no new migration

**Decision**: `CategoryRepositoryImpl` calls Supabase CRUD on `public.categories` using the existing schema. No migration required.

**Rationale**: Table, RLS, and seed trigger already exist. Adding a migration would be unnecessary noise.

### 4. Default categories are read-only

**Decision**: Rows with `is_default = true` are displayed but the edit/delete actions are hidden (or disabled).

**Rationale**: Default categories are seeded by a database trigger and are shared reference data. Deleting them would silently orphan transactions linked to those category IDs.

### 5. Category picker in Add Transaction is a bottom sheet

**Decision**: Tapping the category field in the Add Transaction form opens a modal bottom sheet listing categories with icons and colors.

**Rationale**: Bottom sheets are already used for Quick Add; consistent with existing UX patterns. Inline dropdown would break the glass-card form layout.

## Risks / Trade-offs

- **Orphaned transactions on delete** → Mitigation: DB has `on delete set null` on `transactions.category_id`; UI hides delete for default categories and shows a confirmation dialog for custom ones.
- **Empty category list on first open** → Mitigation: The seed trigger runs on profile insert, so categories are guaranteed to exist for authenticated users; show a loading state and empty-state fallback regardless.
- **Icon field UX** → Mitigation: Accepted trade-off for now; icon input accepts any string. A proper icon picker is deferred.
