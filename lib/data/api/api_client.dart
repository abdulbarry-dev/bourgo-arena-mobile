import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/core/config/app_config.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'dart:developer' as developer;

/// A central client for making HTTP requests to the Laravel backend.
class ApiClient {
  final String baseUrl;
  late final Dio _dio;
  String? _token;
  String? _deviceToken;
  void Function(String? state)? onAuthError;
  String? _cachedDeviceId;

  final SharedPreferences? sharedPreferences;
  final DeviceIdentityStorage? _deviceIdentityStorage;

  ApiClient({
    required this.baseUrl,
    Dio? dio,
    this.sharedPreferences,
    DeviceIdentityStorage? deviceIdentityStorage,
  }) : _deviceIdentityStorage = deviceIdentityStorage {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
            receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: developer.log,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.extra['includeAuth'] ?? true) {
            // Priority:
            // 1. Explicit authToken override
            // 2. Sanctum token (_token) if provided and we want to use it
            // 3. Device token (_deviceToken) as the primary/fallback for persistence
            
            final String? overrideToken = options.extra['authToken'] as String?;
            final bool useSanctumOnly = options.extra['useSanctumOnly'] ?? false;
            
            String? authToken;
            if (overrideToken != null) {
              authToken = overrideToken;
            } else if (useSanctumOnly) {
              authToken = _token;
            } else {
              // Persistence flow: backend recognizes device token as member if linked
              authToken = _deviceToken ?? _token;
            }

            if (authToken != null) {
              options.headers['Authorization'] = 'Bearer $authToken';
            }
          }
          _attachDeviceIdHeader(options);

          developer.log('API Request: [${options.method}] ${options.uri}');
          
          // Log Headers (masking Authorization)
          final loggedHeaders = Map<String, dynamic>.from(options.headers);
          if (loggedHeaders.containsKey('Authorization')) {
            final auth = loggedHeaders['Authorization'] as String;
            if (auth.length > 15) {
              loggedHeaders['Authorization'] = '${auth.substring(0, 12)}...';
            }
          }
          developer.log('Headers: $loggedHeaders');

          if (options.data != null) {
            developer.log('Body: ${jsonEncode(options.data)}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            'API ${response.requestOptions.method} Response (${response.statusCode}): ${response.data}',
          );

          // Cache successful GET requests
          if (response.requestOptions.method == 'GET' &&
              response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            _cacheResponse(
              response.requestOptions.uri.toString(),
              response.data,
            );
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          developer.log('API Error: ${e.message}');

          // If offline/network error, try to fetch from cache for GET requests
          if ((e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout ||
                  e.type == DioExceptionType.sendTimeout ||
                  e.type == DioExceptionType.connectionError) &&
              e.requestOptions.method == 'GET') {
            final cachedData = _getCachedResponse(
              e.requestOptions.uri.toString(),
            );
            if (cachedData != null) {
              developer.log(
                'Returning cached response for ${e.requestOptions.uri}',
              );
              return handler.resolve(
                Response(
                  requestOptions: e.requestOptions,
                  data: cachedData,
                  statusCode: 200,
                  statusMessage: 'OK from Cache',
                ),
              );
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  void _cacheResponse(String url, dynamic data) {
    if (sharedPreferences == null) return;
    try {
      final String jsonString = jsonEncode(data);
      sharedPreferences!.setString('api_cache_$url', jsonString);
    } catch (e) {
      developer.log('Failed to cache response: $e');
    }
  }

  dynamic _getCachedResponse(String url) {
    if (sharedPreferences == null) return null;
    try {
      final String? jsonString = sharedPreferences!.getString('api_cache_$url');
      if (jsonString != null) {
        return jsonDecode(jsonString);
      }
    } catch (e) {
      developer.log('Failed to read cache: $e');
    }
    return null;
  }

  void setToken(String? token) {
    _token = token;
  }

  void setDeviceToken(String? token) {
    _deviceToken = token;
  }

  /// Returns true if a token is currently set.
  bool get hasToken => _token != null;

  void _attachDeviceIdHeader(RequestOptions options) {
    if (_cachedDeviceId != null) {
      options.headers['X-Device-ID'] = _cachedDeviceId;
      return;
    }
    final storage = _deviceIdentityStorage;
    if (storage == null) return;
    final deviceId = storage.getDeviceId();
    if (deviceId != null) {
      _cachedDeviceId = deviceId;
      options.headers['X-Device-ID'] = deviceId;
    }
  }

  /// Sends a GET request to the specified [path].
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
    bool useSanctumOnly = false,
    String? authToken,
  }) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final response = await _dio.get(
        normalizedPath,
        queryParameters: queryParameters,
        options: Options(extra: {
          'includeAuth': includeAuth,
          'useSanctumOnly': useSanctumOnly,
          'authToken': authToken,
        }),
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
    bool useSanctumOnly = false,
    String? authToken,
  }) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final response = await _dio.post(
        normalizedPath,
        data: body,
        options: Options(extra: {
          'includeAuth': includeAuth,
          'useSanctumOnly': useSanctumOnly,
          'authToken': authToken,
        }),
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
    bool useSanctumOnly = false,
    String? authToken,
  }) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final response = await _dio.put(
        normalizedPath,
        data: body,
        options: Options(extra: {
          'includeAuth': includeAuth,
          'useSanctumOnly': useSanctumOnly,
          'authToken': authToken,
        }),
      );
      return _handleResponse(response, fullResponse: fullResponse);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  /// Sends a DELETE request to the specified [path].
  Future<dynamic> delete(
    String path, {
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
    bool useSanctumOnly = false,
    String? authToken,
  }) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final response = await _dio.delete(
        normalizedPath,
        options: Options(extra: {
          'includeAuth': includeAuth,
          'useSanctumOnly': useSanctumOnly,
          'authToken': authToken,
        }),
      );
      return _handleResponse(response, fullResponse: fullResponse);
    } on DioException catch (e) {
      return _handleDioException(e, skipAuthError: skipAuthError);
    }
  }

  /// Sends a multipart/form-data POST request for file uploads.
  Future<dynamic> uploadMultipart(
    String path, {
    required String fileFieldName,
    required String filePath,
    Map<String, dynamic>? extraFields,
    bool fullResponse = false,
    bool skipAuthError = false,
    bool includeAuth = true,
    bool useSanctumOnly = false,
    String? authToken,
  }) async {
    try {
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final formData = FormData.fromMap({
        fileFieldName: await MultipartFile.fromFile(filePath),
        if (extraFields != null) ...extraFields,
      });
      final response = await _dio.post(
        normalizedPath,
        data: formData,
        options: Options(extra: {
          'includeAuth': includeAuth,
          'useSanctumOnly': useSanctumOnly,
          'authToken': authToken,
        }),
      );
      return _handleResponse(response, fullResponse: fullResponse);
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
    final bool success = body['success'] is bool
        ? body['success'] as bool
        : true;

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
    developer.log('API Error Response (${response.statusCode}): $decoded');
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
      case 429:
        throw ServerException(
          'Trop de requêtes. Veuillez réessayer plus tard.',
          state,
          token,
        );
      default:
        if (response.statusCode != null && response.statusCode! >= 500) {
          throw ServerException(
            'Erreur serveur (${response.statusCode}). Veuillez réessayer.',
            state,
            token,
          );
        }
        throw ServerException(message, state, token);
    }
  }
}
