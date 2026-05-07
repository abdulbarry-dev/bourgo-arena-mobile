import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for registering a new user.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  /// Executes the registration operation.
  Future<Result<void>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    bool isFamilyAccount = false,
  }) async {
    try {
      await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        isFamilyAccount: isFamilyAccount,
      );
      return const Success(null);
    } catch (e) {
      return Failure('Registration failed', e);
    }
  }
}
