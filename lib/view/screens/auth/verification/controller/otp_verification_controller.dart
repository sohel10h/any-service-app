import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OtpVerificationController extends GetxController {
  String email = "";
  String otpNumber = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _addListenerFocusNodes();
  }

  void verifyEmailButtonOnTap() {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
  }

  void _addListenerFocusNodes() {
    otpFocusNode.addListener(update);
  }

  void _getArguments() {
    if (Get.arguments != null) {
      email = Get.arguments["email"];
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}
