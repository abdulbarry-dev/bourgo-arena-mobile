/// Domain entity representing a selectable family member for booking/planning.
class FamilyMember {
  /// Unique identifier for the member (user id or child id).
  final String id;

  /// Display name for UI.
  final String name;

  /// Optional avatar URL.
  final String? avatarUrl;

  /// True when this represents the primary account holder.
  final bool isPrimary;

  const FamilyMember({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.isPrimary,
  });
}
