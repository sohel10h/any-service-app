import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/category_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/data/model/network/common/category_model.dart';
import 'package:service_la/data/model/network/all_service_category_response_model.dart';
import 'package:service_la/data/model/network/best_selling_service_category_model.dart';

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
  RxBool isLoadingServicesBestSellersCategories = false.obs;
  RxList<ServiceModel> bestSellingServices = <ServiceModel>[].obs;

  @override
  void onInit() {
    _getArguments();
    getServicesBestSellersCategories();
    _getAllServiceCategories(isRefresh: true);
    super.onInit();
  }

  void goToCreateServiceDetailsScreen(String serviceId) => Get.toNamed(
        AppRoutes.createServiceDetailsScreen,
        arguments: {"serviceId": serviceId},
      );

  Future<void> getServicesBestSellersCategories() async {
    isLoadingServicesBestSellersCategories.value = true;
    try {
      var response = await _categoryRepo.getServicesBestSellersCategories(categoryId);
      if (response is String) {
        log("ServicesBestSellersCategories get failed from controller response: $response");
      } else {
        BestSellingServiceCategoryModel sellingService = response as BestSellingServiceCategoryModel;
        if (sellingService.status == 200 || sellingService.status == 201) {
          bestSellingServices.value = sellingService.bestSellingServiceCategory?.services ?? [];
        } else {
          if (sellingService.status == 401 ||
              (sellingService.errors != null &&
                  sellingService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _categoryRepo.getServicesBestSellersCategories(categoryId),
            );
            if (retryResponse is BestSellingServiceCategoryModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              bestSellingServices.value = retryResponse.bestSellingServiceCategory?.services ?? [];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServicesBestSellersCategories get failed from controller: ${sellingService.status}");
          return;
        }
      }
    } catch (e) {
      log("ServicesBestSellersCategories get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServicesBestSellersCategories.value = false;
    }
  }

  void goToBestSellingServicesScreen() => Get.toNamed(AppRoutes.bestSellingServicesScreen);

  void goToNotificationsScreen() => Get.toNamed(AppRoutes.notificationsScreen);

  void goToChatsListScreen() => Get.toNamed(AppRoutes.chatsListScreen);

  void goToSearchScreen(String heroTag) => Get.toNamed(
        AppRoutes.searchScreen,
        arguments: {"heroTag": heroTag},
      );

  Future<void> loadNextPageAllServiceCategories() async {
    if (currentPageServiceCategories < totalPagesServiceCategories && !isLoadingMoreServiceCategories.value) {
      isLoadingMoreServiceCategories.value = true;
      currentPageServiceCategories++;
      await _getAllServiceCategories();
    }
  }

  Future<void> refreshAllServiceCategories({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getAllServiceCategories(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getAllServiceCategories({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesServiceCategories = 1;
    if (isRefresh) {
      currentPageServiceCategories = 1;
      serviceCategories.clear();
    }
    if (currentPageServiceCategories > totalPagesServiceCategories) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingServiceCategories.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        'page': currentPageServiceCategories,
      };
      var response = await _categoryRepo.getAllServiceCategories(queryParams: queryParams);
      if (response is String) {
        log("ServiceCategories get failed from controller response: $response");
      } else {
        AllServiceCategoryResponseModel serviceCategory = response as AllServiceCategoryResponseModel;
        if (serviceCategory.status == 200 || serviceCategory.status == 201) {
          final data = serviceCategory.serviceCategory?.categories ?? [];
          if (isRefresh) {
            serviceCategories.assignAll(data);
          } else {
            serviceCategories.addAll(data);
          }
          currentPageServiceCategories = serviceCategory.serviceCategory?.meta?.page ?? currentPageServiceCategories;
          totalPagesServiceCategories = serviceCategory.serviceCategory?.meta?.totalPages ?? totalPagesServiceCategories;
        } else {
          if (serviceCategory.status == 401 ||
              (serviceCategory.errors != null &&
                  serviceCategory.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _categoryRepo.getAllServiceCategories(queryParams: queryParams),
            );
            if (retryResponse is AllServiceCategoryResponseModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.serviceCategory?.categories ?? [];
              if (isRefresh) {
                serviceCategories.assignAll(data);
              } else {
                serviceCategories.addAll(data);
              }
              currentPageServiceCategories = retryResponse.serviceCategory?.meta?.page ?? currentPageServiceCategories;
              totalPagesServiceCategories = retryResponse.serviceCategory?.meta?.totalPages ?? totalPagesServiceCategories;
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServiceCategories get failed from controller: ${serviceCategory.status}");
          return;
        }
      }
    } catch (e) {
      log("ServiceCategories get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceCategories.value = false;
      isLoadingMoreServiceCategories.value = false;
    }
  }

  void _getArguments() {
    if (Get.arguments != null) {
      categoryId = Get.arguments["categoryId"] ?? "";
    }
  }
}
