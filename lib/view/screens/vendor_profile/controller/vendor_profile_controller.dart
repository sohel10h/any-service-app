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
import 'package:service_la/data/model/network/service_request_me_model.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bid_list.dart';
import 'package:service_la/data/model/network/service_request_bid_provider_model.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_requests.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_request_list.dart';

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
  Rx<ServiceRequestBidProviderModel> serviceRequestBidProvider = ServiceRequestBidProviderModel().obs;
  RxList<ServiceRequestBid> serviceRequestBids = <ServiceRequestBid>[].obs;
  RxBool isLoadingServiceRequestBids = false.obs;
  RxBool isLoadingMoreServiceRequestBids = false.obs;
  int currentPageServiceRequestBids = 1;
  int totalPagesServiceRequestBids = 1;
  final ScrollController scrollControllerServiceRequestBids = ScrollController();
  Rxn<ServiceRequestMeModel> serviceRequestMeModel = Rxn<ServiceRequestMeModel>();
  RxList<ServiceRequestMe> serviceRequests = <ServiceRequestMe>[].obs;
  RxBool isLoadingServiceRequests = false.obs;
  RxBool isLoadingMoreServiceRequests = false.obs;
  int currentPageServiceRequests = 1;
  int totalPagesServiceRequests = 1;
  final ScrollController scrollControllerServiceRequests = ScrollController();
  final Rxn<ServiceRequestStatus> selectedServiceRequestStatus = Rxn<ServiceRequestStatus>();
  RxBool isDropdownDisabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addViews();
    _initTabCounts();
    _addScrollListenerRequestBids();
    _getServiceServiceRequestBids(isRefresh: true);
    _getServicesMe();
    _addScrollListenerServiceRequests();
    _getServiceRequestsMe(isRefresh: true);
  }

  void goToServiceDetailsScreen(String serviceRequestId) => Get.toNamed(
        AppRoutes.serviceRequestDetailsScreen,
        arguments: {"serviceRequestId": serviceRequestId},
      );

  void _addScrollListenerServiceRequests() {
    scrollControllerServiceRequests.addListener(() {
      if (!scrollControllerServiceRequests.hasClients) return;
      if (scrollControllerServiceRequests.position.pixels >= scrollControllerServiceRequests.position.maxScrollExtent - 100) {
        _loadNextPageServiceRequests();
      }
    });
  }

  Future<void> _loadNextPageServiceRequests() async {
    if (currentPageServiceRequests < totalPagesServiceRequests && !isLoadingMoreServiceRequests.value) {
      isLoadingMoreServiceRequests.value = true;
      currentPageServiceRequests++;
      await _getServiceRequestsMe();
    }
  }

  Future<void> refreshServiceRequestsMe({bool isRefresh = false, bool isLoadingStatus = false, bool isLoadingEmpty = false}) async {
    await _getServiceRequestsMe(isRefresh: isRefresh, isLoadingStatus: isLoadingStatus, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getServiceRequestsMe({bool isRefresh = false, bool isLoadingStatus = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesServiceRequests = 1;
    if (isRefresh || isLoadingStatus) {
      currentPageServiceRequests = 1;
      serviceRequests.clear();
    }
    if (currentPageServiceRequests > totalPagesServiceRequests) return;
    if (isRefresh || isLoadingStatus || isLoadingEmpty) {
      isLoadingServiceRequests.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        'page': currentPageServiceRequests,
      };
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
          serviceRequestMeModel.value = serviceRequestMe;
          final data = serviceRequestMe.serviceRequestMeData?.serviceRequests ?? [];
          if (isRefresh || isLoadingStatus) {
            serviceRequests.assignAll(data);
          } else {
            serviceRequests.addAll(data);
          }
          currentPageServiceRequests = serviceRequestMe.serviceRequestMeData?.meta?.page ?? currentPageServiceRequests;
          totalPagesServiceRequests = serviceRequestMe.serviceRequestMeData?.meta?.totalPages ?? totalPagesServiceRequests;
          tabsCounts.value = [
            serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
            serviceMeDataList.length,
            serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
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
              final data = retryResponse.serviceRequestMeData?.serviceRequests ?? [];
              if (isRefresh || isLoadingStatus) {
                serviceRequests.assignAll(data);
              } else {
                serviceRequests.addAll(data);
              }
              currentPageServiceRequests = retryResponse.serviceRequestMeData?.meta?.page ?? currentPageServiceRequests;
              totalPagesServiceRequests = retryResponse.serviceRequestMeData?.meta?.totalPages ?? totalPagesServiceRequests;
              tabsCounts.value = [
                serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
                serviceMeDataList.length,
                serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
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
      isLoadingMoreServiceRequests.value = false;
    }
  }

  void _addScrollListenerRequestBids() {
    scrollControllerServiceRequestBids.addListener(() {
      if (!scrollControllerServiceRequestBids.hasClients) return;
      if (scrollControllerServiceRequestBids.position.pixels >= scrollControllerServiceRequestBids.position.maxScrollExtent - 100) {
        _loadNextPageRequestBids();
      }
    });
  }

  Future<void> _loadNextPageRequestBids() async {
    if (currentPageServiceRequestBids < totalPagesServiceRequestBids && !isLoadingMoreServiceRequestBids.value) {
      isLoadingMoreServiceRequestBids.value = true;
      currentPageServiceRequestBids++;
      await _getServiceServiceRequestBids();
    }
  }

  Future<void> refreshServiceRequestBids({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getServiceServiceRequestBids(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getServiceServiceRequestBids({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesServiceRequestBids = 1;
    if (isRefresh) {
      currentPageServiceRequestBids = 1;
      serviceRequestBids.clear();
    }
    if (currentPageServiceRequestBids > totalPagesServiceRequestBids) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingServiceRequestBids.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        'page': currentPageServiceRequestBids,
      };
      var response = await _vendorRepo.getServiceRequestBidsProvider(queryParams: queryParams);
      if (response is String) {
        log("ServiceRequestBids get failed from controller response: $response");
      } else {
        ServiceRequestBidProviderModel serviceRequestBid = response as ServiceRequestBidProviderModel;
        if (serviceRequestBid.status == 200 || serviceRequestBid.status == 201) {
          serviceRequestBidProvider.value = serviceRequestBid;
          final data = serviceRequestBid.serviceRequestBidData?.serviceRequestBids ?? [];
          if (isRefresh) {
            serviceRequestBids.assignAll(data);
          } else {
            serviceRequestBids.addAll(data);
          }
          currentPageServiceRequestBids = serviceRequestBid.serviceRequestBidData?.meta?.page ?? currentPageServiceRequestBids;
          totalPagesServiceRequestBids = serviceRequestBid.serviceRequestBidData?.meta?.totalPages ?? totalPagesServiceRequestBids;
          tabsCounts.value = [
            serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
            serviceMeDataList.length,
            serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
            0,
          ];
        } else {
          if (serviceRequestBid.status == 401 ||
              (serviceRequestBid.errors != null &&
                  serviceRequestBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _vendorRepo.getServiceRequestBidsProvider(queryParams: queryParams),
            );
            if (retryResponse is ServiceRequestBidProviderModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.serviceRequestBidData?.serviceRequestBids ?? [];
              if (isRefresh) {
                serviceRequestBids.assignAll(data);
              } else {
                serviceRequestBids.addAll(data);
              }
              currentPageServiceRequestBids = retryResponse.serviceRequestBidData?.meta?.page ?? currentPageServiceRequestBids;
              totalPagesServiceRequestBids = retryResponse.serviceRequestBidData?.meta?.totalPages ?? totalPagesServiceRequestBids;
              tabsCounts.value = [
                serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
                serviceMeDataList.length,
                serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
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
      isLoadingMoreServiceRequestBids.value = false;
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
            serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
            serviceMeDataList.length,
            serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
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
                serviceRequestBidProvider.value.serviceRequestBidData?.meta?.totalItems ?? 0,
                serviceMeDataList.length,
                serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
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
        onRefresh: () => refreshServiceRequestBids(isRefresh: true, isLoadingEmpty: true),
        child: CustomScrollView(
          controller: scrollControllerServiceRequestBids,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            VendorProfileBids(),
            VendorProfileBidList(),
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
        onRefresh: () => refreshServiceRequestsMe(isRefresh: true, isLoadingEmpty: true),
        child: CustomScrollView(
          controller: scrollControllerServiceRequests,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            VendorProfileServiceRequests(),
            VendorProfileServiceRequestList(),
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
