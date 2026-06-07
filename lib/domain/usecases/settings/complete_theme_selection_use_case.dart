import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

class CompleteThemeSelectionUseCase {
  final SessionRepository _repository;

  CompleteThemeSelectionUseCase(this._repository);

  Future<Result<void, Failure>> call() => _repository.completeThemeSelection();
}
