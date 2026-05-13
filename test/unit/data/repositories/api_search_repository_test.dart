import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_search_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiSearchRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiSearchRepository(apiClient);
  });

  group('ApiSearchRepository', () {
    test('returns Success on 200 with mapped results', () async {
      const query = 'football';
      final jsonResponse = [
        {
          'id': '1',
          'type': 'activity',
          'title': 'Football 5x5',
          'subtitle': 'Sport',
          'icon': 'sports_soccer',
        },
      ];

      when(
        () => apiClient.get('/search?q=$query'),
      ).thenAnswer((_) async => jsonResponse);

      final result = await repository.search(query);

      expect(result, isA<Success<List<SearchResult>, Failure>>());
      final data = (result as Success<List<SearchResult>, Failure>).data;
      expect(data, hasLength(1));
      expect(data.first.title, 'Football 5x5');
      expect(data.first.type, SearchResultType.activity);
    });

    test('returns Failure on API exception', () async {
      const query = 'error';
      when(
        () => apiClient.get('/search?q=$query'),
      ).thenThrow(const ServerException('API Error: 500'));

      final result = await repository.search(query);

      expect(result, isA<FailureResult<List<SearchResult>, Failure>>());
    });
  });
}
