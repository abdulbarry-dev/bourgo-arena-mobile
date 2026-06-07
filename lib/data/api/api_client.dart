import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'dart:developer' as developer;

/// A central client for making HTTP requests to the Laravel backend.
class ApiClient {
  final String baseUrl;
  late final Dio _dio;
  String? _token;
  void Function(String? state)? onAuthError;

  ApiClient({required this.baseUrl, Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && (options.extra['includeAuth'] ?? true)) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          developer.log('API ${options.method} Request: ${options.uri}');
          if (options.data != null) {
            developer.log('Body: ${jsonEncode(options.data)}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            'API ${response.requestOptions.method} Response (${response.statusCode}): ${response.data}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          developer.log('API Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  void setToken(String? token) {
    _token = token;
  }

  /// Returns true if a token is currently set.
  bool get hasToken => _token != null;

  /// Sends a GET request to the specified [path].
  Future<dynamic> get(
    String path, {
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(extra: {'includeAuth': includeAuth}),
      );
      return _handleResponse(response, fullResponse: fullResponse);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  /// Sends a POST request to the specified [path] with [body].
  Future<dynamic> post(
    String path,
    dynamic body, {
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: Options(extra: {'includeAuth': includeAuth}),
      );
      return _handleResponse(response, fullResponse: fullResponse);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  /// Sends a PUT request to the specified [path] with [body].
  Future<dynamic> put(
    String path,
    dynamic body, {
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        options: Options(extra: {'includeAuth': includeAuth}),
      );
      return _handleResponse(response, fullResponse: fullResponse);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  /// Sends a DELETE request to the specified [path].
  Future<void> delete(String path, {bool skipAuthError = false}) async {
    try {
      final response = await _dio.delete(path);
      _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  dynamic _handleResponse(Response response, {bool fullResponse = false}) {
    final decoded = response.data;

    if (decoded is List) {
      return decoded;
    }

    final Map<String, dynamic> body = decoded is Map<String, dynamic>
        ? decoded
        : {};
    final bool success = body['success'] ?? true;

    if (success) {
      if (!fullResponse && body.containsKey('data') && body['data'] != null) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          final dataMap = Map<String, dynamic>.from(data);
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
      // If success is false but status is 2xx, we still throw
      final String message = body['message'] ?? body['error'] ?? 'API Error';
      throw ServerException(message);
    }
  }

  dynamic _handleDioException(DioException e, {bool skipAuthError = false}) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(e.message ?? 'Network Error');
    }

    final response = e.response;
    if (response == null) {
      throw NetworkException(e.message ?? 'Unknown Network Error');
    }

    final decoded = response.data;
    final Map<String, dynamic> body = decoded is Map<String, dynamic>
        ? decoded
        : {};

    final String message =
        body['message'] ?? body['error'] ?? 'API Error: ${response.statusCode}';
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
        if (!skipAuthError) {
          onAuthError?.call(state);
        }
        throw AuthException(message, state, token);
      case 403:
        if (state != null) {
          if (!skipAuthError) {
            onAuthError?.call(state);
          }
          throw AuthException(message, state, token);
        }
        throw ServerException(message, state, token);
      case 404:
        throw NotFoundException(message, state, token);
      case 422:
        Map<String, List<String>>? validationErrors;
        if (body.containsKey('errors') && body['errors'] is Map) {
          validationErrors = {};
          (body['errors'] as Map).forEach((key, value) {
            if (value is List) {
              validationErrors![key.toString()] = value
                  .map((e) => e.toString())
                  .toList();
            }
          });
        }
        throw ValidationException(message, state, token, validationErrors);
      default:
        throw ServerException(message, state, token);
    }
  }
}
