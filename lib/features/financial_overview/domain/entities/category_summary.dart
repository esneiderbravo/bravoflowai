import 'package:equatable/equatable.dart';

import '../../../../domain/value_objects/money.dart';

/// Aggregated spending summary for a single category in a given period.
class CategorySummary extends Equatable {
  const CategorySummary({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
    this.categoryIcon,
    this.categoryColor,
  });

  final String categoryId;
  final String categoryName;

  /// Total expense amount for this category in the period.
  final Money totalAmount;

  /// This category's share of total expenses (0.0 – 100.0).
  final double percentage;

  final String? categoryIcon;
  final String? categoryColor;

  @override
  List<Object?> get props => [
    categoryId,
    categoryName,
    totalAmount,
    percentage,
    categoryIcon,
    categoryColor,
  ];
}
