abstract class CategoryApiService {
  Future<dynamic> getAllServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getCategoryBestSellersServices(String categoryId);

  Future<dynamic> getCategoryServices(String categoryId, {Map<String, dynamic>? queryParams});
}
