import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

class MockDio extends Mock implements Dio {}

class MockInterceptors extends Mock implements Interceptors {}

void main() {
  late MockDio mockDio;
  late MockInterceptors mockInterceptors;
  late ApiClient client;

  setUp(() {
    mockDio = MockDio();
    mockInterceptors = MockInterceptors();
    when(() => mockDio.interceptors).thenReturn(mockInterceptors);
    client = ApiClient(baseUrl: 'https://example.com', dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  test('401 response returns AuthException', () async {
    when(() => mockDio.get(any(), options: any(named: 'options'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 401,
          data: {'message': 'Unauthorized'},
        ),
      ),
    );

    await check(client.get('/x')).throws<AuthException>();
  });

  test('404 response returns NotFoundException', () async {
    when(() => mockDio.get(any(), options: any(named: 'options'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 404,
          data: {'message': 'Not Found'},
        ),
      ),
    );

    await check(client.get('/x')).throws<NotFoundException>();
  });

  test('500 response returns ServerException', () async {
    when(() => mockDio.get(any(), options: any(named: 'options'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 500,
          data: {'message': 'Internal Server Error'},
        ),
      ),
    );

    await check(client.get('/x')).throws<ServerException>();
  });

  test('network exception returns NetworkException', () async {
    when(() => mockDio.get(any(), options: any(named: 'options'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
        message: 'Network error',
      ),
    );

    await check(client.get('/x')).throws<NetworkException>();
  });

  test('successful 200 response returns the decoded body', () async {
    final resp = Response(
      requestOptions: RequestOptions(path: '/x'),
      statusCode: 200,
      data: {'id': 1, 'name': 'Test'},
    );
    when(
      () => mockDio.get(any(), options: any(named: 'options')),
    ).thenAnswer((_) async => resp);

    final result = await client.get('/x');

    final map = check(result).isA<Map<String, dynamic>>();
    map['id'].equals(1);
    map['name'].equals('Test');
  });
}
