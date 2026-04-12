import '../../domain/entities/profile.dart';

class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    final fallbackName = json['name'] as String? ?? '';
    final fullName = (json['full_name'] as String?)?.trim();
    return ProfileDto(
      id: json['id'] as String,
      fullName: (fullName == null || fullName.isEmpty) ? fallbackName : fullName,
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String createdAt;

  Map<String, dynamic> toUpdateJson({required String updatedFullName, String? updatedAvatarUrl}) {
    return <String, dynamic>{
      'full_name': updatedFullName,
      'name': updatedFullName,
      'avatar_url': ?updatedAvatarUrl,
    };
  }

  Profile toDomain() {
    return Profile(
      id: id,
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
