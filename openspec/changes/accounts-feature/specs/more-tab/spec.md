## ADDED Requirements

### Requirement: More tab replaces Budget tab in bottom navigation
The system SHALL replace the Budget bottom-navigation tab with a **More** tab using a `more_horiz` (or equivalent) icon. The Budget screen SHALL remain in the codebase but SHALL NOT be reachable from the bottom navigation.

#### Scenario: More tab visible in bottom nav
- **WHEN** the user is on any main screen
- **THEN** the bottom navigation SHALL show four tabs: Home, Transactions, AI, More

#### Scenario: Budget tab no longer visible
- **WHEN** the user views the bottom navigation
- **THEN** the Budget tab SHALL NOT appear

### Requirement: More screen hosts the Accounts section
The system SHALL provide a More screen (route `/more`) that lists navigation items, starting with **Accounts**.

#### Scenario: More screen renders accounts entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a screen with an Accounts list item that navigates to `/more/accounts`

### Requirement: More tab is extensible for future settings
The More screen layout SHALL be designed as a settings-style list so future items (e.g., notifications, preferences) can be added without structural changes.

#### Scenario: Adding a future settings item
- **WHEN** a new settings item is added to the More screen
- **THEN** it SHALL appear as a new list tile below existing items without layout modifications
