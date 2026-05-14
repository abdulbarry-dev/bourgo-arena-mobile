import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/access_history_entry.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';

/// Retrieves the authenticated user's access history.
class GetAccessHistoryUseCase {
  final UserRepository _repository;

  const GetAccessHistoryUseCase(this._repository);

  /// Executes the operation to fetch access history entries.
  Future<Result<List<AccessHistoryEntry>, Failure>> call() {
    return _repository.getAccessHistory();
  }
}
