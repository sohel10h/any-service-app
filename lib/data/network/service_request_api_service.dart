abstract class ServiceRequestApiService {
  Future<dynamic> serviceRequests(dynamic params);

  Future<dynamic> getServiceRequestsDetails(String serviceId);
}
