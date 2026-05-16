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
    } on http.ClientException catch (e) {
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
    } on http.ClientException catch (e) {
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
    } on http.ClientException catch (e) {
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
    } on http.ClientException catch (e) {
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
    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        // If body is not JSON, we'll use the status code and raw body message
      }
    }

    if (decoded is List) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      throw ServerException(
        'API Error: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> body = decoded is Map<String, dynamic>
        ? decoded
        : {};

    final bool success =
        body['success'] ??
        (response.statusCode >= 200 && response.statusCode < 300);

    if (success) {
      if (body.containsKey('data')) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          final dataMap = Map<String, dynamic>.from(data);
          // Preserve important top-level fields if they're not already in data
          if (body.containsKey('token') && !dataMap.containsKey('token')) {
            dataMap['token'] = body['token'];
          }
          if (body.containsKey('state') && !dataMap.containsKey('state')) {
            dataMap['state'] = body['state'];
          }
          return dataMap;
        }
        return data;
      }
      return body;
    } else {
      final String message =
          body['message'] ??
          'API Error: ${response.statusCode} ${response.body}';
      String? state = body['state'] as String?;
      final String? code = body['code'] as String?;
      if (state == null && code != null) {
        switch (code) {
          case 'EMAIL_NOT_VERIFIED':
            state = 'pending_verification';
            break;
          case 'ADDITIONAL_VERIFICATION_REQUIRED':
            state = 'pending_additional_verification';
            break;
          case 'ONBOARDING_INCOMPLETE':
            state = 'pending_onboarding';
            break;
        }
      }
      final String? token = body['token'] as String?;

      switch (response.statusCode) {
        case 401:
        case 403:
          throw AuthException(message, state, token);
        case 404:
          throw NotFoundException(message, state, token);
        case 422:
          throw ValidationException(message, state, token);
        default:
          throw ServerException(message, state, token);
      }
    }
  }
}
