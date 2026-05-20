/// Supported delivery channels for OTP verification.
enum OtpDeliveryMethod {
  email('email'),
  phone('phone'),
  sms('sms');

  const OtpDeliveryMethod(this.value);

  final String value;
}
