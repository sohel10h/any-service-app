import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/data/repository/vendor_repo.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/data/model/network/service_request_me_model.dart';
import 'package:service_la/data/model/network/common/service_review_model.dart';
import 'package:service_la/data/model/network/vendor_review_response_model.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/data/model/network/service_request_bid_provider_model.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class VendorProfileController extends GetxController with GetTickerProviderStateMixin {
  Rxn<String>? userId = Rxn(null);
  LandingController landingController = Get.find<LandingController>();
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  RxList<String> tabs = <String>[].obs;
  final RxList<int> tabsCounts = <int>[].obs;
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxList<ServiceMeData> serviceMeDataList = <ServiceMeData>[].obs;
  RxBool isLoadingServices = false.obs;
  final VendorRepo _vendorRepo = VendorRepo();
  Rxn<ServiceRequestBidProviderModel> serviceRequestBidProvider = Rxn<ServiceRequestBidProviderModel>();
  RxList<ServiceRequestBid> serviceRequestBids = <ServiceRequestBid>[].obs;
  RxBool isLoadingServiceRequestBids = false.obs;
  RxBool isLoadingMoreServiceRequestBids = false.obs;
  int currentPageServiceRequestBids = 1;
  int totalPagesServiceRequestBids = 1;
  Rxn<ServiceRequestMeModel> serviceRequestMeModel = Rxn<ServiceRequestMeModel>();
  RxList<ServiceRequestMe> serviceRequests = <ServiceRequestMe>[].obs;
  RxBool isLoadingServiceRequests = false.obs;
  RxBool isLoadingMoreServiceRequests = false.obs;
  int currentPageServiceRequests = 1;
  int totalPagesServiceRequests = 1;
  Rxn<VendorReviewResponseModel> vendorReviewResponse = Rxn<VendorReviewResponseModel>();
  RxList<ServiceReviewModel> vendorReviews = <ServiceReviewModel>[].obs;
  RxBool isLoadingVendorReviews = false.obs;
  RxBool isLoadingMoreVendorReviews = false.obs;
  int currentPageVendorReviews = 1;
  int totalPagesVendorReviews = 1;
  final Rxn<ServiceRequestStatus> selectedServiceRequestStatus = Rxn<ServiceRequestStatus>();
  RxBool isDropdownDisabled = false.obs;
  TabController? tabController;

  @override
  void onInit() {
    _getArguments();
    _initTabViews();
    _initTabCounts();
    _setupTabController();
    super.onInit();
  }

  @override
  void onReady() {
    refreshAll();
    super.onReady();
  }

  void loadProfile(String? id) {
    userId?.value = id;
    vendorReviewResponse.value = null;
    _initTabViews();
    _initTabCounts();
    _setupTabController();
    refreshAll();
  }

  Future<void> refreshAll() async {
    await _getAdminUser();
    await _getServices();
  }

  Future<void> _getServices() async {
    totalPagesVendorReviews = 1;
    if (userId?.value == null) {
      await _getServiceServiceRequestBids(isRefresh: true);
      await _getServicesMe();
      await _getServiceRequestsMe(isRefresh: true);
      await _getVendorReviews(isRefresh: true);
    } else {
      await _getServicesMe();
      await _getVendorReviews(isRefresh: true);
    }
  }

  Future<void> _getAdminUser() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppDIController.refreshAdminUser(userId: userId?.value);
    });
  }

  void goToServiceDetailsScreen(String serviceRequestId) {
    Get.delete<ServiceRequestDetailsController>();
    Get.toNamed(
      AppRoutes.serviceRequestDetailsScreen,
      arguments: {"serviceRequestId": serviceRequestId},
    );
  }

  Future<void> loadNextPageVendorReviews() async {
    if (currentPageVendorReviews < totalPagesVendorReviews && !isLoadingMoreVendorReviews.value) {
      isLoadingMoreVendorReviews.value = true;
      currentPageVendorReviews++;
      await _getVendorReviews();
    }
  }

  Future<void> refreshVendorReviews({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getVendorReviews(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getVendorReviews({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesVendorReviews = 1;
    if (isRefresh) {
      currentPageVendorReviews = 1;
      vendorReviews.clear();
    }
    if (currentPageVendorReviews > totalPagesVendorReviews) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingVendorReviews.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        ApiParams.page: currentPageVendorReviews,
      };
      var response = await _vendorRepo.getVendorReviews(userId?.value ?? AppDIController.loginUserId, queryParams: queryParams);
      if (response is String) {
        log("VendorReviews get failed from controller response: $response");
      } else {
        VendorReviewResponseModel vendorReview = response as VendorReviewResponseModel;
        if (vendorReview.status == 200 || vendorReview.status == 201) {
          if (vendorReviewResponse.value == null) {
            vendorReviewResponse.value = vendorReview;
          }
          final data = vendorReview.vendorReviewData?.serviceReviews ?? [];
          if (isRefresh) {
            vendorReviews.assignAll(data);
          } else {
            vendorReviews.addAll(data);
          }
          currentPageVendorReviews = vendorReview.vendorReviewData?.meta?.page ?? currentPageVendorReviews;
          totalPagesVendorReviews = vendorReview.vendorReviewData?.meta?.totalPages ?? totalPagesVendorReviews;
          if (userId?.value == null) {
            tabsCounts.value = [
              serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
              serviceMeDataList.length,
              serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          } else {
            tabsCounts.value = [
              serviceMeDataList.length,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          }
        } else {
          if (vendorReview.status == 401 ||
              (vendorReview.errors != null &&
                  vendorReview.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _vendorRepo.getVendorReviews(userId?.value ?? AppDIController.loginUserId, queryParams: queryParams),
            );
            if (retryResponse is VendorReviewResponseModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              if (vendorReviewResponse.value == null) {
                vendorReviewResponse.value = retryResponse;
              }
              final data = retryResponse.vendorReviewData?.serviceReviews ?? [];
              if (isRefresh) {
                vendorReviews.assignAll(data);
              } else {
                vendorReviews.addAll(data);
              }
              currentPageVendorReviews = retryResponse.vendorReviewData?.meta?.page ?? currentPageVendorReviews;
              totalPagesVendorReviews = retryResponse.vendorReviewData?.meta?.totalPages ?? totalPagesVendorReviews;
              if (userId?.value == null) {
                tabsCounts.value = [
                  serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
                  serviceMeDataList.length,
                  serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              } else {
                tabsCounts.value = [
                  serviceMeDataList.length,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              }
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("VendorReviews get failed from controller: ${vendorReview.status}");
          return;
        }
      }
    } catch (e) {
      log("VendorReviews get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingVendorReviews.value = false;
      isLoadingMoreVendorReviews.value = false;
    }
  }

  Future<void> loadNextPageServiceRequests() async {
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
        ApiParams.page: currentPageServiceRequests,
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
          if (serviceRequestMeModel.value == null) {
            serviceRequestMeModel.value = serviceRequestMe;
          }
          final data = serviceRequestMe.serviceRequestMeData?.serviceRequests ?? [];
          if (isRefresh || isLoadingStatus) {
            serviceRequests.assignAll(data);
          } else {
            serviceRequests.addAll(data);
          }
          currentPageServiceRequests = serviceRequestMe.serviceRequestMeData?.meta?.page ?? currentPageServiceRequests;
          totalPagesServiceRequests = serviceRequestMe.serviceRequestMeData?.meta?.totalPages ?? totalPagesServiceRequests;
          if (userId?.value == null) {
            tabsCounts.value = [
              serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
              serviceMeDataList.length,
              serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          } else {
            tabsCounts.value = [
              serviceMeDataList.length,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          }
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
              if (serviceRequestMeModel.value == null) {
                serviceRequestMeModel.value = retryResponse;
              }
              final data = retryResponse.serviceRequestMeData?.serviceRequests ?? [];
              if (isRefresh || isLoadingStatus) {
                serviceRequests.assignAll(data);
              } else {
                serviceRequests.addAll(data);
              }
              currentPageServiceRequests = retryResponse.serviceRequestMeData?.meta?.page ?? currentPageServiceRequests;
              totalPagesServiceRequests = retryResponse.serviceRequestMeData?.meta?.totalPages ?? totalPagesServiceRequests;
              if (userId?.value == null) {
                tabsCounts.value = [
                  serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
                  serviceMeDataList.length,
                  serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              } else {
                tabsCounts.value = [
                  serviceMeDataList.length,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              }
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

  Future<void> loadNextPageRequestBids() async {
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
        ApiParams.page: currentPageServiceRequestBids,
      };
      var response = await _vendorRepo.getServiceRequestBidsProvider(queryParams: queryParams);
      if (response is String) {
        log("ServiceRequestBids get failed from controller response: $response");
      } else {
        ServiceRequestBidProviderModel serviceRequestBid = response as ServiceRequestBidProviderModel;
        if (serviceRequestBid.status == 200 || serviceRequestBid.status == 201) {
          if (serviceRequestBidProvider.value == null) {
            serviceRequestBidProvider.value = serviceRequestBid;
          }
          final data = serviceRequestBid.serviceRequestBidData?.serviceRequestBids ?? [];
          if (isRefresh) {
            serviceRequestBids.assignAll(data);
          } else {
            serviceRequestBids.addAll(data);
          }
          currentPageServiceRequestBids = serviceRequestBid.serviceRequestBidData?.meta?.page ?? currentPageServiceRequestBids;
          totalPagesServiceRequestBids = serviceRequestBid.serviceRequestBidData?.meta?.totalPages ?? totalPagesServiceRequestBids;
          if (userId?.value == null) {
            tabsCounts.value = [
              serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
              serviceMeDataList.length,
              serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          } else {
            tabsCounts.value = [
              serviceMeDataList.length,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          }
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
              if (serviceRequestBidProvider.value == null) {
                serviceRequestBidProvider.value = retryResponse;
              }
              final data = retryResponse.serviceRequestBidData?.serviceRequestBids ?? [];
              if (isRefresh) {
                serviceRequestBids.assignAll(data);
              } else {
                serviceRequestBids.addAll(data);
              }
              currentPageServiceRequestBids = retryResponse.serviceRequestBidData?.meta?.page ?? currentPageServiceRequestBids;
              totalPagesServiceRequestBids = retryResponse.serviceRequestBidData?.meta?.totalPages ?? totalPagesServiceRequestBids;
              if (userId?.value == null) {
                tabsCounts.value = [
                  serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
                  serviceMeDataList.length,
                  serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              } else {
                tabsCounts.value = [
                  serviceMeDataList.length,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              }
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
    serviceMeDataList.clear();
    isLoadingServices.value = true;
    try {
      var response = await _serviceRepo.getServicesMe();
      if (response is String) {
        log("ServicesMe get failed from controller response: $response");
      } else {
        ServiceMeModel serviceMe = response as ServiceMeModel;
        if (serviceMe.status == 200 || serviceMe.status == 201) {
          serviceMeDataList.value = serviceMe.serviceMeData ?? [];
          if (userId?.value == null) {
            tabsCounts.value = [
              serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
              serviceMeDataList.length,
              serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          } else {
            tabsCounts.value = [
              serviceMeDataList.length,
              vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
            ];
          }
        } else {
          if (serviceMe.status == 401 ||
              (serviceMe.errors != null &&
                  serviceMe.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRepo.getServicesMe());
            if (retryResponse is ServiceMeModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceMeDataList.value = retryResponse.serviceMeData ?? [];
              if (userId?.value == null) {
                tabsCounts.value = [
                  serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0,
                  serviceMeDataList.length,
                  serviceRequestMeModel.value?.serviceRequestMeData?.meta?.totalItems ?? 0,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              } else {
                tabsCounts.value = [
                  serviceMeDataList.length,
                  vendorReviewResponse.value?.vendorReviewData?.meta?.totalItems ?? 0,
                ];
              }
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

  void _setupTabController() {
    try {
      if (tabController != null) {
        tabController?.dispose();
      }
    } catch (_) {}
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    if (tabController != null) {
      tabController?.addListener(() {
        selectedTabIndex.value = (tabController?.index ?? 0);
      });
    }
    log("TabController: ${tabController?.length}");
  }

  void _initTabCounts() {
    if (userId?.value == null) {
      tabsCounts.value = [0, 0, 0, 0];
    } else {
      tabsCounts.value = [0, 0];
    }
  }

  void _initTabViews() {
    if (userId?.value == null) {
      tabs.value = ["All Bids", "Services", "Requests", "Reviews"];
    } else {
      tabs.value = ["Services", "Reviews"];
    }
  }

  void _getArguments() {
    if (Get.arguments != null) {
      userId?.value = Get.arguments["userId"] == AppDIController.loginUserId ? null : Get.arguments["userId"];
    }
    log("VendorProfileUserId: ${userId?.value}");
  }

  @override
  void onClose() {
    if (tabController != null) {
      tabController?.dispose();
    }
    super.onClose();
  }
}
