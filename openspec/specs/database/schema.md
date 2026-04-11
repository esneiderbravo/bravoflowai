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

