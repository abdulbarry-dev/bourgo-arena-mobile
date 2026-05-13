import 'package:collection/collection.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';

/// Pure domain entity representing a user.
class User {
  /// Unique identifier.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Email address.
  final String email;

  /// Phone number.
  final String phone;

  /// URL to avatar image.
  final String avatarUrl;

  /// Loyalty points balance.
  final int loyaltyPoints;

  /// Current subscription level.
  final String subscriptionLevel;

  /// Date when the subscription expires.
  final String subscriptionExpiry;

  /// Total number of check-ins.
  final int totalCheckIns;

  /// Birth date of the user.
  final DateTime? birthDate;

  /// Gender of the user.
  final String? gender;

  /// Whether this is a parent account that can manage children.
  final bool isParentAccount;

  /// List of children profiles associated with this account.
  final List<ChildProfile> children;

  /// Creates a new [User] instance.
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.loyaltyPoints,
    required this.subscriptionLevel,
    required this.subscriptionExpiry,
    required this.totalCheckIns,
    this.birthDate,
    this.gender,
    this.isParentAccount = false,
    this.children = const [],
  });

  /// Creates a copy of this [User] but with the given fields replaced.
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    int? loyaltyPoints,
    String? subscriptionLevel,
    String? subscriptionExpiry,
    int? totalCheckIns,
    DateTime? birthDate,
    String? gender,
    bool? isParentAccount,
    List<ChildProfile>? children,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isParentAccount: isParentAccount ?? this.isParentAccount,
      children: children ?? this.children,
    );
  }

  /// Returns the full name of the user.
  String get name => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          phone == other.phone &&
          avatarUrl == other.avatarUrl &&
          loyaltyPoints == other.loyaltyPoints &&
          subscriptionLevel == other.subscriptionLevel &&
          subscriptionExpiry == other.subscriptionExpiry &&
          totalCheckIns == other.totalCheckIns &&
          birthDate == other.birthDate &&
          gender == other.gender &&
          isParentAccount == other.isParentAccount &&
          _listEquality.equals(children, other.children);

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      avatarUrl.hashCode ^
      loyaltyPoints.hashCode ^
      subscriptionLevel.hashCode ^
      subscriptionExpiry.hashCode ^
      totalCheckIns.hashCode ^
      birthDate.hashCode ^
      gender.hashCode ^
      isParentAccount.hashCode ^
      _listEquality.hash(children);

  static const _listEquality = ListEquality<ChildProfile>();
}
