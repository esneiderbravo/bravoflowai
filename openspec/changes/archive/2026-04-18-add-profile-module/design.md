## Context

The More screen (`lib/features/more/presentation/screens/more_screen.dart`) currently displays a static profile hero `GlassCard` with user name and email but no tap action. It also contains a `GhostButton` for sign-out that duplicates the close-session action already present in `ProfileScreen`. Language and theme preferences exist in the Profile screen but are unreachable from the app shell navigation.

The `ProfileScreen` at `/profile` is registered in `app_router.dart` inside the `ShellRoute` but has no entry point — no bottom-nav tab or menu item links to it.

## Goals / Non-Goals

**Goals:**
- Make the profile hero card in More tappable → navigates to `/profile`
- Remove the redundant sign-out `GhostButton` from More
- Add Language and Theme settings tiles to More under a new **Preferences** section that navigate to `/profile`
- Restructure More into three clear sections: Profile entry, Preferences, Finance
- Keep change scoped to the More screen presentation layer only

**Non-Goals:**
- Creating separate `/more/language` or `/more/theme` deep-link routes (out of scope; full settings live in ProfileScreen)
- Modifying ProfileScreen, auth flow, or Supabase data layer
- Adding a "Profile" tab to the bottom navigation bar

## Decisions

### 1. Profile hero tap navigates to `/profile`
Wrap the existing `GlassCard` profile hero in a `GestureDetector` (or make `_SettingsTile` generic enough) and call `context.go('/profile')` on tap. Alternative considered: push a new route with `context.push('/profile')` — rejected because `/profile` is already inside the `ShellRoute`, so `go` keeps the shell and bottom nav visible, which is the desired UX.

### 2. Language and Theme tiles navigate to `/profile`
Both tiles link to `/profile` rather than introducing new sub-routes. The Profile screen already contains inline dropdowns for language and theme. Alternative: dedicated `/more/language` and `/more/theme` screens — deferred as future work since ProfileScreen already bundles these settings with no need to split them today.

### 3. Sign-out removed from More
The `GhostButton` for sign-out in More is removed. The only close-session control will be the `OutlinedButton.icon` already present in `ProfileScreen`. This eliminates duplication and aligns with the user's explicit request.

### 4. More screen sections
Sections after this change:
- *(implicit)* Profile hero tile at the top → tappable
- **Preferences** section: Language tile, Theme tile
- **Finance** section: Accounts tile (unchanged)

## Risks / Trade-offs

- **Risk**: Users who relied on sign-out being one tap away in More will now need to enter the profile screen first → **Mitigation**: Profile is now a first-class entry in More, so the extra tap is acceptable and consistent with iOS/Android conventions.
- **Risk**: Both Language and Theme tiles navigate to the full ProfileScreen rather than a focused settings page → **Mitigation**: Deferred until a dedicated settings page becomes necessary; noted in Open Questions.

## Open Questions

- Should Language and Theme eventually get their own dedicated sub-screens (`/more/language`, `/more/theme`) for quicker access? Deferred to future iteration.
- Should the profile tile show a chevron or a different affordance to indicate it's tappable?
