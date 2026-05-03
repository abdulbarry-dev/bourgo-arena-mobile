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
      name: 'ABDULBARRY BOURGO',
      email: 'test@testor.com',
      phone: '+216 20 000 000',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop',
      loyaltyPoints: 1250,
      subscriptionLevel: 'PREMIUM',
      subscriptionExpiry: '2026-12-31',
      totalCheckIns: 42,
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
