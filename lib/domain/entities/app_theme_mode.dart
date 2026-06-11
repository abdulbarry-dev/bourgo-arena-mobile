/// A pure-Dart representation of the user's preferred theme mode.
///
/// This enum decouples the domain layer from the Flutter UI framework
/// by avoiding a direct dependency on [ThemeMode].
enum AppThemeMode {
  /// Use the device/system default theme.
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark;
}
