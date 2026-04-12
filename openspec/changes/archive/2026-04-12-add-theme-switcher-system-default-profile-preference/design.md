## Context

The app currently hardcodes `ThemeMode.dark` in `lib/main.dart`, so users cannot choose light mode or follow device theme. Profile preferences already persist language in Supabase and are loaded through Riverpod controllers, which provides an existing pattern for bootstrapping user-level UI settings. This change must preserve a responsive startup experience, avoid visual flicker after login, and keep profile save behavior as the single commit point for preference changes.

## Goals / Non-Goals

**Goals:**
- Add a persisted theme preference with values `system`, `dark`, and `light`.
- Default to `system` for users without a saved preference.
- Load and apply preference during app bootstrap/login lifecycle.
- Allow user selection from profile/settings and persist on save.
- Keep localization-driven labels/messages for theme options and save feedback.

**Non-Goals:**
- Introducing custom theme palettes beyond existing light/dark theme definitions.
- Supporting scheduled/automatic theme rules beyond platform `system` mode.
- Redesigning profile UI information architecture.

## Decisions

1. **Theme source of truth is an app-level Riverpod controller**
   - Add `AppThemeController` under `lib/core/theme/` as a `Notifier<ThemeMode>` (or equivalent state holder) that exposes:
     - `bootstrap()` from current session profile
     - `setThemeModeCode(String)` for persisted value mapping
     - `setThemeMode(ThemeMode)` for internal updates
   - **Rationale:** Mirrors current locale-controller pattern and keeps `MaterialApp` wiring centralized.
   - **Alternative considered:** Reading theme directly in each feature from profile state; rejected because it couples routing/UI shell to profile screen lifecycle.

2. **Persist enum-like string in `profiles.theme_mode`**
   - Store one of `system`, `dark`, `light` in Supabase `profiles` with default `system`.
   - Domain entity and DTOs normalize unknown values to `system`.
   - **Rationale:** Explicit, portable, query-friendly, and easy to evolve.
   - **Alternative considered:** nullable column where null means system; rejected due to ambiguous semantics and more conditional logic.

3. **Apply theme only when profile save succeeds**
   - Profile dropdown updates local draft state only.
   - Global `AppThemeController` changes only after successful `updateProfile` response.
   - **Rationale:** Matches language preference behavior and avoids inconsistent UI if save fails.
   - **Alternative considered:** optimistic immediate theme switch on dropdown change; rejected due to mismatch with persisted source and rollback complexity.

4. **`MaterialApp` uses both light and dark themes with `themeMode` binding**
   - Keep existing dark theme config and add/keep light theme config from `AppTheme`.
   - Bind `themeMode` to provider state.
   - **Rationale:** Native Flutter support gives predictable runtime switching and system-mode behavior.

5. **Theme-aware UI parity is enforced beyond profile screen**
   - Replace hardcoded `AppColors.backgroundDark`, `AppColors.cardDark`, and fixed dark text usage in shell and feature screens with `Theme.of(context).colorScheme` / `Theme.of(context).textTheme` driven styles.
   - Prioritize migration order: `AppShell` -> core feature screens -> auth screens -> shared widgets.
   - **Rationale:** Without this pass, `ThemeMode.light` applies only partially and causes inconsistent UX.
   - **Alternative considered:** keep hardcoded dark values and only tune profile; rejected because it violates expected global theme behavior.

## Risks / Trade-offs

- **[Risk] Unknown/legacy `theme_mode` values from database** -> **Mitigation:** sanitize to `system` in DTO/entity mapper and controller.
- **[Risk] Brief theme flash before bootstrap completes** -> **Mitigation:** initialize controller with `ThemeMode.system` and bootstrap as early as app root, similar to locale bootstrap.
- **[Risk] Profile save feedback rendered in mismatched theme/locale timing** -> **Mitigation:** apply controller updates only on successful save and keep post-frame snackbar display strategy where needed.
- **[Trade-off] Profile screen now controls another cross-cutting preference** -> **Mitigation:** keep profile controller as orchestrator while centralizing app-wide effect in dedicated theme controller.
- **[Risk] Broad visual regressions while replacing hardcoded tokens** -> **Mitigation:** stage rollout per module and verify each screen under both light and dark modes.

## Migration Plan

1. Add Supabase migration to append `theme_mode text not null default 'system'` to `public.profiles`.
2. Deploy migration before releasing client update.
3. Release app update with DTO/entity/controller support for theme mode.
4. Verify existing users receive `system` default and can update preference.
5. Rollback strategy: app remains functional by falling back to `ThemeMode.system`; if needed, stop using column in client while keeping backward-compatible schema.

## Verification and Rollout Notes

- `flutter analyze` passes with no issues.
- `flutter test` passes across focused parity and persistence suites, including new shell theme tests and source guards for dark-only tokens.
- Manual smoke validation (`login -> change theme in profile -> save -> restart app -> confirm persistence`) is still pending execution against a live Supabase environment.
- Light-mode parity validation across all main routes is pending after hardcoded dark style migration (`dashboard`, `transactions`, `ai`, `budget`, `auth`).
- Rollback remains low risk because client mapping falls back to `system` for unknown/missing values and profile update payload sanitizes values.

## Open Questions

- Should profile endpoint/update payload enforce lowercase only at API boundary or rely entirely on client normalization?
- Do we want analytics events for theme preference changes in this release or defer to a follow-up change?
