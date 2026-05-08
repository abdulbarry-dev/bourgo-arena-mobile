import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

/// Use case for updating the locale.
class SetLocaleUseCase {
  final SettingsRepository _repository;

  /// Creates a new [SetLocaleUseCase].
  const SetLocaleUseCase(this._repository);

  /// Executes the use case.
  Future<void> call(Locale locale) async => _repository.setLocale(locale);
}
