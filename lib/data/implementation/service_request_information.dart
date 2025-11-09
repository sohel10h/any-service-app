import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/network/service_request_api_service.dart';

class ServiceRequestInformation extends ServiceRequestApiService {
  @override
  Future serviceRequests(params) async {
    dynamic response = await ApiService().post(ApiConstant.serviceRequestsPath, params);
    return response;
  }

  @override
  Future getServiceRequestsDetails(String serviceId) async {
    dynamic response = await ApiService().get(ApiConstant.serviceRequestsDetailsPath.replaceAll("#serviceId#", serviceId));
    return response;
  }
}
