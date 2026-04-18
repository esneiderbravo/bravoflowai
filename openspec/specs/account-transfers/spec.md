# Account Transfers Specification

### Requirement: User can create a transfer between accounts
The system SHALL allow an authenticated user to move money from one account to another by creating a transfer record with: source account, destination account, amount, date, and optional note.

#### Scenario: Successful transfer creation
- **WHEN** the user submits a valid transfer (different source and destination accounts, positive amount, valid date)
- **THEN** the system SHALL persist the transfer and immediately reflect the updated balances on both accounts

#### Scenario: Same account transfer rejected
- **WHEN** the user selects the same account as both source and destination
- **THEN** the system SHALL display a validation error and SHALL NOT persist the transfer

#### Scenario: Zero or negative amount rejected
- **WHEN** the user enters an amount ≤ 0 for a transfer
- **THEN** the system SHALL display a validation error and SHALL NOT persist the transfer

#### Scenario: Insufficient balance warning
- **WHEN** the transfer amount exceeds the current balance of the source account
- **THEN** the system SHALL display a warning to the user before allowing them to proceed

### Requirement: Transfers are stored in a dedicated table
The system SHALL store transfers in a `transfers` table separate from `transactions`. Transfers SHALL NOT use the income/expense transaction type.

#### Scenario: Transfer record structure
- **WHEN** a transfer is created
- **THEN** the system SHALL store `from_account_id`, `to_account_id`, `amount`, `date`, `note`, `user_id`, and `created_at` in the `transfers` table

### Requirement: User can delete a transfer
The system SHALL allow the user to delete a transfer, which SHALL restore both account balances to their pre-transfer state.

#### Scenario: Successful transfer deletion
- **WHEN** the user confirms deletion of a transfer
- **THEN** the system SHALL remove the transfer record and both account balances SHALL update accordingly

### Requirement: Transfers are visible per account
The system SHALL display transfers (both incoming and outgoing) in the account detail view alongside transactions.

#### Scenario: Outgoing transfer displayed
- **WHEN** viewing an account's history
- **THEN** outgoing transfers SHALL appear as money-out entries labelled with the destination account name

#### Scenario: Incoming transfer displayed
- **WHEN** viewing an account's history
- **THEN** incoming transfers SHALL appear as money-in entries labelled with the source account name
