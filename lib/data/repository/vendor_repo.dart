import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/vendor_api_service.dart';
import 'package:service_la/data/implementation/vendor_information.dart';
import 'package:service_la/data/model/network/service_request_me_model.dart';
import 'package:service_la/data/model/network/vendor_review_response_model.dart';
import 'package:service_la/data/model/network/service_request_bid_provider_model.dart';

class VendorRepo {
  final VendorApiService _vendorApiService = VendorInformation();

  Future<dynamic> getServiceRequestBidsProvider({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _vendorApiService.getServiceRequestBidsProvider(queryParams: queryParams);
      log("ServiceRequestBidsProvider get details from vendor repo: $response");
      return ServiceRequestBidProviderModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getServiceRequestsMe({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _vendorApiService.getServiceRequestsMe(queryParams: queryParams);
      log("ServiceRequestsMe get details from vendor repo: $response");
      return ServiceRequestMeModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getVendorReviews(String userId, {Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _vendorApiService.getVendorReviews(userId, queryParams: queryParams);
      log("VendorReviews get details from vendor repo: $response");
      return VendorReviewResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
