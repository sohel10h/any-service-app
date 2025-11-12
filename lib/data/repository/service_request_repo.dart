import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/model/network/service_details_model.dart';
import 'package:service_la/data/network/service_request_api_service.dart';
import 'package:service_la/data/model/network/upload_service_request_model.dart';
import 'package:service_la/data/implementation/service_request_information.dart';
import 'package:service_la/data/model/network/create_service_request_bid_model.dart';

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

  Future<dynamic> postServiceRequestBids(dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.postServiceRequestBids(params);
      log("ServiceRequestBids details from service request repo: $response");
      return CreateServiceRequestBidModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> putServiceRequestBids(String bidId, dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.putServiceRequestBids(bidId, params);
      log("ServiceRequestBids update details from service request repo: $response");
      return CreateServiceRequestBidModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> putServiceRequestBidsShortlist(String bidId, dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.putServiceRequestBidsShortlist(bidId, params);
      log("ServiceRequestBidsShortlist update details from service request repo: $response");
      return CreateServiceRequestBidModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> putServiceRequestBidsApproval(String bidId, dynamic params) async {
    try {
      dynamic response = await _serviceRequestApiService.putServiceRequestBidsApproval(bidId, params);
      log("ServiceRequestBidsApproval update details from service request repo: $response");
      return CreateServiceRequestBidModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
