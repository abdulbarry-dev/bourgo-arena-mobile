import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for deleting the user's account.
class DeleteAccountUseCase {
  final AuthRepository _repository;

  /// Creates a new [DeleteAccountUseCase].
  const DeleteAccountUseCase(this._repository);

  /// Executes the account deletion request.
  Future<Result<void, Failure>> execute({required String password}) {
    return _repository.deleteAccount(password: password);
  }
}
