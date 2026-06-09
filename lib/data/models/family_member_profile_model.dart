import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';

class FamilyMemberProfileModel {
  final String id;
  final String name;
  final String relation;
  final DateTime? birthDate;
  final String? initials;
  final String? avatarUrl;
  final DateTime createdAt;

  const FamilyMemberProfileModel({
    required this.id,
    required this.name,
    required this.relation,
    this.birthDate,
    this.initials,
    this.avatarUrl,
    required this.createdAt,
  });

  factory FamilyMemberProfileModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberProfileModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      relation: json['relation'] as String? ?? '',
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      initials: json['initials'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relation': relation,
    if (birthDate != null)
      'birth_date': birthDate!.toIso8601String().split('T').first,
    'initials': initials,
    'avatar_url': avatarUrl,
    'created_at': createdAt.toIso8601String(),
  };

  FamilyMemberProfile toEntity() => FamilyMemberProfile(
    id: id,
    name: name,
    relation: relation,
    birthDate: birthDate,
    initials: initials,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
  );
}
