## ADDED Requirements

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

### Requirement: More screen Preferences section contains Language and Theme tiles
The system SHALL display a **Preferences** section in the More screen with tiles for Language and Theme, each navigating to `/profile`.

#### Scenario: Language tile navigates to profile
- **WHEN** an authenticated user taps the Language tile in More
- **THEN** the app SHALL navigate to `/profile`

#### Scenario: Theme tile navigates to profile
- **WHEN** an authenticated user taps the Theme tile in More
- **THEN** the app SHALL navigate to `/profile`

#### Scenario: Preferences section is labelled
- **WHEN** the More screen renders
- **THEN** a section label reading "Preferences" (or its localized equivalent) SHALL appear above the Language and Theme tiles
