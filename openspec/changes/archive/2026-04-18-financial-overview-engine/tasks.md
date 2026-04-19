## 1. Feature Scaffolding

- [x] 1.1 Create directory structure `lib/features/financial_overview/{domain,data,application,presentation}/` with all necessary subdirectories
- [x] 1.2 Create `lib/features/financial_overview/domain/entities/financial_summary.dart` with `FinancialSummary` entity (`totalBalance`, `totalIncome`, `totalExpenses`, `netBalance` as `Money`)
- [x] 1.3 Create `lib/features/financial_overview/domain/entities/category_summary.dart` with `CategorySummary` entity (`categoryId`, `categoryName`, `totalAmount` as `Money`, `percentage` as `double`)
- [x] 1.4 Create `lib/features/financial_overview/domain/repositories/financial_overview_repository.dart` defining the `FinancialOverviewRepository` abstract interface with methods `getFinancialSummary()`, `getMonthlySummary(DateTime month)`, and `getCategorySummaries(DateTime month)`

## 2. Data Layer

- [x] 2.1 Create `lib/features/financial_overview/data/repositories/financial_overview_repository_impl.dart`
- [x] 2.2 Implement `getFinancialSummary()`
- [x] 2.3 Implement `getMonthlySummary(DateTime month)`
- [x] 2.4 Implement `getCategorySummaries(DateTime month)`
- [x] 2.5 Ensure all repository methods wrap results in `Either<Failure, T>`

## 3. Application Layer (Riverpod)

- [x] 3.1 Create `lib/features/financial_overview/application/financial_overview_providers.dart`
- [x] 3.2 Add `financialOverviewRepositoryProvider`
- [x] 3.3 Create `FinancialOverviewNotifier` (`AsyncNotifier<FinancialSummary>`) exposed as `financialSummaryProvider`
- [x] 3.4 Create `categorySummaryProvider` as `FutureProvider<List<CategorySummary>>`
- [x] 3.5 Providers watch `accountNotifierProvider` and `transactionNotifierProvider`

## 4. Presentation Layer — Dashboard Widgets

- [x] 4.1 Create `total_balance_card.dart`
- [x] 4.2 Create `monthly_summary_card.dart`
- [x] 4.3 Create `category_breakdown_card.dart`
- [x] 4.4 Create `financial_overview_section.dart`

## 5. Dashboard Screen Integration

- [x] 5.1 Import and place `FinancialOverviewSection` in the Dashboard screen above the existing accounts scroll widget
- [x] 5.2 Verify the Dashboard screen still renders correctly with zero accounts and zero transactions (empty-state paths)
- [x] 5.3 Dashboard pull-to-refresh invalidates `financialSummaryProvider` and `categorySummaryProvider`; providers auto-update via `ref.watch` on account/transaction notifiers

## 6. Validation

- [x] 6.1 Run `flutter analyze` and fix any lint errors or warnings introduced by the new files
- [x] 6.2 Manually verify on a device/simulator: total balance matches sum of individual account balances; monthly summary figures match manually counted transactions; category breakdown percentages sum to 100%; providers update after adding a transaction and navigating back to Dashboard
