## Why

BravoFlow AI already has auth session primitives (`AuthRepository.signOut`, Supabase auth stream, and router redirects), but users do not have an explicit in-app way to close their session. This creates a product gap for account safety and a UX inconsistency where sign-in exists but sign-out is not discoverable.

## What Changes

- Add a visible "Close session" action in authenticated UI (profile/settings surface).
- Add a confirmation step before sign-out to reduce accidental session termination.
- Treat close-session as an explicit async flow with loading and error feedback.
- Ensure close-session success relies on auth-state stream + router redirect to move user to `/auth/sign-in`.
- Improve auth application-layer behavior so sign-out failures are not silently ignored.
- Add localization keys for close-session labels/messages in supported languages.
- Add tests for notifier state transitions and profile logout UX behavior.

## Capabilities

### New Capabilities
- `session-management`: Authenticated users can explicitly close their active app session with predictable confirmation, transition, and error behavior.

### Modified Capabilities
- `app-localization`: Add localized strings for close-session action, confirmation prompt, and failure feedback.

## Impact

- Affected code areas:
  - `lib/features/profile/presentation/screens/profile_screen.dart`
  - `lib/features/auth/application/auth_notifier.dart`
  - `lib/features/auth/presentation/**` (if shared auth feedback widgets are reused)
  - `lib/core/router/app_router.dart` (verification only; redirect behavior already present)
  - `lib/l10n/**` (new i18n keys)
- Affected backend artifacts:
  - None expected (uses existing Supabase auth sign-out API)
- Cross-cutting constraints:
  - No direct Supabase calls in presentation layer
  - Logout redirect remains auth-stream-driven (no route hardcoding in widget callbacks)
  - User-facing copy must come from localization resources
- Risks/dependencies:
  - Network/auth errors during sign-out must keep user in a recoverable state
  - Double-tap/duplicate requests must be prevented while sign-out is running
  - UX decision needed for whether close-session remains profile-only or is also exposed globally

