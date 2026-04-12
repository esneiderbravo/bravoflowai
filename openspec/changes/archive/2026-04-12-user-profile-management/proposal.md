## Why

BravoFlow AI currently supports authentication, but users cannot manage their account profile in the app. Implementing profile management now is necessary to complete core account ownership flows (view/update personal data and avatar) before expanding transactional features.

## What Changes

- Add a dedicated profile feature with layered architecture under `features/profile/`:
  presentation, application, domain, and data.
- Introduce profile read/update workflows backed by Supabase (`profiles` table) through repository interfaces and implementations.
- Add avatar upload support via Supabase Storage bucket `avatars`, with persisted `avatar_url` on profile updates.
- Add Riverpod controller/notifier for loading, editing, validation, save, loading/error UX states.
- Add a Profile screen UI with editable avatar and name, read-only email, and save action using existing design tokens.
- Add/adjust Supabase migration(s) and RLS/policies needed for profile persistence and secure user ownership.

## Capabilities

### New Capabilities
- `profile-management`: End-to-end user profile lifecycle in-app, including fetch, edit, avatar upload, validation, and secure persistence.

### Modified Capabilities
- `database`: Extend `profiles` data contract and migration/security documentation to support `full_name`, `email`, and `avatar_url` for profile management.

## Impact

- Affected code areas:
  - `lib/features/profile/**` (new feature)
  - `lib/domain/**` and repository contracts used by profile feature
  - `lib/core/router/app_router.dart` (profile route)
  - `lib/shared/widgets/**` (only if reusable UI pieces are extracted)
- Affected backend artifacts:
  - `supabase/migrations/**` (profiles schema/policies updates)
  - Supabase Storage bucket usage: `avatars/{user_id}/avatar.png`
- Cross-cutting constraints:
  - No direct Supabase calls in UI
  - Riverpod state management required
  - Theme/token usage only (no hardcoded UI values)
- Risks/dependencies:
  - RLS policy correctness for profile reads/writes
  - Storage policy correctness for avatar upload paths
  - Backward compatibility for existing `profiles` rows

