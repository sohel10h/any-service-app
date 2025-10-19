import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void _addListenerFocusNodes() {
    searchFocusNode.addListener(update);
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    searchFocusNode.dispose();
  }
}
