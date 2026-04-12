# BravoFlow AI — Supabase Database Schema

Date: 2026-04-11

## Overview

This document defines the MVP schema used by BravoFlow AI.
All user data tables enforce Row Level Security (RLS) so users can only access
rows where `auth.uid() = user_id`.

## Tables

### `profiles`
- `id uuid primary key references auth.users(id)`
- `name text not null`
- `full_name text not null`
- `email text`
- `avatar_url text`
- `currency text not null default 'USD'`
- `created_at timestamptz default now()`

### `categories`
- `id uuid primary key default gen_random_uuid()`
- `user_id uuid references profiles(id)`
- `name text not null`
- `icon text`
- `color text`
- `is_default boolean default false`

### `transactions`
- `id uuid primary key default gen_random_uuid()`
- `user_id uuid references profiles(id) on delete cascade`
- `category_id uuid references categories(id)`
- `amount numeric(12,2) not null`
- `type text check (type in ('income','expense')) not null`
- `description text`
- `date date not null`
- `created_at timestamptz default now()`

### `budgets`
- `id uuid primary key default gen_random_uuid()`
- `user_id uuid references profiles(id) on delete cascade`
- `category_id uuid references categories(id)`
- `amount numeric(12,2) not null`
- `period text check (period in ('monthly','weekly','yearly')) not null`
- `starts_at date not null`

### `ai_insights`
- `id uuid primary key default gen_random_uuid()`
- `user_id uuid references profiles(id) on delete cascade`
- `type text not null`
- `title text not null`
- `body text not null`
- `confidence numeric(3,2) default 1.0`
- `generated_at timestamptz default now()`
- `related_transaction_ids uuid[]`

## Relationships

- `auth.users` 1:1 `profiles`
- `profiles` 1:N `transactions`
- `profiles` 1:N `budgets`
- `profiles` 1:N `ai_insights`
- `categories` 1:N `transactions`
- `categories` 1:N `budgets`

## RLS baseline policy pattern

```sql
ALTER TABLE <table_name> ENABLE ROW LEVEL SECURITY;

CREATE POLICY "own_data" ON <table_name>
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

## Seed defaults

Seed default categories per new user:
- Food
- Transport
- Bills
- Entertainment
- Health
- Salary (income)

Use `is_default = true` and copy rows on onboarding.

## Storage

### Bucket: `avatars`
- public bucket used for profile images
- object path format: `<user_id>/avatar.<ext>`

### Storage object policy pattern

```sql
-- Each user can only manage files inside their own prefix
split_part(name, '/', 1) = auth.uid()::text
```

## Requirements

### Requirement: Profiles schema supports user profile management fields
The system MUST maintain a `public.profiles` table keyed by `auth.users(id)` and MUST include fields required by profile management: `id`, `full_name`, `email`, `avatar_url`, and `created_at`.

#### Scenario: New profile row shape
- **WHEN** a profile row is created for a new authenticated user
- **THEN** the row SHALL include `id` linked to `auth.users(id)` and SHALL support `full_name`, `email`, and `avatar_url` fields

#### Scenario: Existing profiles migration
- **WHEN** migration is applied to an environment with existing profile rows
- **THEN** the system SHALL preserve existing rows and SHALL backfill compatible values required for profile rendering

### Requirement: Profiles remain protected by user ownership RLS
The system MUST enforce row-level security so users can only read or write their own profile row.

#### Scenario: Authorized profile update
- **WHEN** an authenticated user updates profile fields for their own `id`
- **THEN** the update SHALL be allowed

#### Scenario: Unauthorized profile update
- **WHEN** a user attempts to update another user's profile row
- **THEN** the operation SHALL be denied by policy

### Requirement: Avatar storage is constrained by user ownership path
The system MUST store avatar files in bucket `avatars` under `user_id/avatar.<ext>` and MUST enforce storage policies scoped to the authenticated user's folder.

#### Scenario: Valid avatar upload path
- **WHEN** an authenticated user uploads a profile avatar
- **THEN** the object SHALL be written only under the user's own folder prefix

#### Scenario: Cross-user avatar write attempt
- **WHEN** a user attempts to write an avatar object under another user's folder prefix
- **THEN** the storage policy SHALL deny the operation

