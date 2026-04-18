# Spec: luminous-stratum-theme

## Overview
The design token system implementing "The Luminous Stratum" — a premium dark-first UI language built on tonal layering, glassmorphism, and digital energy accents.

---

## Color Tokens

### Surface Hierarchy (dark theme)
| Token | Hex | Usage |
|-------|-----|-------|
| `surface` / `background` | `#090d20` | App background — the void |
| `surfaceContainerLowest` | `#000000` | Deepest shadow depth only |
| `surfaceContainerLow` | `#0d1227` | Secondary section backgrounds |
| `surfaceContainer` | `#13182f` | Standard container background |
| `surfaceContainerHigh` | `#191e37` | Interactive cards |
| `surfaceContainerHighest` | `#1e2440` | Icon backgrounds, top layer |
| `surfaceBright` | `#242a48` | Highlighted/elevated surfaces |
| `surfaceVariant` | `#1e2440` | Used at 40% opacity for glass |
| `surfaceDim` | `#090d20` | Dimmed surface (same as bg) |

### Brand Accents
| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#a1faff` | Primary on-dark text accent |
| `primaryFixed` | `#00f4fe` | Neon cyan — primary CTA, icon tints |
| `primaryFixedDim` | `#00e5ee` | Inactive/muted primary states |
| `primaryDim` | `#00e5ee` | Dimmed primary |
| `secondary` | `#bf81ff` | Electric violet — secondary accents |
| `secondaryFixed` | `#e4c6ff` | Secondary on-dark text |
| `secondaryFixedDim` | `#dab4ff` | Muted secondary |
| `secondaryDim` | `#9c42f4` | Dimmed secondary |
| `secondaryContainer` | `#7701d0` | AI badge background |
| `tertiary` | `#64b3ff` | Tertiary blue (investment accounts) |
| `tertiaryFixed` | `#6bb6ff` | Fixed tertiary |
| `tertiaryFixedDim` | `#49a8fc` | Dim tertiary |

### Text / On-Surface
| Token | Hex | Usage |
|-------|-----|-------|
| `onSurface` | `#e1e4ff` | Primary text |
| `onSurfaceVariant` | `#a7aac3` | Secondary/muted text (70% feel) |
| `onPrimary` | `#006165` | Text on primary-colored backgrounds |
| `onSecondary` | `#32005c` | Text on secondary backgrounds |
| `onTertiary` | `#003053` | Text on tertiary backgrounds |
| `inverseSurface` | `#fbf8ff` | Light-mode surface for toasts |
| `inverseOnSurface` | `#50546a` | Text on inverse surface |

### System
| Token | Hex | Usage |
|-------|-----|-------|
| `outline` | `#71748c` | Ghost border (use at 15–20% opacity) |
| `outlineVariant` | `#43475c` | Subtle divider-free separation |
| `error` | `#ff716c` | Error states |
| `errorContainer` | `#9f0519` | Error container background |

---

## Gradient

**The AI Gradient:** Linear, 135°, `#a1faff` → `#bf81ff`  
Used on: primary CTAs, hero text clips, aura borders, splash logo, verified badge.

---

## Typography

### Font Families
- **Display & Headlines:** `Manrope` (via `google_fonts`)  
  Weights: 400, 500, 600, 700, 800  
- **Body & Labels:** `Inter` (via `google_fonts`)  
  Weights: 400, 500, 600

### Scale
| Style | Font | Weight | Size | Letter Spacing |
|-------|------|--------|------|----------------|
| `displayLarge` | Manrope | 800 | 56sp | -0.5 |
| `displayMedium` | Manrope | 800 | 45sp | 0 |
| `headlineLarge` | Manrope | 700 | 32sp | 0 |
| `headlineMedium` | Manrope | 700 | 28sp | 0 |
| `headlineSmall` | Manrope | 700 | 24sp | 0 |
| `titleLarge` | Manrope | 700 | 22sp | 0 |
| `titleMedium` | Manrope | 600 | 16sp | 0.15 |
| `titleSmall` | Inter | 500 | 14sp | 0.1 |
| `bodyLarge` | Inter | 400 | 16sp | 0.15 |
| `bodyMedium` | Inter | 400 | 14sp | 0.25 |
| `bodySmall` | Inter | 400 | 12sp | 0.4 |
| `labelLarge` | Inter | 600 | 14sp | 1.2 (all caps) |
| `labelMedium` | Inter | 600 | 12sp | 0.5 |
| `labelSmall` | Inter | 500 | 10sp | 0.5 |

---

## Spacing / Radius Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `radiusFull` | 9999 | Buttons, pills, chips |
| `radiusXl` | 48 (3rem) | Glass cards, modals, bottom nav top edge |
| `radiusLg` | 32 (2rem) | Standard cards |
| `radiusMd` | 24 (1.5rem) | Input fields, action buttons |
| `radiusSm` | 16 (1rem) | Small elements |
| `xs` | 4 | Micro spacing |
| `sm` | 8 | Tight spacing |
| `md` | 16 | Standard spacing |
| `lg` | 24 | Generous spacing |
| `xl` | 32 | Section spacing |
| `xxl` | 48 | Hero spacing |

---

## Elevation Rules

1. **NO Material 3 elevation shadows (levels 1–5).** Remove all `elevation` parameters from `CardTheme`, `AppBarTheme`, etc.
2. **Tonal layering only** — use `surfaceContainer*` tiers as background colors.
3. **Ambient shadows** for floating elements (bottom sheets, modals):
   - blur: 40–80px, color: `onSurface` at 5% opacity, offset: (0, 12)
4. **Ghost border fallback** if accessibility requires edge visibility:
   - stroke: 1.0, color: `outlineVariant` at 15% opacity

---

## The No-Line Rules

- `Divider()` widgets: **BANNED** throughout the app
- Explicit `Border.all(...)` with `outline` at full opacity: **BANNED**
- Separation achieved via: vertical whitespace (16px between list items), tonal surface shifts, shadow-free ambient depth

---

## Acceptance Criteria

- [ ] `AppColors` contains all tokens from the table above; old tokens removed
- [ ] `AppTheme.dark` uses the new color scheme; no `elevation` on cards/appbar
- [ ] `AppTheme.light` updated as fallback (dark is default); uses `ThemeMode.dark`
- [ ] `AppTextStyles` uses Manrope for display/headlines, Inter for body
- [ ] `AppSpacing` contains `radiusFull`, `radiusXl`, `radiusLg`, `radiusMd`
- [ ] No `Divider()` in any file; no border at full opacity
- [ ] All `BoxDecoration` borders use `outlineVariant.withOpacity(0.15)` or less
