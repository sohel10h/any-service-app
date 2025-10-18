import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

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
