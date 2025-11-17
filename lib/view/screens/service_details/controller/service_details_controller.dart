import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
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
import 'package:service_la/view/widgets/service_details/service_details_provider_final_bids_section.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_rejected_bids_section.dart';
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
  RxList<BidModel> finalBids = <BidModel>[].obs;
  RxList<BidModel> rejectBids = <BidModel>[].obs;
  RxBool isProvider = false.obs;
  RxBool isBidEdit = false.obs;
  final RxMap<String, RxBool> isApprovedLoadingMap = <String, RxBool>{}.obs;
  final RxMap<String, RxBool> isShortlistedLoadingMap = <String, RxBool>{}.obs;
  final RxMap<String, RxBool> isRejectedLoadingMap = <String, RxBool>{}.obs;
  RxBool isLoadingServiceRequestStatus = false.obs;

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

  Future<void> onRefresh({String? serviceRequestIdValue}) async {
    if (serviceRequestIdValue != null) {
      serviceRequestId = serviceRequestIdValue;
    }
    await _getServiceRequestsDetails();
    await _getServicesMe();
  }

  void onTapFinalizeButton(String serviceId, int status) => _putServiceRequestsStatus(serviceId, status);

  Future<void> _putServiceRequestsStatus(String serviceId, int status) async {
    isLoadingServiceRequestStatus.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.status: status,
      };

      log("ServiceRequestsStatus PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestsStatus(serviceId, params);

      if (response is String) {
        log("ServiceRequestsStatus failed from controller response: $response");
      } else {
        ServiceDetailsModel serviceDetails = response as ServiceDetailsModel;
        if (serviceDetails.status == 200 || serviceDetails.status == 201) {
          serviceDetailsData.value.status = ServiceRequestStatus.completed.typeValue;
          serviceDetailsData.refresh();
          HelperFunction.snackbar(
            "Service request completed successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (serviceDetails.status == 401 ||
              (serviceDetails.errors != null &&
                  serviceDetails.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _serviceRequestRepo.putServiceRequestsStatus(serviceId, params),
            );
            if (retryResponse is ServiceDetailsModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value.status = ServiceRequestStatus.completed.typeValue;
              serviceDetailsData.refresh();
              HelperFunction.snackbar(
                "Service request completed successfully!",
                title: "Success",
                icon: Icons.check,
                backgroundColor: AppColors.green,
              );
            }
            return;
          }
          HelperFunction.snackbar("Failed to update service request status. Please try again.");
          log("ServiceRequestsStatus failed from controller: ${serviceDetails.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update service request status. Please try again.");
      log("ServiceRequestsStatus catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequestStatus.value = false;
    }
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
        CreateServiceRequestBidModel updateBid = response as CreateServiceRequestBidModel;
        if (updateBid.status == 200 || updateBid.status == 201) {
          bidData.value = updateBid.bid ?? BidModel();
          isBidEdit.value = false;
          HelperFunction.snackbar(
            "Service request bids updated successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (updateBid.status == 401 ||
              (updateBid.errors != null &&
                  updateBid.errors.any((error) =>
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
          log("UpdateServiceRequestBids failed from controller: ${updateBid.status}");
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
    isShortlistedLoadingMap[bidId]?.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.isShortlisted: isShortlisted,
      };

      log("ServiceRequestBidsShortlist PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestBidsShortlist(bidId, params);

      if (response is String) {
        log("ServiceRequestBidsShortlist failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel shortlistedBid = response as CreateServiceRequestBidModel;
        if (shortlistedBid.status == 200 || shortlistedBid.status == 201) {
          serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == shortlistedBid.bid?.id).isShortlisted =
              shortlistedBid.bid?.isShortlisted;
          serviceDetailsData.refresh();
          final bid = shortlistedBid.bid;
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
            rejectBids.length,
            finalBids.length,
          ];
        } else {
          if (shortlistedBid.status == 401 ||
              (shortlistedBid.errors != null &&
                  shortlistedBid.errors.any((error) =>
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
                rejectBids.length,
                finalBids.length,
              ];
            }
            return;
          }
          HelperFunction.snackbar("Failed to update shortlisted bid. Please try again.");
          log("ServiceRequestBidsShortlist failed from controller: ${shortlistedBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update shortlisted bid. Please try again.");
      log("ServiceRequestBidsShortlist catch error from controller: ${e.toString()}");
    } finally {
      isShortlistedLoadingMap[bidId]?.value = false;
    }
  }

  void onTapAcceptBidButton(String bidId, bool isApproved, {bool isVendor = false}) =>
      _putServiceRequestBidsApproval(bidId, isApproved, isVendor: isVendor);

  Future<void> _putServiceRequestBidsApproval(String bidId, bool isApproved, {bool isVendor = false}) async {
    isApprovedLoadingMap[bidId] ??= false.obs;
    isApprovedLoadingMap[bidId]?.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.isApproved: isApproved,
      };

      log("ServiceRequestBidsApproval PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestBidsApproval(bidId, params);

      if (response is String) {
        log("ServiceRequestBidsApproval failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel approvedBid = response as CreateServiceRequestBidModel;
        if (approvedBid.status == 200 || approvedBid.status == 201) {
          if (!isVendor) {
            serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == approvedBid.bid?.id).userApproved = approvedBid.bid?.userApproved;
          } else {
            bidData.value?.vendorApproved = approvedBid.bid?.vendorApproved;
          }
          bidData.refresh();
          serviceDetailsData.refresh();
          final bid = approvedBid.bid;
          final bidId = bid?.id;
          if (bid != null && bidId != null) {
            final existingBid = finalBids.firstWhereOrNull((b) => b.id == bidId);
            if (existingBid != null) {
              finalBids.remove(existingBid);
            }
            if (bid.userApproved == true && bid.vendorApproved == true) {
              finalBids.add(bid);
            }
            finalBids.refresh();
          }
          tabsCounts.value = [
            serviceDetailsData.value.bids?.length ?? 0,
            shortlistedBids.length,
            rejectBids.length,
            finalBids.length,
          ];
        } else {
          if (approvedBid.status == 401 ||
              (approvedBid.errors != null &&
                  approvedBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _serviceRequestRepo.putServiceRequestBidsApproval(bidId, params),
            );
            if (retryResponse is CreateServiceRequestBidModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              if (!isVendor) {
                serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == retryResponse.bid?.id).userApproved =
                    retryResponse.bid?.userApproved;
              } else {
                bidData.value?.vendorApproved = retryResponse.bid?.vendorApproved;
              }
              bidData.refresh();
              serviceDetailsData.refresh();
              final bid = retryResponse.bid;
              final bidId = bid?.id;
              if (bid != null && bidId != null) {
                final existingBid = finalBids.firstWhereOrNull((b) => b.id == bidId);
                if (existingBid != null) {
                  finalBids.remove(existingBid);
                }
                if (bid.userApproved == true && bid.vendorApproved == true) {
                  finalBids.add(bid);
                }
                finalBids.refresh();
              }
              tabsCounts.value = [
                serviceDetailsData.value.bids?.length ?? 0,
                shortlistedBids.length,
                rejectBids.length,
                finalBids.length,
              ];
            }
            return;
          }
          HelperFunction.snackbar("Failed to update approved bid. Please try again.");
          log("ServiceRequestBidsApproval failed from controller: ${approvedBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update approved bid. Please try again.");
      log("ServiceRequestBidsApproval catch error from controller: ${e.toString()}");
    } finally {
      isApprovedLoadingMap[bidId]?.value = false;
    }
  }

  void onTapRejectBidButton(String bidId, int status) => _putServiceRequestBidsStatus(bidId, status);

  Future<void> _putServiceRequestBidsStatus(String bidId, int status) async {
    isRejectedLoadingMap[bidId] ??= false.obs;
    isRejectedLoadingMap[bidId]?.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.status: status,
      };

      log("ServiceRequestBidsStatus PUT Params: $params");
      var response = await _serviceRequestRepo.putServiceRequestBidsStatus(bidId, params);

      if (response is String) {
        log("ServiceRequestBidsStatus failed from controller response: $response");
      } else {
        CreateServiceRequestBidModel statusBid = response as CreateServiceRequestBidModel;
        if (statusBid.status == 200 || statusBid.status == 201) {
          serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == statusBid.bid?.id).status = statusBid.bid?.status;
          serviceDetailsData.refresh();
          final bid = statusBid.bid;
          final bidId = bid?.id;
          if (bid != null && bidId != null) {
            final existingBid = rejectBids.firstWhereOrNull((b) => b.id == bidId);
            if (existingBid != null) {
              rejectBids.remove(existingBid);
            }
            if (bid.status == ServiceRequestBidStatus.rejected.typeValue) {
              rejectBids.add(bid);
            }
            rejectBids.refresh();
          }
          tabsCounts.value = [
            serviceDetailsData.value.bids?.length ?? 0,
            shortlistedBids.length,
            rejectBids.length,
            finalBids.length,
          ];
        } else {
          if (statusBid.status == 401 ||
              (statusBid.errors != null &&
                  statusBid.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _serviceRequestRepo.putServiceRequestBidsStatus(bidId, params),
            );
            if (retryResponse is CreateServiceRequestBidModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value.bids?.singleWhere((bid) => bid.id == retryResponse.bid?.id).status = retryResponse.bid?.status;
              serviceDetailsData.refresh();
              final bid = retryResponse.bid;
              final bidId = bid?.id;
              if (bid != null && bidId != null) {
                final existingBid = rejectBids.firstWhereOrNull((b) => b.id == bidId);
                if (existingBid != null) {
                  rejectBids.remove(existingBid);
                }
                if (bid.status == ServiceRequestBidStatus.rejected.typeValue) {
                  rejectBids.add(bid);
                }
                rejectBids.refresh();
              }
              tabsCounts.value = [
                serviceDetailsData.value.bids?.length ?? 0,
                shortlistedBids.length,
                rejectBids.length,
                finalBids.length,
              ];
            }
            return;
          }
          HelperFunction.snackbar("Failed to update status bid. Please try again.");
          log("ServiceRequestBidsStatus failed from controller: ${statusBid.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to update status bid. Please try again.");
      log("ServiceRequestBidsStatus catch error from controller: ${e.toString()}");
    } finally {
      isRejectedLoadingMap[bidId]?.value = false;
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
            if ((serviceDetailsData.value.bids?.isNotEmpty ?? false)) {
              bidData.value = serviceDetailsData.value.bids?.first;
            }
          }
          if (isProvider.value) {
            shortlistedBids.addAll(serviceDetailsData.value.bids?.where((bid) => bid.isShortlisted == true) ?? []);
            finalBids.addAll(serviceDetailsData.value.bids?.where((bid) => bid.userApproved == true && bid.vendorApproved == true) ?? []);
            rejectBids
                .addAll(serviceDetailsData.value.bids?.where((bid) => bid.status == ServiceRequestBidStatus.rejected.typeValue) ?? []);
            tabsCounts.value = [
              serviceDetailsData.value.bids?.length ?? 0,
              shortlistedBids.length,
              rejectBids.length,
              finalBids.length,
            ];
            _initializeApprovalLoadingMap(serviceDetailsData.value.bids ?? []);
            _initializeShortlistedLoadingMap(serviceDetailsData.value.bids ?? []);
            _initializeRejectedLoadingMap(serviceDetailsData.value.bids ?? []);
          }
          if (!isProvider.value) {
            isApprovedLoadingMap[bidData.value?.id ?? ""] = false.obs;
          }
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
                if ((serviceDetailsData.value.bids?.isNotEmpty ?? false)) {
                  bidData.value = serviceDetailsData.value.bids?.first;
                }
              }
              if (isProvider.value) {
                shortlistedBids.addAll(serviceDetailsData.value.bids?.where((bid) => bid.isShortlisted == true) ?? []);
                finalBids
                    .addAll(serviceDetailsData.value.bids?.where((bid) => bid.userApproved == true && bid.vendorApproved == true) ?? []);
                rejectBids
                    .addAll(serviceDetailsData.value.bids?.where((bid) => bid.status == ServiceRequestBidStatus.rejected.typeValue) ?? []);
                tabsCounts.value = [
                  serviceDetailsData.value.bids?.length ?? 0,
                  shortlistedBids.length,
                  rejectBids.length,
                  finalBids.length,
                ];
                _initializeApprovalLoadingMap(serviceDetailsData.value.bids ?? []);
                _initializeShortlistedLoadingMap(serviceDetailsData.value.bids ?? []);
                _initializeRejectedLoadingMap(serviceDetailsData.value.bids ?? []);
              }
              if (!isProvider.value) {
                isApprovedLoadingMap[bidData.value?.id ?? ""] = false.obs;
              }
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

  void _initializeRejectedLoadingMap(List<BidModel> bids) {
    for (final bid in bids) {
      final bidId = bid.id;
      if (bidId != null) {
        isRejectedLoadingMap[bidId] = false.obs;
      }
    }
  }

  void _initializeApprovalLoadingMap(List<BidModel> bids) {
    for (final bid in bids) {
      final bidId = bid.id;
      if (bidId != null) {
        isApprovedLoadingMap[bidId] = false.obs;
      }
    }
  }

  void _initializeShortlistedLoadingMap(List<BidModel> bids) {
    for (final bid in bids) {
      final bidId = bid.id;
      if (bidId != null) {
        isShortlistedLoadingMap[bidId] = false.obs;
      }
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
          ServiceDetailsProviderRejectedBidsSection(),
        ],
      ),
      CustomScrollView(
        slivers: [
          ServiceDetailsProviderFinalBidsSection(),
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
