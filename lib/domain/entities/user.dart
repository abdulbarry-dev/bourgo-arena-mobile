import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';

part 'user.freezed.dart';

/// Pure domain entity representing a user.
@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? avatarUrl,
    required int loyaltyPoints,
    String? subscriptionLevel,
    String? subscriptionExpiry,
    DateTime? birthDate,
    String? gender,
    @Default('active') String status,
    @Default('active') String state,
    @Default(false) bool isParentAccount,
    @Default([]) List<ChildProfile> children,
    Map<String, dynamic>? preferences,
  }) = _User;

  /// Returns the full name of the user.
  String get name => '$firstName $lastName';
}
