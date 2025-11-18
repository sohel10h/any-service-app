import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/data/repository/vendor_repo.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services.dart';
import 'package:service_la/data/model/network/service_request_bid_provider_model.dart';
import 'package:service_la/data/model/network/websocket/service_request_me_model.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_requests.dart';

class VendorProfileController extends GetxController {
  LandingController landingController = Get.find<LandingController>();
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Services", "Requests", "Reviews"];
  final RxList<int> tabsCounts = <int>[].obs;
  List<Widget> tabViews = [];
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxList<ServiceMeData> serviceMeDataList = <ServiceMeData>[].obs;
  RxBool isLoadingServices = false.obs;
  final VendorRepo _vendorRepo = VendorRepo();
  RxList<ServiceRequestBid> serviceRequestBids = <ServiceRequestBid>[].obs;
  RxBool isLoadingServiceRequestBids = false.obs;
  RxList<ServiceRequestMe> serviceRequests = <ServiceRequestMe>[].obs;
  RxBool isLoadingServiceRequests = false.obs;
  final Rxn<ServiceRequestStatus> selectedServiceRequestStatus = Rxn<ServiceRequestStatus>();
  RxBool isDropdownDisabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addViews();
    _initTabCounts();
    _getServiceRequestBids();
    _getServicesMe();
    _getServiceRequestsMe();
  }

  Future<void> refreshServiceRequestsMe({bool isRefresh = false}) async {
    await _getServiceRequestsMe(isRefresh: isRefresh);
  }

  Future<void> _getServiceRequestsMe({bool isRefresh = false}) async {
    isLoadingServiceRequests.value = true;
    try {
      Map<String, dynamic> queryParams = {};
      if (!isRefresh) {
        if (selectedServiceRequestStatus.value != null) {
          queryParams['status'] = selectedServiceRequestStatus.value?.typeValue ?? 1;
        }
      } else {
        selectedServiceRequestStatus.value = null;
      }
      var response = await _vendorRepo.getServiceRequestsMe(queryParams: queryParams);
      if (response is String) {
        log("ServiceRequestsMe get failed from controller response: $response");
      } else {
        ServiceRequestMeModel serviceRequestMe = response as ServiceRequestMeModel;
        if (serviceRequestMe.status == 200 || serviceRequestMe.status == 201) {
          serviceRequests.value = serviceRequestMe.serviceRequestMeData?.serviceRequests ?? [];
          tabsCounts.value = [
            serviceRequestBids.length,
            serviceMeDataList.length,
            serviceRequests.length,
            0,
          ];
        } else {
          if (serviceRequestMe.status == 401 ||
              (serviceRequestMe.errors != null &&
                  serviceRequestMe.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _vendorRepo.getServiceRequestsMe(queryParams: queryParams),
            );
            if (retryResponse is ServiceRequestMeModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceRequests.value = retryResponse.serviceRequestMeData?.serviceRequests ?? [];
              tabsCounts.value = [
                serviceRequestBids.length,
                serviceMeDataList.length,
                serviceRequests.length,
                0,
              ];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServiceRequestsMe get failed from controller: ${serviceRequestMe.status}");
          return;
        }
      }
    } catch (e) {
      log("ServiceRequestsMe get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequests.value = false;
    }
  }

  Future<void> refreshServiceRequestBids() async {
    await _getServiceRequestBids();
  }

  Future<void> _getServiceRequestBids() async {
    isLoadingServiceRequestBids.value = true;
    try {
      var response = await _vendorRepo.getServiceRequestBidsProvider();
      if (response is String) {
        log("ServiceRequestBids get failed from controller response: $response");
      } else {
        ServiceRequestBidProviderModel serviceRequestBid = response as ServiceRequestBidProviderModel;
        if (serviceRequestBid.status == 200 || serviceRequestBid.status == 201) {
          serviceRequestBids.value = serviceRequestBid.serviceRequestBidData?.serviceRequestBids ?? [];
          tabsCounts.value = [
            serviceRequestBids.length,
            serviceMeDataList.length,
            serviceRequests.length,
            0,
          ];
        } else {
          if (serviceRequestBid.status == 401 ||
              (serviceRequestBid.errors != null &&
                  serviceRequestBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _vendorRepo.getServiceRequestBidsProvider());
            if (retryResponse is ServiceRequestBidProviderModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceRequestBids.value = retryResponse.serviceRequestBidData?.serviceRequestBids ?? [];
              tabsCounts.value = [
                serviceRequestBids.length,
                serviceMeDataList.length,
                serviceRequests.length,
                0,
              ];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServiceRequestBids get failed from controller: ${serviceRequestBid.status}");
          return;
        }
      }
    } catch (e) {
      log("ServiceRequestBids get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequestBids.value = false;
    }
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
          tabsCounts.value = [
            serviceRequestBids.length,
            serviceMeDataList.length,
            serviceRequests.length,
            0,
          ];
        } else {
          if (serviceMe.status == 401 ||
              (serviceMe.errors != null &&
                  serviceMe.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRepo.getServicesMe());
            if (retryResponse is ServiceMeModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceMeDataList.value = retryResponse.serviceMeData ?? [];
              tabsCounts.value = [
                serviceRequestBids.length,
                serviceMeDataList.length,
                serviceRequests.length,
                0,
              ];
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

  Future<void> refreshServicesMe() async {
    await _getServicesMe();
  }

  void goToCreateServiceScreen() async {
    final status = await Get.toNamed(AppRoutes.createServiceScreen);
    if (status == true) {
      await Future.delayed(Duration(milliseconds: 2000));
      await _getServicesMe();
    }
  }

  void _initTabCounts() => tabsCounts.value = [0, 0, 0, 0];

  void _addViews() {
    tabViews = [
      RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: refreshServiceRequestBids,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            VendorProfileBids(),
          ],
        ),
      ),
      RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: refreshServicesMe,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            VendorProfileServices(),
          ],
        ),
      ),
      RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: () => refreshServiceRequestsMe(isRefresh: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            VendorProfileServiceRequests(),
          ],
        ),
      ),
      RefreshIndicator(
        onRefresh: refreshServiceRequestBids,
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
