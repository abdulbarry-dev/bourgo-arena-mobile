/// Application configuration constants and flags.
///
/// These values can be overridden using `--dart-define` during the build process.
class AppConfig {
  /// The base URL for the production API.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );

  /// The timeout duration for API requests in milliseconds.
  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  /// The application name.
  static const String appName = 'Bourgo Arena';

  /// The application version.
  static const String version = '1.0.0';
}
