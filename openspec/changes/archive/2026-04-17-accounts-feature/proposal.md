## Why

Users manage money across multiple real-world accounts (checking, savings, cash, investments) but BravoFlow AI currently has no concept of accounts — every transaction is just tied to a user. This makes it impossible to see balances per account or understand where money actually lives.

## What Changes

- Introduce an `Account` entity (checking, savings, cash, investment, other) owned by each user
- Transactions are linked to a specific account (`account_id`)
- Transfers between accounts are supported via a dedicated `transfers` table — not conflated with income/expense transactions
- Account balance is derived: `initialBalance + SUM(income txns) - SUM(expense txns) + SUM(incoming transfers) - SUM(outgoing transfers)`
- Dashboard gains a horizontally scrollable accounts widget showing each account's current balance
- Budget tab is removed; a new **More** tab replaces it, housing account management and future settings
- **BREAKING**: `transactions` table gains a required `account_id` foreign key

## Capabilities

### New Capabilities
- `account-management`: CRUD for user accounts (name, type, initialBalance, currency, icon/color). Accessible from the More tab.
- `account-balance`: Derived balance computation per account from transactions and transfers.
- `account-transfers`: Move money between two accounts via a dedicated transfer record; does not use transaction income/expense types.
- `accounts-dashboard-widget`: Horizontally scrollable widget on the Dashboard showing all accounts with their current balances.
- `more-tab`: New bottom-nav tab replacing Budget, providing a home for account management and future settings items.

### Modified Capabilities
- `database`: `transactions` table gains `account_id` (FK → accounts). New `accounts` and `transfers` tables added with RLS policies.

## Impact

- **Domain**: New `Account` entity, new `Transfer` entity; `Transaction` gains `accountId`
- **Data layer**: New Supabase migration; new DTOs and repository implementations for accounts and transfers; `TransactionDto` updated
- **Presentation**: Dashboard screen updated (accounts widget); AppShell bottom nav updated (Budget → More); new Accounts screen and More screen
- **Router**: New `/more`, `/more/accounts`, `/more/accounts/add`, `/more/accounts/:id/edit` routes
- **Localization**: New i18n keys for all new UI strings
