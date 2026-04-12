## Why

BravoFlow AI currently enforces a fixed dark theme, which prevents users from matching their device accessibility and comfort preferences. Introducing a persisted theme preference now improves UX consistency across sessions and aligns with profile-driven personalization already used in the app.

## What Changes

- Add theme preference support with three modes: `system`, `dark`, and `light`.
- Default app appearance to system theme behavior for new and existing users.
- Add a profile-level theme selector in settings/profile UI.
- Persist selected theme in Supabase `profiles` and load it at login/bootstrap.
- Apply selected `ThemeMode` globally through app state so the UI updates predictably.
- Enforce light/dark parity across all app screens by replacing hardcoded dark-only colors with theme-aware tokens.

## Capabilities

### New Capabilities
- `app-theming`: Manage app theme mode selection, persistence, and runtime application (`system`, `dark`, `light`).

### Modified Capabilities
- `database`: Extend `profiles` schema to include persisted `theme_mode` with default `system`.

## Impact

- Flutter app wiring in `lib/main.dart` and app-level state bootstrap.
- Profile/domain/data flow for reading and updating theme preference.
- Settings/profile UI to expose theme selection control.
- Supabase migration and profile query/update payloads.
- Additional localization strings for theme labels and save feedback where applicable.
- Shared shell and feature screens (`dashboard`, `transactions`, `ai_insights`, `budget`, `auth`) to remove dark-only UI styles.

