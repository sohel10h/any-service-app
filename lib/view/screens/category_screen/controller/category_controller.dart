import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/common/category_model.dart';
import 'package:service_la/data/model/network/service_category_model.dart';

class CategoryController extends GetxController {
  final AdminRepo _adminRepo = AdminRepo();
  RxList<CategoryModel> serviceCategories = <CategoryModel>[].obs;
  RxBool isLoadingServiceCategories = false.obs;
  RxBool isLoadingMoreServiceCategories = false.obs;
  int currentPageServiceCategories = 1;
  int totalPagesServiceCategories = 1;

  @override
  void onInit() {
    super.onInit();
    _getAdminServiceCategories(isRefresh: true);
  }

  Future<void> loadNextPageAdminServiceCategories() async {
    if (currentPageServiceCategories < totalPagesServiceCategories && !isLoadingMoreServiceCategories.value) {
      isLoadingMoreServiceCategories.value = true;
      currentPageServiceCategories++;
      await _getAdminServiceCategories();
    }
  }

  Future<void> refreshAdminServiceCategories({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getAdminServiceCategories(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getAdminServiceCategories({bool isRefresh = false, bool isLoadingEmpty = false}) async {
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
      var response = await _adminRepo.getAdminServiceCategories(queryParams: queryParams);
      if (response is String) {
        log("ServiceCategories get failed from controller response: $response");
      } else {
        ServiceCategoryModel serviceCategory = response as ServiceCategoryModel;
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
              () => _adminRepo.getAdminServiceCategories(queryParams: queryParams),
            );
            if (retryResponse is ServiceCategoryModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
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
}
