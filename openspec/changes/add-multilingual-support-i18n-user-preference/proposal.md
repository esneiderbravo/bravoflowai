## Why

BravoFlow AI currently relies on static UI text and does not let users choose their language, which limits usability for non-Spanish or non-default audiences. We need a first-class localization system now so language can be personalized and persisted as part of each user profile.

## What Changes

- Introduce app-wide Flutter localization infrastructure using generated localizations and language resources for Spanish (`es`) and English (`en`).
- Add translation catalogs for core shared strings and move existing hardcoded UI strings to localization keys.
- Add a user-facing language selector in settings/profile flow with options for Espanol and English.
- Persist user language preference in Supabase `profiles.language_code` and load it during authenticated app startup.
- Apply locale changes dynamically in `MaterialApp` so text updates without app restart.
- Add a mandatory database migration to extend `profiles` with `language_code text default 'es'`.

## Capabilities

### New Capabilities
- `app-localization`: Defines multilingual UI behavior, supported locales (`es`, `en`), locale resolution, and dynamic runtime language switching.

### Modified Capabilities
- `database`: Extend profile schema requirements to include persisted `language_code` preference with default `'es'` and backward-compatible migration behavior.

## Impact

- Affected code: `lib/main.dart`, new `lib/core/i18n/` module, and settings/profile UI for language selection.
- Affected data layer: profile entity/model/repository and Supabase profile update/read flows.
- Affected database: new migration under `supabase/migrations/` adding `profiles.language_code`.
- Tooling/dependencies: Flutter localization generation (`gen-l10n` / `flutter_localizations` / `intl`) and ARB resources.
- QA impact: widget/integration tests for locale switching, persistence, startup locale bootstrap, and regression checks for removed hardcoded strings.

