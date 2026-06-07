import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/search_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/search_result_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/repositories/search_repository.dart';

/// Laravel API implementation of [SearchRepository].
class ApiSearchRepository implements SearchRepository {
  final ApiClient _apiClient;

  ApiSearchRepository(this._apiClient);

  @override
  Future<Result<List<SearchResult>, Failure>> search(String query) {
    return executeApiCall(() async {
      final response = await _apiClient.get('/search?q=$query');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
                []);
      final entities = data
          .map(
            (json) => SearchMapper.toEntity(
              SearchResultModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }
}
