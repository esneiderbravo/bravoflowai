## Why

The More screen currently contains a static profile hero card with no navigation, a sign-out button that duplicates what the Profile screen already provides, and no access to language or theme settings. Users have no discoverable path from the app shell to their full profile, language switcher, or theme preferences.

## What Changes

- The profile hero card in the More screen becomes a tappable tile that navigates to `/profile`
- The sign-out (`GhostButton`) is removed from the More screen (close-session already lives in ProfileScreen)
- New settings tiles are added to More for **Language** and **Theme** — each tapping into the Profile screen (anchored to the relevant section or as standalone routes)
- The More screen layout is reorganised into clearly labelled sections: **Profile**, **Preferences** (Language, Theme), **Finance** (Accounts), with extensibility for future items
- Profile screen entry point is surfaced through the More tab instead of being a hidden route

## Capabilities

### New Capabilities
- `more-screen-profile-entry`: Tappable profile hero in More that navigates to `/profile`; close-session button removed from More; More screen restructured with Profile, Preferences, and Finance sections

### Modified Capabilities
- `more-tab`: More screen gains a tappable profile entry, Preferences section (Language, Theme tiles), removes the inline sign-out action, and retains the Finance section

## Impact

- `lib/features/more/presentation/screens/more_screen.dart` — layout restructured; sign-out removed; profile hero made tappable; Language and Theme tiles added
- `lib/core/router/app_router.dart` — `/more/language` and `/more/theme` routes may be added if deep-link entry points are needed; or navigation goes directly to `/profile`
- No changes to ProfileScreen, auth flow, or data layer
