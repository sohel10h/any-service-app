import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/model/network/service_details_model.dart';
import 'package:service_la/data/network/service_request_api_service.dart';
import 'package:service_la/data/model/network/upload_service_request_model.dart';
import 'package:service_la/data/implementation/service_request_information.dart';

class ServiceRequestRepo {
  final ServiceRequestApiService _serviceRequestApiService = ServiceRequestInformation();

  Future<dynamic> postServiceRequests(dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.postServiceRequests(params);
      log("ServiceRequests details from service request repo: $response");
      return UploadServiceRequestModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getServiceRequestsDetails(String serviceId) async {
    try {
      dynamic response = await _serviceRequestApiService.getServiceRequestsDetails(serviceId);
      log("ServiceRequestsDetails get details from service request repo: $response");
      return ServiceDetailsModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
