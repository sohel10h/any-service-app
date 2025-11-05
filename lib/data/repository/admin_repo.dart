import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/admin_api_service.dart';
import 'package:service_la/data/model/network/service_model.dart';
import 'package:service_la/data/implementation/admin_information.dart';
import 'package:service_la/data/model/network/create_service_model.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';

class AdminRepo {
  final AdminApiService _adminApiService = AdminInformation();

  Future<dynamic> uploadAdminPictures(dynamic params) async {
    try {
      dynamic response = await _adminApiService.uploadAdminPictures(params);
      log("UploadAdminPictures details from admin repo: $response");
      return UploadAdminPictureModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> createAdminServices(dynamic params) async {
    try {
      dynamic response = await _adminApiService.createAdminServices(params);
      log("AdminServices create details from admin repo: $response");
      return CreateServiceModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getAdminServices() async {
    try {
      dynamic response = await _adminApiService.getAdminServices();
      log("AdminServices get details from admin repo: $response");
      return ServiceModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
