import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// BravoFlow AI — General Utility Helpers
abstract final class AppUtils {
  /// Formats a double value as a currency string (USD).
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$symbol$intPart.${parts[1]}';
  }

  /// Returns a greeting based on the current hour.
  static String timeBasedGreeting() {
    final hour = TimeOfDay.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Clamps a value between [min] and [max].
  static double clamp(double value, double min, double max) =>
      value.clamp(min, max);

  /// Returns a BorderRadius using [AppConstants.radiusLg] by default.
  static BorderRadius get defaultRadius =>
      BorderRadius.circular(AppConstants.radiusLg);
}

