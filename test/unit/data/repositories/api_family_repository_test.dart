import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_family_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member_profile.dart';
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
        () => apiClient.get(
          '/family/children',
          fullResponse: any(named: 'fullResponse'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [tChildJson],
        },
      );

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

    group('getFamilyMembers', () {
      final tMemberJson = {
        'id': '10',
        'name': 'Sara Ben Ali',
        'relation': 'spouse',
        'birth_date': '1997-08-22',
        'initials': 'SB',
        'avatar_url': null,
        'created_at': '2026-02-10T08:00:00.000000Z',
      };

      test('returns list of FamilyMemberProfile on 200', () async {
        when(
          () => apiClient.get(
            '/family/members',
            fullResponse: any(named: 'fullResponse'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': [tMemberJson],
          },
        );

        final result = await repository.getFamilyMembers();

        expect(result, isA<Success<List<FamilyMemberProfile>, Failure>>());
        final data =
            (result as Success<List<FamilyMemberProfile>, Failure>).data;
        expect(data, hasLength(1));
        expect(data.first.name, 'Sara Ben Ali');
        expect(data.first.relation, 'spouse');
      });

      test('returns empty list when not authenticated', () async {
        when(() => apiClient.hasToken).thenReturn(false);

        final result = await repository.getFamilyMembers();

        expect(result, isA<Success<List<FamilyMemberProfile>, Failure>>());
        expect(
          (result as Success<List<FamilyMemberProfile>, Failure>).data,
          isEmpty,
        );
      });
    });
  });
}
