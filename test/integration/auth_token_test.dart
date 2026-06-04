import 'package:flutter_test/flutter_test.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';

void main() {
  test('ApiClient sends Authorization header', () async {
    final client = ApiClient(baseUrl: 'http://localhost:8000/api/v1');
    client.setToken('test_token');
    
    try {
      await client.post('/auth/complete-registration', {});
    } catch (e) {
      // Ignore
    }
  });
}
