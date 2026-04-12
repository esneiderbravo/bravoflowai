# Database Specification

### Requirement: Profiles schema supports user profile management fields
The system MUST maintain a `public.profiles` table keyed by `auth.users(id)` and MUST include fields required by profile management: `id`, `full_name`, `email`, `avatar_url`, and `created_at`.

#### Scenario: New profile row shape
- **WHEN** a profile row is created for a new authenticated user
- **THEN** the row SHALL include `id` linked to `auth.users(id)` and SHALL support `full_name`, `email`, and `avatar_url` fields

#### Scenario: Existing profiles migration
- **WHEN** migration is applied to an environment with existing profile rows
- **THEN** the system SHALL preserve existing rows and SHALL backfill compatible values required for profile rendering

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

