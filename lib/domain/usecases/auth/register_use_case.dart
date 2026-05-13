import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Use case for registering a new user.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  /// Executes the registration operation.
  Future<Result<void, Failure>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required DateTime birthDate,
    bool isFamilyAccount = false,
  }) async {
    return _repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      gender: gender,
      birthDate: birthDate,
      isFamilyAccount: isFamilyAccount,
    );
  }
}
