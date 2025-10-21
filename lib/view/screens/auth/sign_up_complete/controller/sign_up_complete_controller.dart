import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/auth_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_up_model.dart';
import 'package:service_la/services/api_constants/api_params.dart';

class SignUpCompleteController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  String sessionToken = "";
  RxString password = "".obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;
  final AuthRepo _authRepo = AuthRepo();
  RxBool isLoadingSignUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _addListenerFocusNodes();
  }

  void submitButtonOnTap() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    _signUp();
  }

  Future<void> _signUp() async {
    HelperFunction.hideKeyboard();
    isLoadingSignUp.value = true;
    try {
      dynamic params = {
        ApiParams.name: nameController.text,
        ApiParams.password: passwordController.text,
        ApiParams.sessionToken: sessionToken,
      };
      log("SignUp POST Params: $params");
      var response = await _authRepo.signUp(params);

      if (response is String) {
        HelperFunction.snackbar("Sign up failed. Please check your details and try again.");
        log("SignUp failed from controller response: $response");
      } else {
        SignUpModel signUp = response as SignUpModel;
        if (signUp.status == 200 || signUp.status == 201) {
          HelperFunction.snackbar(
            "Sign Up complete. You can now sign in and explore.",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
          _goToSignInScreen();
        } else {
          HelperFunction.snackbar("Sign up failed. Please check your details and try again.");
          log("SignUp failed from controller: ${signUp.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Sign up failed. Please check your details and try again.");
      log("SignUp catch error from controller: ${e.toString()}");
    } finally {
      isLoadingSignUp.value = false;
    }
  }

  void _goToSignInScreen() => Get.offAllNamed(AppRoutes.signInScreen);

  void _addListenerFocusNodes() {
    nameFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
  }

  void _getArguments() {
    if (Get.arguments != null) {
      sessionToken = Get.arguments["sessionToken"] ?? "";
    }
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
