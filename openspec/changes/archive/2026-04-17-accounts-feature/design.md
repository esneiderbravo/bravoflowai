## Context

BravoFlow AI is a Flutter + Supabase personal finance app. Currently every transaction is tied directly to a user (`user_id`) with no intermediate account concept. Users need to track balances across distinct real-world accounts (checking, savings, cash, investments). The app uses clean architecture (domain entities → repositories → Riverpod providers → Flutter UI), Go Router for navigation, and `fpdart` Either for error handling.

## Goals / Non-Goals

**Goals:**
- Introduce `Account` as a first-class domain entity with CRUD support
- Link `Transaction` to an `Account` via `account_id`
- Support transfers between accounts via a dedicated `transfers` table
- Derive account balance from `initialBalance` + transaction sums + transfer sums (never stored)
- Add a horizontally scrollable accounts widget to the Dashboard
- Replace the Budget bottom-nav tab with a **More** tab that hosts account management

**Non-Goals:**
- Credit card accounts (excluded by design — all balances are positive)
- Bank sync / Open Banking / Plaid integration
- Budget feature changes (Budget tab removal is a side effect of the More tab addition, not a budget redesign)
- Multi-currency transfers (transfers use the source account currency)

## Decisions

### 1. Separate `transfers` table over linked transaction pairs
**Decision**: A dedicated `transfers(id, user_id, from_account_id, to_account_id, amount, date, note)` table rather than adding a `transfer_pair_id` to the transactions table.

**Rationale**: Transfers are not income or expense — they have no category, no type, and should not pollute category-based analytics or the income/expense enum. A single `transfers` row is atomic: creating or deleting a transfer is one operation with no risk of orphaned half-pairs. The balance formula stays clean and auditable.

**Alternatives considered**: Adding `transfer_pair_id` (nullable UUID) to transactions. Rejected because it couples two rows that must always be kept in sync, complicates category queries, and exposes a broken state if one row is deleted.

### 2. Derived balance — never stored
**Decision**: `currentBalance` is always computed: `initialBalance + SUM(income txns) - SUM(expense txns) + SUM(incoming transfers) - SUM(outgoing transfers)`. No `current_balance` column on the accounts table.

**Rationale**: A stored balance would drift whenever a transaction is edited or deleted. Derived balance is always consistent. Supabase RPC or in-app aggregation both work; the initial implementation aggregates in-app via the repository.

**Alternatives considered**: Storing and updating `current_balance` on every transaction write. Rejected due to consistency risk and additional update logic in every mutation path.

### 3. `account_id` is required on new transactions
**Decision**: `account_id` is a non-null FK on `transactions` going forward. Existing rows that predate this migration will need a default account to satisfy the constraint.

**Rationale**: An account-less transaction has no meaning once accounts exist. The migration creates a default "Cash" account per user and backfills existing transactions to it.

**Migration steps**: See Migration Plan below.

### 4. More tab replaces Budget tab
**Decision**: Budget tab is removed from bottom nav. A new **More** tab (`/more`) replaces it, containing the Accounts section. Budget screen remains in the codebase but is not linked from the nav until reintroduced later.

**Rationale**: Budget is explicitly deprioritised. More tab is an extensible home for settings-category items. This avoids adding a 5th nav tab.

### 5. Account types as an enum
**Decision**: `account_type` is a Dart enum / Postgres `check` constraint: `checking | savings | cash | investment | other`.

**Rationale**: Bounded set enables icon/color mapping per type without free-form string matching. `other` is the escape hatch for unlisted types.

## Risks / Trade-offs

- **Backfill migration risk** → Create a default "Cash" account for each existing user and assign all orphaned transactions to it. Include a rollback migration that drops `account_id` and the new tables.
- **Balance accuracy with partial data** → If a user doesn't enter all transactions, derived balance will differ from the real bank balance. Accepted trade-off; user is responsible for data completeness. Consider a UI disclaimer.
- **Transfer currency mismatch** → Transfers between accounts with different currencies are not supported in v1. The UI should restrict `to_account` to same-currency accounts only.
- **Deleting an account with transactions** → Block deletion if the account has transactions or transfers. Show a clear error message. Avoid cascade delete to prevent data loss.

## Migration Plan

1. Add migration: create `accounts` table with RLS policy `own_accounts`.
2. Add migration: for each existing `profiles` row, insert a default `Cash` account (`is_default = true`).
3. Add migration: add `account_id` column to `transactions` (nullable first).
4. Add migration: backfill `account_id` on all existing `transactions` to the user's default account.
5. Add migration: make `account_id` NOT NULL on `transactions`.
6. Add migration: create `transfers` table with RLS policy `own_transfers`.

**Rollback**: Drop `transfers`, remove `account_id` from `transactions`, drop `accounts`.

## Open Questions

- Should `initialBalance` be editable after account creation? (Editing it would change all historical balance calculations.) Recommendation: allow edits with a clear warning.
- Should transfers appear in the transaction list screen filtered by account, or only in a dedicated transfers view?
