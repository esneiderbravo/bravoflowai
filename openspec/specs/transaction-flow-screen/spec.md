# Transaction Flow Screen Specification

### Requirement: Flow screen displays All, Income, and Expenses filter tabs
The system SHALL display three filter tabs at the top of the Flow screen — All, Income, and Expenses — that filter the transaction list to the corresponding transaction type.

#### Scenario: All tab shows every transaction
- **WHEN** the user selects the All tab
- **THEN** the system SHALL display all transactions regardless of type, sorted by date descending

#### Scenario: Income tab filters to income transactions only
- **WHEN** the user selects the Income tab
- **THEN** the system SHALL display only transactions with type `income`, sorted by date descending

#### Scenario: Expenses tab filters to expense transactions only
- **WHEN** the user selects the Expenses tab
- **THEN** the system SHALL display only transactions with type `expense`, sorted by date descending

#### Scenario: Empty state per filter tab
- **WHEN** the active tab has no matching transactions
- **THEN** the system SHALL display a contextual empty-state message appropriate to the active tab

### Requirement: Flow screen displays a monthly summary header
The system SHALL display a summary header showing total income, total expenses, and net balance for the current calendar month, scoped to the active filter tab.

#### Scenario: All tab summary shows combined monthly totals
- **WHEN** the All tab is active
- **THEN** the header SHALL show total monthly income, total monthly expenses, and net (`income - expenses`)

#### Scenario: Income tab summary shows income total only
- **WHEN** the Income tab is active
- **THEN** the header SHALL show the total monthly income amount prominently

#### Scenario: Expenses tab summary shows expenses total only
- **WHEN** the Expenses tab is active
- **THEN** the header SHALL show the total monthly expenses amount prominently

#### Scenario: Summary updates when tab changes
- **WHEN** the user switches between tabs
- **THEN** the summary header SHALL update immediately to reflect the active tab's totals

### Requirement: Transaction list is grouped by date
The system SHALL group transactions under human-friendly date section headers.

#### Scenario: Today's transactions grouped under "Today"
- **WHEN** a transaction's date matches the current calendar day
- **THEN** it SHALL appear under a section labelled with the localized word for "Today"

#### Scenario: Yesterday's transactions grouped under "Yesterday"
- **WHEN** a transaction's date matches the previous calendar day
- **THEN** it SHALL appear under a section labelled with the localized word for "Yesterday"

#### Scenario: Older transactions grouped by formatted date
- **WHEN** a transaction's date is older than yesterday
- **THEN** it SHALL appear under a section header showing a human-readable date (e.g., `dd/MM/yyyy`)

### Requirement: Transaction tile uses Luminous Stratum design
The system SHALL render each transaction as a `GlassCard`-based tile using design system tokens (`AppColors`, `AppSpacing`, `AppTextStyles`) with no hardcoded values.

#### Scenario: Income transaction tile displays correctly
- **WHEN** a transaction with type `income` is rendered
- **THEN** the tile SHALL show the category icon (or fallback icon), description, category name and date subtitle, amount in `AppColors.success` with a `+` prefix, and a downward arrow indicator in `AppColors.success`

#### Scenario: Expense transaction tile displays correctly
- **WHEN** a transaction with type `expense` is rendered
- **THEN** the tile SHALL show the category icon (or fallback icon), description, category name and date subtitle, amount in `AppColors.error` with a `-` prefix, and an upward arrow indicator in `AppColors.error`

#### Scenario: Transaction tile category icon displays emoji if available
- **WHEN** the transaction's category has a non-null `icon` string
- **THEN** the tile SHALL display that icon value as the leading indicator

### Requirement: Add Transaction screen uses Luminous Stratum design
The system SHALL render the Add Transaction screen using design system components, replacing all raw Material widgets with Luminous Stratum equivalents.

#### Scenario: Add transaction screen renders with design system styling
- **WHEN** the user opens the Add Transaction screen
- **THEN** the screen SHALL display the type toggle, account picker, amount field, description field, and save button all styled with `AppColors`, `AppSpacing`, and `AppTextStyles` tokens — no hardcoded values

#### Scenario: Save button uses GradientButton
- **WHEN** the form is valid and the user taps Save
- **THEN** the save action SHALL be triggered via a `GradientButton` styled consistently with other primary actions in the app
