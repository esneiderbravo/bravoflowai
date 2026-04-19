## 1. Inactive Tab Visibility

- [x] 1.1 In `_NavTabItem.build`, replace `AppColors.outline.withValues(alpha: 0.6)` with `AppColors.onSurfaceVariant` for the inactive color variable
- [x] 1.2 Verify icon and label both use the updated `color` variable (no separate overrides)

## 2. Active Pill Indicator

- [x] 2.1 In `_NavTabItem.build`, raise both gradient stop alphas in the active `LinearGradient` from `0.10` to `0.18`
  - `AppColors.primaryFixed.withValues(alpha: 0.18)`
  - `AppColors.secondary.withValues(alpha: 0.18)`

## 3. Top Separator Border

- [x] 3.1 In `_GlassNavBar.build`, add a `border` property to the `BoxDecoration` of the container:
  ```dart
  border: Border(
    top: BorderSide(
      color: AppColors.outlineVariant.withValues(alpha: 0.4),
      width: 1,
    ),
  ),
  ```

## 4. Ambient Shadow Uplift

- [x] 4.1 In `_GlassNavBar.build`, update the `BoxShadow` entry in `boxShadow`:
  - Change `alpha` from `0.05` to `0.12`
  - Change `blurRadius` from `40` to `32`
  - Keep `offset: const Offset(0, -12)`

## 5. Verification

- [x] 5.1 Run `flutter analyze` and confirm no new warnings or errors
- [ ] 5.2 Visually verify on a device/emulator: inactive tabs are legible, active pill is visible, top border is present, shadow separates bar from content
