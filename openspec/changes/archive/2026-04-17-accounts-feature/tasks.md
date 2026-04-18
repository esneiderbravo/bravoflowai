## 1. Database Migrations

- [x] 1.1 Write migration: create `public.accounts` table with all fields, `type` check constraint, and `own_accounts` RLS policy
- [x] 1.2 Write migration: insert default `Cash` account (`is_default = true`) for every existing profile row
- [x] 1.3 Write migration: add `account_id` column (nullable) to `public.transactions`
- [x] 1.4 Write migration: backfill `account_id` on existing transactions to each user's default account
- [x] 1.5 Write migration: make `account_id` NOT NULL on `public.transactions`
- [x] 1.6 Write migration: create `public.transfers` table with `from_account_id`, `to_account_id` FKs and `own_transfers` RLS policy
- [x] 1.7 Update profile-creation trigger to also insert a default `Cash` account for every new user

## 2. Domain Layer

- [x] 2.1 Create `lib/domain/entities/account.dart` — `Account` entity with `id`, `userId`, `name`, `type` (enum), `initialBalance` (Money), `currency`, `color`, `icon`, `isDefault`, `createdAt`
- [x] 2.2 Create `lib/domain/entities/transfer.dart` — `Transfer` entity with `id`, `userId`, `fromAccountId`, `toAccountId`, `amount` (Money), `date`, `note`, `createdAt`
- [x] 2.3 Add `accountId` field to `lib/domain/entities/transaction.dart`
- [x] 2.4 Create `lib/domain/repositories/account_repository.dart` — abstract interface with `getAll`, `getById`, `create`, `update`, `delete`
- [x] 2.5 Create `lib/domain/repositories/transfer_repository.dart` — abstract interface with `getByAccount`, `create`, `delete`

## 3. Data Layer

- [x] 3.1 Create `lib/features/accounts/data/dtos/account_dto.dart` — `AccountDto` with `fromJson`, `toJson`, `fromDomain`, `toDomain`
- [x] 3.2 Create `lib/features/accounts/data/dtos/transfer_dto.dart` — `TransferDto` with `fromJson`, `toJson`, `fromDomain`, `toDomain`
- [x] 3.3 Update `TransactionDto` to include `accountId` field in serialization and deserialization
- [x] 3.4 Create `lib/features/accounts/data/account_repository_impl.dart` — Supabase implementation of `AccountRepository`
- [x] 3.5 Create `lib/features/accounts/data/transfer_repository_impl.dart` — Supabase implementation of `TransferRepository`

## 4. Application Layer (Providers)

- [x] 4.1 Create `lib/features/accounts/application/account_providers.dart` — Riverpod providers for `AccountRepository`, account list notifier with `getAll`, `create`, `update`, `delete`
- [x] 4.2 Create `lib/features/accounts/application/account_balance_provider.dart` — provider that computes derived balance per account from transactions + transfers
- [x] 4.3 Create `lib/features/accounts/application/transfer_providers.dart` — Riverpod providers for `TransferRepository`, transfer notifier with `getByAccount`, `create`, `delete`
- [x] 4.4 Update `TransactionNotifier` / transaction providers to include `accountId` in create/update calls
- [x] 4.5 Register `AccountRepository` and `TransferRepository` in `lib/core/services/app_providers.dart`

## 5. Presentation — Accounts Feature

- [x] 5.1 Create `lib/features/accounts/presentation/screens/accounts_screen.dart` — list of accounts with name, type icon, derived balance; empty state; FAB to add account
- [x] 5.2 Create `lib/features/accounts/presentation/screens/add_edit_account_screen.dart` — form for creating/editing account (name, type, initialBalance, color/icon)
- [x] 5.3 Create `lib/features/accounts/presentation/screens/account_detail_screen.dart` — account header with balance, list of transactions and transfers for that account
- [x] 5.4 Create `lib/features/accounts/presentation/widgets/account_card.dart` — card widget showing name, type icon, balance; used in both accounts screen and dashboard widget
- [x] 5.5 Add delete confirmation dialog with guard: show error if account has transactions or transfers

## 6. Presentation — Dashboard Widget

- [x] 6.1 Create `lib/features/accounts/presentation/widgets/accounts_scroll_widget.dart` — horizontally scrollable row of `AccountCard` widgets with an empty-state prompt card
- [x] 6.2 Update `DashboardScreen` to include `AccountsScrollWidget` at the top, above the recent transactions section
- [x] 6.3 Ensure Dashboard re-fetches account balances when returning from account/transaction screens (use `ref.invalidate` or `ref.refresh` on navigation pop)

## 7. Presentation — Transfers UI

- [x] 7.1 Create `lib/features/accounts/presentation/screens/add_transfer_screen.dart` — form with source account, destination account (different from source), amount, date, optional note; insufficient balance warning
- [x] 7.2 Add transfer entry point from account detail screen (e.g., action button or FAB option)

## 8. Presentation — More Tab

- [x] 8.1 Create `lib/features/more/presentation/screens/more_screen.dart` — settings-style list screen with an Accounts entry item
- [x] 8.2 Update `AppShell` bottom nav: replace Budget tab with More tab (`more_horiz` icon, `/more` route)
- [x] 8.3 Add i18n keys: `tab_more`, `more_accounts`, `accounts_title`, `add_account`, `edit_account`, `delete_account`, `add_transfer`, `account_type_checking`, `account_type_savings`, `account_type_cash`, `account_type_investment`, `account_type_other`, `initial_balance`, `account_balance`, `transfer_from`, `transfer_to`, `transfer_note`

## 9. Router

- [x] 9.1 Add routes to `app_router.dart`: `/more` (MoreScreen), `/more/accounts` (AccountsScreen), `/more/accounts/add` (AddEditAccountScreen), `/more/accounts/:id/edit` (AddEditAccountScreen), `/more/accounts/:id` (AccountDetailScreen), `/more/accounts/transfer/add` (AddTransferScreen)
- [x] 9.2 Remove `/budget` from shell routes (keep BudgetScreen file, just unlink from router and nav)

## 10. Testing

- [x] 10.1 Write unit tests for `AccountRepositoryImpl` (mock Supabase client): `getAll`, `create`, `update`, `delete`
- [x] 10.2 Write unit tests for `TransferRepositoryImpl`: `getByAccount`, `create`, `delete`
- [x] 10.3 Write unit tests for `account_balance_provider`: verify derived balance formula with income, expense, and transfer combinations
- [x] 10.4 Write widget tests for `AccountCard` and `AccountsScrollWidget`
- [x] 10.5 Write widget test for `AddEditAccountScreen`: validation errors, successful submission
