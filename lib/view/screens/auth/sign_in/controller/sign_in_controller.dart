import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void signInButtonOnTap() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    StorageHelper.setValue("authToken", "authToken");
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    _goToLandingScreen();
  }

  void _goToLandingScreen() => Get.toNamed(AppRoutes.landingScreen);

  void goToSignUpScreen() => Get.offAllNamed(AppRoutes.sigUpScreen);

  void _addListenerFocusNodes() {
    emailFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
