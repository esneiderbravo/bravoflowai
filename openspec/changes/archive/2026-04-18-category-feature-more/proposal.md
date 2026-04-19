## Why

Transactions currently use a hardcoded placeholder category ("General"), making it impossible for users to organise their spending by category. The database schema and `Category` entity are already in place — this change wires up the missing UI and data layer so users can manage and assign categories.

## What Changes

- Add a **Categories** entry under the Finance section in the More screen navigating to `/more/categories`
- Introduce a **category management feature** (list, add, edit, delete custom categories)
- Replace the placeholder category in the Add Transaction flow with a real **category picker**
- Add routes `/more/categories`, `/more/categories/add`, `/more/categories/:id/edit`
- Add localisation keys for category-related labels

## Capabilities

### New Capabilities

- `category-management`: Full CRUD UI for user categories — list screen, add/edit form, delete action, accessible from the More screen under Finance. Default (seeded) categories are visible but not deletable.

### Modified Capabilities

- `more-tab`: Add a "Categories" tile under the Finance section linking to `/more/categories`.
- `transaction-flow-screen`: Replace the placeholder category with a real category picker in the Add Transaction screen.

## Impact

- New feature directory: `lib/features/categories/`
- Router: new category routes added under the shell
- More screen: new tile in Finance section
- Add Transaction screen: category picker replaces placeholder
- Localisation: new keys in `app_en.arb` and `app_es.arb`
- No database migrations needed (table and RLS policies already exist)
