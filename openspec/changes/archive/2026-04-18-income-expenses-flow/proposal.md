## Why

The Flow tab currently shows a flat, unfiltered list of all transactions without any way to view income or expenses separately, no monthly totals, and a basic Material design that doesn't match the Luminous Stratum design system. Users have no quick way to understand their cash flow at a glance or drill into a specific transaction type.

## What Changes

- Redesign the Flow screen (`TransactionListScreen`) with three filter tabs: All / Income / Expenses
- Add a monthly summary header showing total income, total expenses, and net for the current filter
- Group transactions by date (Today, Yesterday, this week's day names, then formatted dates)
- Redesign the transaction list tile to match the Luminous Stratum design (GlassCard, AppColors, AppTextStyles)
- Redesign the Add Transaction screen to match the Luminous Stratum design (replacing raw Material widgets with app design system components)

## Capabilities

### New Capabilities

- `transaction-flow-screen`: Revamped Flow screen with income/expense filter tabs, a monthly summary header (totals per type), date-grouped transaction list, and full Luminous Stratum styling

### Modified Capabilities

<!-- No existing specs change behaviorally — this is a UI and UX overhaul of a screen with no prior spec -->

## Impact

- **`lib/features/transactions/presentation/screens/transaction_list_screen.dart`**: Full redesign
- **`lib/features/transactions/presentation/widgets/transaction_tile.dart`**: Redesign to Luminous Stratum style
- **`lib/features/transactions/presentation/screens/add_transaction_screen.dart`**: Redesign to Luminous Stratum style
- **`lib/features/transactions/application/transaction_providers.dart`**: May add a filtered provider or derive filtered lists in the screen
- **`lib/core/i18n/l10n/`**: New translation keys for tabs and labels
- No domain model changes, no new database queries, no breaking changes to existing providers
