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

  /// Creates a copy of this [ChildProfile] but with the given fields replaced.
  ChildProfile copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? avatarUrl,
  }) {
    return ChildProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Returns the full name of the child.
  String get name => '$firstName $lastName';
}
