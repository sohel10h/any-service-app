class ApiConstant {
  //BASE URL
  static const String baseUrl = "http://54.151.254.172:8080";

  //END POINTS

  // Auth
  static const String sendOtpPath = "/sendOtp";
  static const String validateOtpPath = "/validateOtp";
  static const String signUpPath = "/signup";
  static const String signInPath = "/signin";

  // FCM
  static const String userDeviceTokensPath = "/api/user-device-tokens";
}
