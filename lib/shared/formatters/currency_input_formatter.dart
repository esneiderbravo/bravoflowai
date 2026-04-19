import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formats a numeric text field as currency while typing.
/// Keeps only digits and one decimal point, formats with thousands separators.
/// e.g. typing "1234567" → "1,234,567"  |  "1234.5" → "1,234.5"
class CurrencyInputFormatter extends TextInputFormatter {
  static final _intFmt = NumberFormat('#,##0', 'en_US');

  /// Format a [double] for display in the input field (no dollar sign).
  /// Returns empty string for zero.
  static String formatAmount(double amount) {
    if (amount == 0) return '';
    // Use at most 2 decimal places, strip trailing zeros
    final formatted = NumberFormat('#,##0.##', 'en_US').format(amount);
    return formatted;
  }

  /// Strip formatting characters so the raw number can be parsed.
  static double? parse(String text) => double.tryParse(text.replaceAll(',', ''));

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text;

    // Allow empty
    if (raw.isEmpty) return newValue.copyWith(text: '');

    // Strip non-numeric except dot
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple dots
    final dotCount = '.'.allMatches(cleaned).length;
    if (dotCount > 1) return oldValue;

    // Split integer and decimal
    final parts = cleaned.split('.');
    final intPart = parts[0];
    final hasDecimal = cleaned.contains('.');
    final decPart = hasDecimal ? parts[1] : null;

    // Cap decimal at 2 digits
    if (decPart != null && decPart.length > 2) return oldValue;

    // Format integer part with thousands separators
    final intVal = int.tryParse(intPart) ?? 0;
    final formattedInt = intPart.isEmpty ? '' : _intFmt.format(intVal);

    final result = hasDecimal ? '$formattedInt.${decPart ?? ''}' : formattedInt;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
