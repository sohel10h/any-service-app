import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
