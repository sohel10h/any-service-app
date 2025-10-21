import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/auth_api_service.dart';
import 'package:service_la/data/model/network/send_otp_model.dart';
import 'package:service_la/data/implementation/auth_information.dart';
import 'package:service_la/data/model/network/validate_otp_model.dart';

class AuthRepo {
  AuthApiService authApiService = AuthInformation();

  Future<dynamic> sendOtp(dynamic params) async {
    try {
      dynamic response = await authApiService.sendOtp(params);
      log("SendOtp details from auth repo: $response");
      return SendOtpModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> validateOtp(dynamic params) async {
    try {
      dynamic response = await authApiService.validateOtp(params);
      log("ValidateOtp details from auth repo: $response");
      return ValidateOtpModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
