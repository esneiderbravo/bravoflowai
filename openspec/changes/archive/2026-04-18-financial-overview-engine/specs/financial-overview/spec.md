## ADDED Requirements

### Requirement: System computes a global total balance across all accounts
The system SHALL compute the total balance as the sum of all individual account derived balances (`initialBalance + SUM(income) - SUM(expense) + SUM(incoming transfers) - SUM(outgoing transfers)` per account).

#### Scenario: Global balance with multiple accounts
- **WHEN** the user has two or more accounts each with transactions
- **THEN** the system SHALL return a `totalBalance` equal to the arithmetic sum of each account's derived balance

#### Scenario: Global balance with no accounts
- **WHEN** the user has no accounts
- **THEN** the system SHALL return a `totalBalance` of zero

#### Scenario: Transfers do not inflate global balance
- **WHEN** a transfer exists between two accounts owned by the same user
- **THEN** the transfer amount SHALL net to zero in the global `totalBalance` (added to destination, subtracted from source)

### Requirement: System computes a monthly income, expense, and net summary
The system SHALL compute, for the current calendar month, the total income, total expenses, and net balance (`totalIncome - totalExpenses`) across all accounts.

#### Scenario: Monthly summary with income and expense transactions
- **WHEN** the current month has both income and expense transactions
- **THEN** the system SHALL return `totalIncome` as the sum of income transaction amounts, `totalExpenses` as the sum of expense transaction amounts, and `netBalance` as `totalIncome - totalExpenses`

#### Scenario: Monthly summary with no transactions in current month
- **WHEN** there are no transactions dated in the current calendar month
- **THEN** `totalIncome`, `totalExpenses`, and `netBalance` SHALL all be zero

#### Scenario: Monthly summary excludes transactions from other months
- **WHEN** transactions exist from a previous month
- **THEN** those transactions SHALL NOT be included in the current month's summary

### Requirement: System computes a category spending breakdown
The system SHALL group expense transactions by category for the current month, sum the total amount per category, and compute each category's percentage of total monthly expenses.

#### Scenario: Category breakdown with multiple categories
- **WHEN** the current month has expense transactions across multiple categories
- **THEN** the system SHALL return one `CategorySummary` per category with `totalAmount` and `percentage` (where all percentages sum to 100%)

#### Scenario: Category breakdown excludes income transactions
- **WHEN** an income transaction exists for a category in the current month
- **THEN** that transaction SHALL NOT appear in the category spending breakdown

#### Scenario: Category breakdown with no expenses
- **WHEN** there are no expense transactions in the current month
- **THEN** the system SHALL return an empty list of `CategorySummary` items

### Requirement: Financial overview providers update reactively
The system SHALL recompute the financial overview whenever accounts, transactions, or transfers change.

#### Scenario: Overview refreshes after new transaction
- **WHEN** a new transaction is created
- **THEN** `financialSummaryProvider` and `categorySummaryProvider` SHALL reflect the updated totals without requiring manual refresh

#### Scenario: Overview refreshes after account creation
- **WHEN** a new account is created
- **THEN** `totalBalance` in `financialSummaryProvider` SHALL include the new account's initial balance

### Requirement: Financial overview providers expose loading and error states
The system SHALL surface loading and error states to the presentation layer via `AsyncValue` wrappers on all financial overview providers.

#### Scenario: Loading state during data fetch
- **WHEN** the financial overview data is being fetched
- **THEN** the providers SHALL be in a loading state and the UI SHALL display appropriate loading indicators

#### Scenario: Error state on repository failure
- **WHEN** the underlying repository fails to fetch accounts or transactions
- **THEN** the providers SHALL be in an error state and the UI SHALL display an error message
