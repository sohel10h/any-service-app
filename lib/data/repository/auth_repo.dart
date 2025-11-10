import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/auth_api_service.dart';
import 'package:service_la/data/model/network/sign_up_model.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/data/model/network/send_otp_model.dart';
import 'package:service_la/data/implementation/auth_information.dart';
import 'package:service_la/data/model/network/validate_otp_model.dart';
import 'package:service_la/data/model/network/refresh_token_model.dart';

class AuthRepo {
  AuthApiService authApiService = AuthInformation();

  Future<dynamic> postOtp(dynamic params) async {
    try {
      dynamic response = await authApiService.postOtp(params);
      log("SendOtp details from auth repo: $response");
      return SendOtpModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postValidateOtp(dynamic params) async {
    try {
      dynamic response = await authApiService.postValidateOtp(params);
      log("ValidateOtp details from auth repo: $response");
      return ValidateOtpModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postSignUp(dynamic params) async {
    try {
      dynamic response = await authApiService.postSignUp(params);
      log("SignUp details from auth repo: $response");
      return SignUpModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postSignIn(dynamic params) async {
    try {
      dynamic response = await authApiService.postSignIn(params);
      log("SignIn details from auth repo: $response");
      return SignInModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postRefreshToken(dynamic params) async {
    try {
      dynamic response = await authApiService.postRefreshToken(params);
      log("RefreshToken details from auth repo: $response");
      return RefreshTokenModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
