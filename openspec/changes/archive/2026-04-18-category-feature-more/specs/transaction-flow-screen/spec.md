## MODIFIED Requirements

### Requirement: Add Transaction screen requires a category selection
The system SHALL require the user to select a category when adding a transaction. The category field SHALL present a modal bottom sheet listing all available categories (default and custom) grouped by section. The previously hardcoded placeholder category SHALL be removed.

#### Scenario: Category picker opens on tap
- **WHEN** the user taps the category field in the Add Transaction form
- **THEN** the system SHALL open a modal bottom sheet listing all available categories grouped into Default and Custom sections

#### Scenario: Category selected
- **WHEN** the user selects a category from the picker
- **THEN** the system SHALL close the bottom sheet and display the selected category name in the category field

#### Scenario: Transaction submitted with selected category
- **WHEN** the user submits the Add Transaction form with a valid category selected
- **THEN** the transaction SHALL be persisted with the correct category_id

#### Scenario: Category field validation
- **WHEN** the user submits the Add Transaction form without selecting a category
- **THEN** the system SHALL display a validation error on the category field and SHALL NOT submit the form
