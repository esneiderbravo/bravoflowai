import 'package:equatable/equatable.dart';

/// BravoFlow AI — AppUser domain entity.
///
/// Named [AppUser] to avoid collision with [supabase_flutter]'s `User`.
/// Pure Dart — no Flutter or Supabase imports.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.currency,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String name;

  /// ISO 4217 currency code, e.g. "USD".
  final String currency;

  final DateTime createdAt;

  @override
  List<Object> get props => [id, email, name, currency, createdAt];
}
