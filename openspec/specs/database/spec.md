# Database Specification

### Requirement: Profiles schema supports user profile management fields
The system MUST maintain a `public.profiles` table keyed by `auth.users(id)` and MUST include fields required by profile management and personalization: `id`, `full_name`, `email`, `avatar_url`, `language_code`, `theme_mode`, and `created_at`. The `language_code` field MUST default to `'es'`.

#### Scenario: New profile row shape
- **WHEN** a profile row is created for a new authenticated user
- **THEN** the row SHALL include `id` linked to `auth.users(id)` and SHALL support `full_name`, `email`, `avatar_url`, `language_code`, and `theme_mode` fields

#### Scenario: Existing profiles migration
- **WHEN** migration is applied to an environment with existing profile rows
- **THEN** the system SHALL preserve existing rows and SHALL backfill compatible values required for profile rendering, including a default `language_code` of `'es'` where absent

#### Scenario: Theme mode default value
- **WHEN** a profile row is inserted without an explicit `theme_mode`
- **THEN** the system SHALL store `theme_mode = 'system'` by default

### Requirement: Profiles remain protected by user ownership RLS
The system MUST enforce row-level security so users can only read or write their own profile row.

#### Scenario: Authorized profile update
- **WHEN** an authenticated user updates profile fields for their own `id`
- **THEN** the update SHALL be allowed

#### Scenario: Unauthorized profile update
- **WHEN** a user attempts to update another user's profile row
- **THEN** the operation SHALL be denied by policy

### Requirement: Avatar storage is constrained by user ownership path
The system MUST store avatar files in bucket `avatars` under `user_id/avatar.<ext>` and MUST enforce storage policies scoped to the authenticated user's folder.

#### Scenario: Valid avatar upload path
- **WHEN** an authenticated user uploads a profile avatar
- **THEN** the object SHALL be written only under the user's own folder prefix

#### Scenario: Cross-user avatar write attempt
- **WHEN** a user attempts to write an avatar object under another user's folder prefix
- **THEN** the storage policy SHALL deny the operation

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

