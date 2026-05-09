import 'dart:async';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

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

  test('GET throws NetworkException on timeout', () async {
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenThrow(TimeoutException('timed out'));

    expect(
      () async => await client.get('/x'),
      throwsA(isA<NetworkException>()),
    );
  });

  test('GET with malformed JSON throws FormatException', () async {
    final resp = http.Response('{bad json', 200);
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => resp);

    expect(() async => await client.get('/x'), throwsA(isA<FormatException>()));
  });
}
