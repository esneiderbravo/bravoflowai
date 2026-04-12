/// Convenience extensions on [DateTime].
extension DateTimeExtensions on DateTime {
  // ── Comparisons ──────────────────────────────────────────────────────────
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear => year == DateTime.now().year;

  // ── Formatting helpers ───────────────────────────────────────────────────

  /// Returns "Today", "Yesterday", or a formatted date string.
  String get relativeLabel {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return toShortDateString;
  }

  /// e.g. "Apr 11"
  String get toShortDateString {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[month - 1]} $day';
  }

  /// e.g. "Apr 11, 2026"
  String get toLongDateString {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month - 1]} $day, $year';
  }

  /// ISO 8601 date-only string, e.g. "2026-04-11".
  String get toIsoDateString =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  // ── Start / end of period ────────────────────────────────────────────────
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get startOfYear => DateTime(year);
}
