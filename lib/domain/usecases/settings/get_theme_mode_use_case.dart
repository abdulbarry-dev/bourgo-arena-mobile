import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/material.dart';

/// Use case for retrieving the current theme mode.
class GetThemeModeUseCase {
  final SessionRepository _repository;

  /// Creates a new [GetThemeModeUseCase].
  const GetThemeModeUseCase(this._repository);

  /// Executes the use case.
  Future<Result<ThemeMode, Failure>> call() => _repository.getThemeMode();
}
