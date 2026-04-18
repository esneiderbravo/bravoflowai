# Account Balance Specification

### Requirement: Account balance is derived, never stored
The system SHALL compute an account's current balance as:
`currentBalance = initialBalance + SUM(income transactions) - SUM(expense transactions) + SUM(incoming transfers) - SUM(outgoing transfers)`
No `current_balance` column SHALL be stored on the account row.

#### Scenario: Balance with no transactions
- **WHEN** an account has no transactions or transfers
- **THEN** the system SHALL display the account's `initialBalance` as the current balance

#### Scenario: Balance with income and expense transactions
- **WHEN** an account has a mix of income and expense transactions
- **THEN** the system SHALL compute the balance using `initialBalance + SUM(income) - SUM(expense)`

#### Scenario: Balance including transfers
- **WHEN** an account is the destination of a transfer
- **THEN** the transfer amount SHALL be added to the balance
- **WHEN** an account is the source of a transfer
- **THEN** the transfer amount SHALL be subtracted from the balance

### Requirement: Balance recomputes on data changes
The system SHALL recompute and refresh account balances whenever a transaction or transfer linked to that account is created, updated, or deleted.

#### Scenario: Balance updates after new transaction
- **WHEN** a new transaction is added to an account
- **THEN** the displayed balance for that account SHALL reflect the new transaction immediately

#### Scenario: Balance updates after transaction deletion
- **WHEN** a transaction is deleted from an account
- **THEN** the displayed balance SHALL decrease or increase accordingly
