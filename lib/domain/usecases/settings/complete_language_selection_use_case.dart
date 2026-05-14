import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

/// Use case for marking the language selection as complete.
class CompleteLanguageSelectionUseCase {
  final SessionRepository _repository;

  /// Creates a new [CompleteLanguageSelectionUseCase].
  const CompleteLanguageSelectionUseCase(this._repository);

  /// Executes the use case.
  Future<Result<void, Failure>> call() =>
      _repository.completeLanguageSelection();
}
