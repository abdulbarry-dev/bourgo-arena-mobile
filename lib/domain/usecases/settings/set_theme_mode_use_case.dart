import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/material.dart';

/// Use case for updating the theme mode.
class SetThemeModeUseCase {
  final SessionRepository _repository;

  /// Creates a new [SetThemeModeUseCase].
  const SetThemeModeUseCase(this._repository);

  /// Executes the use case.
  Future<Result<void, Failure>> call(ThemeMode mode) =>
      _repository.setThemeMode(mode);
}
