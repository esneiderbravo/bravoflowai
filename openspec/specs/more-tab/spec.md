# More Tab Specification

### Requirement: More tab replaces Budget tab in bottom navigation
The system SHALL replace the Budget bottom-navigation tab with a **More** tab using a `more_horiz` (or equivalent) icon. The Budget screen SHALL remain in the codebase but SHALL NOT be reachable from the bottom navigation.

#### Scenario: More tab visible in bottom nav
- **WHEN** the user is on any main screen
- **THEN** the bottom navigation SHALL show four tabs: Home, Transactions, AI, More

#### Scenario: Budget tab no longer visible
- **WHEN** the user views the bottom navigation
- **THEN** the Budget tab SHALL NOT appear

### Requirement: More screen hosts the Profile entry and Finance section
The system SHALL provide a More screen (route `/more`) that lists navigation items starting with a tappable **Profile** hero card, followed by a **Finance** section containing **Accounts**.

#### Scenario: More screen renders profile entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a tappable profile hero card at the top that navigates to `/profile`

#### Scenario: More screen renders accounts entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a screen with an Accounts list item under the Finance section that navigates to `/more/accounts`

### Requirement: More tab sections are extensible for future settings
The More screen layout SHALL use clearly labelled sections so future items can be added to any section without structural changes.

#### Scenario: Adding a future profile item
- **WHEN** a new profile-related item is added to the More screen
- **THEN** it SHALL appear within the Profile section without requiring layout modifications

#### Scenario: Adding a future finance item
- **WHEN** a new finance item is added to the More screen
- **THEN** it SHALL appear as a new tile under the Finance section without requiring layout modifications
