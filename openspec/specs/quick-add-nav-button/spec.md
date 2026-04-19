# Quick Add Nav Button Specification

### Requirement: Global quick-add button in bottom nav bar
The bottom navigation bar SHALL display a floating action button (FAB) docked at its center, rendered inside a concave circular notch cut into the bar. The button SHALL be accessible from every tab in the app.

#### Scenario: Button is visible on all tabs
- **WHEN** the user is on any main tab (Home, Flow, or More)
- **THEN** the "+" FAB is visible at the center of the bottom nav bar

#### Scenario: Button has correct visual style
- **WHEN** the "+" FAB is rendered
- **THEN** it is a 56×56dp circle with the primary `primaryFixed → secondary` gradient fill and a cyan glow shadow (`primaryFixed` at 40% opacity, blur 16, offset 0/6)
- **THEN** it contains an `add_rounded` icon in `AppColors.surface` color at 28dp

#### Scenario: Notch shape is present
- **WHEN** the bottom nav bar is rendered
- **THEN** the bar has a smooth concave indentation at the center where the FAB is docked (produced by `CircularNotchAndBar`)

---

### Requirement: Quick-add bottom sheet
Tapping the center "+" FAB SHALL open a modal bottom sheet without navigating away from the current screen. The sheet SHALL allow the user to record an income or expense transaction.

#### Scenario: Sheet opens on tap
- **WHEN** the user taps the center "+" FAB
- **THEN** a modal bottom sheet slides up from the bottom of the screen
- **THEN** the current screen remains mounted beneath the sheet

#### Scenario: Sheet fields
- **WHEN** the sheet is open
- **THEN** the sheet displays: a type toggle (Income / Expense), an amount text field, a category dropdown, and an account dropdown
- **THEN** all dropdowns are populated from existing app data (categories and accounts)

#### Scenario: Sheet keyboard behavior
- **WHEN** the user taps the amount field and the keyboard appears
- **THEN** the sheet resizes upward so the input fields remain visible above the keyboard

#### Scenario: Successful save
- **WHEN** the user fills in required fields (type, amount, account) and taps Save
- **THEN** the transaction is persisted via `transactionNotifierProvider`
- **THEN** `financialSummaryProvider` and `categorySummaryProvider` are invalidated
- **THEN** the sheet dismisses automatically

#### Scenario: Save with missing required fields
- **WHEN** the user taps Save without providing amount or account
- **THEN** the sheet displays inline validation messages and does NOT dismiss

#### Scenario: Dismiss without saving
- **WHEN** the user drags the sheet downward or taps outside it
- **THEN** the sheet dismisses without creating a transaction

---

### Requirement: Remove redundant in-screen FAB from Flow tab
The floating action button previously rendered inside `TransactionListScreen` SHALL be removed, since the global center button replaces its function.

#### Scenario: No duplicate FAB on Flow screen
- **WHEN** the user is on the Flow (transactions) tab
- **THEN** there is no separate floating "+" button on the Flow screen
- **THEN** the center nav button is the only "+" entry point
