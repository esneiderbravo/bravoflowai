import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Convenience extensions on [BuildContext].
extension ContextExtensions on BuildContext {
  // ── Theme shortcuts ─────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ── Screen size helpers ──────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ── Navigation ───────────────────────────────────────────────────────────
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // ── Snackbars ────────────────────────────────────────────────────────────
  void showInfoSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: textTheme.bodySmall),
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
      );
  }

  void showErrorSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: textTheme.bodySmall?.copyWith(color: Colors.white)),
          backgroundColor: AppColors.error,
        ),
      );
  }
}
