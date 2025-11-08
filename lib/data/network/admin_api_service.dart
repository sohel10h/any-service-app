abstract class AdminApiService {
  Future<dynamic> uploadAdminPictures(dynamic params);

  Future<dynamic> createAdminServices(dynamic params);

  Future<dynamic> getAdminServices();

  Future<dynamic> getAdminServicesDetails(String serviceId);
}
