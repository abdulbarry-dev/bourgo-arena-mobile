/// Standardized error codes for the application.
enum AppErrorCode {
  /// Local caching or storage error.
  cacheError,

  /// Input validation failed.
  validationFailed,

  /// General server-side error.
  serverError,

  /// Resource not found.
  notFound,

  /// Authentication or authorization failure.
  invalidCredentials,

  /// Network connectivity issue.
  networkUnavailable,
}
