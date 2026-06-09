import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdentityStorage {
  final SharedPreferences _prefs;

  DeviceIdentityStorage(this._prefs);

  static const String _deviceIdKey = 'device_identity_id';
  static const String _registrationTokenKey = 'device_registration_token';
  static const String _tokenExpiresAtKey =
      'device_registration_token_expires_at';

  String? getDeviceId() => _prefs.getString(_deviceIdKey);

  Future<void> saveDeviceId(String id) => _prefs.setString(_deviceIdKey, id);

  String? getRegistrationToken() => _prefs.getString(_registrationTokenKey);

  Future<void> saveRegistrationToken(String token) =>
      _prefs.setString(_registrationTokenKey, token);

  DateTime? getTokenExpiresAt() {
    final raw = _prefs.getString(_tokenExpiresAtKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> saveTokenExpiresAt(DateTime expiresAt) =>
      _prefs.setString(_tokenExpiresAtKey, expiresAt.toIso8601String());

  bool needsTokenRefresh() {
    final expiresAt = getTokenExpiresAt();
    if (expiresAt == null) return true;
    return expiresAt.isBefore(DateTime.now().add(const Duration(days: 7)));
  }

  Future<void> clearRegistrationData() async {
    await _prefs.remove(_registrationTokenKey);
    await _prefs.remove(_tokenExpiresAtKey);
  }
}
