import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/category_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/data/model/network/common/category_model.dart';
import 'package:service_la/data/model/network/category_service_model.dart';
import 'package:service_la/data/model/network/category_best_seller_service_model.dart';

class ServiceCategoryController extends GetxController {
  String categoryId = "";
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final CategoryRepo _categoryRepo = CategoryRepo();
  RxList<CategoryModel> serviceCategories = <CategoryModel>[].obs;
  RxBool isLoadingServiceCategories = false.obs;
  RxBool isLoadingMoreServiceCategories = false.obs;
  int currentPageServiceCategories = 1;
  int totalPagesServiceCategories = 1;
  RxList<ServiceModel> categoryBestSellersServices = <ServiceModel>[].obs;
  RxBool isLoadingCategoryBestSellersServices = false.obs;
  RxList<ServiceModel> categoryServices = <ServiceModel>[].obs;
  RxBool isLoadingCategoryServices = false.obs;
  RxBool isLoadingMoreCategoryServices = false.obs;
  int currentPageCategoryServices = 1;
  int totalPagesCategoryServices = 1;

  @override
  void onInit() {
    _getArguments();
    _getCategoryBestSellersServices();
    _getCategoryServices(isRefresh: true);
    super.onInit();
  }

  void goToBestSellingServicesScreen() => Get.toNamed(AppRoutes.bestSellingServicesScreen);

  void goToNotificationsScreen() => Get.toNamed(AppRoutes.notificationsScreen);

  void goToChatsListScreen() => Get.toNamed(AppRoutes.chatsListScreen);

  void goToSearchScreen(String heroTag) => Get.toNamed(
        AppRoutes.searchScreen,
        arguments: {"heroTag": heroTag},
      );

  void goToCreateServiceDetailsScreen(String serviceId) => Get.toNamed(
        AppRoutes.createServiceDetailsScreen,
        arguments: {"serviceId": serviceId},
      );

  Future<void> refreshApiCall() async {
    _getCategoryBestSellersServices();
    _getCategoryServices(isRefresh: true);
  }

  Future<void> loadNextPageCategoryServices() async {
    if (currentPageCategoryServices < totalPagesServiceCategories && !isLoadingMoreCategoryServices.value) {
      isLoadingMoreCategoryServices.value = true;
      currentPageCategoryServices++;
      await _getCategoryServices();
    }
  }

  Future<void> refreshCategoryServices({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getCategoryServices(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getCategoryServices({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesCategoryServices = 1;
    if (isRefresh) {
      currentPageCategoryServices = 1;
      serviceCategories.clear();
    }
    if (currentPageCategoryServices > totalPagesCategoryServices) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingCategoryServices.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        ApiParams.page: currentPageCategoryServices,
      };
      var response = await _categoryRepo.getCategoryServices(categoryId, queryParams: queryParams);
      if (response is String) {
        log("CategoryServices get failed from controller response: $response");
      } else {
        CategoryServiceModel categoryService = response as CategoryServiceModel;
        if (categoryService.status == 200 || categoryService.status == 201) {
          final data = categoryService.categoryService?.services ?? [];
          if (isRefresh) {
            categoryServices.assignAll(data);
          } else {
            categoryServices.addAll(data);
          }
          currentPageCategoryServices = categoryService.categoryService?.meta?.page ?? currentPageCategoryServices;
          totalPagesCategoryServices = categoryService.categoryService?.meta?.totalPages ?? totalPagesCategoryServices;
        } else {
          if (categoryService.status == 401 ||
              (categoryService.errors != null &&
                  categoryService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _categoryRepo.getCategoryServices(categoryId, queryParams: queryParams),
            );
            if (retryResponse is CategoryServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.categoryService?.services ?? [];
              if (isRefresh) {
                categoryServices.assignAll(data);
              } else {
                categoryServices.addAll(data);
              }
              currentPageCategoryServices = retryResponse.categoryService?.meta?.page ?? currentPageCategoryServices;
              totalPagesCategoryServices = retryResponse.categoryService?.meta?.totalPages ?? totalPagesCategoryServices;
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("CategoryServices get failed from controller: ${categoryService.status}");
          return;
        }
      }
    } catch (e) {
      log("CategoryServices get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingCategoryServices.value = false;
      isLoadingMoreCategoryServices.value = false;
    }
  }

  Future<void> refreshCategoryBestSellersServices() async {
    await _getCategoryBestSellersServices();
  }

  Future<void> _getCategoryBestSellersServices() async {
    isLoadingCategoryBestSellersServices.value = true;
    try {
      var response = await _categoryRepo.getCategoryBestSellersServices(categoryId);
      if (response is String) {
        log("CategoryBestSellersServices get failed from controller response: $response");
      } else {
        CategoryBestSellerServiceModel categoryBestSellerService = response as CategoryBestSellerServiceModel;
        if (categoryBestSellerService.status == 200 || categoryBestSellerService.status == 201) {
          categoryBestSellersServices.value = categoryBestSellerService.services ?? [];
        } else {
          if (categoryBestSellerService.status == 401 ||
              (categoryBestSellerService.errors != null &&
                  categoryBestSellerService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _categoryRepo.getCategoryBestSellersServices(categoryId),
            );
            if (retryResponse is CategoryBestSellerServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              categoryBestSellersServices.value = retryResponse.services ?? [];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("CategoryBestSellersServices get failed from controller: ${categoryBestSellerService.status}");
          return;
        }
      }
    } catch (e) {
      log("CategoryBestSellersServices get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingCategoryBestSellersServices.value = false;
    }
  }

  void _getArguments() {
    if (Get.arguments != null) {
      categoryId = Get.arguments["categoryId"] ?? "";
    }
  }
}
