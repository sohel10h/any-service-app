import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/data/model/network/best_selling_service_model.dart';

class BestSellingServicesController extends GetxController {
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxBool isLoadingBestSellingServices = false.obs;
  RxList<ServiceModel> bestSellingServices = <ServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getBestSellingServices();
  }

  void goToCreateServiceDetailsScreen(String serviceId) => Get.toNamed(
        AppRoutes.createServiceDetailsScreen,
        arguments: {"serviceId": serviceId},
      );

  Future<void> refreshBestSellingServices() async {
    await _getBestSellingServices();
  }

  Future<void> _getBestSellingServices() async {
    isLoadingBestSellingServices.value = true;
    try {
      var response = await _serviceRepo.getBestSellingServices();
      if (response is String) {
        log("BestSellingServices get failed from controller response: $response");
      } else {
        BestSellingServiceModel sellingService = response as BestSellingServiceModel;
        if (sellingService.status == 200 || sellingService.status == 201) {
          bestSellingServices.value = sellingService.bestSellingServices ?? [];
        } else {
          if (sellingService.status == 401 ||
              (sellingService.errors != null &&
                  sellingService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRepo.getBestSellingServices());
            if (retryResponse is BestSellingServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              bestSellingServices.value = retryResponse.bestSellingServices ?? [];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("BestSellingServices get failed from controller: ${sellingService.status}");
          return;
        }
      }
    } catch (e) {
      log("BestSellingServices get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingBestSellingServices.value = false;
    }
  }
}
