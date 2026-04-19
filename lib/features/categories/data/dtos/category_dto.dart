import '../../../../domain/entities/category.dart';

/// DTO mapping between Supabase `categories` table rows and [Category].
class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.isDefault,
    this.icon,
    this.color,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) => CategoryDto(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    isDefault: json['is_default'] as bool? ?? false,
    icon: json['icon'] as String?,
    color: json['color'] as String?,
  );

  factory CategoryDto.fromDomain(Category c) => CategoryDto(
    id: c.id,
    userId: c.userId,
    name: c.name,
    isDefault: c.isDefault,
    icon: c.icon,
    color: c.color,
  );

  final String id;
  final String userId;
  final String name;
  final bool isDefault;
  final String? icon;
  final String? color;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'is_default': isDefault,
    if (icon != null) 'icon': icon,
    if (color != null) 'color': color,
  };

  Category toDomain() =>
      Category(id: id, userId: userId, name: name, isDefault: isDefault, icon: icon, color: color);
}
