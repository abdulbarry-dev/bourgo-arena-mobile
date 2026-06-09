class FamilyMemberProfile {
  final String id;
  final String name;
  final String relation;
  final DateTime? birthDate;
  final String? initials;
  final String? avatarUrl;
  final DateTime createdAt;

  const FamilyMemberProfile({
    required this.id,
    required this.name,
    required this.relation,
    this.birthDate,
    this.initials,
    this.avatarUrl,
    required this.createdAt,
  });
}
