import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/network/service_request_api_service.dart';

class ServiceRequestInformation extends ServiceRequestApiService {
  @override
  Future uploadAdminPictures(params) async {
    dynamic response = await ApiService().post(ApiConstant.adminPicturesPath, params, isItFile: true);
    return response;
  }

  @override
  Future serviceRequests(params) async {
    dynamic response = await ApiService().post(ApiConstant.serviceRequestsPath, params);
    return response;
  }
}
