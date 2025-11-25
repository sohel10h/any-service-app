import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/service_api_service.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/data/implementation/service_information.dart';
import 'package:service_la/data/model/network/best_selling_service_model.dart';

class ServiceRepo {
  final ServiceApiService _serviceApiService = ServiceInformation();

  Future<dynamic> getServicesMe() async {
    try {
      dynamic response = await _serviceApiService.getServicesMe();
      log("ServicesMe get details from service repo: $response");
      return ServiceMeModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getBestSellingServices() async {
    try {
      dynamic response = await _serviceApiService.getBestSellingServices();
      log("BestSellingServices get details from service repo: $response");
      return BestSellingServiceModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
