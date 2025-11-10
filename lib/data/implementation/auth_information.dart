import 'package:service_la/data/network/auth_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class AuthInformation extends AuthApiService {
  @override
  Future postOtp(params) async {
    dynamic response = await ApiService().post(ApiConstant.postOtpPath, params);
    return response;
  }

  @override
  Future postValidateOtp(params) async {
    dynamic response = await ApiService().post(ApiConstant.postValidateOtpPath, params);
    return response;
  }

  @override
  Future postSignUp(params) async {
    dynamic response = await ApiService().post(ApiConstant.postSignUpPath, params);
    return response;
  }

  @override
  Future postSignIn(params) async {
    dynamic response = await ApiService().post(ApiConstant.postSignInPath, params);
    return response;
  }

  @override
  Future postRefreshToken(params) async {
    dynamic response = await ApiService().post(ApiConstant.postRefreshTokenPath, params);
    return response;
  }
}
