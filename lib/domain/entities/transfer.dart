import 'package:equatable/equatable.dart';
import '../value_objects/money.dart';

class Transfer extends Equatable {
  const Transfer({
    required this.id,
    required this.userId,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final String fromAccountId;
  final String toAccountId;
  final Money amount;
  final DateTime date;
  final DateTime createdAt;
  final String? note;

  @override
  List<Object?> get props => [
    id,
    userId,
    fromAccountId,
    toAccountId,
    amount,
    date,
    createdAt,
    note,
  ];
}
