class ApiConstant {
  // BASE URL
  static const String baseUrl = "http://54.151.254.172:8080";

  // END POINTS - Auth
  static const String sendOtpPath = "/sendOtp";
  static const String validateOtpPath = "/validateOtp";
  static const String signUpPath = "/signup";
  static const String signInPath = "/signin";
  static const String refreshTokenPath = "/refresh-token";

  // END POINTS - FCM
  static const String userDeviceTokensPath = "/api/user-device-tokens";

  // END POINTS - Service requests
  static const String serviceRequestsPath = "/api/service-requests";

  // END POINTS - Admin
  static const String adminPicturesPath = "/api/admin/pictures";
  static const String adminServicesPath = "/api/admin/services?page=2";
  static const String adminServicesDetailsPath = "/api/admin/services/#serviceId#";

  // Functions
  static String dynamicQueryParams(String endpoint, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse(endpoint).replace(
      queryParameters: queryParams?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    return uri.toString();
  }
}
