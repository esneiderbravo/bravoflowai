# Spec: glass-components

## Overview
Reusable glassmorphism UI components that form the visual core of the Luminous Stratum design. These components are shared across all feature screens.

---

## Components

### 1. GlassCard

A frosted-glass container widget replacing the standard `Card`.

**Visual spec:**
- Background: `surfaceVariant` at 40% opacity (`rgba(30, 36, 64, 0.4)`)
- Backdrop filter: `ImageFilter.blur(sigmaX: 12, sigmaY: 12)`
- Corner radius: `radiusLg` (32) by default, configurable
- Ghost border: `outlineVariant` at 15% opacity
- No shadow / elevation

**API:**
```dart
GlassCard({
  required Widget child,
  double borderRadius = AppSpacing.radiusLg,
  EdgeInsetsGeometry? padding,
  Color? backgroundColor,    // overrides default glass color
})
```

**Acceptance criteria:**
- [ ] `BackdropFilter` wraps content correctly — content clips within rounded corners
- [ ] Transparent background shows underlying content blurred
- [ ] Works correctly inside `ListView`, `Stack`, and `Column`

---

### 2. AnimatedAuraCard

A GlassCard variant with an animated rotating gradient border (the "AI Aura").

**Visual spec:**
- Gradient border: 2px wide, 135° linear gradient `primaryFixed` (#00f4fe) → `secondary` (#bf81ff)
- Animation: gradient rotates 360° continuously; period 3s; ease: linear
- Border sits **behind** card content (drawn via `CustomPainter` or `DecoratedBox` in a `Stack`)
- Aura opacity: 0.4 at rest, pulses to 0.7 on a 2s sine cycle (combine rotation + pulse)
- Corner radius: `radiusXl` (48) — slightly larger than the inner card (radiusLg) to prevent clipping

**Implementation approach:**
```
Stack(
  children: [
    // Layer 1: rotating gradient aura (CustomPainter)
    AuraPainterWidget(animation: controller),
    // Layer 2: GlassCard content (inset by 2px)
    Positioned.fill(child: GlassCard(...))
  ]
)
```

**AnimationController:**
- `vsync` provided by the widget's `State with SingleTickerProviderStateMixin`
- Duration: 3000ms, repeat: true

**Acceptance criteria:**
- [ ] Gradient border animates continuously without jank
- [ ] Animation disposes correctly when widget leaves tree
- [ ] Pulse opacity cycles between 0.4 and 0.7
- [ ] Inner content is not clipped by the aura layer

---

### 3. GradientButton (Primary CTA)

**Visual spec:**
- Background: LinearGradient 135°, `primaryFixed` → `secondary`
- Border radius: `radiusFull` (9999)
- No shadow; outer glow via `BoxShadow` with `primaryFixed` at 20% opacity, blur 16, spread 0
- Text: `labelLarge`, `onPrimary` color
- Minimum tap target: 48×48

**Acceptance criteria:**
- [ ] Gradient renders correctly on both iOS and Android
- [ ] Tap feedback: scale to 0.95 over 100ms on press-down

---

### 4. GhostButton (Secondary CTA)

**Visual spec:**
- Background: transparent
- Border: 1px `outline` at 20% opacity
- Text: `onSurface`
- Border radius: `radiusFull`

---

### 5. JeweledIcon

A circular icon container used in list items and quick-action tiles.

**Visual spec:**
- Container: circle, background `surfaceContainerHighest`, padding 8px
- Icon: Material Symbols Outlined, size 24, colored with appropriate accent token

---

### 6. Bottom Navigation Bar (AppShell)

**Visual spec:**
- Background: `surface` (#090d20) at 90% opacity + `backdropFilter blur(24)`
- Top edge: `radiusXl` (48) on top-left and top-right corners
- Ambient shadow above: `BoxShadow` offset (0, -12), blur 40, `onSurface` at 5% opacity
- 4 tabs: Home (`grid_view`), Flow (`swap_horiz`), Bravo AI (`auto_awesome`), More (`more_horiz`)
- Active tab: text + icon `primaryFixed` (#00f4fe) + pill background gradient at 10% opacity
- Inactive tabs: `outline` color at 60% opacity
- Labels: `labelSmall`, Manrope, UPPERCASE, `letterSpacing: 1.6`
- Safe area padding: `pb` accounts for system home indicator

**Acceptance criteria:**
- [ ] Blur effect visible on both iOS and Android
- [ ] Active indicator updates on navigation
- [ ] Taps navigate to correct routes
- [ ] Renders correctly with system gesture bar on notchless devices

---

## Acceptance Criteria (all components)

- [ ] All components live in `lib/shared/widgets/`
- [ ] No component imports feature-specific code
- [ ] Each component has a dartdoc comment
- [ ] GlassCard and AnimatedAuraCard tested on low-end device simulation (blur performance)
