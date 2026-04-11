import 'package:equatable/equatable.dart';
import '../value_objects/money.dart';
import 'category.dart';

enum BudgetPeriod { weekly, monthly, yearly }

/// A spending limit set by the user for a [Category] over a [BudgetPeriod].
class Budget extends Equatable {
  const Budget({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.period,
    required this.startsAt,
  });

  final String id;
  final String userId;
  final Category category;
  final Money amount;
  final BudgetPeriod period;
  final DateTime startsAt;

  @override
  List<Object> get props =>
      [id, userId, category, amount, period, startsAt];
}

