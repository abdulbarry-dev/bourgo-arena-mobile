import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';

/// Use case for checking if the user has explicitly selected a language.
class IsLanguageSelectedUseCase {
  final SettingsRepository _repository;

  /// Creates a new [IsLanguageSelectedUseCase].
  const IsLanguageSelectedUseCase(this._repository);

  /// Executes the use case.
  Future<Result<bool, Failure>> call() => _repository.isLanguageSelected();
}
