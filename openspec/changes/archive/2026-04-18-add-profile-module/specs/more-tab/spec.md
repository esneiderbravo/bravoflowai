## MODIFIED Requirements

### Requirement: More screen hosts the Accounts section
The system SHALL provide a More screen (route `/more`) that lists navigation items starting with a tappable **Profile** entry, followed by a **Preferences** section (Language, Theme), and a **Finance** section (Accounts).

#### Scenario: More screen renders profile entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a tappable profile hero card at the top that navigates to `/profile`

#### Scenario: More screen renders accounts entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a screen with an Accounts list item that navigates to `/more/accounts`

#### Scenario: More screen renders preferences tiles
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display Language and Theme tiles under a Preferences section label

## REMOVED Requirements

### Requirement: More tab is extensible for future settings
**Reason**: Replaced by the updated requirement below that already encodes extensibility with explicit sections.
**Migration**: The More screen now has three explicit sections (Profile, Preferences, Finance). New settings items SHALL be added as tiles within the appropriate section without structural changes.

## ADDED Requirements

### Requirement: More tab sections are extensible for future settings
The More screen layout SHALL use clearly labelled sections so future items can be added to any section without structural changes.

#### Scenario: Adding a future preferences item
- **WHEN** a new preferences item is added to the More screen
- **THEN** it SHALL appear as a new tile under the Preferences section without requiring layout modifications

#### Scenario: Adding a future finance item
- **WHEN** a new finance item is added to the More screen
- **THEN** it SHALL appear as a new tile under the Finance section without requiring layout modifications
