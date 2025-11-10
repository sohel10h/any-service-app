import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/fcm_api_service.dart';
import 'package:service_la/data/implementation/fcm_information.dart';
import 'package:service_la/data/model/network/user_device_token_model.dart';

class FcmRepo {
  final FcmApiService _fcmApiService = FcmInformation();

  Future<dynamic> postUserDeviceTokens(dynamic params) async {
    try {
      dynamic response = await _fcmApiService.postUserDeviceTokens(params);
      log("UserDeviceTokens details from fcm repo: $response");
      return UserDeviceTokenModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
