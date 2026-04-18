import 'package:flutter/material.dart';

import '../widgets/app_toast.dart';

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

  // ── Toasts (top-anchored) ────────────────────────────────────────────────
  void showInfoSnack(String message) => AppToast.info(this, message);
  void showErrorSnack(String message) => AppToast.error(this, message);
  void showSuccessSnack(String message) => AppToast.success(this, message);
  void showWarningSnack(String message) => AppToast.warning(this, message);
}
