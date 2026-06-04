import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_family_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiFamilyRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    when(() => apiClient.hasToken).thenReturn(true);
    repository = ApiFamilyRepository(apiClient);
  });

  group('ApiFamilyRepository', () {
    final tChildJson = {
      'id': '1',
      'first_name': 'John',
      'last_name': 'Doe',
      'birth_date': '2015-05-15',
      'gender': 'male',
      'avatar_url': null,
    };

    test('getChildren returns list of ChildProfile on 200', () async {
      when(
        () => apiClient.get('/family/children'),
      ).thenAnswer((_) async => [tChildJson]);

      final result = await repository.getChildren();

      expect(result, isA<Success<List<ChildProfile>, Failure>>());
      final data = (result as Success<List<ChildProfile>, Failure>).data;
      expect(data, hasLength(1));
      expect(data.first.firstName, 'John');
    });

    test('addChild returns new ChildProfile on 200', () async {
      when(
        () => apiClient.post(any(), any()),
      ).thenAnswer((_) async => tChildJson);

      final result = await repository.addChild(
        firstName: 'John',
        lastName: 'Doe',
        birthDate: DateTime(2015, 5, 15),
        gender: 'male',
      );

      expect(result, isA<Success<ChildProfile, Failure>>());
      final data = (result as Success<ChildProfile, Failure>).data;
      expect(data.firstName, 'John');
    });
  });
}
