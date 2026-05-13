import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';

/// Interface for global search operations.
abstract interface class SearchRepository {
  /// Performs a global search with the given [query].
  Future<Result<List<SearchResult>, Failure>> search(String query);
}
