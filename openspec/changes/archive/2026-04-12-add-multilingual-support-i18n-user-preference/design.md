## Context

BravoFlow AI currently has no centralized localization layer and still contains hardcoded UI text. The app already uses Supabase-backed user profiles, making profile attributes the correct source of truth for per-user language preference. This change crosses application shell (`MaterialApp` locale wiring), shared UI text management, settings/profile UX, repository/data mapping, and database schema migration.

Constraints:
- Spanish (`es`) is the product default for all users and fallback behavior.
- Initial supported locales are limited to Spanish and English.
- Preference must be persisted in `profiles.language_code` and applied when users return.
- Scope excludes RTL support and advanced pluralization.

## Goals / Non-Goals

**Goals:**
- Provide a single localization system using Flutter-generated localizations and ARB resources under `lib/core/i18n/`.
- Ensure all user-facing app strings are served from localization keys (no hardcoded UI strings).
- Allow runtime language switching from settings/profile UI with immediate app-wide updates.
- Persist selected locale in Supabase profile (`language_code`) and restore on authenticated startup/login.
- Add a safe migration to add `language_code text default 'es'` for existing and new profiles.

**Non-Goals:**
- Support RTL languages or locale-specific layout changes.
- Implement advanced ICU plural/gender/message formatting beyond basic key translation.
- Add new business features unrelated to localization (for example transaction management).

## Decisions

- Use Flutter `gen-l10n` + ARB files (`app_es.arb`, `app_en.arb`) as the canonical translation source.
  - Rationale: Native Flutter flow minimizes custom parsing and integrates cleanly with analyzer/tooling.
  - Alternative considered: Custom JSON loader; rejected due to higher maintenance and weaker type safety.

- Add `AppLocaleController` (or equivalent state holder) in `lib/core/i18n/` to own current locale and notify `MaterialApp`.
  - Rationale: Centralized state avoids fragmented locale logic across feature widgets.
  - Alternative considered: Store locale only in feature-level state; rejected because locale impacts the whole widget tree.

- Persist locale in profile as a short BCP-47-like language tag constrained to known values (`es`, `en`) and fallback to `es` if missing/invalid.
  - Rationale: Simple, explicit contract with backward compatibility for existing rows.
  - Alternative considered: Device locale precedence when profile missing; rejected because product requirement mandates Spanish default.

- Load locale on session bootstrap in auth/profile startup path before rendering primary signed-in routes.
  - Rationale: Prevents language flicker and ensures first meaningful paint matches user preference.
  - Alternative considered: Render first and switch later; rejected due to visible UX inconsistency.

- Add one migration file in `supabase/migrations/` for `language_code` with default `'es'` and idempotent-safe DDL pattern used by project.
  - Rationale: Keeps schema evolution explicit and deployable with Supabase migration workflow.

## Risks / Trade-offs

- [Risk] Remaining hardcoded strings can cause mixed-language UI.
  -> Mitigation: Audit key screens and add lint/test checks for localized text usage in touched features.

- [Risk] Startup flow can regress if locale load blocks app too long.
  -> Mitigation: Keep locale bootstrap lightweight, default to `es` immediately, and apply remote value as soon as profile fetch resolves.

- [Risk] Invalid DB values (manual edits, legacy states) may break locale parsing.
  -> Mitigation: Validate against supported locale set and fallback deterministically to `es`.

- [Trade-off] Restricting to `es`/`en` keeps scope small but requires follow-up changes for additional locales.
  -> Mitigation: Structure ARB and locale registry for straightforward extension.

## Migration Plan

1. Create and review migration `20260411_add_language_to_profiles.sql` adding `language_code text not null default 'es'` to `public.profiles`.
2. Apply migration in dev/staging and verify existing rows receive `'es'` default where needed.
3. Deploy app update with i18n resources, locale controller, and profile persistence integration.
4. Rollback approach: if app rollout fails, keep column in place (backward compatible) and revert client usage to default `es` only.

## Open Questions

- Should anonymous/pre-auth screens follow device locale when supported, or always remain Spanish until login?
- Should language selector live in `features/settings` only, or also be surfaced within profile edit flow?

