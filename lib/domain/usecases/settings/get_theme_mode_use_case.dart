import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

/// Use case for retrieving the current theme mode.
class GetThemeModeUseCase {
  final SettingsRepository _repository;

  /// Creates a new [GetThemeModeUseCase].
  const GetThemeModeUseCase(this._repository);

  /// Executes the use case.
  ThemeMode call() => _repository.getThemeMode();
}
