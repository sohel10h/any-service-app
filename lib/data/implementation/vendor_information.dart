import 'package:service_la/data/network/vendor_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class VendorInformation extends VendorApiService {
  @override
  Future getServiceRequestBidsProvider({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getServiceRequestBidsProviderPath,
        queryParams: queryParams,
      ),
    );
    return response;
  }

  @override
  Future getServiceRequestsMe({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getServiceRequestsMePath,
        queryParams: queryParams,
      ),
    );
    return response;
  }
}
