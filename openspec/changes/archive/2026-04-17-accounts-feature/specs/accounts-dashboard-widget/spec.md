## ADDED Requirements

### Requirement: Dashboard shows a horizontally scrollable accounts widget
The system SHALL display a horizontally scrollable row of account cards at the top of the Dashboard screen, one card per account owned by the user.

#### Scenario: Accounts widget renders with data
- **WHEN** the user opens the Dashboard and has at least one account
- **THEN** the system SHALL display account cards in a horizontal scroll view, each showing the account name, type icon, and current balance

#### Scenario: Accounts widget empty state
- **WHEN** the user has no accounts
- **THEN** the system SHALL display a prompt card inviting the user to create their first account

#### Scenario: Tapping an account card
- **WHEN** the user taps an account card on the Dashboard
- **THEN** the system SHALL navigate to that account's detail screen

### Requirement: Account card displays derived balance
Each account card in the dashboard widget SHALL show the account's derived current balance, formatted using the user's preferred currency.

#### Scenario: Balance displayed correctly
- **WHEN** an account card is rendered
- **THEN** the balance shown SHALL match `initialBalance + SUM(income) - SUM(expense) + SUM(incoming transfers) - SUM(outgoing transfers)`

### Requirement: Dashboard accounts widget refreshes on return
The system SHALL refresh account balances in the dashboard widget when the user navigates back to the Dashboard from any account or transaction screen.

#### Scenario: Balance refreshes after adding transaction
- **WHEN** the user adds a transaction and returns to the Dashboard
- **THEN** the affected account card SHALL display the updated balance
