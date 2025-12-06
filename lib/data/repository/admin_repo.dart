import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/admin_api_service.dart';
import 'package:service_la/data/model/network/service_model.dart';
import 'package:service_la/data/model/network/admin_user_model.dart';
import 'package:service_la/data/implementation/admin_information.dart';
import 'package:service_la/data/model/network/create_service_model.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';
import 'package:service_la/data/model/network/create_service_details_model.dart';
import 'package:service_la/data/model/network/service_category_response_model.dart';
import 'package:service_la/data/model/network/admin_service_category_response_model.dart';

class AdminRepo {
  final AdminApiService _adminApiService = AdminInformation();

  Future<dynamic> postAdminPictures(dynamic params) async {
    try {
      dynamic response = await _adminApiService.postAdminPictures(params);
      log("UploadAdminPictures details from admin repo: $response");
      return UploadAdminPictureModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> postAdminServices(dynamic params) async {
    try {
      dynamic response = await _adminApiService.postAdminServices(params);
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

  Future<dynamic> getAdminServicesDetails(String serviceId) async {
    try {
      dynamic response = await _adminApiService.getAdminServicesDetails(serviceId);
      log("AdminServicesDetails get details from admin repo: $response");
      return CreateServiceDetailsModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getAllServiceCategories({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _adminApiService.getAllServiceCategories(queryParams: queryParams);
      log("AdminServiceCategories get details from admin repo: $response");
      return AdminServiceCategoryResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getServiceCategories({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _adminApiService.getServiceCategories(queryParams: queryParams);
      log("ServiceCategories get details from admin repo: $response");
      return ServiceCategoryResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getAdminUser(String userId) async {
    try {
      dynamic response = await _adminApiService.getAdminUser(userId);
      log("AdminUser get details from admin repo: $response");
      return AdminUserModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
