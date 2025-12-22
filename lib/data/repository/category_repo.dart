import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/category_api_service.dart';
import 'package:service_la/data/implementation/category_information.dart';
import 'package:service_la/data/model/network/service_category_response_model.dart';
import 'package:service_la/data/model/network/best_selling_service_category_model.dart';
import 'package:service_la/data/model/network/all_service_category_response_model.dart';

class CategoryRepo {
  final CategoryApiService _categoryApiService = CategoryInformation();

  Future<dynamic> getAllServiceCategories({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _categoryApiService.getAllServiceCategories(queryParams: queryParams);
      log("AllServiceCategories get details from category repo: $response");
      return AllServiceCategoryResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getServiceCategories({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _categoryApiService.getServiceCategories(queryParams: queryParams);
      log("ServiceCategories get details from category repo: $response");
      return ServiceCategoryResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getServicesBestSellersCategories(String categoryId) async {
    try {
      dynamic response = await _categoryApiService.getServicesBestSellersCategories(categoryId);
      log("ServicesBestSellersCategory get details from category repo: $response");
      return BestSellingServiceCategoryModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
