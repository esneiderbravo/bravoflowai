## 1. Database and Profile Contract

- [x] 1.1 Add Supabase migration to append `profiles.theme_mode` with default `system` and backfill existing rows.
- [x] 1.2 Extend profile DTO/entity/repository mapping to read, sanitize, and write `theme_mode` values (`system|dark|light`).
- [x] 1.3 Update profile API update flow so theme mode is sent as part of profile save payload.

## 2. App-Level Theme State Wiring

- [x] 2.1 Implement `AppThemeController` in `lib/core/theme/` with bootstrap + mapping helpers from persisted code to `ThemeMode`.
- [x] 2.2 Wire `MaterialApp` in `lib/main.dart` to watch theme controller, apply `theme` + `darkTheme`, and bind dynamic `themeMode`.
- [x] 2.3 Bootstrap theme preference from authenticated profile/session at startup with fallback to `ThemeMode.system`.

## 3. Profile UI and Save Behavior

- [x] 3.1 Add theme draft state to `ProfileState` and update controller methods for changing selected theme option.
- [x] 3.2 Add theme selector UI in profile/settings with localized labels for System, Dark, and Light.
- [x] 3.3 Apply global theme change only after successful `saveProfile` response; keep previous theme if save fails.

## 4. Localization and Validation

- [x] 4.1 Add localization keys for theme selector label, option labels, and save feedback messages in supported locales.
- [x] 4.2 Ensure no new hardcoded theme-related UI strings remain in modified screens/controllers.
- [x] 4.3 Add/adjust automated tests for profile theme persistence, fallback behavior, and runtime theme application.

## 5. Verification and Release Readiness

- [x] 5.1 Validate migration + app behavior for new users and existing users upgrading from older schema.
- [x] 5.2 Run lint/tests and smoke test login -> profile update -> app restart persistence flow.
- [x] 5.3 Document rollout notes and rollback expectations in change artifacts before `/opsx:apply` execution.

## 6. Full-Screen Theme Parity

- [x] 6.1 Migrate `lib/shared/widgets/app_shell.dart` to theme-aware scaffold and navigation colors.
- [x] 6.2 Replace hardcoded dark surfaces/text in `dashboard`, `transactions`, `ai_insights`, and `budget` screens with theme-derived tokens.
- [x] 6.3 Update auth screens/widgets to support light mode contrast and consistent text readability.
- [x] 6.4 Refactor shared style usage to prefer `Theme.of(context)` text/color roles for runtime brightness changes.
- [x] 6.5 Add widget/smoke coverage that validates light and dark rendering on all primary routes.

