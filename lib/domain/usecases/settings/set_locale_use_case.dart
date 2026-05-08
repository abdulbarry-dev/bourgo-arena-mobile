import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/material.dart';

/// Use case for updating the locale.
class SetLocaleUseCase {
  final SessionRepository _repository;

  /// Creates a new [SetLocaleUseCase].
  const SetLocaleUseCase(this._repository);

  /// Executes the use case.
  Future<Result<void, Failure>> call(Locale locale) =>
      _repository.setLocale(locale);
}
