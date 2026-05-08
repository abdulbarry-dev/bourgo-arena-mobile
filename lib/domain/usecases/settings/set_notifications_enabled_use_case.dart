import 'package:bourgo_arena_mobile/domain/repositories/settings_repository.dart';

/// Use case for updating the notification preference.
class SetNotificationsEnabledUseCase {
  final SettingsRepository _repository;

  /// Creates a new [SetNotificationsEnabledUseCase].
  const SetNotificationsEnabledUseCase(this._repository);

  /// Executes the use case.
  Future<void> call(bool enabled) async =>
      _repository.setNotificationsEnabled(enabled);
}
