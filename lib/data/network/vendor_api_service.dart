abstract class VendorApiService {
  Future<dynamic> getServiceRequestBidsProvider({Map<String, dynamic>? queryParams});

  Future<dynamic> getServiceRequestsMe({Map<String, dynamic>? queryParams});

  Future<dynamic> getVendorReviews(String userId, {Map<String, dynamic>? queryParams});
}
