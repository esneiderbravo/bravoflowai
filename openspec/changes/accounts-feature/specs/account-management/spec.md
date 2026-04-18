## ADDED Requirements

### Requirement: User can create an account
The system SHALL allow an authenticated user to create a new financial account by providing a name, type, initial balance, and optional color/icon. Account types SHALL be limited to: `checking`, `savings`, `cash`, `investment`, `other`.

#### Scenario: Successful account creation
- **WHEN** a user submits valid account data (name, type, initialBalance ≥ 0)
- **THEN** the system SHALL persist the account linked to the user's profile and return the created entity

#### Scenario: Missing required fields
- **WHEN** a user submits account creation without a name or type
- **THEN** the system SHALL display validation errors and SHALL NOT persist the account

#### Scenario: Negative initial balance rejected
- **WHEN** a user enters a negative value for initial balance
- **THEN** the system SHALL display a validation error and SHALL NOT persist the account

### Requirement: User can view their accounts list
The system SHALL display all accounts belonging to the authenticated user, each showing name, type, and current balance.

#### Scenario: Accounts list loaded
- **WHEN** the user navigates to the Accounts section in the More tab
- **THEN** the system SHALL display all accounts ordered by creation date

#### Scenario: Empty state
- **WHEN** the user has no accounts
- **THEN** the system SHALL display an empty state with a prompt to create the first account

### Requirement: User can edit an account
The system SHALL allow the user to update an account's name, type, color/icon, and initial balance.

#### Scenario: Successful edit
- **WHEN** the user submits valid updated account data
- **THEN** the system SHALL persist the changes and update the displayed account details

#### Scenario: Initial balance edit warning
- **WHEN** the user modifies the initial balance of an account that already has transactions
- **THEN** the system SHALL display a warning that this will affect all historical balance calculations before saving

### Requirement: User can delete an account
The system SHALL allow the user to delete an account only if it has no linked transactions or transfers.

#### Scenario: Delete account with no transactions
- **WHEN** the user confirms deletion of an account that has no transactions or transfers
- **THEN** the system SHALL permanently remove the account

#### Scenario: Delete blocked when transactions exist
- **WHEN** the user attempts to delete an account that has linked transactions or transfers
- **THEN** the system SHALL display an error message and SHALL NOT delete the account
