abstract class VendorApiService {
  Future<dynamic> getServiceRequestBidsProvider();

  Future<dynamic> getServiceRequestsMe({Map<String, dynamic>? queryParams});
}
