abstract class ServiceRequestApiService {
  Future<dynamic> postServiceRequests(dynamic params);

  Future<dynamic> getServiceRequestsDetails(String serviceId);

  Future<dynamic> postServiceRequestBids(dynamic params);
}
