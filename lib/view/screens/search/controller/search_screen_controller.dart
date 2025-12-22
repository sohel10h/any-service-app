import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SearchScreenController extends GetxController with GetTickerProviderStateMixin {
  String heroTag = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    _getArguments();
    _addListenerFocusNodes();
    super.onInit();
  }

  void onCloseTap() => Get.back();

  void _addListenerFocusNodes() {
    searchFocusNode.addListener(update);
  }

  void _getArguments() {
    if (Get.arguments != null) {
      heroTag = Get.arguments["heroTag"] ?? "";
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
