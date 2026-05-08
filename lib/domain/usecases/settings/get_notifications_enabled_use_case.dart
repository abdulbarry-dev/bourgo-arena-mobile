import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';

/// Use case for checking if notifications are enabled.
class GetNotificationsEnabledUseCase {
  final SettingsRepository _repository;

  /// Creates a new [GetNotificationsEnabledUseCase].
  const GetNotificationsEnabledUseCase(this._repository);

  /// Executes the use case.
  Future<Result<bool, Failure>> call() => _repository.areNotificationsEnabled();
}
