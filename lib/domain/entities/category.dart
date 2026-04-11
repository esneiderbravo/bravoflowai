import 'package:equatable/equatable.dart';

/// Spending / income category for transactions and budgets.
class Category extends Equatable {
  const Category({
    required this.id,
    required this.userId,
    required this.name,
    this.icon,
    this.color,
    this.isDefault = false,
  });

  final String id;
  final String userId;
  final String name;

  /// Icon identifier (e.g. Material icon name or emoji).
  final String? icon;

  /// Hex colour string, e.g. "#3A86FF".
  final String? color;

  /// Whether this is a system-provided default category.
  final bool isDefault;

  @override
  List<Object?> get props => [id, userId, name, icon, color, isDefault];
}

