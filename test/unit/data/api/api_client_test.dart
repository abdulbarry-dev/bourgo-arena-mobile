import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late ApiClient client;

  setUp(() {
    mockClient = MockHttpClient();
    client = ApiClient(baseUrl: 'https://example.com', client: mockClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  test(
    'auth token header is attached to every request when session has a token',
    () async {
      client.setToken('test-token');
      final resp = http.Response('{"status": "ok"}', 200);
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => resp);

      await client.get('/x');

      final captured = verify(
        () => mockClient.get(any(), headers: captureAny(named: 'headers')),
      ).captured;

      check(
        captured.first as Map<String, String>,
      )['Authorization'].equals('Bearer test-token');
    },
  );

  test('no Authorization header sent when session token is empty', () async {
    client.setToken(null);
    final resp = http.Response('{"status": "ok"}', 200);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    await client.get('/x');

    final captured = verify(
      () => mockClient.get(any(), headers: captureAny(named: 'headers')),
    ).captured;

    check(
      captured.first as Map<String, String>,
    ).not((it) => it.containsKey('Authorization'));
  });

  test('401 response returns AuthFailure', () async {
    final resp = http.Response('Unauthorized', 401);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    await check(client.get('/x')).throws<AuthException>();
  });

  test('404 response returns NotFoundFailure', () async {
    final resp = http.Response('Not Found', 404);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    await check(client.get('/x')).throws<NotFoundException>();
  });

  test('500 response returns ServerFailure', () async {
    final resp = http.Response('Internal Server Error', 500);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    await check(client.get('/x')).throws<ServerException>();
  });

  test('network exception returns NetworkFailure', () async {
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenThrow(http.ClientException('Network error'));

    await check(client.get('/x')).throws<NetworkException>();
  });

  test('successful 200 response returns the decoded body', () async {
    final resp = http.Response('{"id": 1, "name": "Test"}', 200);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    final result = await client.get('/x');

    final map = check(result).isA<Map<String, dynamic>>();
    map['id'].equals(1);
    map['name'].equals('Test');
  });
}
