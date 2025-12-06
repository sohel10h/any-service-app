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
  static const String putServiceRequestsStatusPath = "/api/service-requests/status/#serviceId#";

  // END POINTS - Admin
  static const String postAdminPicturesPath = "/api/admin/pictures";
  static const String getPostAdminServicesPath = "/api/admin/services";
  static const String getAdminServicesDetailsPath = "/api/admin/services/#serviceId#";
  static const String getAdminServiceCategoriesPath = "/api/admin/categories";
  static const String getAdminUserPath = "/api/admin/users/#userId#";

  // END POINTS - Service requests bids
  static const String postServiceRequestBidsPath = "/api/service-request-bids";
  static const String putServiceRequestBidsPath = "/api/service-request-bids/#bidId#";
  static const String putServiceRequestBidsShortlistPath = "/api/service-request-bids/shortlist/#bidId#";
  static const String putServiceRequestBidsApprovalPath = "/api/service-request-bids/approval/#bidId#";
  static const String putServiceRequestBidsStatusPath = "/api/service-request-bids/status/#bidId#";

  // END POINTS - Services
  static const String getServicesMePath = "/api/services/me";
  static const String getBestSellingServicesPath = "/services/best-sellers";
  static const String getServiceCategoriesPath = "/categories/homepage";

  // END POINTS - Vendor details
  static const String getServiceRequestBidsProviderPath = "/api/service-request-bids/provider";
  static const String getServiceRequestsMePath = "/api/service-requests/me";

  // END POINTS - Chats
  static const String getChatsPath = "/api/chats";
  static const String getChatsMessagesPath = "/api/chats/messages/#conversationId#";
  static const String getChatsMessagesUserPath = "/api/chats/messages/user/#userId#";

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
