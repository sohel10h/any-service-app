import 'package:service_la/data/network/vendor_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class VendorInformation extends VendorApiService {
  @override
  Future getServiceRequestBidsProvider() async {
    dynamic response = await ApiService().get(ApiConstant.getServiceRequestBidsProviderPath);
    return response;
  }

  @override
  Future getServiceRequestsMe() async {
    dynamic response = await ApiService().get(ApiConstant.getServiceRequestsMePath);
    return response;
  }
}
