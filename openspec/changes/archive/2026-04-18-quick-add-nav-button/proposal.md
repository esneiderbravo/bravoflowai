## Why

Users currently have no persistent way to add a transaction from anywhere in the app — they must navigate to the Flow tab first. A global quick-add button embedded in the bottom nav bar removes that friction and speeds up daily expense/income logging.

## What Changes

- Replace the current custom `_GlassNavBar` widget with a Flutter `BottomAppBar` + docked FAB pattern:
  - `BottomAppBar` with `shape: CircularNotchAndBar()` creates a concave indentation at the center
  - `Scaffold.floatingActionButton` is a gradient circle "+" button docked at `FloatingActionButtonLocation.centerDocked`
  - The glass blur and Luminous Stratum styling is preserved inside the `BottomAppBar`
- The three nav tabs (Home, Flow, More) are distributed left and right of the notch (2 left, 1 right)
- Tapping the "+" button opens a **modal bottom sheet** (stays on current screen, no navigation) with a quick-add form
- The quick-add sheet supports: transaction type toggle (Income / Expense), amount input, category picker, account picker, and a save button
- After saving, the sheet dismisses and financial providers are invalidated to refresh the dashboard
- The existing FAB inside `TransactionListScreen` is **removed** (replaced by the global button)

## Capabilities

### New Capabilities
- `quick-add-nav-button`: Persistent center CTA in the bottom nav with concave notch shape; docked gradient FAB that opens a quick-add transaction bottom sheet from anywhere in the app

### Modified Capabilities
- `luminous-stratum-theme`: Bottom nav bar visual treatment changes from custom `_GlassNavBar` Stack to `BottomAppBar`-based glass implementation with circular notch

## Impact

- `lib/shared/widgets/app_shell.dart` — primary change: replace `_GlassNavBar` with `BottomAppBar` + docked FAB; add `QuickAddSheet` invocation
- `lib/features/transactions/presentation/screens/transaction_list_screen.dart` — remove the existing floating FAB (gradient `_AddFab` widget)
- New widget: `lib/shared/widgets/quick_add_sheet.dart` — modal bottom sheet with minimal quick-add form
- No new routes; no new Supabase tables; reuses existing `TransactionRepository` and `transactionNotifierProvider`
- Riverpod: on save, invalidate `transactionNotifierProvider`, `financialSummaryProvider`, `categorySummaryProvider` so dashboard and flow screen update reactively
