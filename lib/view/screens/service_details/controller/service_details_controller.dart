import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/common/bid_model.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/data/repository/service_request_repo.dart';
import 'package:service_la/data/model/network/service_details_model.dart';
import 'package:service_la/data/model/network/create_service_request_bid_model.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_section.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_shortlisted_bids_section.dart';

class ServiceDetailsController extends GetxController {
  String userId = "";
  final formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  String serviceRequestId = "";
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedFilterIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Shortlisted", "Rejected", "Final Bid"];
  List<CustomScrollView> tabViews = [];
  final RxList<int> tabsCounts = <int>[].obs;
  final List<String> filters = ["Lowest Price", "Top Rated"];
  final ServiceRequestRepo _serviceRequestRepo = ServiceRequestRepo();
  RxBool isLoadingServiceRequestsDetails = false.obs;
  Rx<ServiceDetailsData> serviceDetailsData = ServiceDetailsData().obs;
  RxBool isLoadingCrateBids = false.obs;
  RxBool isLoadingUpdateBids = false.obs;
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxList<ServiceMeData> serviceMeDataList = <ServiceMeData>[].obs;
  final Rx<ServiceMeData?> selectedServiceMeData = Rx<ServiceMeData?>(null);
  Rx<BidModel?> bidData = Rx<BidModel?>(null);
  RxList<BidModel> shortlistedBids = <BidModel>[].obs;
  RxBool isProvider = false.obs;
  RxBool isBidEdit = false.obs;
  final RxMap<String, RxBool> isShortlistLoadingMap = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _getStorageValue();
    _getArguments();
    _addListenerFocusNodes();
    _addViews();
    _getServiceRequestsDetails();
    _getServicesMe();
  }

  void onTapEditBidItem() {
    isBidEdit.value = true;
    final serviceId = bidData.value?.serviceId;
    if (serviceId != null) {
      final match = serviceMeDataList.firstWhereOrNull(
        (item) => item.id == serviceId,
      );
      if (match != null) {
        selectedServiceMeData.value = match;
      }
    }
    descriptionController.text = bidData.value?.message ?? "";
    priceController.text = "${bidData.value?.proposedPrice ?? "0"}";
  }

  void onTapServiceRequestBids() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    if (isBidEdit.value) {
      await _putServiceRequestBids();
    } else {
      await _postServiceRequestBids();
    }
  }

  Future<void> _putServiceRequestBids() async {
    HelperFunction.hideKeyboard();
    isLoadingUpdateBids.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.message: descriptionController.text.trim(),
        ApiParams.proposedPrice: double.tryParse(priceController.text.trim()),
      };

      log("UpdateServiceRequestBids PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestBids(bidData.value?.id ?? "", params);

      if (response is String) {
        log("UpdateServiceRequestBids failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel createBid = response as CreateServiceRequestBidModel;
        if (createBid.status == 200 || createBid.status == 201) {
          bidData.value = createBid.bid ?? BidModel();
          isBidEdit.value = false;
          HelperFunction.snackbar(
            "Service request bids updated successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (createBid.status == 401 ||
              (createBid.errors != null &&
                  createBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _serviceRequestRepo.putServiceRequestBids(bidData.value?.id ?? "", params),
            );
            if (retryResponse is CreateServiceRequestBidModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              bidData.value = retryResponse.bid ?? BidModel();
              HelperFunction.snackbar(
                "Service request bids updated successfully!",
                title: "Success",
                icon: Icons.check,
                backgroundColor: AppColors.green,
              );
            }
            return;
          }
          HelperFunction.snackbar("Failed to update your bid. Please try again.");
          log("UpdateServiceRequestBids failed from controller: ${createBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update your bid. Please try again.");
      log("UpdateServiceRequestBids catch error from controller: ${e.toString()}");
    } finally {
      isLoadingUpdateBids.value = false;
    }
  }

  void onTapShortlistButton(String bidId, bool isShortlisted) => _putServiceRequestBidsShortlist(bidId, isShortlisted);

  Future<void> _putServiceRequestBidsShortlist(String bidId, bool isShortlisted) async {
    isShortlistLoadingMap[bidId] ??= false.obs;
    isShortlistLoadingMap[bidId]?.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.isShortlisted: isShortlisted,
      };

      log("ServiceRequestBidsShortlist PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestBidsShortlist(bidId, params);

      if (response is String) {
        log("ServiceRequestBidsShortlist failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel createBid = response as CreateServiceRequestBidModel;
        if (createBid.status == 200 || createBid.status == 201) {
          serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == createBid.bid?.id).isShortlisted = createBid.bid?.isShortlisted;
          serviceDetailsData.refresh();
          final bid = createBid.bid;
          final bidId = bid?.id;
          if (bid != null && bidId != null) {
            final existingBid = shortlistedBids.firstWhereOrNull((b) => b.id == bidId);
            if (existingBid != null) {
              shortlistedBids.remove(existingBid);
            }
            if (bid.isShortlisted == true) {
              shortlistedBids.add(bid);
            }
            shortlistedBids.refresh();
          }
          tabsCounts.value = [
            serviceDetailsData.value.bids?.length ?? 0,
            shortlistedBids.length,
            1,
            0,
          ];
        } else {
          if (createBid.status == 401 ||
              (createBid.errors != null &&
                  createBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _serviceRequestRepo.putServiceRequestBidsShortlist(bidData.value?.id ?? "", params),
            );
            if (retryResponse is CreateServiceRequestBidModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == retryResponse.bid?.id).isShortlisted =
                  retryResponse.bid?.isShortlisted;
              serviceDetailsData.refresh();
              final bid = retryResponse.bid;
              final bidId = bid?.id;
              if (bid != null && bidId != null) {
                final existingBid = shortlistedBids.firstWhereOrNull((b) => b.id == bidId);
                if (existingBid != null) {
                  shortlistedBids.remove(existingBid);
                }
                if (bid.isShortlisted == true) {
                  shortlistedBids.add(bid);
                }
                shortlistedBids.refresh();
              }
              tabsCounts.value = [
                serviceDetailsData.value.bids?.length ?? 0,
                shortlistedBids.length,
                1,
                0,
              ];
            }
            return;
          }
          HelperFunction.snackbar("Failed to update shortlisted bid. Please try again.");
          log("ServiceRequestBidsShortlist failed from controller: ${createBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update shortlisted bid. Please try again.");
      log("ServiceRequestBidsShortlist catch error from controller: ${e.toString()}");
    } finally {
      isShortlistLoadingMap[bidId]?.value = false;
    }
  }

  Future<void> _postServiceRequestBids() async {
    if ((selectedServiceMeData.value?.id?.isEmpty ?? true)) {
      HelperFunction.snackbar(
        "Please select a service",
        title: "Warning",
        icon: Icons.warning,
        backgroundColor: AppColors.yellow,
      );
      return;
    }
    HelperFunction.hideKeyboard();
    isLoadingCrateBids.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.serviceRequestId: serviceRequestId,
        ApiParams.serviceId: selectedServiceMeData.value?.id ?? "",
        ApiParams.message: descriptionController.text.trim(),
        ApiParams.proposedPrice: double.tryParse(priceController.text.trim()),
      };

      log("CreateServiceRequestBids POST Params: $params");
      var response = await _serviceRequestRepo.postServiceRequestBids(params);

      if (response is String) {
        log("CreateServiceRequestBids failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel createBid = response as CreateServiceRequestBidModel;
        if (createBid.status == 200 || createBid.status == 201) {
          bidData.value = createBid.bid ?? BidModel();
          HelperFunction.snackbar(
            "Service request bids created successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (createBid.status == 401 ||
              (createBid.errors != null &&
                  createBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRequestRepo.postServiceRequestBids(params));
            if (retryResponse is CreateServiceRequestBidModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              bidData.value = retryResponse.bid ?? BidModel();
              HelperFunction.snackbar(
                "Service request bids created successfully!",
                title: "Success",
                icon: Icons.check,
                backgroundColor: AppColors.green,
              );
            }
            return;
          }
          HelperFunction.snackbar("Failed to submit your bid. Please try again.");
          log("CreateServiceRequestBids failed from controller: ${createBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to submit your bid. Please try again.");
      log("CreateServiceRequestBids catch error from controller: ${e.toString()}");
    } finally {
      isLoadingCrateBids.value = false;
    }
  }

  Future<void> _getServicesMe() async {
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
    } finally {}
  }

  Future<void> _getServiceRequestsDetails() async {
    isLoadingServiceRequestsDetails.value = true;
    try {
      var response = await _serviceRequestRepo.getServiceRequestsDetails(serviceRequestId);

      if (response is String) {
        log("ServiceRequestsDetails get failed from controller response: $response");
      } else {
        ServiceDetailsModel serviceDetails = response as ServiceDetailsModel;
        if (serviceDetails.status == 200 || serviceDetails.status == 201) {
          serviceDetailsData.value = serviceDetails.serviceDetailsData ?? ServiceDetailsData();
          isProvider.value = serviceDetailsData.value.createdBy == userId;
          if (!isProvider.value) {
            bidData.value = serviceDetailsData.value.bids?.first;
          }
          shortlistedBids.addAll(serviceDetailsData.value.bids?.where((bid) => bid.isShortlisted == true) ?? []);
          tabsCounts.value = [
            serviceDetailsData.value.bids?.length ?? 0,
            shortlistedBids.length,
            1,
            0,
          ];
        } else {
          if (serviceDetails.status == 401 ||
              (serviceDetails.errors != null &&
                  serviceDetails.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse =
                await ApiService().postRefreshTokenAndRetry(() => _serviceRequestRepo.getServiceRequestsDetails(serviceRequestId));
            if (retryResponse is ServiceDetailsModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value = retryResponse.serviceDetailsData ?? ServiceDetailsData();
              isProvider.value = serviceDetailsData.value.createdBy == userId;
              if (!isProvider.value) {
                bidData.value = serviceDetailsData.value.bids?.first;
              }
              shortlistedBids.addAll(serviceDetailsData.value.bids?.where((bid) => bid.isShortlisted == true) ?? []);
              tabsCounts.value = [
                serviceDetailsData.value.bids?.length ?? 0,
                shortlistedBids.length,
                1,
                0,
              ];
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServiceRequestsDetails get failed from controller: ${serviceDetails.status}");
          return;
        }
      }
    } catch (e) {
      log("ServiceRequestsDetails get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequestsDetails.value = false;
    }
  }

  void _addViews() {
    tabViews = [
      CustomScrollView(
        slivers: [
          ServiceDetailsProviderBidsSection(),
        ],
      ),
      CustomScrollView(
        slivers: [
          ServiceDetailsProviderShortlistedBidsSection(),
        ],
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text("Tab 3")),
        ],
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text("Tab 4")),
        ],
      ),
    ];
  }

  void _addListenerFocusNodes() {
    descriptionFocusNode.addListener(update);
    priceFocusNode.addListener(update);
  }

  void _getArguments() {
    if (Get.arguments != null) {
      serviceRequestId = Get.arguments["serviceRequestId"];
    }
  }

  void _getStorageValue() {
    userId = StorageHelper.getValue(StorageHelper.userId);
    log("UserId: $userId");
  }

  @override
  void onClose() {
    super.onClose();
    descriptionController.dispose();
    priceController.dispose();
    descriptionFocusNode.dispose();
    priceFocusNode.dispose();
  }
}
