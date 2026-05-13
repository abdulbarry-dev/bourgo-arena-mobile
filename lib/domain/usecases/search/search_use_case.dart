import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/search_repository.dart';

/// Use case for performing a global application search.
class SearchUseCase {
  final SearchRepository _repository;

  SearchUseCase(this._repository);

  Future<Result<List<SearchResult>, Failure>> call(String query) {
    return _repository.search(query);
  }
}
