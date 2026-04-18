import 'package:equatable/equatable.dart';
import '../value_objects/money.dart';

enum AccountType { checking, savings, cash, investment, other }

class Account extends Equatable {
  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currency,
    required this.isDefault,
    required this.createdAt,
    this.color,
    this.icon,
  });

  final String id;
  final String userId;
  final String name;
  final AccountType type;
  final Money initialBalance;
  final String currency;
  final bool isDefault;
  final DateTime createdAt;
  final String? color;
  final String? icon;

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    type,
    initialBalance,
    currency,
    isDefault,
    createdAt,
    color,
    icon,
  ];
}
