## MODIFIED Requirements

### Requirement: More screen hosts the Profile entry and Finance section
The system SHALL provide a More screen (route `/more`) that lists navigation items starting with a tappable **Profile** hero card, followed by a **Finance** section containing **Accounts** and **Categories**.

#### Scenario: More screen renders profile entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a tappable profile hero card at the top that navigates to `/profile`

#### Scenario: More screen renders accounts entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a screen with an Accounts list item under the Finance section that navigates to `/more/accounts`

#### Scenario: More screen renders categories entry
- **WHEN** the user taps the More tab
- **THEN** the system SHALL display a Categories list item under the Finance section that navigates to `/more/categories`
