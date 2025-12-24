import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/network/category_api_service.dart';

class CategoryInformation extends CategoryApiService {
  @override
  Future getAllServiceCategories({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getAllServiceCategoriesPath,
        queryParams: queryParams,
      ),
    );
    return response;
  }

  @override
  Future getServiceCategories({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(ApiConstant.getServiceCategoriesPath, queryParams: queryParams),
    );
    return response;
  }

  @override
  Future getCategoryBestSellersServices(String categoryId) async {
    dynamic response = await ApiService().get(
      ApiConstant.getCategoryBestSellersServicesPath.replaceAll("#categoryId#", categoryId),
    );
    return response;
  }

  @override
  Future getCategoryServices(String categoryId, {Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getCategoryServicesPath.replaceAll("#categoryId#", categoryId),
        queryParams: queryParams,
      ),
    );
    return response;
  }
}
