import '../../../../domain/entities/transfer.dart';
import '../../../../domain/value_objects/money.dart';

/// DTO mapping between Supabase `transfers` table rows and [Transfer].
class TransferDto {
  const TransferDto({
    required this.id,
    required this.userId,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.note,
  });

  factory TransferDto.fromJson(Map<String, dynamic> json) => TransferDto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    fromAccountId: json['from_account_id'] as String,
    toAccountId: json['to_account_id'] as String,
    amount: (json['amount'] as num).toDouble(),
    date: json['date'] as String,
    createdAt: json['created_at'] as String,
    note: json['note'] as String?,
  );

  factory TransferDto.fromDomain(Transfer t) => TransferDto(
    id: t.id,
    userId: t.userId,
    fromAccountId: t.fromAccountId,
    toAccountId: t.toAccountId,
    amount: t.amount.amount,
    date: t.date.toIso8601String().substring(0, 10),
    createdAt: t.createdAt.toIso8601String(),
    note: t.note,
  );

  final String id;
  final String userId;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String date;
  final String createdAt;
  final String? note;

  /// Converts to the Supabase insert/update payload (no generated fields).
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'from_account_id': fromAccountId,
    'to_account_id': toAccountId,
    'amount': amount,
    'date': date,
    if (note != null) 'note': note,
  };

  Transfer toDomain() => Transfer(
    id: id,
    userId: userId,
    fromAccountId: fromAccountId,
    toAccountId: toAccountId,
    amount: Money(amount: amount),
    date: DateTime.parse(date),
    createdAt: DateTime.parse(createdAt),
    note: note,
  );
}
