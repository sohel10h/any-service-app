import 'package:service_la/data/network/admin_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class AdminInformation extends AdminApiService {
  @override
  Future uploadAdminPictures(params) async {
    dynamic response = await ApiService().post(ApiConstant.adminPicturesPath, params, isItFile: true);
    return response;
  }

  @override
  Future createAdminServices(params) async {
    dynamic response = await ApiService().post(ApiConstant.adminServicesPath, params);
    return response;
  }

  @override
  Future getAdminServices() async {
    dynamic response = await ApiService().get(ApiConstant.adminServicesPath);
    return response;
  }
}
