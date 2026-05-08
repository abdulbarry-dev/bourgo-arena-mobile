import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

/// Use case for updating the theme mode.
class SetThemeModeUseCase {
  final SettingsRepository _repository;

  /// Creates a new [SetThemeModeUseCase].
  const SetThemeModeUseCase(this._repository);

  /// Executes the use case.
  Future<void> call(ThemeMode mode) async => _repository.setThemeMode(mode);
}
