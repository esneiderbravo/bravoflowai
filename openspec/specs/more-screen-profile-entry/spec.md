# More Screen Profile Entry Specification

### Requirement: Profile hero card in More is tappable and navigates to profile
The system SHALL make the profile hero `GlassCard` in the More screen a tappable element that navigates the user to the `/profile` route.

#### Scenario: User taps profile card in More
- **WHEN** an authenticated user taps the profile hero card at the top of the More screen
- **THEN** the app SHALL navigate to `/profile` keeping the bottom navigation shell visible

#### Scenario: Profile card displays chevron affordance
- **WHEN** the More screen renders the profile hero card
- **THEN** a trailing chevron icon SHALL be visible to indicate the card is interactive

### Requirement: Sign-out action is removed from the More screen
The system SHALL NOT display a close-session button directly on the More screen; the close-session action SHALL only be accessible through the Profile screen.

#### Scenario: More screen has no sign-out button
- **WHEN** an authenticated user views the More screen
- **THEN** no sign-out or close-session button SHALL be visible on the More screen
