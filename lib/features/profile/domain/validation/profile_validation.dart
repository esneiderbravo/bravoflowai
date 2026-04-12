abstract final class ProfileValidation {
  static const int minNameLength = 2;
  static const int maxNameLength = 80;

  static String? validateFullName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Full name is required';
    if (trimmed.length < minNameLength) {
      return 'Full name must be at least $minNameLength characters';
    }
    if (trimmed.length > maxNameLength) {
      return 'Full name must be at most $maxNameLength characters';
    }
    return null;
  }
}
