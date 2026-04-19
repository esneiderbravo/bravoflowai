## Why

The bottom navigation bar blends into dark screen content due to low-contrast inactive tab icons (outline color at 60% opacity), an almost-invisible active pill indicator (10% alpha gradient), and no top border to separate the bar from scrolling content. Users cannot easily distinguish which tab is active or where the navigation area begins.

## What Changes

- Increase inactive tab icon and label opacity from 60% to a readable baseline
- Strengthen the active pill indicator background gradient opacity
- Add a subtle top border/separator line to the glass nav bar for visual grounding
- Boost the bar's ambient shadow so it lifts off content

## Capabilities

### New Capabilities
- `navbar-visibility`: Visual improvements to bottom nav bar contrast, active state indicator, and separation from page content

### Modified Capabilities
<!-- No existing spec-level requirements are changing -->

## Impact

- `lib/shared/widgets/app_shell.dart` — `_GlassNavBar`, `_NavTabItem` widgets
- `lib/core/theme/app_colors.dart` — potentially adds or documents a border/separator token if needed
- No API, routing, or state management changes
