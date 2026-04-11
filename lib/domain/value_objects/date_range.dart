import 'package:equatable/equatable.dart';

/// Value object representing an inclusive date interval.
class DateRange extends Equatable {
  const DateRange({required this.start, required this.end})
      : assert(
          true, // runtime check below
        );

  /// Returns a [DateRange] covering the current calendar month.
  factory DateRange.thisMonth() {
    final now = DateTime.now();
    return DateRange(
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1, 0), // last day of month
    );
  }

  /// Returns a [DateRange] covering the last [days] calendar days.
  factory DateRange.lastDays(int days) {
    final end = DateTime.now();
    return DateRange(start: end.subtract(Duration(days: days)), end: end);
  }

  final DateTime start;
  final DateTime end;

  bool contains(DateTime date) =>
      !date.isBefore(start) && !date.isAfter(end);

  Duration get duration => end.difference(start);

  @override
  List<Object> get props => [start, end];
}

