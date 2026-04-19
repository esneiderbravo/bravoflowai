## Why

The accounts module has all the scaffolding for create, edit, and delete but several pieces are incomplete or broken: the total balance on the list screen always shows `$—`, the add/edit form lacks color/icon/currency pickers and doesn't match the Luminous Stratum design system, and there is no success or error feedback after mutations. Users cannot trust or fully use the module as shipped.

## What Changes

- Fix total balance calculation on `AccountsScreen` so it sums real balances from `accountBalanceProvider`
- Restyle `AddEditAccountScreen` to use the Luminous Stratum design system: backdrop-blur app bar, `GlassCard` form sections, gradient submit button
- Add color picker, icon picker, currency selector, and "set as default" toggle to the account form
- Show success snack after create/edit and error snack on failure (instead of silently moving to `AsyncError`)
- Replace all hardcoded English strings in screens and widgets with `l10n` keys (e.g. "No accounts yet", "Add Account", "TOTAL BALANCE", "AVAILABLE")
- Add missing l10n keys for new form fields and feedback messages

## Capabilities

### New Capabilities

- `account-form-complete`: Full-featured create/edit account form matching the Luminous Stratum design — includes color picker, icon picker, currency selector, isDefault toggle, and proper success/error feedback via snack bars.

### Modified Capabilities

- `account-management`: Fix total balance display on the accounts list screen and replace all hardcoded strings with localised keys.

## Impact

- `lib/features/accounts/presentation/screens/add_edit_account_screen.dart` — major restyle + new fields
- `lib/features/accounts/presentation/screens/accounts_screen.dart` — balance fix + l10n
- `lib/features/accounts/presentation/widgets/account_card.dart` — l10n for hardcoded strings
- `lib/core/i18n/l10n/app_en.arb` and `app_es.arb` — new keys added
- No API, DB schema, or repository changes required
