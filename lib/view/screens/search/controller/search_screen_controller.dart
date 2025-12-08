import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SearchScreenController extends GetxController with GetTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    _addListenerFocusNodes();
    super.onInit();
  }

  void onCloseTap() => Get.back();

  void _addListenerFocusNodes() {
    searchFocusNode.addListener(update);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
