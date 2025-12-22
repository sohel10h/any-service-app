abstract class AdminApiService {
  Future<dynamic> postAdminPictures(dynamic params);

  Future<dynamic> postAdminServices(dynamic params);

  Future<dynamic> getAdminServices();

  Future<dynamic> getAdminServicesDetails(String serviceId);

  Future<dynamic> getAdminUser(String userId);

  Future<dynamic> putAdminUser(String userId, dynamic params);
}
