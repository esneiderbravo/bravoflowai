## MODIFIED Requirements

### Requirement: Profiles schema supports user profile management fields
The system MUST maintain a `public.profiles` table keyed by `auth.users(id)` and MUST include fields required by profile management and personalization: `id`, `full_name`, `email`, `avatar_url`, `language_code`, and `created_at`. The `language_code` field MUST default to `'es'`.

#### Scenario: New profile row shape
- **WHEN** a profile row is created for a new authenticated user
- **THEN** the row SHALL include `id` linked to `auth.users(id)` and SHALL support `full_name`, `email`, `avatar_url`, and `language_code`

#### Scenario: Existing profiles migration
- **WHEN** migration is applied to an environment with existing profile rows
- **THEN** the system SHALL preserve existing rows and SHALL backfill compatible values required for profile rendering, including a default `language_code` of `'es'` where absent

