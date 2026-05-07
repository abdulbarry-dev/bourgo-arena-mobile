import 'dart:convert';
import 'package:http/http.dart' as http;

/// A central client for making HTTP requests to the Laravel backend.
class ApiClient {
  final String baseUrl;
  final http.Client _client;
  String? _token;

  ApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  /// Updates the authentication token used for requests.
  void setToken(String? token) {
    _token = token;
  }

  /// Sends a GET request to the specified [path].
  Future<dynamic> get(String path) async {
    final response = await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  /// Sends a POST request to the specified [path] with [body].
  Future<dynamic> post(String path, dynamic body) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// Sends a PUT request to the specified [path] with [body].
  Future<dynamic> put(String path, dynamic body) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// Sends a DELETE request to the specified [path].
  Future<void> delete(String path) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    _handleResponse(response);
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      // TODO: Implement custom exception handling
      throw Exception('API Error: ${response.statusCode} ${response.body}');
    }
  }
}
