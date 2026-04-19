## ADDED Requirements

### Requirement: Dashboard displays a Total Balance card
The system SHALL display a Total Balance card on the Dashboard screen, showing the aggregated balance across all user accounts.

#### Scenario: Total balance card with accounts
- **WHEN** the user opens the Dashboard and has at least one account
- **THEN** the system SHALL display a Total Balance card showing the sum of all account derived balances formatted using the user's preferred currency

#### Scenario: Total balance card with no accounts
- **WHEN** the user has no accounts
- **THEN** the system SHALL display the Total Balance card with a zero balance and a prompt to create an account

### Requirement: Dashboard displays a Monthly Summary section
The system SHALL display a Monthly Summary section on the Dashboard showing income, expenses, and net balance for the current calendar month.

#### Scenario: Monthly summary renders income and expense
- **WHEN** the user opens the Dashboard
- **THEN** the system SHALL display three figures: total monthly income, total monthly expenses, and net balance (`income - expenses`), each labeled and formatted with currency symbol

#### Scenario: Net balance is visually differentiated by sign
- **WHEN** the net balance is positive
- **THEN** the net balance SHALL be displayed in a positive/green colour
- **WHEN** the net balance is negative
- **THEN** the net balance SHALL be displayed in a negative/red colour

### Requirement: Dashboard displays a Category Breakdown section
The system SHALL display a Category Breakdown section on the Dashboard showing the top spending categories for the current month with percentage bars.

#### Scenario: Category breakdown renders top categories
- **WHEN** the current month has expense transactions
- **THEN** the system SHALL display up to 5 top categories sorted by total amount descending, each showing the category name, total amount, and a proportional percentage bar

#### Scenario: Category breakdown empty state
- **WHEN** there are no expense transactions in the current month
- **THEN** the system SHALL display an empty-state message indicating no expenses recorded this month

## MODIFIED Requirements

### Requirement: Dashboard accounts widget refreshes on return
The system SHALL refresh account balances and all financial overview sections (Total Balance, Monthly Summary, Category Breakdown) when the user navigates back to the Dashboard from any account or transaction screen.

#### Scenario: Balance refreshes after adding transaction
- **WHEN** the user adds a transaction and returns to the Dashboard
- **THEN** the affected account card SHALL display the updated balance

#### Scenario: Financial overview refreshes after adding transaction
- **WHEN** the user adds a transaction and returns to the Dashboard
- **THEN** the Total Balance card, Monthly Summary, and Category Breakdown SHALL all reflect the new transaction data
