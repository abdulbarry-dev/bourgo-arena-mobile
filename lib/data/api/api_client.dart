import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';

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
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException catch (e) {
      throw NetworkException(e.message ?? 'Request timed out');
    }
  }

  /// Sends a POST request to the specified [path] with [body].
  Future<dynamic> post(String path, dynamic body) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException catch (e) {
      throw NetworkException(e.message ?? 'Request timed out');
    }
  }

  /// Sends a PUT request to the specified [path] with [body].
  Future<dynamic> put(String path, dynamic body) async {
    try {
      final response = await _client
          .put(
            Uri.parse('$baseUrl$path'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException catch (e) {
      throw NetworkException(e.message ?? 'Request timed out');
    }
  }

  /// Sends a DELETE request to the specified [path].
  Future<void> delete(String path) async {
    try {
      final response = await _client
          .delete(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException catch (e) {
      throw NetworkException(e.message ?? 'Request timed out');
    }
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
      final message = 'API Error: ${response.statusCode} ${response.body}';
      switch (response.statusCode) {
        case 401:
        case 403:
          throw AuthException(message);
        case 404:
          throw NotFoundException(message);
        case 422:
          throw ValidationException(message);
        default:
          throw ServerException(message);
      }
    }
  }
}
