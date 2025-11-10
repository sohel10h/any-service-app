import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/local/provider_bid_model.dart';
import 'package:service_la/data/repository/service_request_repo.dart';
import 'package:service_la/data/model/network/create_service_model.dart';
import 'package:service_la/data/model/network/service_details_model.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_section.dart';

class ServiceDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  String serviceId = "";
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedFilterIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Shortlisted", "Rejected", "Final Bid"];
  List<CustomScrollView> tabViews = [];
  final List<int> tabsCounts = [5, 1, 2, 0];
  final List<String> filters = ["Lowest Price", "Top Rated"];
  final ServiceRequestRepo _serviceRequestRepo = ServiceRequestRepo();
  RxBool isLoadingServiceRequestsDetails = false.obs;
  Rx<ServiceDetailsData> serviceDetailsData = ServiceDetailsData().obs;
  RxBool isLoadingCrateBids = false.obs;
  final RxList<String> requestServices = ["Home Cleaning", "Car Washing", "House keeping"].obs;
  final Rx<String?> selectedRequestService = Rx<String?>(null);
  final RxList<ProviderBidModel> bids = [
    ProviderBidModel(
      name: "David Martinez",
      title: "General Cleaning",
      price: 75,
      rating: 4.7,
      jobsCount: 189,
      timeAgo: "1 hour ago",
      description: "Affordable and reliable cleaning service. I have 3 years "
          "of experience and great references. Can work around your schedule.",
      availability: "Available next week",
      duration: "4–5 hours",
      isBest: true,
      belowBudget: true,
      shortlisted: false,
      imageUrl: HelperFunction.userImage1,
    ),
    ProviderBidModel(
      name: "Sarah Johnson",
      title: "Deep Cleaning Expert",
      price: 89,
      rating: 4.9,
      jobsCount: 456,
      timeAgo: "5 mins ago",
      description: "I specialize in deep cleaning and have over 5 years of experience. "
          "I use eco-friendly products and guarantee excellent results.",
      availability: "Available tomorrow",
      duration: "3–4 hours",
      isBest: false,
      belowBudget: true,
      shortlisted: true,
      imageUrl: HelperFunction.userImage2,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _addListenerFocusNodes();
    _addViews();
    _getServiceRequestsDetails();
  }

  void onTapSubmitBids() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    await _createBids();
  }

  Future<void> _createBids() async {
    HelperFunction.hideKeyboard();
    isLoadingCrateBids.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.description: descriptionController.text.trim(),
        ApiParams.price: double.tryParse(priceController.text.trim()),
      };

      log("CreateService POST Params: $params");
      var response = await _serviceRequestRepo.getServiceRequestsDetails("serviceId");

      if (response is String) {
        log("CreateService failed from controller response: $response");
      } else {
        CreateServiceModel createService = response as CreateServiceModel;
        if (createService.status == 200 || createService.status == 201) {
          Get.back(result: true);
          HelperFunction.snackbar(
            "Service created successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (createService.status == 401 ||
              (createService.errors != null &&
                  createService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _serviceRequestRepo.getServiceRequestsDetails("serviceId"));
            if (retryResponse is CreateServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              Get.back(result: true);
              HelperFunction.snackbar(
                "Service created successfully!",
                title: "Success",
                icon: Icons.check,
                backgroundColor: AppColors.green,
              );
            }
            return;
          }
          HelperFunction.snackbar("CreateService failed");
          log("CreateService failed from controller: ${createService.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("CreateService failed");
      log("CreateService catch error from controller: ${e.toString()}");
    } finally {
      isLoadingCrateBids.value = false;
    }
  }

  Future<void> _getServiceRequestsDetails() async {
    isLoadingServiceRequestsDetails.value = true;
    try {
      var response = await _serviceRequestRepo.getServiceRequestsDetails(serviceId);

      if (response is String) {
        log("ServiceRequestsDetails get failed from controller response: $response");
      } else {
        ServiceDetailsModel serviceDetails = response as ServiceDetailsModel;
        if (serviceDetails.status == 200 || serviceDetails.status == 201) {
          serviceDetailsData.value = serviceDetails.serviceDetailsData ?? ServiceDetailsData();
        } else {
          if (serviceDetails.status == 401 ||
              (serviceDetails.errors != null &&
                  serviceDetails.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _serviceRequestRepo.getServiceRequestsDetails(serviceId));
            if (retryResponse is ServiceDetailsModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value = serviceDetails.serviceDetailsData ?? ServiceDetailsData();
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
          SliverToBoxAdapter(child: Text("Tab 2")),
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
      serviceId = Get.arguments["serviceId"];
    }
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
