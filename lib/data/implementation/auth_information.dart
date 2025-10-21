import 'package:service_la/data/network/auth_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class AuthInformation extends AuthApiService {
  @override
  Future sendOtp(params) async {
    dynamic response = await ApiService().post(ApiConstant.sendOtpPath, params);
    return response;
  }

  @override
  Future validateOtp(params) async {
    dynamic response = await ApiService().post(ApiConstant.validateOtpPath, params);
    return response;
  }

  @override
  Future signup(params) async {
    dynamic response = await ApiService().post(ApiConstant.signupPath, params);
    return response;
  }
}
