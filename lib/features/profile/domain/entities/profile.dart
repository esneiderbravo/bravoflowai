import 'package:equatable/equatable.dart';

/// User profile aggregate for profile management flows.
class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.languageCode,
    required this.themeMode,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String languageCode;
  final String themeMode;
  final DateTime createdAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    fullName,
    email,
    avatarUrl,
    languageCode,
    themeMode,
    createdAt,
  ];
}
