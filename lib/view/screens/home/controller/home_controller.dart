import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/local/file_option_model.dart';
import 'package:service_la/routes/app_routes.dart';
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

  void goToServiceDetailsScreen() => Get.toNamed(AppRoutes.serviceDetailsScreen);

  void submitBudgetRange() {
    if (!(budgetFormKey.currentState?.validate() ?? true)) {
      return;
    }
    Get.back();
    final from = budgetFromController.text.trim();
    final to = budgetToController.text.trim();
    log("Budget Range: From ৳$from To ৳$to");
    budgetFromController.clear();
    budgetToController.clear();
  }

  void onTextChanged(String value) {
    hasUnsavedChanges.value = value.trim().isNotEmpty || selectedImages.isNotEmpty;
  }

  void clearDraft() {
    serviceController.clear();
    selectedImages.clear();
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
    final List<XFile> pickedImages = await _picker.pickMultiImage(limit: 3);
    if (pickedImages.isNotEmpty) {
      for (XFile image in pickedImages) {
        if (selectedImages.length >= 4) {
          HelperFunction.snackbar(
            "You can only add up to 4 images.",
            title: "Limit Reached",
            icon: Icons.warning,
            backgroundColor: AppColors.yellow,
          );
          break;
        }
        _addImage(image);
        imageLoadingFlags.add(true);
        final currentIndex = selectedImages.length - 1;
        try {
          final imageFile = await HelperFunction.getImageXFile(image);
          selectedImages[currentIndex] = imageFile;
          imageLoadingFlags[currentIndex] = false;
          selectedImages.refresh();
          imageLoadingFlags.refresh();
        } catch (e) {
          imageLoadingFlags[currentIndex] = false;
          imageLoadingFlags.refresh();
          log("Error loading image: $e");
        }
      }
    } else {
      log("🚫 No image selected.");
    }
  }

  void _addImage(XFile image) {
    selectedImages.add(image);
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
