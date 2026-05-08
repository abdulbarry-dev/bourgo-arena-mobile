import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

/// Use case for checking if the user has explicitly selected a language.
class IsLanguageSelectedUseCase {
  final SessionRepository _repository;

  /// Creates a new [IsLanguageSelectedUseCase].
  const IsLanguageSelectedUseCase(this._repository);

  /// Executes the use case.
  Future<Result<bool, Failure>> call() => _repository.isLanguageSelected();
}
