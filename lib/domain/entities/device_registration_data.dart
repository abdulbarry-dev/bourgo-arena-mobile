class DeviceRegistrationData {
  final String token;
  final DateTime expiresAt;

  const DeviceRegistrationData({required this.token, required this.expiresAt});
}

class DeviceRefreshData {
  final String token;
  final DateTime expiresAt;

  const DeviceRefreshData({required this.token, required this.expiresAt});
}
