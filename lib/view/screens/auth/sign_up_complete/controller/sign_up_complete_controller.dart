import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';

class SignUpCompleteController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  RxString password = "".obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void submitButtonOnTap() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    _goToSignInScreen();
  }

  void _goToSignInScreen() => Get.offAllNamed(AppRoutes.signInScreen);

  void _addListenerFocusNodes() {
    nameFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
