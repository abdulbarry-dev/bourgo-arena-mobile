import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';

/// Use case for checking if the user has explicitly selected a language.
class IsLanguageSelectedUseCase {
  final SettingsRepository _repository;

  /// Creates a new [IsLanguageSelectedUseCase].
  const IsLanguageSelectedUseCase(this._repository);

  /// Executes the use case.
  bool call() => _repository.isLanguageSelected();
}
