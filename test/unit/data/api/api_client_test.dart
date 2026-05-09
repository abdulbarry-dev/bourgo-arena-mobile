import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  const baseUrl = 'https://api.example.com';

  setUpAll(() {
    registerFallbackValue(Uri.parse(baseUrl));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(baseUrl: baseUrl, client: mockHttpClient);
  });

  group('ApiClient', () {
    const testPath = '/test';
    const testUrl = '$baseUrl$testPath';

    group('Authorization Header', () {
      test(
        'correct Authorization header is attached when a token exists',
        () async {
          // Arrange
          const token = 'test_token';
          apiClient.setToken(token);
          when(
            () => mockHttpClient.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => http.Response('{}', 200));

          // Act
          await apiClient.get(testPath);

          // Assert
          verify(
            () => mockHttpClient.get(
              Uri.parse(testUrl),
              headers: any(
                named: 'headers',
                that: containsPair('Authorization', 'Bearer $token'),
              ),
            ),
          ).called(1);
        },
      );

      test('no Authorization header when session has no token', () async {
        // Arrange
        apiClient.setToken(null);
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('{}', 200));

        // Act
        await apiClient.get(testPath);

        // Assert
        verify(
          () => mockHttpClient.get(
            Uri.parse(testUrl),
            headers: any(
              named: 'headers',
              that: isNot(contains('Authorization')),
            ),
          ),
        ).called(1);
      });

      test(
        'correct Authorization header is attached to POST requests',
        () async {
          // Arrange
          const token = 'test_token';
          apiClient.setToken(token);
          when(
            () => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer((_) async => http.Response('{}', 200));

          // Act
          await apiClient.post(testPath, {});

          // Assert
          verify(
            () => mockHttpClient.post(
              Uri.parse(testUrl),
              headers: any(
                named: 'headers',
                that: containsPair('Authorization', 'Bearer $token'),
              ),
              body: any(named: 'body'),
            ),
          ).called(1);
        },
      );
    });

    group('Error Mapping', () {
      test('401 response throws AuthException (maps to AuthFailure)', () async {
        // Arrange
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        // Act & Assert
        await check(apiClient.get(testPath)).throws<AuthException>();
      });

      test(
        '404 response throws NotFoundException (maps to NotFoundFailure)',
        () async {
          // Arrange
          when(
            () => mockHttpClient.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => http.Response('Not Found', 404));

          // Act & Assert
          await check(apiClient.get(testPath)).throws<NotFoundException>();
        },
      );

      test(
        '500 response throws ServerException (maps to ServerFailure)',
        () async {
          // Arrange
          when(
            () => mockHttpClient.get(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => http.Response('Server Error', 500));

          // Act & Assert
          await check(apiClient.get(testPath)).throws<ServerException>();
        },
      );

      test(
        'network timeout throws NetworkException (maps to NetworkFailure)',
        () async {
          // Arrange
          when(
            () => mockHttpClient.get(any(), headers: any(named: 'headers')),
          ).thenThrow(TimeoutException('Timed out'));

          // Act & Assert
          await check(apiClient.get(testPath)).throws<NetworkException>();
        },
      );

      test(
        'SocketException throws NetworkException (maps to NetworkFailure)',
        () async {
          // Arrange
          when(
            () => mockHttpClient.get(any(), headers: any(named: 'headers')),
          ).thenThrow(const SocketException('No Internet'));

          // Act & Assert
          await check(apiClient.get(testPath)).throws<NetworkException>();
        },
      );
    });

    group('Success Scenarios', () {
      test('successful 200 response returns the parsed body', () async {
        // Arrange
        final expectedBody = <String, dynamic>{'key': 'value'};
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response(jsonEncode(expectedBody), 200));

        // Act
        final result = await apiClient.get(testPath);

        // Assert
        check(result).isA<Map<String, dynamic>>().deepEquals(expectedBody);
      });
    });
  });
}
