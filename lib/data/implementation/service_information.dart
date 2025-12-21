import 'package:service_la/data/network/service_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class ServiceInformation extends ServiceApiService {
  @override
  Future getServicesMe(String userId) async {
    dynamic response = await ApiService().get(ApiConstant.getServicesMePath.replaceAll("#userId#", userId));
    return response;
  }

  @override
  Future getBestSellingServices() async {
    dynamic response = await ApiService().get(ApiConstant.getBestSellingServicesPath);
    return response;
  }
}
