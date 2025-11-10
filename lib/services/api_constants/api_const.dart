class ApiConstant {
  // BASE URL
  static const String baseUrl = "http://54.151.254.172:8080";
  static const String websocketBaseUrl = "ws://54.151.254.172:8080/api/chats/ws";

  // END POINTS - Auth
  static const String postOtpPath = "/sendOtp";
  static const String postValidateOtpPath = "/validateOtp";
  static const String postSignUpPath = "/signup";
  static const String postSignInPath = "/signin";
  static const String postRefreshTokenPath = "/refresh-token";

  // END POINTS - FCM
  static const String postUserDeviceTokensPath = "/api/user-device-tokens";

  // END POINTS - Service requests
  static const String postServiceRequestsPath = "/api/service-requests";
  static const String getServiceRequestsDetailsPath = "/api/service-requests/#serviceId#";

  // END POINTS - Admin
  static const String postAdminPicturesPath = "/api/admin/pictures";
  static const String getPostAdminServicesPath = "/api/admin/services";
  static const String getAdminServicesDetailsPath = "/api/admin/services/#serviceId#";

  // END POINTS - Service requests bids
  static const String postServiceRequestBidsPath = "/api/service-request-bids";

  // END POINTS - Services
  static const String getServicesMePath = "/api/services/me";

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
