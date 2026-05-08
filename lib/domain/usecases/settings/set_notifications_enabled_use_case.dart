import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';

/// Use case for updating the notification preference.
class SetNotificationsEnabledUseCase {
  final SettingsRepository _repository;

  /// Creates a new [SetNotificationsEnabledUseCase].
  const SetNotificationsEnabledUseCase(this._repository);

  /// Executes the use case.
  Future<Result<void, Failure>> call(bool enabled) =>
      _repository.setNotificationsEnabled(enabled);
}
