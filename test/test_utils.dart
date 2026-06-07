import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

/// Helper to create a [User] for testing.
User createTestUser({
  String id = '1',
  String firstName = 'Test',
  String lastName = 'User',
  String email = 'test@example.com',
  String phone = '1234567890',
  String avatarUrl = 'https://example.com/avatar.png',
  int loyaltyPoints = 100,
  String subscriptionLevel = 'Gold',
  DateTime? subscriptionExpiry,
  DateTime? birthDate,
  bool isParentAccount = false,
  List<ChildProfile> children = const [],
}) {
  return User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    loyaltyPoints: loyaltyPoints,
    subscriptionLevel: subscriptionLevel,
    subscriptionExpiry: subscriptionExpiry,
    birthDate: birthDate,
    isParentAccount: isParentAccount,
    children: children,
  );
}
