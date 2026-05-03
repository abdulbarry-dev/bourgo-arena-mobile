import 'dart:async';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Mock implementation of [AuthRepository] for development and testing.
class MockAuthRepository implements AuthRepository {
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  User? _currentUser;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = const User(
      id: 'mock-user-123',
      name: 'Mock User',
      email: 'mock@test.com',
      phone: '+216 00 000 000',
      avatarUrl: 'https://i.pravatar.cc/150?u=mock',
      loyaltyPoints: 100,
      subscriptionLevel: 'Basic',
      subscriptionExpiry: '2026-01-01',
      totalCheckIns: 5,
    );

    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<String?> getToken() async => 'mock_token_abc';

  @override
  Stream<User?> get onAuthStateChanged => _authStateController.stream;
}
