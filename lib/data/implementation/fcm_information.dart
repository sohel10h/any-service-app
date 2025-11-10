import 'package:service_la/data/network/fcm_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class FcmInformation extends FcmApiService {
  @override
  Future postUserDeviceTokens(params) async {
    dynamic response = await ApiService().post(ApiConstant.postUserDeviceTokensPath, params);
    return response;
  }
}
