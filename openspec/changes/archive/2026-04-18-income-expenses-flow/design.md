## Context

The Flow tab (`/transactions`) renders `TransactionListScreen`, a basic `ConsumerWidget` that watches `transactionNotifierProvider` and renders a flat `ListView` using `TransactionTile` (a `ListTile` wrapper). The screen has no type filtering, no monthly summary, and uses raw Material widgets that don't match the Luminous Stratum design system applied to the rest of the app (Dashboard, Accounts). The add transaction screen similarly uses raw Material form widgets.

All transaction data is already available via the existing `transactionNotifierProvider` (`AsyncNotifier<List<Transaction>>`). Each `Transaction` entity carries `type` (`income` | `expense`), `amount` (`Money`), `category`, `description`, and `date`. No schema or domain changes are needed — the redesign is entirely in the presentation and application layers.

## Goals / Non-Goals

**Goals:**
- Revamp `TransactionListScreen` with All / Income / Expenses filter tabs
- Add a monthly summary header (total income, total expenses, net) that reacts to the active filter tab
- Group the transaction list by date using human-friendly labels (Today, Yesterday, weekday names, then `dd/MM/yyyy`)
- Redesign `TransactionTile` using Luminous Stratum components (`GlassCard`, `AppColors`, `AppTextStyles`, `AppSpacing`)
- Redesign `AddTransactionScreen` using Luminous Stratum components (`GradientButton`, `GlassCard` form fields, design system tokens)
- Add all new UI strings to both `app_en.arb` and `app_es.arb`

**Non-Goals:**
- Editing existing transactions (no edit screen in scope)
- Category management (placeholder category remains for now)
- Date range picker / advanced filtering
- CSV export
- Pagination or infinite scroll

## Decisions

### 1. Filter state lives in the screen widget (local `ValueNotifier` / `setState`)

**Decision**: The selected tab index (All / Income / Expenses) is local UI state managed with a `StatefulWidget` or a local `StateProvider`. The filtered list is derived inline from `transactionNotifierProvider`.

**Rationale**: Filtering is a pure presentation concern — it does not affect any other screen or provider. Lifting it to a global Riverpod provider would add unnecessary complexity for something with no cross-feature dependency.

**Alternative considered**: A `transactionFilterProvider` (global `StateProvider<TransactionFilter>`). Rejected because the filter resets naturally when leaving the tab, which is the expected UX.

---

### 2. Date grouping computed in the screen, not the repository

**Decision**: Group `List<Transaction>` by date label in the widget's `build` method after filtering. The repository returns a flat list; the screen converts it to `Map<String, List<Transaction>>`.

**Rationale**: Date grouping is a display concern. The `TransactionRepository.getAll()` already returns transactions sorted by date descending (Supabase orders by `date DESC`). Grouping at the presentation layer avoids adding display logic to the domain.

---

### 3. Monthly summary uses the same `transactionNotifierProvider` list — no new provider

**Decision**: The monthly summary header sums income and expense amounts from the already-fetched transactions, filtered to the current calendar month, in the build method.

**Rationale**: `financialOverviewProvider` (from the Financial Overview Engine change) already provides global monthly totals. The Flow screen derives its own per-tab summary inline to avoid creating a duplicate subscription and to allow the header to react instantly to the active tab filter without extra async hops.

---

### 4. `TransactionTile` redesigned as a standalone `StatelessWidget` using `GlassCard`

**Decision**: Replace `ListTile` with a custom `GlassCard`-based row widget. Category icon/emoji is shown if available; falls back to a type-based icon.

**Rationale**: `ListTile` applies Material 3 defaults (padding, text styles, divider insets) that clash with the Luminous Stratum dark-surface glass aesthetic. A custom widget gives full control over spacing, colors, and layout.

## Risks / Trade-offs

- **[Risk] Performance with large transaction lists** → Grouping and filtering runs synchronously in `build`. Mitigation: personal-finance lists are small (hundreds of records); acceptable for V1. Future: memoize with `useMemoized` or a `Provider`.
- **[Risk] Add Transaction screen still uses a placeholder category** → Category selection is deferred. Mitigation: the existing placeholder behavior is preserved; no regression.
- **[Risk] Monthly summary header shows different totals from the Financial Overview dashboard** → The Flow screen filters by month using device local time, matching the Financial Overview Engine behavior, so totals will be consistent.

## Migration Plan

1. Replace `TransactionListScreen` body in-place (same route `/transactions`)
2. Replace `TransactionTile` widget in-place (same file, no other consumers except the list screen)
3. Replace `AddTransactionScreen` in-place (same route `/transactions/add`)
4. Add translation keys; regenerate l10n
5. No routing changes, no provider renames — zero breaking changes to other features
