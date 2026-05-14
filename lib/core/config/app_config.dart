/// Application configuration constants and flags.
///
/// These values are loaded from the .env file at runtime.
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  /// The base URL for the production API.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:8000/api/v1';

  /// The timeout duration for API requests in milliseconds.
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  /// The application name.
  static String get appName => dotenv.env['APP_NAME'] ?? 'Bourgo Arena';

  /// The application version.
  static String get version => dotenv.env['APP_VERSION'] ?? '1.0.0';

  /// Whether to use mock data instead of calling the real API.
  static bool get useMockData =>
      dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true' ?? false;

  /// Whether to use the mock server interceptor.
  static bool get useMockServer =>
      dotenv.env['USE_MOCK_SERVER']?.toLowerCase() == 'true' ?? false;
}
