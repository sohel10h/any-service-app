abstract class AdminApiService {
  Future<dynamic> postAdminPictures(dynamic params);

  Future<dynamic> postAdminServices(dynamic params);

  Future<dynamic> getAdminServices();

  Future<dynamic> getAdminServicesDetails(String serviceId);

  Future<dynamic> getAllServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getAdminUser(String userId);

  Future<dynamic> putAdminUser(String userId, dynamic params);
}
