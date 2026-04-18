## ADDED Requirements

### Requirement: Accounts table stores user financial accounts
The system MUST maintain a `public.accounts` table with fields: `id`, `user_id`, `name`, `type`, `initial_balance`, `currency`, `color`, `icon`, `is_default`, `created_at`. The `type` field MUST be constrained to `('checking', 'savings', 'cash', 'investment', 'other')`.

#### Scenario: Account row created
- **WHEN** a user creates a new account
- **THEN** a row SHALL be inserted into `public.accounts` with all required fields and `created_at` defaulting to `now()`

#### Scenario: RLS enforces account ownership
- **WHEN** an authenticated user queries the accounts table
- **THEN** they SHALL only see rows where `user_id = auth.uid()`

### Requirement: Transfers table stores inter-account transfers
The system MUST maintain a `public.transfers` table with fields: `id`, `user_id`, `from_account_id`, `to_account_id`, `amount`, `date`, `note`, `created_at`. Both `from_account_id` and `to_account_id` MUST be foreign keys referencing `public.accounts(id)`.

#### Scenario: Transfer row created
- **WHEN** a user creates a transfer between two accounts
- **THEN** a single row SHALL be inserted into `public.transfers` with `from_account_id` ≠ `to_account_id`

#### Scenario: RLS enforces transfer ownership
- **WHEN** an authenticated user queries the transfers table
- **THEN** they SHALL only see rows where `user_id = auth.uid()`

### Requirement: Transactions table references account
The system MUST add an `account_id` column (non-null UUID FK → `public.accounts(id)`) to the `public.transactions` table. Existing rows MUST be backfilled to a default account before the column becomes non-null.

#### Scenario: New transaction has account_id
- **WHEN** a transaction is inserted after migration
- **THEN** the row SHALL include a non-null `account_id` referencing a valid account

#### Scenario: Backfill of existing transactions
- **WHEN** the migration runs on an environment with existing transaction rows
- **THEN** all existing transactions SHALL be assigned the user's default (`is_default = true`) account id

### Requirement: Default account seeded per user on registration
The system MUST insert a default `Cash` account (`is_default = true`, `type = 'cash'`) for every new user profile, via the existing profile creation trigger or a new trigger.

#### Scenario: Default account on sign-up
- **WHEN** a new user completes registration and a profile row is created
- **THEN** a corresponding default `Cash` account SHALL be inserted into `public.accounts`
