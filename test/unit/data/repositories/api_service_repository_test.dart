import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_service_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ApiServiceRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ApiServiceRepository(mockApiClient);
  });

  group('ApiServiceRepository', () {
    test('getServices returns list of services', () async {
      // Arrange
      final jsonResponse = {
        'data': [
          {
            'id': 1,
            'name': 'Service A',
            'image_url': 'https://example.com/img.png',
            'description': 'Description A',
          }
        ]
      };
      when(() => mockApiClient.get(any())).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getServices(page: 1, limit: 15);

      // Assert
      check(result).isA<Success>();
      final services = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(services.length).equals(1);
      check(services.first.id).equals(1);
      check(services.first.name).equals('Service A');
      
      verify(() => mockApiClient.get('/services?page=1&per_page=15')).called(1);
    });

    test('getServiceDetails returns service details', () async {
      // Arrange
      final jsonResponse = {
        'data': {
          'id': 1,
          'name': 'Service A',
          'image_url': 'https://example.com/img.png',
          'description': 'Description A',
        }
      };
      when(() => mockApiClient.get(any())).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getServiceDetails(1);

      // Assert
      check(result).isA<Success>();
      final service = result.fold(
        onSuccess: (val) => val,
        onFailure: (_) => fail('Expected success'),
      );
      check(service.id).equals(1);
      check(service.name).equals('Service A');
      
      verify(() => mockApiClient.get('/services/1')).called(1);
    });

    test('getServices returns failure on exception', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getServices();

      // Assert
      check(result).isA<FailureResult>();
      final failure = result.fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (f) => f,
      );
      check(failure).isA<ServerFailure>();
    });
  });
}
