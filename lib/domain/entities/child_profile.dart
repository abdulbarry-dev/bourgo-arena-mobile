import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

class ChildProfile {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String? gender;
  final String? avatarUrl;
  final String status;
  final bool isArchived;
  final bool hasActiveSubscription;
  final Subscription? activeSubscription;
  final DateTime? createdAt;

  const ChildProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.gender,
    this.avatarUrl,
    this.status = 'active',
    this.isArchived = false,
    this.hasActiveSubscription = false,
    this.activeSubscription,
    this.createdAt,
  });

  ChildProfile copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? avatarUrl,
    String? status,
    bool? isArchived,
    bool? hasActiveSubscription,
    Subscription? activeSubscription,
    DateTime? createdAt,
  }) {
    return ChildProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      isArchived: isArchived ?? this.isArchived,
      hasActiveSubscription:
          hasActiveSubscription ?? this.hasActiveSubscription,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get name => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          birthDate == other.birthDate &&
          gender == other.gender &&
          avatarUrl == other.avatarUrl &&
          status == other.status &&
          isArchived == other.isArchived &&
          hasActiveSubscription == other.hasActiveSubscription &&
          activeSubscription == other.activeSubscription &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      birthDate.hashCode ^
      gender.hashCode ^
      avatarUrl.hashCode ^
      status.hashCode ^
      isArchived.hashCode ^
      hasActiveSubscription.hashCode ^
      activeSubscription.hashCode ^
      createdAt.hashCode;
}
