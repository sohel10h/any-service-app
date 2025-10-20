import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  RxString password = "".obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isAgreeWithTAndC = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void registerButtonOnTap() {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    _goToOtpVerificationScreen();
  }

  void _goToOtpVerificationScreen() => Get.offAllNamed(
        AppRoutes.otpVerificationScreen,
        arguments: {
          "email": emailController.text,
        },
      );

  void goToSignInScreen() => Get.offAllNamed(AppRoutes.signInScreen);

  void _addListenerFocusNodes() {
    firstNameFocusNode.addListener(update);
    lastNameFocusNode.addListener(update);
    emailFocusNode.addListener(update);
    phoneFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
    confirmPasswordFocusNode.addListener(update);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
