## Context

BravoFlow AI already computes per-account balances via `accountBalanceProvider` (a `FutureProvider.family`) by watching the existing `accountNotifierProvider`, `transactionNotifierProvider`, and `transferNotifierProvider`. The Dashboard currently renders an accounts scroll widget with individual derived balances, but there is no aggregation across accounts and no month-scoped or category-scoped summaries.

The existing domain layer follows: `lib/domain/entities/`, `lib/domain/repositories/`, with feature modules under `lib/features/<feature>/` structured as `application/`, `data/`, `domain/`, `presentation/`. The `fpdart` `Either` type wraps all repository results; Riverpod providers consume them and expose `AsyncValue` to the UI.

## Goals / Non-Goals

**Goals:**
- Introduce a `financial_overview` feature module with its own domain entities, repository interface, repository implementation, Riverpod providers, and dashboard UI sections
- Compute global total balance, monthly income/expense/net summary, per-account balance (via delegation), and category spending breakdown in one cohesive layer
- Expose reactive providers that auto-update when underlying account or transaction data changes
- Extend the Dashboard with a Total Balance card, a Monthly Summary section, and a Category Breakdown section
- Reuse existing repositories; perform no additional Supabase queries beyond what is already available

**Non-Goals:**
- AI insights or smart suggestions (next feature)
- Budget limits or budget-vs-actual tracking
- Credit card or liability modeling
- Multi-currency aggregation (single-currency totals; mixed-currency accounts are out of scope for V1)
- Persistent caching of aggregated results

## Decisions

### 1. Pure in-memory aggregation (no new DB columns or views)

**Decision**: Compute all aggregations in the application layer by iterating over already-fetched accounts, transactions, and transfers.

**Rationale**: The `account-balance` spec explicitly forbids storing `current_balance`. Extending this principle to global and monthly aggregations avoids schema changes, keeps the system consistent, and allows immediate reactive updates without cache invalidation complexity.

**Alternative considered**: Supabase database views / RPCs for aggregation. Rejected because it adds DB coupling, requires migrations, and bypasses the clean-architecture layer separation already established in the project.

---

### 2. New `FinancialOverviewRepository` delegates to existing repositories

**Decision**: Introduce `FinancialOverviewRepository` (interface in `features/financial_overview/domain/`) whose implementation accepts `AccountRepository`, `TransactionRepository`, and `TransferRepository` as constructor dependencies and coordinates them.

**Rationale**: The repository acts as an anti-corruption layer — the application layer talks to a single cohesive API (`getFinancialSummary`, `getMonthlySummary`, `getCategorySummaries`) rather than orchestrating three separate repositories in providers. This keeps aggregation logic testable and off the UI.

**Alternative considered**: Aggregating directly in Riverpod providers by watching multiple existing providers. Rejected because it leaks business logic into the application layer and creates overlapping recomputation between providers.

---

### 3. Three focused Riverpod providers backed by `AsyncNotifier`

**Decision**: Create `FinancialOverviewNotifier` (AsyncNotifier) and derive `financialSummaryProvider` and `categorySummaryProvider` as watched computed values from it.

**Rationale**: A single notifier fetches and holds all raw data once; derived providers select subsets. This avoids fetching accounts and transactions multiple times for each summary type, which would happen with independent `FutureProvider`s that each call the repository.

---

### 4. Feature-local domain entities

**Decision**: `FinancialSummary` and `CategorySummary` live under `features/financial_overview/domain/entities/`, not in `lib/domain/entities/`.

**Rationale**: These are view-model-like aggregates specific to this feature, not core domain primitives used across features. Keeping them local follows the bounded-context principle and prevents core domain bloat.

---

### 5. Month scope uses device local time

**Decision**: Monthly summary filters transactions where `transaction.date` falls in the same calendar month/year as `DateTime.now()`.

**Rationale**: Simple, deterministic, and requires no user configuration. Can be parameterised in future iterations.

## Risks / Trade-offs

- **[Risk] Memory: large transaction lists** → The full transaction list is loaded into memory for aggregation. Mitigation: acceptable for a personal-finance app (hundreds to low thousands of records). Future optimisation can filter at the repository layer using `DateRange`.
- **[Risk] Stale aggregation on partial refresh** → If `transactionNotifierProvider` refreshes but `accountNotifierProvider` does not (or vice versa), totals could momentarily be inconsistent. Mitigation: `FinancialOverviewNotifier.build()` awaits all sources before computing; any invalidation triggers a full re-build.
- **[Risk] Transfer double-counting** → A transfer adds to one account and subtracts from another; global balance must not count it twice. Mitigation: global balance is computed as `SUM(accountBalances)`, and each individual account balance already applies the correct transfer sign (per the `account-balance` spec). Transfers are net-zero across the portfolio.
- **[Risk] Mixed-currency accounts** → Summing `Money.amount` across accounts with different currencies produces a meaningless number. Mitigation: V1 treats all amounts as the same currency (matching existing `accountBalanceProvider` behaviour). A currency-guard assertion is added with a TODO for V2.

## Migration Plan

1. Add `features/financial_overview/` directory structure
2. Create domain entities and repository interface
3. Implement repository; wire into providers
4. Extend Dashboard screen; keep all existing widgets unchanged
5. No data migrations required; no breaking changes to existing providers or screens
6. Rollback: remove the new feature module and revert Dashboard changes — zero risk to existing features
