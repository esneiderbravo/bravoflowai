## 1. Database and Storage Foundation

- [x] 1.1 Create migration to extend `public.profiles` with `full_name`, `email`, and `avatar_url`
- [x] 1.2 Add migration backfill to populate `full_name` from legacy `name` where needed
- [x] 1.3 Update signup profile trigger to persist `full_name` and `email` metadata for new users
- [x] 1.4 Add storage setup SQL/policies for `avatars` bucket with user folder ownership rules
- [x] 1.5 Validate RLS and storage policies with manual SQL checks (own row/file allowed, cross-user denied)

## 2. Profile Domain Contracts

- [x] 2.1 Create `features/profile/domain/entities/profile.dart` immutable entity
- [x] 2.2 Create `features/profile/domain/repositories/profile_repository.dart` interface for fetch/update/avatar upload
- [x] 2.3 Define domain-level validation rules/messages for profile form inputs

## 3. Profile Data Layer (Supabase)

- [x] 3.1 Create profile DTO mapping file in `features/profile/data/dtos/`
- [x] 3.2 Implement `ProfileRepositoryImpl` for fetch/update profile operations
- [x] 3.3 Implement avatar upload path `avatars/{user_id}/avatar.<ext>` and URL persistence
- [x] 3.4 Add robust failure mapping for auth/postgrest/storage errors

## 4. Profile Application Layer (Riverpod)

- [x] 4.1 Create profile providers file wiring repository dependency injection
- [x] 4.2 Implement profile controller/notifier for load, edit, save, and error states
- [x] 4.3 Add controller flow for avatar replacement upload before profile save
- [x] 4.4 Ensure save flow prevents duplicate submissions during loading

## 5. Profile Presentation Layer

- [x] 5.1 Create `ProfileScreen` under `features/profile/presentation/screens/`
- [x] 5.2 Build profile form UI: editable avatar, editable full name, read-only email
- [x] 5.3 Integrate image picker flow through controller events (no direct Supabase in UI)
- [x] 5.4 Apply design system tokens (`AppColors`, text styles, spacing) with no hardcoded UI values
- [x] 5.5 Add loading/error/success feedback states for fetch and save operations

## 6. App Integration and Routing

- [x] 6.1 Add profile route entry in `core/router/app_router.dart`
- [x] 6.2 Add navigation entry point from existing app shell/dashboard to profile screen
- [x] 6.3 Verify authenticated-only access behavior for profile route

## 7. Quality Gates and Documentation

- [x] 7.1 Add/adjust unit tests for DTO mapping and profile repository behaviors
- [x] 7.2 Add application-layer tests for profile notifier state transitions
- [x] 7.3 Add widget test for profile screen render + validation + save trigger
- [x] 7.4 Run `dart format .`, `dart fix --apply`, `flutter analyze`, and `flutter test`
- [x] 7.5 Update `openspec/specs/database/schema.md` to reflect final profiles/avatar schema decisions

