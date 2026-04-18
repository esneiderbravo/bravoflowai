import 'package:equatable/equatable.dart';
import '../value_objects/money.dart';
import 'category.dart';

enum TransactionType { income, expense }

/// Core financial transaction entity.
///
/// Uses [Money] value object — never raw doubles — to prevent
/// currency confusion bugs.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String accountId;
  final Money amount;
  final Category category;
  final String description;
  final DateTime date;
  final TransactionType type;
  final DateTime createdAt;

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  @override
  List<Object> get props => [
    id,
    userId,
    accountId,
    amount,
    category,
    description,
    date,
    type,
    createdAt,
  ];
}
