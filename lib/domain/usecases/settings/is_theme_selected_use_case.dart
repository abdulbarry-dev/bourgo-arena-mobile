import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';

class IsThemeSelectedUseCase {
  final SessionRepository _repository;

  IsThemeSelectedUseCase(this._repository);

  Future<Result<bool, Failure>> call() => _repository.isThemeSelected();
}
