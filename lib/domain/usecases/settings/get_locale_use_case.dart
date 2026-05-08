import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:flutter/material.dart';

/// Use case for retrieving the current locale.
class GetLocaleUseCase {
  final SessionRepository _repository;

  /// Creates a new [GetLocaleUseCase].
  const GetLocaleUseCase(this._repository);

  /// Executes the use case.
  Future<Result<Locale, Failure>> call() => _repository.getLocale();
}
