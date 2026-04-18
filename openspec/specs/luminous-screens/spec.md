# Spec: luminous-screens

## Overview
All 7 redesigned app screens, pixel-faithful to the HTML references in `stitch_bravoflow_ai_finance_app/`. Each screen spec references the corresponding `screen_N_*/screen.png` and `code.html` as the source of truth.

---

## Screen 0b — Splash Screen

**Reference:** `screen_0b_splash_screen/`  
**Implementation:** `flutter_native_splash` package (background + logo only; no Flutter route needed)

**Spec:**
- Background: `#090d20` (the void)
- Center logo: BravoFlow AI wordmark with gradient clip (`primaryFixed` → `secondary`)
- No loading indicator on native splash

**pubspec.yaml additions:**
```yaml
dependencies:
  flutter_native_splash: ^2.x

flutter_native_splash:
  color: "#090d20"
  image: assets/images/splash_logo.png
  android_12:
    color: "#090d20"
    image: assets/images/splash_logo.png
```

**Acceptance criteria:**
- [ ] Native splash background matches `#090d20`
- [ ] Logo centered, no white flash on launch

---

## Screen 1 — Dashboard

**Reference:** `screen_1_dashboard/`  
**File:** `lib/features/dashboard/dashboard_screen.dart`

**Sections:**
1. **TopAppBar** — glassmorphism, sticky; profile avatar (circle, 40px, ring `primaryFixed/20`); "BravoFlow AI" gradient text; notification bell in `primaryFixed`
2. **Greeting** — `onSurfaceVariant` sub-label ("Good evening, Alex 👋"), `headlineMedium` hero text ("Your wealth at a glance.")
3. **Accounts Widget** — horizontal scroll, no scrollbar; each card: `min-width 280`, `GlassCard` with gradient `surfaceContainerHigh→surfaceContainer`, colored left border (4px: primary/secondary/tertiary per account type); balance in `headlineSmall` extrabold; "View All" label in `primaryFixed` uppercase
4. **AI Insights Section** — `AnimatedAuraCard`; gradient avatar circle (primary→secondary) with `auto_awesome` icon; insight text; 3 pill action buttons (`surfaceContainerHighest` background); "BETA" badge (`secondaryContainer` bg, `secondaryFixed` text)
5. **Quick Actions Grid** — 2×2; each tile: `surfaceContainerLow` bg, `JeweledIcon`, bold title, muted subtitle; tiles: Add Transaction, Budget, Reports, AI Chat
6. **Bottom Nav** — 4-tab `AppShell`

---

## Screen 2 — Accounts List

**Reference:** `screen_2_accounts_list/`  
**File:** `lib/features/accounts/presentation/screens/accounts_screen.dart`

**Sections:**
1. **TopAppBar** — back arrow (`primaryFixed`); gradient "Accounts" title; search icon + mini avatar
2. **Net Worth Summary** — editorial style: `labelLarge` "TOTAL BALANCE" (`onSurfaceVariant`), 5xl extrabold balance with tight tracking, `+2.4%` in `primary`
3. **Account Cards** — `GlassCard` with ghost border; left: `JeweledIcon` (account type icon, `surfaceContainerHighest`); center: account name + masked number; right: balance + "Available" micro-label in `primaryFixed` uppercase; chevron right
4. **FAB / Add Account** — gradient button bottom-right

---

## Screen 3 — Account Detail

**Reference:** `screen_3_account_detail/`  
**File:** `lib/features/accounts/presentation/screens/account_detail_screen.dart` (new, or existing to update)

**Sections:**
1. **TopAppBar** — back; account name as gradient title; edit icon
2. **Balance Hero** — `GlassCard` full-width; account type label, large balance, masked account number, bank name
3. **Transaction History** — section header; transaction tiles (no `Divider`; 16px vertical spacing between items); `JeweledIcon` per category; amount colored green (credit) or `onSurface` (debit)
4. **Transfer CTA** — `GradientButton` "Add Transfer"

---

## Screen 4 — Add / Edit Account

**Reference:** `screen_4_add_edit_account/`  
**File:** `lib/features/accounts/presentation/screens/add_edit_account_screen.dart`

**Sections:**
1. **TopAppBar** — back; "Add Account" or "Edit Account" title (gradient)
2. **Form** — filled inputs (`surfaceContainerHigh`, `radiusMd`); focus state: ghost border transitions to full `primaryFixed`; fields: Name, Type (dropdown), Bank, Balance, Account Number (masked)
3. **Save CTA** — `GradientButton` full-width at bottom

---

## Screen 5 — Add Transfer

**Reference:** `screen_5_add_transfer/`  
**File:** `lib/features/accounts/presentation/screens/add_transfer_screen.dart`

**Sections:**
1. **TopAppBar** — back; "New Transfer" gradient title
2. **Transfer Direction** — two `GlassCard` selectors (From / To accounts); swap icon between them (`primaryFixed`)
3. **Amount Input** — large centered input, `displayMedium` Manrope
4. **Note / Date fields** — filled inputs
5. **Confirm CTA** — `GradientButton`

---

## Screen 6 — More / Settings

**Reference:** `screen_6_more_tab/`  
**File:** `lib/features/more/presentation/screens/more_screen.dart`

**Sections:**
1. **TopAppBar** — profile avatar + gradient "BravoFlow AI" title; settings gear icon
2. **Profile Hero** — centered avatar (`radiusLg` clip, ring `surfaceContainerHighest`); gradient verified badge overlay; name in `headlineMedium`; subtitle `onSurfaceVariant`
3. **Settings Groups** — each group has: section label (`labelSmall` Manrope uppercase, `primaryFixed`), list container (`surfaceContainerLow`), items with `JeweledIcon` + title + subtitle + `chevron_right`; NO `Divider` between items — whitespace only
   - Account Management: Accounts, Security
   - System & Customization: Notifications, Theme, Language, Currency
   - Support & Legal: Help, Privacy Policy, Terms
4. **Sign Out** — ghost button, `error` color text, bottom of scroll

---

## Auth Screens (Sign In / Sign Up)

**Files:** `lib/features/auth/presentation/screens/sign_in_screen.dart`, `sign_up_screen.dart`

**Spec:**
- Background: `surface` (#090d20)
- Centered logo + gradient "BravoFlow AI" wordmark
- Email + Password: filled inputs per spec (see luminous-stratum-theme spec)
- Primary CTA: `GradientButton`
- Switch between sign-in/sign-up: `GhostButton` or text link in `primaryFixed`

---

## Acceptance Criteria (all screens)

- [ ] Every screen uses tokens from `AppColors` — no hardcoded hex values
- [ ] No `Divider()` widget used anywhere
- [ ] All cards use `GlassCard` or `AnimatedAuraCard`
- [ ] All primary CTAs use `GradientButton`
- [ ] All list item icons use `JeweledIcon`
- [ ] TopAppBar on every screen: glassmorphism bg, gradient title text
- [ ] Bottom navigation uses redesigned `AppShell` (4 tabs)
- [ ] Screens visually match their respective `screen.png` reference image
