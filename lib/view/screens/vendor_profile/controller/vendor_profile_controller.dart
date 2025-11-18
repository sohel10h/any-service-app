import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/data/model/local/vendor_profile_bid_model.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services.dart';

class VendorProfileController extends GetxController {
  LandingController landingController = Get.find<LandingController>();
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Services", "Completed", "Reviews"];
  final List<int> tabsCounts = [5, 1, 2, 0];
  List<Widget> tabViews = [];
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxList<ServiceMeData> serviceMeDataList = <ServiceMeData>[].obs;
  RxBool isLoadingServices = false.obs;
  final bids = [
    VendorProfileBidModel(
      title: 'Deep Home Cleaning Service',
      customer: 'John Davis',
      location: 'Downtown',
      time: '2 hours ago',
      status: 'Active',
      amount: '\$89',
      statusColor: AppColors.containerFFEDD4,
      statusTextColor: AppColors.textCA3500,
    ),
    VendorProfileBidModel(
      title: 'Office Cleaning - Weekly',
      customer: 'Tech Corp',
      location: 'Financial District',
      time: '5 hours ago',
      status: 'Active',
      amount: '\$150',
      statusColor: AppColors.containerFFEDD4,
      statusTextColor: AppColors.textCA3500,
    ),
    VendorProfileBidModel(
      title: 'Move-in Cleaning',
      customer: 'Emily Chen',
      location: 'Mission Bay',
      time: '1 day ago',
      status: 'Pending',
      amount: '\$120',
      statusColor: AppColors.containerF3F4F6,
      statusTextColor: AppColors.text364153,
    ),
    VendorProfileBidModel(
      title: 'Post-Construction Cleaning',
      customer: 'BuildRight LLC',
      location: 'SOMA',
      time: '2 days ago',
      status: 'Accepted',
      amount: '\$200',
      statusColor: AppColors.containerDCFCE7,
      statusTextColor: AppColors.text008236,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _addViews();
    _getServicesMe();
  }

  Future<void> _getServicesMe() async {
    isLoadingServices.value = true;
    try {
      var response = await _serviceRepo.getServicesMe();
      if (response is String) {
        log("ServicesMe get failed from controller response: $response");
      } else {
        ServiceMeModel serviceMe = response as ServiceMeModel;
        if (serviceMe.status == 200 || serviceMe.status == 201) {
          serviceMeDataList.value = serviceMe.serviceMeData ?? [];
        } else {
          if (serviceMe.status == 401 ||
              (serviceMe.errors != null &&
                  serviceMe.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRepo.getServicesMe());
            if (retryResponse is ServiceMeModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceMeDataList.value = retryResponse.serviceMeData ?? [];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServicesMe get failed from controller: ${serviceMe.status}");
          return;
        }
      }
    } catch (e) {
      log("ServicesMe get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServices.value = false;
    }
  }

  void goToCreateServiceDetailsScreen(String serviceId) => Get.toNamed(
        AppRoutes.createServiceDetailsScreen,
        arguments: {"serviceId": serviceId},
      );

  Future<void> refreshAdminServices() async {
    await _getServicesMe();
  }

  void goToCreateServiceScreen() async {
    final status = await Get.toNamed(AppRoutes.createServiceScreen);
    if (status == true) {
      await Future.delayed(Duration(milliseconds: 2000));
      await _getServicesMe();
    }
  }

  void _addViews() {
    tabViews = [
      RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: refreshAdminServices,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            VendorProfileBids(),
          ],
        ),
      ),
      RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: refreshAdminServices,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            VendorProfileServices(),
          ],
        ),
      ),
      RefreshIndicator(
        onRefresh: refreshAdminServices,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Text("Tab 3")),
          ],
        ),
      ),
      RefreshIndicator(
        onRefresh: refreshAdminServices,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Text("Tab 4")),
          ],
        ),
      ),
    ];
  }
}
