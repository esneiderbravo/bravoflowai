## MODIFIED Requirements

### Requirement: User can view their accounts list
The system SHALL display all accounts belonging to the authenticated user, each showing name, type, and current balance. The accounts list header SHALL display the real computed total balance across all accounts using `accountBalanceProvider`. All user-visible strings SHALL be sourced from the localisation system (`l10n`) — no hardcoded English text.

#### Scenario: Accounts list loaded
- **WHEN** the user navigates to the Accounts section in the More tab
- **THEN** the system SHALL display all accounts ordered by creation date

#### Scenario: Total balance displayed correctly
- **WHEN** accounts are loaded
- **THEN** the header SHALL show the sum of all per-account balances computed by `accountBalanceProvider`, formatted as a currency string

#### Scenario: Empty state
- **WHEN** the user has no accounts
- **THEN** the system SHALL display an empty state with a localised prompt to create the first account

## ADDED Requirements

### Requirement: Accounts list strings are fully localised
All visible text strings in the accounts list screen, account card widget, and account detail screen SHALL be sourced from the `l10n` system. No hardcoded English strings SHALL appear in these files.

#### Scenario: No hardcoded strings in AccountsScreen
- **WHEN** the accounts screen is rendered in any supported locale
- **THEN** all visible labels (e.g. "Total Balance", "No accounts yet", "Add Account") SHALL display in the active locale

#### Scenario: No hardcoded strings in AccountCard
- **WHEN** an account card is rendered
- **THEN** the "AVAILABLE" label SHALL be sourced from `l10n`
