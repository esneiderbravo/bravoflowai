import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/value_objects/money.dart';

/// DTO mapping between Supabase `transactions` table rows and [Transaction].
class TransactionDto {
  const TransactionDto({
    required this.id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.date,
    required this.type,
    required this.createdAt,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) => TransactionDto(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        categoryId: json['category_id'] as String? ?? '',
        categoryName:
            (json['categories'] as Map?)?['name'] as String? ?? 'Uncategorized',
        description: json['description'] as String? ?? '',
        date: json['date'] as String,
        type: json['type'] as String,
        createdAt: json['created_at'] as String,
      );

  factory TransactionDto.fromDomain(Transaction t) => TransactionDto(
        id: t.id,
        userId: t.userId,
        amount: t.amount.amount,
        categoryId: t.category.id,
        categoryName: t.category.name,
        description: t.description,
        date: t.date.toIso8601String().substring(0, 10),
        type: t.type.name,
        createdAt: t.createdAt.toIso8601String(),
      );

  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String description;
  final String date;
  final String type;
  final String createdAt;

  /// Converts to the Supabase insert/update payload (no generated fields).
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'amount': amount,
        'category_id': categoryId.isEmpty ? null : categoryId,
        'description': description,
        'date': date,
        'type': type,
      };

  Transaction toDomain() {
    final category = Category(
      id: categoryId,
      userId: userId,
      name: categoryName,
    );
    return Transaction(
      id: id,
      userId: userId,
      amount: Money(amount: amount),
      category: category,
      description: description,
      date: DateTime.parse(date),
      type: type == 'income' ? TransactionType.income : TransactionType.expense,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

