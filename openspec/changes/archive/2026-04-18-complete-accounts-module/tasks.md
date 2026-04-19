## 1. Localisation — Add Missing l10n Keys

- [x] 1.1 Add keys to `app_en.arb`: `account_color_label`, `account_icon_label`, `account_currency_label`, `account_is_default_label`, `account_created_success`, `account_updated_success`, `account_error_save`, `accounts_total_balance`, `accounts_no_accounts`, `account_available_label`
- [x] 1.2 Add the same keys with Spanish translations to `app_es.arb`
- [x] 1.3 Run `flutter gen-l10n` (or `flutter pub get`) to regenerate `AppLocalizations`

## 2. Total Balance Provider

- [x] 2.1 Add a `totalBalanceProvider` in `lib/features/accounts/application/account_balance_provider.dart` that watches `accountNotifierProvider` and fans out to each `accountBalanceProvider`, returning the summed `Money` value (or `Money(amount: 0)` when loading/empty)

## 3. Restyle `AddEditAccountScreen`

- [x] 3.1 Replace the plain `Scaffold` app bar with a `BackdropFilter` blur app bar matching the style in `AccountsScreen` and `AccountDetailScreen`
- [x] 3.2 Wrap the form fields (name, type, balance) inside a `GlassCard` container
- [x] 3.3 Replace the `GradientButton` usage to ensure it already exists — it does; just verify the submit button uses it correctly
- [x] 3.4 Add error handling: catch failures from `add`/`edit` calls and show `context.showErrorSnack` with the error message; do NOT navigate on failure
- [x] 3.5 Add success snack: after a successful `add` call show `context.showSuccessSnack(l10n.account_created_success)` before popping; after `edit` show `account_updated_success`

## 4. Color Picker Field

- [x] 4.1 Define a `_kPresetColors` constant list of 8–10 hex strings using `AppColors` palette values in `add_edit_account_screen.dart`
- [x] 4.2 Add `_selectedColor` (`String?`) state field
- [x] 4.3 Render a horizontal `SingleChildScrollView` row of `CircleAvatar` color chips below the type dropdown; selected chip shows a white checkmark overlay
- [x] 4.4 Pass `_selectedColor` to the `Account` constructor on submit

## 5. Icon Picker Field

- [x] 5.1 Define a `_kPresetIcons` constant list of `IconData` values (finance-related icons already used in `AccountCard` plus a few extras) in `add_edit_account_screen.dart`
- [x] 5.2 Add `_selectedIcon` (`IconData?`) state field
- [x] 5.3 Render a `GlassCard` row tappable with `JeweledIcon` preview and `l10n.account_icon_label` label
- [x] 5.4 Implement `_showIconPicker` method that calls `showModalBottomSheet` with a `GridView` of `JeweledIcon` widgets; tapping one sets `_selectedIcon` and pops the sheet
- [x] 5.5 Pass `_selectedIcon?.codePoint.toString()` to the `Account` constructor on submit; pre-populate when editing an account that has a stored icon

## 6. Currency Selector Field

- [x] 6.1 Add `_selectedCurrency` (`String`) state field defaulting to `'USD'`
- [x] 6.2 Render a `DropdownButtonFormField<String>` with values `['USD', 'EUR', 'COP', 'GBP', 'BRL']` and `l10n.account_currency_label`
- [x] 6.3 Pass `_selectedCurrency` to `Account` on submit; pre-populate from existing account when editing

## 7. isDefault Toggle Field

- [x] 7.1 Add `_isDefault` (`bool`) state field defaulting to `false`
- [x] 7.2 Render a `SwitchListTile` (inside the `GlassCard`) with `l10n.account_is_default_label`
- [x] 7.3 Pass `_isDefault` to `Account` on submit; pre-populate from existing account when editing

## 8. Fix Total Balance on `AccountsScreen`

- [x] 8.1 Replace the `_totalBalance` helper method with `ref.watch(totalBalanceProvider)` and display `totalBalance.toString()` (or a loading indicator while computing)
- [x] 8.2 Remove the hardcoded `'\$—'` fallback
- [x] 8.3 Replace the hardcoded `'TOTAL BALANCE'` string with `l10n.accounts_total_balance`
- [x] 8.4 Replace the hardcoded `'No accounts yet'` string with `l10n.accounts_no_accounts`
- [x] 8.5 Replace the hardcoded `'Add Account'` FAB label with `l10n.add_account`

## 9. Fix Hardcoded Strings in `AccountCard`

- [x] 9.1 Replace the hardcoded `'AVAILABLE'` string with `l10n.account_available_label`

## 10. Verification

- [x] 10.1 Run `flutter analyze` and fix any new warnings or errors
- [x] 10.2 Manually verify the add account flow: form opens styled, color/icon/currency/default fields work, success snack shows, account appears in list with correct balance
- [x] 10.3 Manually verify the edit account flow: existing values pre-populate, changes persist, success snack shows
- [x] 10.4 Manually verify the delete flow: delete with no transactions succeeds; delete with transactions shows error snack
- [x] 10.5 Manually verify total balance on `AccountsScreen` reflects sum of all account balances
