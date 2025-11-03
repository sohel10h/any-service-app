import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/service_request_api_service.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';
import 'package:service_la/data/implementation/service_request_information.dart';

class ServiceRequestRepo {
  final ServiceRequestApiService _serviceRequestApiService = ServiceRequestInformation();

  Future<dynamic> uploadAdminPictures(dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.uploadAdminPictures(params);
      log("UploadAdminPictures details from service request repo: $response");
      return UploadAdminPictureModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
