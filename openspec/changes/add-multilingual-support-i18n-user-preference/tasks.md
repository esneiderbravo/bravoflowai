## 1. Localization Foundation

- [x] 1.1 Configure Flutter localization generation (`flutter_localizations`, `intl`, `gen-l10n`) and verify `es`/`en` delegates are available.
- [x] 1.2 Create localization resource files under `lib/core/i18n/l10n/` (`app_es.arb`, `app_en.arb`) with required keys (`app_title`, `welcome_message`, `profile_title`, `save_button`, `language_label`) and shared UI strings.
- [x] 1.3 Implement `lib/core/i18n/` localization layer (`app_localizations.dart`, delegate/config helpers, locale registry) with Spanish fallback behavior.

## 2. App Shell Locale Wiring

- [x] 2.1 Add app-level locale controller/state that exposes current locale and notifies listeners on changes.
- [x] 2.2 Wire `MaterialApp` in `lib/main.dart` to localization delegates, `supportedLocales`, and reactive `locale` from the app-level locale controller.
- [x] 2.3 Refactor touched UI surfaces to replace hardcoded text with localization lookups for localized screens/components.

## 3. Profile Persistence and Startup Loading

- [x] 3.1 Extend profile domain/data models and repository contracts to include `language_code`.
- [x] 3.2 Implement Supabase profile read/write mapping for `language_code` and validation fallback to `es` when values are missing/invalid.
- [x] 3.3 Update authenticated startup/login flow to load `language_code` and set app locale before rendering primary signed-in content.

## 4. Language Selector UX

- [x] 4.1 Add language selector UI in settings/profile feature with options Espanol (`es`) and English (`en`).
- [x] 4.2 On selection, update app locale immediately and persist preference to Supabase profile.
- [x] 4.3 Handle save/update errors gracefully while preserving last known locale and providing localized feedback.

## 5. Database Migration

- [x] 5.1 Create migration `supabase/migrations/202604110008_add_language_to_profiles.sql` to add `language_code text not null default 'es'` to `public.profiles`.
- [x] 5.2 Verify migration is backward compatible for existing rows and aligns with database spec delta.

## 6. Verification and Quality Gates

- [x] 6.1 Add/update unit/widget tests for locale switching, generated localization usage, and fallback to Spanish.
- [x] 6.2 Add/update integration tests for persisted language across login/session restoration.
- [x] 6.3 Run lint/tests and perform a manual regression pass confirming dynamic updates and no remaining hardcoded localized strings in touched scope.

