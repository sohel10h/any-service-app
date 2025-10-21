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
  Future signUp(params) async {
    dynamic response = await ApiService().post(ApiConstant.signUpPath, params);
    return response;
  }

  @override
  Future signIn(params) async {
    dynamic response = await ApiService().post(ApiConstant.signInPath, params);
    return response;
  }
}
