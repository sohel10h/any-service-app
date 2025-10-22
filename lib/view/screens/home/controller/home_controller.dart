import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
