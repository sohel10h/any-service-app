import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/category_api_service.dart';
import 'package:service_la/data/implementation/category_information.dart';
import 'package:service_la/data/model/network/category_service_model.dart';
import 'package:service_la/data/model/network/service_category_response_model.dart';
import 'package:service_la/data/model/network/category_best_seller_service_model.dart';
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

  Future<dynamic> getCategoryBestSellersServices(String categoryId, {Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _categoryApiService.getCategoryBestSellersServices(categoryId, queryParams: queryParams);
      log("CategoryBestSellersServices get details from category repo: $response");
      return CategoryBestSellerServiceModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getCategoryServices(String categoryId, {Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _categoryApiService.getCategoryServices(categoryId, queryParams: queryParams);
      log("CategoryServices get details from category repo: $response");
      return CategoryServiceModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
