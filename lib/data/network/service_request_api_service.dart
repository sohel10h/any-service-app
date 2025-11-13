abstract class ServiceRequestApiService {
  Future<dynamic> postServiceRequests(dynamic params);

  Future<dynamic> getServiceRequestsDetails(String serviceId);

  Future<dynamic> postServiceRequestBids(dynamic params);

  Future<dynamic> putServiceRequestBids(String bidId, dynamic params);

  Future<dynamic> putServiceRequestBidsShortlist(String bidId, dynamic params);

  Future<dynamic> putServiceRequestBidsApproval(String bidId, dynamic params);

  Future<dynamic> putServiceRequestBidsStatus(String bidId, dynamic params);
}
