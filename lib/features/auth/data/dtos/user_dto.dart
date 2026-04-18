import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../domain/entities/user.dart';

/// DTO mapping between Supabase `profiles` table rows and [AppUser].
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.currency,
    required this.createdAt,
    this.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String? ?? '',
    name: json['name'] as String? ?? '',
    currency: json['currency'] as String? ?? 'USD',
    createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    avatarUrl: json['avatar_url'] as String?,
  );

  factory UserDto.fromSupabaseUser(
    sb.User user, {
    String name = '',
    String currency = 'USD',
    String? avatarUrl,
  }) => UserDto(
    id: user.id,
    email: user.email ?? '',
    name: name,
    currency: currency,
    createdAt: user.createdAt,
    avatarUrl: avatarUrl ?? user.userMetadata?['avatar_url'] as String?,
  );

  final String id;
  final String email;
  final String name;
  final String currency;
  final String createdAt;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'currency': currency};

  AppUser toDomain() => AppUser(
    id: id,
    email: email,
    name: name,
    currency: currency,
    createdAt: DateTime.parse(createdAt),
    avatarUrl: avatarUrl,
  );
}
