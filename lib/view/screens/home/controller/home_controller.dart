import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/helper_function.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode serviceFocusNode = FocusNode();
  final RxList<String> requestTypeOptions = ["Individual", "Company"].obs;
  final RxList<String> urgencyOptions = ["Normal", "Urgent"].obs;
  final RxList<String> budgetOptions = ["Low", "Medium", "High"].obs;
  final Rx<String?> requestType = Rx<String?>(null);
  final Rx<String?> urgency = Rx<String?>(null);
  final Rx<String?> budget = Rx<String?>(null);
  RxList<bool> imageLoadingFlags = <bool>[].obs;
  final ImagePicker _picker = ImagePicker();
  final RxList<XFile> selectedImages = <XFile>[].obs;
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

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
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
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    imageLoadingFlags.removeAt(index);
  }

  void _addListenerFocusNodes() {
    searchFocusNode.addListener(update);
    serviceFocusNode.addListener(update);
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    serviceController.dispose();
    searchFocusNode.dispose();
    serviceFocusNode.dispose();
  }
}
