## Context

The accounts module is built on a clean layered architecture (domain → data → application → presentation) with Supabase as the backend. The Riverpod `AccountNotifier` already exposes `add`, `edit`, and `remove` methods. The `AccountRepository` CRUD methods all exist and are wired to Supabase. The `Account` entity already carries `color`, `icon`, `currency`, and `isDefault` fields; however the `AddEditAccountScreen` form never surfaces them.

The app uses a Luminous Stratum design system: backdrop-blur `AppBar`s built with `BackdropFilter`, `GlassCard` for content containers, `GradientButton` for primary actions, `JeweledIcon` for iconography, and `AppTextStyles` / `AppColors` for all typography and colour tokens. The existing `AddEditAccountScreen` deviates from this — it uses a plain Material `Scaffold` + bare `TextFormField` decorations without glass styling.

## Goals / Non-Goals

**Goals:**
- Restyle `AddEditAccountScreen` to fully match the Luminous Stratum design (backdrop-blur app bar, `GlassCard` form sections, consistent spacing)
- Expose `color`, `icon`, `currency`, and `isDefault` fields in the form
- Fix `AccountsScreen._totalBalance()` to sum actual `accountBalanceProvider` values
- Replace all hardcoded English strings in the accounts feature with `l10n` keys
- Show success snack after create/edit; show error snack (instead of silently entering `AsyncError`) when an operation fails

**Non-Goals:**
- Changes to the Supabase schema or repository layer (not needed)
- New routing changes (existing `/more/accounts/add` and `/more/accounts/:id/edit` routes are sufficient)
- Pagination or search for accounts list
- Transaction or transfer UI changes

## Decisions

### 1 — Use `accountBalanceProvider` for total balance, not `account.initialBalance`

The current `_totalBalance` ignores computed balances. The correct approach is to watch `accountBalanceProvider` for each account and sum them. Since `AccountCard` already does this individually, `AccountsScreen` can accumulate values by watching each provider.

**Alternative considered**: Sum `initialBalance` locally — rejected because it doesn't reflect real balance after transactions.

**Decision**: Introduce a derived `totalBalanceProvider` in `account_balance_provider.dart` that combines all per-account balances. The screen watches this single provider and formats via `Money.toString()`.

### 2 — Color picker via a scrollable chip row

The entity stores `color` as a hex string. The form will show a row of preset `AppColors` swatches as tappable `CircleAvatar` chips. No free-form hex input — this keeps the UX simple and consistent with the Luminous colour palette.

**Alternative considered**: Full-blown `ColorPicker` package — rejected to avoid a new dependency and keep the palette on-brand.

### 3 — Icon picker via a grid bottom sheet

The entity stores `icon` as an icon code-point string. Tapping "Choose icon" opens a `showModalBottomSheet` with a grid of `JeweledIcon` previews for the curated set of finance icons already used in the app.

**Alternative considered**: Free-form icon name text field — rejected as error-prone. Bottom-sheet grid matches the pattern in `CategoryManagement`.

### 4 — Success/error feedback via `ContextExtensions` snack helpers

The existing `context_extensions.dart` already provides `showSuccessSnack` and `showErrorSnack`. The notifier methods will be wrapped in try/catch at the screen level so errors are caught and displayed with `showErrorSnack` before clearing `AsyncError` state (or the screen simply listens to the provider state).

**Alternative considered**: Bubble errors through `AsyncError` and display inline — rejected because `AsyncError` replaces the whole list state and is visible to other consumers.

### 5 — Currency selector as a `DropdownButtonFormField`

Support a short curated list: USD, EUR, COP, GBP, BRL. This is consistent with the existing `AccountType` dropdown pattern.

## Risks / Trade-offs

- [Total balance watcher] Watching N per-account balance providers in one screen adds N reactive subscriptions. For typical personal finance (< 20 accounts) this is negligible. → Mitigation: introduce a single `totalBalanceProvider` that fans out internally.
- [Icon picker bottom sheet] On very small screens the grid may require scrolling. → Mitigation: wrap in a `SingleChildScrollView` inside the sheet.
- [Color picker] Users who previously saved a custom hex `color` outside the preset palette will still see their account rendered correctly (color field is cosmetic only), but the picker will show no chip selected. → Accepted trade-off for now.
