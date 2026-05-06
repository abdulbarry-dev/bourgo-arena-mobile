import 'package:flutter_api_mock_server/flutter_api_mock_server.dart';
import 'package:http/http.dart' as http;

/// An HTTP client that intercepts requests and returns mock responses from [MockServer].
class MockHttpClient extends http.BaseClient {
  final MockServer mockServer;

  MockHttpClient(this.mockServer);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final method = _mapMethod(request.method);
    final path = request.url.path;

    final mockResponse = await mockServer.fetchMockData(path, method);

    return http.StreamedResponse(
      Stream.value(mockResponse.response.codeUnits),
      mockResponse.statusCode,
      headers: {'content-type': 'application/json'},
      request: request,
    );
  }

  HttpMethod _mapMethod(String method) {
    switch (method.toLowerCase()) {
      case 'get':
        return HttpMethod.get;
      case 'post':
        return HttpMethod.post;
      case 'put':
        return HttpMethod.put;
      case 'delete':
        return HttpMethod.delete;
      case 'patch':
        return HttpMethod.patch;
      case 'head':
        return HttpMethod.head;
      case 'options':
        return HttpMethod.options;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
}
