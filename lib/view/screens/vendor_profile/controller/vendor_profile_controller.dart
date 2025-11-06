import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/data/model/network/service_model.dart';
import 'package:service_la/services/api_service/api_service.dart';
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
  final AdminRepo _adminRepo = AdminRepo();
  RxBool isLoadingServices = false.obs;
  RxList<ServiceData> services = <ServiceData>[].obs;
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
    _getAdminServices();
  }

  void goToCreateServiceDetailsScreen() => Get.toNamed(AppRoutes.createServiceDetailsScreen);

  Future<void> refreshAdminServices() async {
    await _getAdminServices();
  }

  Future<void> _getAdminServices() async {
    isLoadingServices.value = true;
    try {
      var response = await _adminRepo.getAdminServices();

      if (response is String) {
        log("AdminServices get failed from controller response: $response");
      } else {
        ServiceModel service = response as ServiceModel;
        if (service.status == 200 || service.status == 201) {
          services.value = service.data?.services ?? [];
        } else {
          if (service.status == 401 ||
              (service.errors != null &&
                  service.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _adminRepo.getAdminServices());
            if (retryResponse is ServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              services.value = retryResponse.data?.services ?? [];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("AdminServices get failed from controller: ${service.status}");
          return;
        }
      }
    } catch (e) {
      log("AdminServices get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServices.value = false;
    }
  }

  void goToCreateServiceScreen() async {
    final status = await Get.toNamed(AppRoutes.createServiceScreen);
    if (status == true) {
      await Future.delayed(Duration(milliseconds: 2000));
      await _getAdminServices();
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
