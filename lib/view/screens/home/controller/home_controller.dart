import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/repository/service_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/local/file_option_model.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/data/repository/service_request_repo.dart';
import 'package:service_la/data/model/network/common/category_model.dart';
import 'package:service_la/data/model/network/service_category_model.dart';
import 'package:service_la/data/model/network/best_selling_service_model.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';
import 'package:service_la/data/model/network/upload_service_request_model.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';

class HomeController extends GetxController {
  String userId = "";
  final formKey = GlobalKey<FormState>();
  final budgetFormKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController budgetFromController = TextEditingController();
  final TextEditingController budgetToController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode serviceFocusNode = FocusNode();
  FocusNode budgetFromFocusNode = FocusNode();
  FocusNode budgetToFocusNode = FocusNode();
  FocusNode companyNameFocusNode = FocusNode();
  final RxList<String> requestTypeOptions = ["Individual", "Company"].obs;
  final RxList<String> urgencyOptions = ["Normal", "Urgent"].obs;
  final RxList<String> budgetOptions = ["Low", "Medium", "High"].obs;
  final Rx<String?> requestType = Rx<String?>(null);
  final Rx<String?> urgency = Rx<String?>(null);
  final Rx<String?> budget = Rx<String?>(null);
  RxList<bool> imageLoadingFlags = <bool>[].obs;
  final ImagePicker _picker = ImagePicker();
  final RxList<XFile> selectedImages = <XFile>[].obs;
  RxBool isKeyboardVisible = false.obs;
  RxBool hasUnsavedChanges = false.obs;
  RxBool isIndividualSelected = true.obs;
  LandingController landingController = Get.find<LandingController>();
  RxString minBudget = "".obs;
  RxString maxBudget = "".obs;
  final ServiceRequestRepo _serviceRequestRepo = ServiceRequestRepo();
  final AdminRepo _adminRepo = AdminRepo();
  RxString serviceDescription = "".obs;
  RxString companyName = "".obs;
  RxList<String> attachmentIds = <String>[].obs;
  RxBool isLoadingServiceRequests = false.obs;
  final ServiceRepo _serviceRepo = ServiceRepo();
  RxBool isLoadingBestSellingServices = false.obs;
  RxList<BestSellingServiceData> bestSellingServiceData = <BestSellingServiceData>[].obs;
  RxList<CategoryModel> serviceCategories = <CategoryModel>[].obs;
  RxBool isLoadingServiceCategories = false.obs;
  RxBool isLoadingMoreServiceCategories = false.obs;
  int currentPageServiceCategories = 1;
  int totalPagesServiceCategories = 1;
  final List<Map<String, dynamic>> cleaningServices = [
    {
      "serviceName": "Regular House Cleaning",
      "providerName": "CleanMaster",
      "profileImageUrl": HelperFunction.placeholderImageUrl35,
      "rating": 4.9,
      "price": "65",
      "postedTime": "2 hours ago",
    },
    {
      "serviceName": "Deep Cleaning",
      "providerName": "CleanMaster",
      "profileImageUrl": HelperFunction.placeholderImageUrl35,
      "rating": 4.9,
      "price": "120",
      "postedTime": "3 hours ago",
    },
  ];
  List<FileOptionModel> fileOptions = [];

  @override
  void onInit() {
    super.onInit();
    _getStorageValue();
    _addListenerFocusNodes();
    _initFileOptions();
    getBestSellingServices();
    getAdminServiceCategories();
  }

  Future<void> getAdminServiceCategories({bool isRefresh = false, bool isLoadingEmpty = false}) async {
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
          final data = serviceCategory.serviceCategory?.categories?.where((category) => category.showInHomepage == true) ?? [];
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
              final data = retryResponse.serviceCategory?.categories?.where((category) => category.showInHomepage == true) ?? [];
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

  Future<void> getBestSellingServices() async {
    isLoadingBestSellingServices.value = true;
    try {
      var response = await _serviceRepo.getBestSellingServices();
      if (response is String) {
        log("BestSellingServices get failed from controller response: $response");
      } else {
        BestSellingServiceModel sellingService = response as BestSellingServiceModel;
        if (sellingService.status == 200 || sellingService.status == 201) {
          bestSellingServiceData.value = sellingService.bestSellingServices ?? [];
        } else {
          if (sellingService.status == 401 ||
              (sellingService.errors != null &&
                  sellingService.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRepo.getServicesMe());
            if (retryResponse is BestSellingServiceModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              bestSellingServiceData.value = retryResponse.bestSellingServices ?? [];
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

  void onTapPostButton(BuildContext context) async => await _postServiceRequests(context);

  Future<void> _postServiceRequests(BuildContext context) async {
    HelperFunction.hideKeyboard();
    isLoadingServiceRequests.value = true;
    try {
      dynamic params = {
        ApiParams.description: serviceController.text.trim(),
        ApiParams.budgetMin: double.tryParse(minBudget.value),
        ApiParams.budgetMax: double.tryParse(maxBudget.value),
        ApiParams.isCorporate: !isIndividualSelected.value,
        ApiParams.companyName: companyNameController.text.trim(),
        ApiParams.contactPerson: "",
        ApiParams.attachmentIds: attachmentIds,
      };
      log("ServiceRequests POST Params: $params");
      var response = await _serviceRequestRepo.postServiceRequests(params);

      if (response is String) {
        log("ServiceRequests failed from controller response: $response");
      } else {
        UploadServiceRequestModel serviceRequest = response as UploadServiceRequestModel;
        if (serviceRequest.status == 200 || serviceRequest.status == 201) {
          clearDraft();
          Get.back();
          if (context.mounted) landingController.changeIndex(0, context);
          HelperFunction.snackbar(
            "Service requests uploaded successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (serviceRequest.status == 401 ||
              (serviceRequest.errors != null &&
                  serviceRequest.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _serviceRequestRepo.postServiceRequests(params));
            if (retryResponse is UploadServiceRequestModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              clearDraft();
              Get.back();
              if (context.mounted) landingController.changeIndex(0, context);
              HelperFunction.snackbar(
                "Service requests uploaded successfully!",
                title: "Success",
                icon: Icons.check,
                backgroundColor: AppColors.green,
              );
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          HelperFunction.snackbar("Failed to submit your requests. Please try again.");
          log("ServiceRequests failed from controller: ${serviceRequest.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Failed to submit your requests. Please try again.");
      log("ServiceRequests catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequests.value = false;
    }
  }

  void goToCreateServiceDetailsScreen(String serviceId) => Get.toNamed(
        AppRoutes.createServiceDetailsScreen,
        arguments: {"serviceId": serviceId},
      );

  void clearBudgetRange() {
    hasUnsavedChanges.value = false;
    budgetFromController.clear();
    budgetToController.clear();
    minBudget.value = "";
    maxBudget.value = "";
  }

  void editBudgetRange(BuildContext context) async {
    budgetFromController.text = minBudget.value;
    budgetToController.text = maxBudget.value;
    await Future.delayed(Duration(microseconds: 300));
    if (context.mounted) {
      DialogHelper.showBudgetRangeSheet(context);
    }
  }

  void addBudgetRange() {
    if (!(budgetFormKey.currentState?.validate() ?? true)) {
      return;
    }
    Get.back();
    minBudget.value = budgetFromController.text.trim();
    maxBudget.value = budgetToController.text.trim();
    log("Budget Range: From ৳${minBudget.value} To ৳${maxBudget.value}");
    budgetFromController.clear();
    budgetToController.clear();
    hasUnsavedChanges.value = true;
  }

  void onCompanyNameTextChanged(String companyNameValue) {
    companyName.value = companyNameValue.trim();
    hasUnsavedChanges.value = companyNameValue.trim().isNotEmpty || selectedImages.isNotEmpty;
  }

  void onServiceTextChanged(String serviceValue) {
    serviceDescription.value = serviceValue.trim();
    hasUnsavedChanges.value = serviceValue.trim().isNotEmpty || selectedImages.isNotEmpty;
  }

  void clearDraft() {
    isIndividualSelected.value = true;
    isIndividualSelected.refresh();
    serviceController.clear();
    serviceDescription.value = "";
    companyNameController.clear();
    selectedImages.clear();
    clearBudgetRange();
    hasUnsavedChanges.value = false;
  }

  void _initFileOptions() {
    fileOptions = [
      FileOptionModel(
        id: 0,
        image: "assets/svgs/image_outline.svg",
        onTap: pickImages,
      ),
      FileOptionModel(
        id: 1,
        image: "assets/svgs/tag_outline.svg",
        onTap: () => log("Tag tapped"),
      ),
      FileOptionModel(
        id: 2,
        image: "assets/svgs/location_outline.svg",
        onTap: () => log("Location tapped"),
      ),
      FileOptionModel(
        id: 3,
        image: "assets/svgs/clock_outline.svg",
        onTap: () => log("Clock tapped"),
      ),
      FileOptionModel(
        id: 4,
        image: "assets/svgs/more_horizontal.svg",
        onTap: () => DialogHelper.showBottomSheet(Get.context!),
      ),
    ];
  }

  Future<void> pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage(limit: 4);
    if (pickedImages.isEmpty) {
      log("No image selected.");
      return;
    }
    if (pickedImages.length >= 4) {
      HelperFunction.snackbar(
        "You can only add up to 4 images at a time",
        title: "Limit Reached",
        icon: Icons.warning,
        backgroundColor: AppColors.yellow,
      );
      return;
    }
    for (XFile image in pickedImages) {
      try {
        final imageFile = await HelperFunction.getImageXFile(image);
        _addImage(imageFile);
        final index = selectedImages.length - 1;
        imageLoadingFlags.insert(index, true);
        imageLoadingFlags.refresh();
        final success = await _postAdminPictures(imageFile, index);
        if (!success) {
          selectedImages.removeAt(index);
          imageLoadingFlags.removeAt(index);
        } else {
          imageLoadingFlags[index] = false;
        }
        selectedImages.refresh();
        imageLoadingFlags.refresh();
      } catch (e) {
        log("Error loading or uploading image: $e");
        HelperFunction.snackbar("Failed to process image.");
      }
    }
  }

  Future<bool> _postAdminPictures(XFile imageXFile, int index) async {
    try {
      final file = File(imageXFile.path);
      if (!await file.exists()) {
        log("File does not exist: ${imageXFile.path}");
        return false;
      }
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final formData = dio.FormData.fromMap({
        ApiParams.file: await dio.MultipartFile.fromFile(
          file.path,
          contentType: MediaType("image", "image/$extension"),
          filename: fileName,
        ),
        ApiParams.mimeType: extension,
        ApiParams.seoFilename: fileName,
        ApiParams.altAttribute: "Uploaded Image",
        ApiParams.titleAttribute: "Admin Picture",
      });
      log("Upload Params: ${formData.fields}");
      final response = await _adminRepo.postAdminPictures(formData);
      if (response is String) {
        HelperFunction.snackbar("Image upload failed");
        log("Image upload failed controller response: $response");
        return false;
      } else {
        UploadAdminPictureModel pictureModel = response as UploadAdminPictureModel;
        if (pictureModel.status == 200 || pictureModel.status == 201) {
          attachmentIds.add(pictureModel.data?.id ?? "");
          return true;
        } else {
          if (pictureModel.status == 401 ||
              (pictureModel.errors != null &&
                  pictureModel.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected in controller, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _adminRepo.postAdminPictures(formData));
            if (retryResponse is UploadAdminPictureModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              attachmentIds.add(pictureModel.data?.id ?? "");
              return true;
            } else {
              log("Retry request failed after token refresh");
              return false;
            }
          }
          HelperFunction.snackbar("Image upload failed");
          log("Image upload failed from controller: ${pictureModel.status}");
          return false;
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Image upload failed");
      log("Image upload catch error from controller: ${e.toString()}");
      return false;
    } finally {
      imageLoadingFlags[index] = false;
      imageLoadingFlags.refresh();
    }
  }

  void _addImage(XFile image) {
    selectedImages.add(image);
    selectedImages.refresh();
    hasUnsavedChanges.value = true;
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    imageLoadingFlags.removeAt(index);
    hasUnsavedChanges.value = serviceController.text.trim().isNotEmpty || selectedImages.isNotEmpty;
  }

  void _addListenerFocusNodes() {
    searchFocusNode.addListener(update);
    serviceFocusNode.addListener(update);
    budgetFromFocusNode.addListener(update);
    budgetToFocusNode.addListener(update);
    companyNameFocusNode.addListener(update);
  }

  void _getStorageValue() {
    userId = StorageHelper.getValue(StorageHelper.userId) ?? "";
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    serviceController.dispose();
    budgetFromController.dispose();
    budgetToController.dispose();
    companyNameController.dispose();
    searchFocusNode.dispose();
    serviceFocusNode.dispose();
    budgetFromFocusNode.dispose();
    budgetToFocusNode.dispose();
    companyNameFocusNode.dispose();
  }
}
