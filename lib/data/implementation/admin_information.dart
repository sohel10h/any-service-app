import 'package:service_la/data/network/admin_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class AdminInformation extends AdminApiService {
  @override
  Future postAdminPictures(params) async {
    dynamic response = await ApiService().post(ApiConstant.postAdminPicturesPath, params, isItFile: true);
    return response;
  }

  @override
  Future postAdminServices(params) async {
    dynamic response = await ApiService().post(ApiConstant.getPostAdminServicesPath, params);
    return response;
  }

  @override
  Future getAdminServices() async {
    dynamic response = await ApiService().get(ApiConstant.getPostAdminServicesPath);
    return response;
  }

  @override
  Future getAdminServicesDetails(String serviceId) async {
    dynamic response = await ApiService().get(ApiConstant.getAdminServicesDetailsPath.replaceAll("#serviceId#", serviceId));
    return response;
  }

  @override
  Future getAdminServiceCategories({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getAdminServiceCategoriesPath,
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
  Future getAdminUser(String userId) async {
    dynamic response = await ApiService().get(ApiConstant.getAdminUserPath.replaceAll("#userId#", userId));
    return response;
  }
}
