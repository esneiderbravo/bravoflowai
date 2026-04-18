import '../../../../domain/entities/account.dart';
import '../../../../domain/value_objects/money.dart';

/// DTO mapping between Supabase `accounts` table rows and [Account].
class AccountDto {
  const AccountDto({
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

  factory AccountDto.fromJson(Map<String, dynamic> json) => AccountDto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    initialBalance: (json['initial_balance'] as num).toDouble(),
    currency: json['currency'] as String? ?? 'USD',
    isDefault: json['is_default'] as bool? ?? false,
    createdAt: json['created_at'] as String,
    color: json['color'] as String?,
    icon: json['icon'] as String?,
  );

  factory AccountDto.fromDomain(Account a) => AccountDto(
    id: a.id,
    userId: a.userId,
    name: a.name,
    type: a.type.name,
    initialBalance: a.initialBalance.amount,
    currency: a.currency,
    isDefault: a.isDefault,
    createdAt: a.createdAt.toIso8601String(),
    color: a.color,
    icon: a.icon,
  );

  final String id;
  final String userId;
  final String name;
  final String type;
  final double initialBalance;
  final String currency;
  final bool isDefault;
  final String createdAt;
  final String? color;
  final String? icon;

  /// Converts to the Supabase insert/update payload (no generated fields).
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'type': type,
    'initial_balance': initialBalance,
    'currency': currency,
    'is_default': isDefault,
    if (color != null) 'color': color,
    if (icon != null) 'icon': icon,
  };

  Account toDomain() => Account(
    id: id,
    userId: userId,
    name: name,
    type: _parseType(type),
    initialBalance: Money(amount: initialBalance),
    currency: currency,
    isDefault: isDefault,
    createdAt: DateTime.parse(createdAt),
    color: color,
    icon: icon,
  );

  static AccountType _parseType(String type) => switch (type) {
    'checking' => AccountType.checking,
    'savings' => AccountType.savings,
    'cash' => AccountType.cash,
    'investment' => AccountType.investment,
    _ => AccountType.other,
  };
}
