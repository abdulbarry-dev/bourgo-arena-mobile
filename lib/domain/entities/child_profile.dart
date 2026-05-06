/// Pure domain entity representing a child's profile.
class ChildProfile {
  /// Unique identifier.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Birth date.
  final DateTime birthDate;

  /// Gender (optional).
  final String? gender;

  /// URL to avatar image (optional).
  final String? avatarUrl;

  /// Creates a new [ChildProfile] instance.
  const ChildProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.gender,
    this.avatarUrl,
  });

  /// Returns the full name of the child.
  String get name => '$firstName $lastName';
}
