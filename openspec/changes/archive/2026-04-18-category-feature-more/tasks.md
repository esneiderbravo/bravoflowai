## 1. Domain & Data Layer

- [x] 1.1 Create `lib/features/categories/domain/repositories/category_repository.dart` with `CategoryRepository` abstract interface (fetchAll, add, update, delete)
- [x] 1.2 Create `lib/features/categories/data/dtos/category_dto.dart` with `CategoryDto` (fromJson/toJson, toDomain)
- [x] 1.3 Create `lib/features/categories/data/repositories/category_repository_impl.dart` backed by Supabase `public.categories` table
- [x] 1.4 Register `categoryRepositoryProvider` in `lib/features/categories/application/category_providers.dart`

## 2. Application Layer

- [x] 2.1 Create `CategoryNotifier extends AsyncNotifier<List<Category>>` in `lib/features/categories/application/category_notifier.dart` with `add`, `update`, `delete` methods
- [x] 2.2 Expose `categoryNotifierProvider` in `category_providers.dart`

## 3. Presentation — Categories Screen

- [x] 3.1 Create `lib/features/categories/presentation/screens/categories_screen.dart` showing Default and Custom sections using `GlassCard` + `_SettingsTile`-style rows
- [x] 3.2 Create `lib/features/categories/presentation/screens/add_edit_category_screen.dart` with name (required), icon, and colour fields
- [x] 3.3 Wire up edit action (tap row → `/more/categories/:id/edit`) only for custom categories
- [x] 3.4 Wire up delete action with confirmation dialog only for custom categories

## 4. Router

- [x] 4.1 Add route `/more/categories` → `CategoriesScreen` in `lib/core/router/app_router.dart`
- [x] 4.2 Add route `/more/categories/add` → `AddEditCategoryScreen`
- [x] 4.3 Add route `/more/categories/:id/edit` → `AddEditCategoryScreen(categoryId: ...)`

## 5. More Screen

- [x] 5.1 Add a `Categories` tile under the Finance section in `lib/features/more/presentation/screens/more_screen.dart` navigating to `/more/categories`
- [x] 5.2 Add `more_categories` localisation key to `lib/core/i18n/app_en.arb` and `app_es.arb` and regenerate

## 6. Transaction Category Picker

- [x] 6.1 Create `lib/features/categories/presentation/widgets/category_picker_sheet.dart` — a `DraggableScrollableSheet` listing categories grouped into Default / Custom sections
- [x] 6.2 Replace the placeholder `_placeholderCategory` in `lib/features/transactions/presentation/screens/add_transaction_screen.dart` with a tappable category field that opens the picker sheet
- [x] 6.3 Add category field validation (required) to the Add Transaction form

## 7. Verification

- [x] 7.1 Run `flutter analyze` and resolve any warnings or errors
- [x] 7.2 Smoke-test: navigate More → Categories, create a custom category, edit it, delete it
- [x] 7.3 Smoke-test: add a transaction and verify the category picker shows all categories and the selected category is saved
