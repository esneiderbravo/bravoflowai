## Context

BravoFlow AI already supports auth, dashboard, and Supabase-backed persistence, but profile management is incomplete at the product level. Users currently do not have a dedicated profile feature to review/update identity fields or avatar.

Constraints and current architecture:
- App architecture is feature-first with layered boundaries (`presentation -> application -> domain <- data`).
- Supabase is the backend for auth, Postgres, and storage.
- UI must use centralized theme tokens and avoid hardcoded styling.
- RLS is enabled and mandatory for user-owned data.
- Existing schema has `public.profiles` (`id`, `name`, `currency`, `created_at`) and an auth-trigger migration now auto-creates profile rows.

This change introduces profile management while preserving clean boundaries and secure RLS behavior.

## Goals / Non-Goals

**Goals:**
- Add a full `features/profile/` module with presentation/application/domain/data layers.
- Support profile fetch + update for `full_name`, `email`, and `avatar_url`.
- Support avatar upload to Supabase Storage bucket `avatars` using path `user_id/avatar.<ext>`.
- Keep Supabase calls inside repositories only.
- Provide Riverpod-driven loading/error/success states for profile editing UX.
- Add migration(s) to align database schema and policies with profile requirements.

**Non-Goals:**
- Social auth providers, advanced preferences, notification settings.
- Cross-feature preference center.
- Background image processing/CDN optimization beyond basic upload.

## Decisions

### Decision 1: New vertical feature module `features/profile/`
- **Choice:** Implement as an independent feature module (`presentation`, `application`, `domain`, `data`) rather than extending `auth`.
- **Rationale:** Keeps account lifecycle concerns (auth) separate from post-auth profile management and aligns with Open Spec architecture boundaries.
- **Alternative considered:** Add profile logic into `features/auth/` for fewer files.
- **Why rejected:** Blurs responsibilities and makes auth feature a long-term coupling hotspot.

### Decision 2: Keep domain repository contract in local feature domain
- **Choice:** Define `ProfileRepository` interface under `features/profile/domain/repositories/` and `Profile` entity under `features/profile/domain/entities/`.
- **Rationale:** Profile behavior is feature-specific and not yet shared cross-feature.
- **Alternative considered:** Put profile repository/entity under global `lib/domain/`.
- **Why rejected:** Premature globalization; can be promoted later if other features consume it broadly.

### Decision 3: Extend `profiles` table with `full_name`, `email`, `avatar_url`
- **Choice:** Add migration to evolve existing `profiles` table instead of creating a parallel table.
- **Rationale:** Existing auth linkage and RLS ownership model already centered on `profiles.id = auth.users.id`.
- **Alternative considered:** Create a `user_profiles` table.
- **Why rejected:** Duplicates identity data and complicates joins, policies, and migration.

### Decision 4: Email treated as read-only in profile form
- **Choice:** Display email but do not allow direct editing in this change.
- **Rationale:** Email updates are an auth concern requiring Supabase auth update/verification flow, separate from normal profile row updates.
- **Alternative considered:** Editable email in the same save action.
- **Why rejected:** Conflates auth and profile write paths, adds verification complexity.

### Decision 5: Avatar upload flow via repository abstraction
- **Choice:** `ProfileRepository.uploadAvatar(fileBytes, fileExt)` uploads to `avatars/{userId}/avatar.<ext>`, returns public/signed URL, then repository updates `avatar_url`.
- **Rationale:** Keeps UI free of storage client logic and provides a single transactional profile save pathway.
- **Alternative considered:** Upload directly from UI and save URL separately.
- **Why rejected:** Violates architecture rule (no backend calls in presentation) and duplicates error handling.

### Decision 6: Riverpod controller as single write orchestrator
- **Choice:** Use `AsyncNotifier<ProfileState>` to fetch initial profile, stage edits, run validation, upload avatar if changed, and persist updates.
- **Rationale:** Guarantees one source of truth for form and side effects.
- **Alternative considered:** Local widget state + separate save calls.
- **Why rejected:** Harder to test and easy to leak infrastructure concerns into UI.

### Decision 7: Policy model for secure profile and avatar ownership
- **Choice:** Keep `profiles` RLS ownership by `auth.uid() = id`; add storage policies so users can only read/write files in their own avatar folder prefix.
- **Rationale:** Ensures least-privilege and tenant isolation.
- **Alternative considered:** Open read on avatars with unrestricted writes.
- **Why rejected:** High data integrity/security risk.

## Risks / Trade-offs

- **[Risk] Existing rows may have `name` but not `full_name`/`email`** -> **Mitigation:** Backfill migration copies `name -> full_name` where needed and sets email from auth data path when available; app handles null-safe fallback display.
- **[Risk] Storage bucket policy misconfiguration blocks uploads** -> **Mitigation:** Add explicit policy SQL + smoke test checklist for upload/list/update by user.
- **[Risk] Avatar overwrite caching issues** -> **Mitigation:** Include cache-busting query param/version timestamp after successful upload.
- **[Risk] Additional profile domain inside feature may later need global reuse** -> **Mitigation:** Document promotion path to `lib/domain/` if consumed by 2+ features.
- **[Trade-off] Read-only email simplifies this release but defers auth-email change UX** -> **Mitigation:** Track follow-up change for verified email update flow.

## Migration Plan

1. Add SQL migration to alter `public.profiles` with new columns:
   - `full_name text`
   - `email text`
   - `avatar_url text`
2. Backfill `full_name` from existing `name` where `full_name` is null/empty.
3. Ensure profile auto-create trigger writes `full_name` and `email` for new signups.
4. Create `avatars` storage bucket (if missing) and enforce RLS storage policies by user folder prefix.
5. Deploy migration to non-prod, run profile CRUD + avatar upload smoke tests.
6. Deploy to prod; rollback plan is additive-safe (columns can remain even if UI is reverted).

## Open Questions

- Should avatar URLs be public bucket URLs or signed URLs with short expiry?
- Do we require image size/type enforcement server-side now, or only client-side validation?
- Should legacy `name` column be retained long-term or deprecated in a later migration?

