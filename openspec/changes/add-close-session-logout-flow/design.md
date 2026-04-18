## Context

The codebase already contains most session mechanics:
- `AuthRepository.signOut()` is implemented in data layer and calls Supabase auth sign-out.
- `authStateProvider` streams auth state updates.
- `GoRouter` redirect logic sends unauthenticated users to `/auth/sign-in`.

Current gap: there is no explicit close-session UI action, and `AuthNotifier.signOut()` currently discards the repository result and always emits `AsyncData(null)`. That can hide failures and produce misleading state transitions.

This change introduces a user-facing close-session flow while preserving existing architecture boundaries and auth-stream-driven navigation behavior.

## Goals / Non-Goals

**Goals:**
- Add a discoverable close-session action for authenticated users.
- Add confirmation before sign-out.
- Expose loading and failure feedback for sign-out attempts.
- Preserve router-driven redirect behavior from auth stream events.
- Ensure notifier propagates sign-out failure state for UX handling and tests.

**Non-Goals:**
- Multi-device/global session revocation.
- Token/device management dashboard.
- Server-side session analytics/auditing.

## Decisions

### Decision 1: Entry point in Profile screen (initial scope)
- **Choice:** Add close-session action to `ProfileScreen` first.
- **Rationale:** Profile is the existing account-management surface and avoids introducing global shell/menu churn in this change.
- **Alternative considered:** Add sign-out in app shell overflow/global app bar.
- **Why rejected:** Increases UI scope and requires broader navigation design decisions.

### Decision 2: Explicit confirmation before sign-out request
- **Choice:** Require user confirmation (dialog/sheet) before starting sign-out.
- **Rationale:** Prevents accidental taps and aligns with destructive-action UX expectations.
- **Alternative considered:** Immediate sign-out on button tap.
- **Why rejected:** Higher accidental logout risk.

### Decision 3: Notifier must surface failure outcomes
- **Choice:** `AuthNotifier.signOut()` will map repository failure to `AsyncError` rather than always forcing signed-out state.
- **Rationale:** Keeps app/application state truthful and enables proper error UX.
- **Alternative considered:** Ignore errors and rely only on eventual auth stream update.
- **Why rejected:** Masks failure and removes retry affordance.

### Decision 4: Redirect ownership remains in router/auth stream
- **Choice:** UI triggers sign-out intent only; navigation to auth routes continues to be performed by existing `GoRouter.redirect` + `authStateProvider`.
- **Rationale:** Single source of truth for authenticated routing and fewer race conditions.
- **Alternative considered:** Imperative `context.go('/auth/sign-in')` in logout callback.
- **Why rejected:** Duplicates navigation responsibility and can diverge from auth truth.

### Decision 5: Localized close-session copy
- **Choice:** Add localization keys for action label, confirmation title/body/actions, and sign-out failure message.
- **Rationale:** Maintains i18n coverage and avoids hardcoded user-facing strings.
- **Alternative considered:** Inline literals in profile screen.
- **Why rejected:** Violates localization standards.

## Risks / Trade-offs

- **[Risk] Sign-out fails due to network/auth API transient errors** -> **Mitigation:** Keep session active, show localized error, allow retry.
- **[Risk] Duplicate sign-out requests from rapid taps** -> **Mitigation:** Disable action while sign-out is in-flight.
- **[Trade-off] Profile-only placement may reduce discoverability** -> **Mitigation:** Track follow-up change for global entry point if product needs it.
- **[Trade-off] Confirmation adds one interaction step** -> **Mitigation:** Keep prompt concise and only for explicit close-session action.

## Test Strategy

1. Unit test `AuthNotifier.signOut()` success and failure transitions.
2. Widget test Profile close-session action rendering and confirmation behavior.
3. Widget/integration test: confirmed sign-out triggers auth-state change and redirect to `/auth/sign-in`.
4. Regression check: canceling confirmation keeps user on current route with unchanged session.

## Open Questions

- Do we want an additional close-session action in a global shell/menu in the same release?
- Should failure UX expose raw backend message or normalized friendly message only?
- Is biometric/device-auth confirmation required before close-session for this app segment?

