import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';

/// Use case for retrieving the current verification status.
class GetVerificationStatusUseCase {
  final AuthRepository _repository;

  const GetVerificationStatusUseCase(this._repository);

  /// Executes the get verification status operation.
  Future<Result<VerificationStatus, Failure>> call() async {
    return _repository.getVerificationStatus();
  }
}
