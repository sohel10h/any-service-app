import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/local/file_option_model.dart';
import 'package:service_la/data/repository/service_request_repo.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';
import 'package:service_la/data/model/network/upload_service_request_model.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';

class HomeController extends GetxController {
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
  final List<Map<String, dynamic>> bestSellingServices = [
    {
      "label": "BEST",
      "title": "Deep Home Cleaning",
      "rating": 4.9,
      "price": 75,
      "bookedCount": 234,
      "description": "Professional service",
      "imagePath": HelperFunction.placeholderImageUrl178_84,
      "labelColorStart": AppColors.containerFB2C36,
      "labelColorEnd": AppColors.containerFF6900,
    },
    {
      "label": "TREND",
      "title": "AC Installation & Repair",
      "rating": 4.8,
      "price": 120,
      "bookedCount": 187,
      "description": "Expert technicians",
      "imagePath": HelperFunction.placeholderImageUrl178_84,
      "labelColorStart": Colors.green,
      "labelColorEnd": Colors.green,
    },
    {
      "label": "HOT",
      "title": "Plumbing Services",
      "rating": 4.8,
      "price": 90,
      "bookedCount": 150,
      "description": "Reliable plumbers",
      "imagePath": HelperFunction.placeholderImageUrl178_84,
      "labelColorStart": Colors.green,
      "labelColorEnd": Colors.green,
    },
  ];
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
    _addListenerFocusNodes();
    _initFileOptions();
  }

  void onTapPostButton(BuildContext context) async => await _serviceRequests(context);

  Future<void> _serviceRequests(BuildContext context) async {
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
      var response = await _serviceRequestRepo.serviceRequests(params);

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
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _serviceRequestRepo.serviceRequests(params));
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
          HelperFunction.snackbar("ServiceRequests failed");
          log("ServiceRequests failed from controller: ${serviceRequest.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("ServiceRequests failed");
      log("ServiceRequests catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequests.value = false;
    }
  }

  void goToServiceDetailsScreen() => Get.toNamed(AppRoutes.serviceDetailsScreen);

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
        final success = await _uploadAdminPictures(imageFile, index);
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

  Future<bool> _uploadAdminPictures(XFile imageXFile, int index) async {
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
      final response = await _adminRepo.uploadAdminPictures(formData);
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
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _adminRepo.uploadAdminPictures(formData));
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
