## Why

BravoFlow AI manages accounts and transactions but lacks a centralized aggregation layer to compute global balances, monthly income/expense summaries, and category spending breakdowns. Without this engine, the dashboard cannot surface meaningful financial insights to users, blocking value delivery and future AI-powered features.

## What Changes

- Introduce a `financial-overview` feature module under `features/financial_overview/` following the existing layered architecture (domain / data / application / presentation)
- Add `FinancialSummary` and `CategorySummary` domain entities
- Implement `FinancialOverviewRepository` that aggregates data from existing account and transaction sources — no new database tables required
- Create Riverpod providers (`financialOverviewProvider`, `financialSummaryProvider`, `categorySummaryProvider`) to expose reactive financial state
- Update the Dashboard screen to display a Total Balance card, a Monthly Summary section (income / expenses / net), and a Category Breakdown section (top categories with percentage bars)

## Capabilities

### New Capabilities

- `financial-overview`: Centralized aggregation engine that computes global balance, monthly income/expense summary, net balance, per-account balance, and category spending breakdown; feeds the Dashboard with accurate reactive data

### Modified Capabilities

- `accounts-dashboard-widget`: Dashboard widget gains a Total Balance card and Monthly Summary section above the existing accounts scroll widget; existing per-account balance display is unchanged in behavior but now sourced through the unified overview providers

## Impact

- **Features**: New `features/financial_overview/` module (domain, data, application, presentation layers)
- **Dashboard screen**: Extended with new financial summary sections; no breaking changes to existing navigation or account cards
- **Riverpod providers**: New providers added; existing account/transaction providers remain unchanged
- **No new Supabase schema changes**: Aggregation is computed at the application layer from existing data
- **Dependencies**: Reuses existing account and transaction repositories
