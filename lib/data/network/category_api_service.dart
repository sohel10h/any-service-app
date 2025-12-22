abstract class CategoryApiService {
  Future<dynamic> getAllServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getServiceCategories({Map<String, dynamic>? queryParams});

  Future<dynamic> getServicesBestSellersCategories(String categoryId);
}
